/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.listeners;

import android.support.v4.view.ViewPager;

import com.ibm.mil.readyapps.summit.views.AutoInfiniteViewPager;

/**
 * An extension of the {@link com.ibm.mil.readyapps.summit.listeners.InfinitePageChangeListener}
 * that only extends the functionality of the {@link #onPageScrollStateChanged(int) onPageScrollStateChange}
 * method.
 * <p/>
 * The reason for this is to determine when the pager has finished paging and the animations have
 * settled. At this point, we would like to restart the auto scroll timer so that the pager will
 * begin auto scrolling again.
 * <p/>
 * See the {@link com.ibm.mil.readyapps.summit.listeners.AutoInfiniteTouchListener}
 * to see how the auto scrolling timer stops.
 *
 * @author Jonathan Ballands
 */
public class AutoInfinitePageChangeListener extends InfinitePageChangeListener implements ViewPager.OnPageChangeListener {

    /**
     * Constructs a new {@link com.ibm.mil.readyapps.summit.listeners.AutoInfinitePageChangeListener}.
     *
     * @param p The {@link com.ibm.mil.readyapps.summit.views.AutoInfiniteViewPager} this listener
     *          should listen to.
     */
    public AutoInfinitePageChangeListener(final AutoInfiniteViewPager p) {
        super(p);
    }

    // Invoked when a touch or auto scroll is detected
    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {
        super.onPageScrolled(position, positionOffset, positionOffsetPixels);
        ((AutoInfiniteViewPager) super.getPager()).setPagesDidMove(true);
    }

    // Invoked when a new page is coming to the fore
    @Override
    public void onPageSelected(int position) {
        super.onPageSelected(position);
    }

    // Invoked when the scrolling state changes on the pager
    @Override
    public void onPageScrollStateChanged(int state) {

        // Let the super class solve all the hot page stuff first before we do some auto scrolling
        // nonsense
        super.onPageScrollStateChanged(state);

        // If the pager is sitting idle when this gets called, just restart the timer
        if (state == ViewPager.SCROLL_STATE_IDLE) {
            ((AutoInfiniteViewPager) super.getPager()).restartAutoScrolling();
            ((AutoInfiniteViewPager) super.getPager()).setPagesDidMove(false);
        }
    }
}