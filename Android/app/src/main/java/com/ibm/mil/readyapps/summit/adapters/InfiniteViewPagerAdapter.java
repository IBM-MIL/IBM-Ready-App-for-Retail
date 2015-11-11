/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.adapters;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentManager;
import android.support.v4.app.FragmentStatePagerAdapter;

import com.google.gson.Gson;
import com.ibm.mil.readyapps.summit.fragments.ItemsPageFragment;
import com.ibm.mil.readyapps.summit.models.ItemMetaData;

import java.util.LinkedList;
import java.util.List;

/**
 * An adapter for the {@link com.ibm.mil.readyapps.summit.views.InfiniteViewPager} that adapts
 * resources using the "hot pages" algorithm.
 *
 * @author Jonathan Ballands
 */
public class InfiniteViewPagerAdapter extends FragmentStatePagerAdapter {

    /**
     * A list of fragments in the "hot page" format.
     */
    private List<Fragment> mPagerFragments;

    /**
     * The current page being displayed by the pager.
     */
    private int currentPage;

    /**
     * Constructs a new {@link com.ibm.mil.readyapps.summit.adapters.InfiniteViewPagerAdapter}.
     *
     * @param fm             The fragment manager for the app.
     * @param pagerResources A linked list of resources that this adapter should load into fragments.
     *                       A new linked list called {@link #mPagerFragments mPagerFragments} will
     *                       be generated following the "hot pages" algorithm.
     */
    public InfiniteViewPagerAdapter(FragmentManager fm, List<ItemMetaData> pagerResources) {
        super(fm);
        this.currentPage = -1;

        this.mPagerFragments = new LinkedList<>();

        Gson gson = new Gson();

        // Set up resources
        if (pagerResources != null && pagerResources.size() > 1) {
            int finalResource = pagerResources.size() - 1;

            // Put the "hot pages" in
            mPagerFragments.add(ItemsPageFragment.newInstance(gson.toJson(pagerResources.get(finalResource)), false));
            mPagerFragments.add(ItemsPageFragment.newInstance(gson.toJson(pagerResources.get(0)), false));

            // Put the regular pages in
            for (int i = 0; i < pagerResources.size(); i++) {
                mPagerFragments.add(i + 1, ItemsPageFragment.newInstance(gson.toJson(pagerResources.get(i)), false));
            }

            this.currentPage = 1;
        } else if (pagerResources != null && pagerResources.size() == 1) {
            this.mPagerFragments.add(ItemsPageFragment.newInstance(gson.toJson(pagerResources), false));

            this.currentPage = 0;
        }
    }

    @Override
    public Fragment getItem(int position) {
        if (this.mPagerFragments == null || position > this.mPagerFragments.size() || position < 0) {
            return null;
        }

        return this.mPagerFragments.get(position);
    }

    @Override
    public int getCount() {
        if (this.mPagerFragments == null) {
            return 0;
        }
        return this.mPagerFragments.size();
    }

    @Override
    public int getItemPosition(Object object) {
        return POSITION_NONE;
    }

    /**
     * A getter method that returns the {@link #currentPage currentPage}.
     *
     * @return The current page this adapter thinks its associated pager is on.
     */
    public int getCurrentPage() {
        return this.currentPage;
    }

    /**
     * A setter method that sets the {@link #currentPage currentPage}.
     *
     * @param position The position you want this adapter to think its associated pager is on.
     */
    public void setCurrentPage(int position) {
        this.currentPage = position;
    }

    /**
     * Gets the index of the duplicate for the so-called "hot page", or the special edge pages
     * that this adapter automatically adds to its data model. For example, if the current page is
     * 0, then this method will return the size of the modified data model - 2.
     *
     * @return The corresponding page if {@link #currentPage currentPage} is a "hot page", -1 otherwise.
     */
    public int getDuplicateHotPageIndex() {
        int fragmentListSize = this.mPagerFragments.size();

        if (this.currentPage == 0) {
            return fragmentListSize - 2;
        } else if (this.currentPage == fragmentListSize - 1) {
            return 1;
        }

        return -1;
    }
}
