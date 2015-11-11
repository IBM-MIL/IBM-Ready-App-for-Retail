/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.fragments;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TextView;

import com.ibm.mil.readyapps.summit.R;
import com.ibm.mil.readyapps.summit.models.Product;
import com.ibm.mil.readyapps.summit.utilities.AndroidUtils;
import com.ibm.mil.readyapps.summit.utilities.FontCache;
import com.ibm.mil.readyapps.summit.utilities.RealmDataManager;
import com.ibm.mqa.Log;

/**
 * Responsible for creating a user list. It can be displayed in two different modes, regular and
 * overlay mode. Overlay mode is used when the fragment is spawned from
 * {@link com.ibm.mil.readyapps.summit.fragments.ProductDetailsFragment}. To enable overlay mode,
 * instantiate the fragment with {@link #newInstance(boolean)}.
 *
 * @author John Petitto
 */
public class CreateListFragment extends Fragment {
    private static final String TAG = CreateListFragment.class.getName();
    private static final String BUNDLE_KEY = "overlayMode";

    private EditText mEnterListName;

    public CreateListFragment() {
        // Required empty public constructor
    }

    /**
     * Use this static factory method when you want to use overlay mode.
     *
     * @param enableOverlayMode Configures UI to work with overlay mode.
     * @return A new instance of the fragment prepared for the desired display mode.
     */
    public static CreateListFragment newInstance(boolean enableOverlayMode) {
        CreateListFragment fragment = new CreateListFragment();
        Bundle bundle = new Bundle();
        bundle.putBoolean(BUNDLE_KEY, enableOverlayMode);
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View layout = inflater.inflate(R.layout.fragment_create_list, container, false);

        getActivity().setTitle(getString(R.string.create_list_title));

        // submit list name when user clicks 'Done' key on soft keyboard
        mEnterListName = (EditText) layout.findViewById(R.id.enter_list_name);
        mEnterListName.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_DONE) {
                    createList(v.getText().toString());
                    return true;
                }

                return false;
            }
        });

        // configure UI depending on display mode
        if (isOverlayMode()) {
            TextView createNewList = (TextView) layout.findViewById(R.id.create_new_list);
            createNewList.setTypeface(FontCache.getFont(getActivity(), FontCache.FontName.OSWALD_REGULAR));

            ImageButton backButton = (ImageButton) layout.findViewById(R.id.back_button);
            backButton.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    getFragmentManager().popBackStackImmediate();
                }
            });

            mEnterListName.setHint(getString(R.string.list_name_hint));
        } else {
            View overlayHeader = layout.findViewById(R.id.overlay_header);
            overlayHeader.setVisibility(View.GONE);
        }

        return layout;
    }

    @Override
    public void onStop() {
        super.onStop();
        AndroidUtils.closeSoftKeyboard(getActivity(), mEnterListName);
    }

    private void createList(final String listName) {
        Log.i(TAG, "List name: " + listName);

        boolean isListCreated = RealmDataManager.createList(getActivity(), listName);
        if (isListCreated) {
            // list was successfully created
            AndroidUtils.closeSoftKeyboard(getActivity(), mEnterListName);

            if (isOverlayMode()) {
                // automatically add item to the newly created list when in overlay mode
                Product product = MultipleUserListFragment.getCurrentProduct();
                if (RealmDataManager.addItem(getActivity(), listName, product)) {
                    AndroidUtils.showAddedProductToast(getActivity(), listName);
                } else {
                    AndroidUtils.showDuplicateItemToast(getActivity());
                }

                // dismiss overlay after product has been added
                ((ProductDetailsFragment) getParentFragment()).hideOverlay();
            } else {
                // return to previous fragment in default mode
                getFragmentManager().popBackStackImmediate();
            }
        } else {
            // list name already exists, alert user
            new AlertDialog.Builder(getActivity())
                    .setMessage("List name already exists")
                    .setNeutralButton(android.R.string.ok, new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            dialog.cancel();
                        }
                    })
                    .show();
        }
    }

    private boolean isOverlayMode() {
        return getArguments() != null && getArguments().getBoolean(BUNDLE_KEY);
    }

}
