/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.fragments;

import android.app.Activity;
import android.content.Context;
import android.graphics.drawable.ColorDrawable;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.ListFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.ibm.mil.readyapps.summit.R;
import com.ibm.mil.readyapps.summit.models.Product;
import com.ibm.mil.readyapps.summit.models.UserList;
import com.ibm.mil.readyapps.summit.utilities.AndroidUtils;
import com.ibm.mil.readyapps.summit.utilities.DownloadImageTask;
import com.ibm.mil.readyapps.summit.utilities.FontCache;
import com.ibm.mil.readyapps.summit.utilities.RealmDataManager;

import java.util.List;

/**
 * Displays a user's created lists. It can be configured to be displayed in overlay mode when
 * instantiated with {@link #newInstance(boolean)}.
 *
 * @author John Petitto
 */
public class MultipleUserListFragment extends ListFragment {
    private static final String BUNDLE_KEY = "overlayMode";

    private List<UserList> mListData;
    private static Product mProduct;
    private UserListAdapter userAdapter;

    public MultipleUserListFragment() {
        // Required empty public constructor
    }

    /**
     * Use this static factory method when you want to use overlay mode.
     *
     * @param enableOverlayMode Configures UI to work with overlay mode.
     * @return A new instance of the fragment prepared for the desired display mode.
     */
    public static MultipleUserListFragment newInstance(boolean enableOverlayMode) {
        MultipleUserListFragment fragment = new MultipleUserListFragment();
        Bundle bundle = new Bundle();
        bundle.putBoolean(BUNDLE_KEY, enableOverlayMode);
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        if (isOverlayMode()) {
            // overlay mode, load custom layout with fixed header
            View rootView = inflater.inflate(R.layout.fragment_user_list_overlay, container, false);
            createOverlayMode(rootView);
            return rootView;
        } else {
            // regular mode, use default layout for ListFragment
            getActivity().setTitle(getString(R.string.list_title));
            return super.onCreateView(inflater, container, savedInstanceState);
        }
    }

    private void createOverlayMode(View view) {
        TextView chooseList = (TextView) view.findViewById(R.id.choose_list);
        chooseList.setTypeface(FontCache.getFont(getActivity(), FontCache.FontName.OSWALD_REGULAR));

        ImageButton cancelButton = (ImageButton) view.findViewById(R.id.cancel_button);
        cancelButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (getParentFragment() instanceof ProductDetailsFragment) {
                    ((ProductDetailsFragment) getParentFragment()).hideOverlay();
                }
            }
        });

        ImageButton addButton = (ImageButton) view.findViewById(R.id.add_button);
        addButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                getFragmentManager()
                        .beginTransaction()
                        .replace(R.id.fragment_container, CreateListFragment.newInstance(true))
                        .addToBackStack(null)
                        .commit();
            }
        });

        // the masked region at the top of the overlay that should cancel the overlay when clicked
        View parentView = getParentFragment().getView();
        View topBuffer = parentView.findViewById(R.id.top_buffer);
        View fragmentBuffer = parentView.findViewById(R.id.fragment_buffer);
        View.OnClickListener cancelOverlayListener = new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                hideOverlay();
            }
        };
        topBuffer.setOnClickListener(cancelOverlayListener);
        fragmentBuffer.setOnClickListener(cancelOverlayListener);
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        // add header to list view if in non-overlay mode
        if (!isOverlayMode()) {
            addCustomHeader(savedInstanceState);
        }

        getListView().setDivider(new ColorDrawable(android.R.color.transparent));
        getListView().setDividerHeight(AndroidUtils.pixelsToDip(getActivity(), 3));

        // properly displays ripple effect on API 21+
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            getListView().setDrawSelectorOnTop(true);
        }

        mListData = RealmDataManager.getLists(getActivity());
        userAdapter = new UserListAdapter(getActivity(), R.layout.item_multiple_user_list, mListData);
        setListAdapter(userAdapter);
    }

    private void addCustomHeader(Bundle bundle) {
        View headerView = getLayoutInflater(bundle).inflate(R.layout.header_create_new_list, null);

        headerView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                getFragmentManager()
                        .beginTransaction()
                        .replace(R.id.content_frame, CreateListFragment.newInstance(false))
                        .addToBackStack(null)
                        .commit();
            }
        });

        getListView().addHeaderView(headerView);
    }

    @Override
    public void onDestroyView() {
        super.onDestroyView();
        setListAdapter(null);
    }

    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {
        super.onListItemClick(l, v, position, id);

        if (isOverlayMode()) {
            UserList userList = mListData.get(position);

            if (RealmDataManager.addItem(getActivity(), userList.getName(), mProduct)) {
                AndroidUtils.showAddedProductToast(getActivity(), userList.getName());
            } else {
                AndroidUtils.showDuplicateItemToast(getActivity());
            }

            hideOverlay();
        } else {
            UserList userList = mListData.get(position - 1); // account for header
            getFragmentManager()
                    .beginTransaction()
                    .replace(R.id.content_frame,
                            SingleUserListFragment.newInstance(userList.getName()))
                    .addToBackStack(null)
                    .commit();
        }
    }

    /**
     * Allow this fragment to know about the currently active product when in overlay mode.
     *
     * @param product The currently visible product on
     *                {@link com.ibm.mil.readyapps.summit.fragments.ProductDetailsFragment}.
     */
    public void setProduct(Product product) {
        mProduct = product;
    }

    /**
     * Get the current product displayed on
     * {@link com.ibm.mil.readyapps.summit.fragments.ProductDetailsFragment} when this fragment
     * is displayed in overlay mode.
     *
     * @return The product currently being displayed on
     * {@link com.ibm.mil.readyapps.summit.fragments.ProductDetailsFragment}.
     */
    public static Product getCurrentProduct() {
        return mProduct;
    }

    private static class UserListAdapter extends ArrayAdapter<UserList> {
        Context context;
        int layoutResourceId;
        List<UserList> data;

        public UserListAdapter(Context context, int layoutResourceId, List<UserList> data) {
            super(context, layoutResourceId, data);
            this.context = context;
            this.layoutResourceId = layoutResourceId;
            this.data = data;
        }

        static class ViewHolder {
            ImageView thumbnail;
            TextView name;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            View row = convertView;
            ViewHolder holder;

            if (row == null) {
                LayoutInflater inflater = ((Activity) context).getLayoutInflater();
                row = inflater.inflate(R.layout.item_multiple_user_list, parent, false);

                holder = new ViewHolder();
                holder.name = (TextView) row.findViewById(R.id.list_name);
                holder.thumbnail = (ImageView) row.findViewById(R.id.thumbnail);

                row.setTag(holder);
            } else {
                holder = (ViewHolder) row.getTag();
            }

            UserList userList = data.get(position);
            int itemsCount = userList.getProducts().size();
            holder.name.setText(userList.getName() + " (" + itemsCount + ")");

            // load thumbnail from product (or default image if no products in list)
            if (!userList.getProducts().isEmpty()) {
                // use first product image as list thumbnail
                String imageUrl = userList.getProducts().get(0).getImageUrl();
                new DownloadImageTask(holder.thumbnail).execute(imageUrl);
            }

            return row;
        }
    }

    private boolean isOverlayMode() {
        return getArguments() != null && getArguments().getBoolean(BUNDLE_KEY);
    }

    private void hideOverlay() {
        if (getParentFragment() instanceof ProductDetailsFragment) {
            ((ProductDetailsFragment) getParentFragment()).hideOverlay();
        }
    }

}
