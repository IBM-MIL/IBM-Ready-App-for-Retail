/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.fragments;

import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.reflect.TypeToken;
import com.ibm.mil.readyapps.summit.R;
import com.ibm.mil.readyapps.summit.adapters.InfiniteViewPagerAdapter;
import com.ibm.mil.readyapps.summit.adapters.MultiPageViewPagerAdapter;
import com.ibm.mil.readyapps.summit.models.ItemMetaData;
import com.ibm.mil.readyapps.summit.utilities.FontCache;
import com.ibm.mil.readyapps.summit.utilities.Utils;
import com.ibm.mil.readyapps.summit.views.AutoInfiniteViewPager;
import com.ibm.mil.readyapps.summit.views.CircularProgressDialog;
import com.ibm.mil.readyapps.worklight.WLProcedureCaller;
import com.ibm.mqa.Log;
import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLResponse;
import com.worklight.wlclient.api.WLResponseListener;

import java.lang.reflect.Type;
import java.util.List;
import java.util.Locale;

/**
 * The fragment for the main dashboard in Summit.
 *
 * @author John Petitto
 * @author Jonathan Ballands
 */
public class DashboardFragment extends Fragment {
    private static final String TAG = DashboardFragment.class.getName();

    private static List<ItemMetaData> allItems;
    private static List<ItemMetaData> featuredItems;
    private static List<ItemMetaData> recommendedItems;

    private AutoInfiniteViewPager mFeaturedItemsPager;
    private ViewPager mRecommendedItemsPager;
    private ViewPager mShopAllItemsPager;

    public DashboardFragment() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View rootView = inflater.inflate(R.layout.fragment_dashboard, container, false);

        getActivity().setTitle(getString(R.string.landing_title));

        // Instantiate private properties
        mFeaturedItemsPager = (AutoInfiniteViewPager) rootView.findViewById(R.id.featured_items_pager);
        mRecommendedItemsPager = (ViewPager) rootView.findViewById(R.id.recommended_items_pager);
        mShopAllItemsPager = (ViewPager) rootView.findViewById(R.id.shopall_items_pager);

        // set custom typefaces
        TextView recommendedText = (TextView) rootView.findViewById(R.id.recommended_text);
        recommendedText.setTypeface(FontCache.getFont(getActivity(),
                FontCache.FontName.OPEN_SANS_REGULAR));
        TextView shopAllText = (TextView) rootView.findViewById(R.id.shop_all_text);
        shopAllText.setTypeface(FontCache.getFont(getActivity(),
                FontCache.FontName.OPEN_SANS_REGULAR));

        getDashboardData();

        return rootView;
    }

    private void getDashboardData() {
        // see if data was cached previously
        if (Utils.notNull(allItems, recommendedItems, featuredItems)) {
            // data cached, set data adapters directly
            setDataAdapters();
            return;
        }

        // make WL call to fetch data
        WLProcedureCaller wlProcedureCaller = new WLProcedureCaller("SummitAdapter",
                "getHomeViewMetadata", new CircularProgressDialog(getActivity()));

        // retrieve current user locale
        Locale locale = getResources().getConfiguration().locale;
        Object[] params = new Object[]{locale.getDisplayName()};

        wlProcedureCaller.invoke(params, new WLResponseListener() {
            @Override
            public void onSuccess(WLResponse wlResponse) {
                Log.i(TAG, wlResponse.getResponseJSON().toString());
                parseJson(wlResponse.getResponseJSON().toString());
            }

            @Override
            public void onFailure(WLFailResponse wlFailResponse) {
                Log.i(TAG, wlFailResponse.getErrorMsg());
            }
        });
    }

    private void parseJson(String json) {
        JsonObject resultObject = Utils.getRawResultObject(json);

        // parse and store data for each property type (all, recommended, featured)
        allItems = getPropertyData(resultObject, "all");
        recommendedItems = getPropertyData(resultObject, "recommended");
        featuredItems = getPropertyData(resultObject, "featured");

        getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                setDataAdapters();
            }
        });
    }

    private static List<ItemMetaData> getPropertyData(JsonObject object, String propertyName) {
        JsonArray propertyArray = object.getAsJsonArray(propertyName);
        Gson gson = new Gson();
        Type type = new TypeToken<List<ItemMetaData>>() {
        }.getType();
        return gson.fromJson(propertyArray, type);
    }

    private void setDataAdapters() {
        mFeaturedItemsPager.setAdapter(
                new InfiniteViewPagerAdapter(getChildFragmentManager(), featuredItems));
        mRecommendedItemsPager.setAdapter(
                new MultiPageViewPagerAdapter(getChildFragmentManager(), recommendedItems));
        mShopAllItemsPager.setAdapter(
                new MultiPageViewPagerAdapter(getChildFragmentManager(), allItems));
    }

}
