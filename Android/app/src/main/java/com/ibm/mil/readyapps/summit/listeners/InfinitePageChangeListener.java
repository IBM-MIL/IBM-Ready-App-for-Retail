/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.listeners;

import android.support.v4.view.ViewPager;

import com.ibm.mil.readyapps.summit.adapters.InfiniteViewPagerAdapter;
import com.ibm.mil.readyapps.summit.views.InfiniteViewPager;

/**
 * Implementation of the {@link android.support.v4.view.ViewPager.OnPageChangeListener}
 * interface designed specifically for the {@link com.ibm.mil.readyapps.summit.views.InfiniteViewPager}.
 * <p/>
 * This listener is needed so that the adapter can be modified appropriately and specific behaviors
 * that are important in the "hot pages" algorithm can be executed at the right time.
 *
 * @author Jonathan Ballands
 */
public class InfinitePageChangeListener implements ViewPager.OnPageChangeListener {

    /**
     * The pager that this listener is listening to.
     */
    private final InfiniteViewPager mPager;

    /**
     * True if the pager is in the settling state, false if not.
     */
    private boolean isSettling;

    /**
     * Constructs a new {@link com.ibm.mil.readyapps.summit.listeners.InfinitePageChangeListener}.
     *
     * @param p The {@link com.ibm.mil.readyapps.summit.views.InfiniteViewPager} this listener
     *          should listen to.
     */
    public InfinitePageChangeListener(final InfiniteViewPager p) {
        this.mPager = p;
        this.isSettling = false;
    }

    // Invoked when a touch or auto scroll is detected
    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
        // Nothing to do...
    }

    // Invoked when a new page is coming to the fore
    @Override
    public void onPageSelected(int position) {
        InfiniteViewPagerAdapter adapter = (InfiniteViewPagerAdapter) this.mPager.getAdapter();
        adapter.setCurrentPage(position);

        if (adapter.getCount() > 1) {
            this.mPager.setListener(null);
            this.mPager.setCurrentItem(position, true);
            this.mPager.setListener(this);
        }
    }

    // Invoked when the scrolling state changes on the pager
    @Override
    public void onPageScrollStateChanged(int state) {

        // Has stopped scrolling
        if (state == ViewPager.SCROLL_STATE_IDLE && this.isSettling) {

            // Check for hot page
            int hotpageCounterpart = ((InfiniteViewPagerAdapter) this.mPager.getAdapter()).getDuplicateHotPageIndex();
            if (hotpageCounterpart != -1) {
                // Move away from hot page
                this.mPager.setCurrentItem(hotpageCounterpart, false);
            }

            // Pager can animate
            this.isSettling = false;
        }

        // Has started scrolling
        if (state == ViewPager.SCROLL_STATE_SETTLING && !this.isSettling) {
            this.isSettling = true;
        }
    }

    /**
     * Gets the {@link com.ibm.mil.readyapps.summit.listeners.InfinitePageChangeListener}
     * associated with this listener.
     *
     * @return The {@link com.ibm.mil.readyapps.summit.listeners.InfinitePageChangeListener}
     * associated with this listener.
     */
    public InfiniteViewPager getPager() {
        return this.mPager;
    }
}