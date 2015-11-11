/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.views;

import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;

import com.ibm.mil.readyapps.summit.adapters.InfiniteViewPagerAdapter;
import com.ibm.mil.readyapps.summit.listeners.InfinitePageChangeListener;

/**
 * A subclass of the {@link android.support.v4.view.ViewPager} class that allows the pager to
 * appear to scroll infinitely in both directions. This pager has its own adapter called the
 * {@link com.ibm.mil.readyapps.summit.adapters.InfiniteViewPagerAdapter} that provides important
 * functionality for this pager.
 * <p/>
 * The pager uses the "hot pages" algorithm and the view model implemented in the
 * {@link com.ibm.mil.readyapps.summit.adapters.InfiniteViewPagerAdapter} to get to the next page,
 * as well as uses a custom listener called
 * {@link com.ibm.mil.readyapps.summit.listeners.InfinitePageChangeListener} to listen
 * for page changes and update the adapter appropriately.
 *
 * @author Jonathan Ballands
 */
public class InfiniteViewPager extends ViewPager {

    /**
     * The listener that this {@link android.support.v4.view.ViewPager} uses to listen to scrolling
     * changes.
     */
    private InfinitePageChangeListener mPageListener;

    /**
     * Constructs a new {@link com.ibm.mil.readyapps.summit.views.InfiniteViewPager}.
     *
     * @param c The context of this pager.
     */
    public InfiniteViewPager(Context c) {
        super(c);
    }

    /**
     * Constructs a new {@link com.ibm.mil.readyapps.summit.views.InfiniteViewPager}.
     *
     * @param c     The context of this pager.
     * @param attrs Any attributes associated.
     */
    public InfiniteViewPager(Context c, AttributeSet attrs) {
        super(c, attrs);
    }

    @Override
    public void setAdapter(PagerAdapter adapter) {
        super.setAdapter(adapter);

        setOffscreenPageLimit(5);

        this.mPageListener = new InfinitePageChangeListener(this);
        super.setOnPageChangeListener(this.mPageListener);

        InfiniteViewPagerAdapter theAdapter = (InfiniteViewPagerAdapter) adapter;
        this.setCurrentItem(theAdapter.getCurrentPage());
    }

    /**
     * A getter method that returns the {@link com.ibm.mil.readyapps.summit.listeners.InfinitePageChangeListener}
     * associated with this pager.
     *
     * @return The {@link com.ibm.mil.readyapps.summit.listeners.InfinitePageChangeListener}
     * associated with this.
     */
    public InfinitePageChangeListener getListener() {
        return this.mPageListener;
    }

    /**
     * A setter method that sets the {@link com.ibm.mil.readyapps.summit.listeners.InfinitePageChangeListener}
     * associated with this pager.
     *
     * @param listener The {@link com.ibm.mil.readyapps.summit.listeners.InfinitePageChangeListener}
     *                 you want to associate with this.
     */
    public void setListener(InfinitePageChangeListener listener) {
        this.mPageListener = listener;
    }

}
