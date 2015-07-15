/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;

import com.google.gson.Gson;
import com.ibm.mil.readyapps.summit.R;
import com.ibm.mil.readyapps.summit.models.ItemMetaData;
import com.ibm.mil.readyapps.summit.utilities.DownloadImageTask;
import com.ibm.mil.readyapps.summit.utilities.WLPropertyReader;

/**
 * Displays an item in one of the specialized view pagers in the
 * {@link com.ibm.mil.readyapps.summit.fragments.DashboardFragment}.
 *
 * @author Jonathan Ballands
 * @author John Petitto
 */
public class ItemsPageFragment extends Fragment {
    private ItemMetaData itemMetaData;

    /**
     * Create an item to be displayed in a view pager in the
     * {@link com.ibm.mil.readyapps.summit.fragments.DashboardFragment} with the necessary data
     * and proper UI formatting.
     *
     * @param json        The json data representation for the item to be displayed.
     * @param isMultiPage Whether or not the item will be used in a multi-page view pager.
     * @return A new instance of the fragment prepared for proper displaying.
     */
    public static ItemsPageFragment newInstance(String json, boolean isMultiPage) {
        ItemsPageFragment frag = new ItemsPageFragment();
        Bundle b = new Bundle();
        b.putString("json", json);
        b.putBoolean("isMultiPage", isMultiPage);
        frag.setArguments(b);
        return frag;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        String savedData = getArguments().getString("json");
        itemMetaData = new Gson().fromJson(savedData, ItemMetaData.class);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {

        // use appropriate layout depending on use
        int layoutResId;
        if (getArguments().getBoolean("isMultiPage")) {
            layoutResId = R.layout.fragment_multi_items_page;
        } else {
            layoutResId = R.layout.fragment_featured_items_page;
        }
        View rootView = inflater.inflate(layoutResId, container, false);

        ImageView imgView = (ImageView) rootView.findViewById(R.id.image);

        WLPropertyReader wlPropertyReader = new WLPropertyReader(getActivity());
        String fullUrl = wlPropertyReader.serverUrl() + itemMetaData.getImageUrl();
        new DownloadImageTask(imgView).execute(fullUrl);

        if (itemMetaData.getType().equals("product")) {
            rootView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    ProductDetailsFragment fragment = ProductDetailsFragment.newInstance(itemMetaData.getId());
                    getActivity().getSupportFragmentManager()
                            .beginTransaction()
                            .replace(R.id.content_frame, fragment)
                            .addToBackStack(null)
                            .commit();
                }
            });
        }

        return rootView;
    }

}
