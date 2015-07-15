/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.views;

import android.content.Context;
import android.os.CountDownTimer;
import android.support.v4.view.PagerAdapter;
import android.util.AttributeSet;

import com.ibm.mil.readyapps.summit.listeners.AutoInfinitePageChangeListener;
import com.ibm.mil.readyapps.summit.listeners.AutoInfiniteTouchListener;

/**
 * A subclass of the {@link com.ibm.mil.readyapps.summit.views.InfiniteViewPager} class that allows
 * appear to scroll infinitely in both directions and scroll automatically after a certain time
 * elapses. If the user taps the pager, the auto scroller will be interrupted until no more user
 * input is detected. Then, the auto scroller will resume.
 * <p/>
 * This class uses the same {@link com.ibm.mil.readyapps.summit.adapters.InfiniteViewPagerAdapter} as
 * the {@link com.ibm.mil.readyapps.summit.views.InfiniteViewPager}.
 *
 * @author Jonathan Ballands
 */
public class AutoInfiniteViewPager extends InfiniteViewPager {

    /**
     * The timer that counts to the next auto scroll.
     */
    public CountDownTimer mTimer;

    /**
     * The amount of time desired between auto scrolls.
     */
    private static final int AUTO_PAGE_TIME_MS = 4000;

    /**
     * A boolean that's true if the user touched down on this pager but didn't move the pages,
     * false if the user did move the pages.
     */
    private boolean pagesDidMove;

    /**
     * A reference to the number of pages available in the adapter.
     */
    private int pages;

    /**
     * A reference to the current page in the adapter.
     */
    private int currentPage;

    /**
     * A reference to the {@link android.view.View.OnTouchListener} registered with this pager.
     */
    private AutoInfiniteTouchListener mTouchListener;

    /**
     * A reference to the {@link android.support.v4.view.ViewPager.OnPageChangeListener} registered
     * with this pager.
     */
    private AutoInfinitePageChangeListener mPageListener;

    /**
     * Constructs a new {@link com.ibm.mil.readyapps.summit.views.AutoInfiniteViewPager}.
     *
     * @param c The context of this pager.
     */
    public AutoInfiniteViewPager(Context c) {
        super(c);
    }

    /**
     * Constructs a new {@link com.ibm.mil.readyapps.summit.views.AutoInfiniteViewPager}.
     *
     * @param c     The context of this pager.
     * @param attrs Any attributes associated.
     */
    public AutoInfiniteViewPager(Context c, AttributeSet attrs) {
        super(c, attrs);
    }

    @Override
    public void setAdapter(PagerAdapter adapter) {
        super.setAdapter(adapter);

        this.pages = this.getAdapter().getCount();
        this.currentPage = super.getCurrentItem();

        this.mTouchListener = new AutoInfiniteTouchListener(this);
        super.setOnTouchListener(mTouchListener);

        this.mPageListener = new AutoInfinitePageChangeListener(this);
        super.setOnPageChangeListener(mPageListener);

        this.pagesDidMove = false;

        // Define new abstract class CountDownTimer inline
        this.mTimer = new CountDownTimer(AUTO_PAGE_TIME_MS, AUTO_PAGE_TIME_MS) {

            @Override
            public void onTick(long millisUntilFinished) {
                // Nothing to do on tick...
            }

            @Override
            public void onFinish() {
                nextPage();
            }
        };

        // Start timer
        this.mTimer.start();
    }

    /**
     * A getter method that returns the {@link com.ibm.mil.readyapps.summit.listeners.AutoInfiniteTouchListener}
     * associated with this pager.
     *
     * @return The {@link com.ibm.mil.readyapps.summit.listeners.AutoInfiniteTouchListener}
     * associated with this pager.
     */
    public AutoInfiniteTouchListener getTouchListener() {
        return this.mTouchListener;
    }

    /**
     * A setter method that sets the {@link com.ibm.mil.readyapps.summit.listeners.AutoInfiniteTouchListener}
     * associated with this pager.
     *
     * @param listener The {@link com.ibm.mil.readyapps.summit.listeners.AutoInfiniteTouchListener}
     *                 you want to associate with this.
     */
    public void setTouchListener(AutoInfiniteTouchListener listener) {
        this.mTouchListener = listener;
    }

    /**
     * A getter method that returns the {@link com.ibm.mil.readyapps.summit.listeners.AutoInfinitePageChangeListener}
     * associated with this pager.
     *
     * @return The {@link com.ibm.mil.readyapps.summit.listeners.AutoInfinitePageChangeListener}
     * associated with this pager.
     */
    public AutoInfinitePageChangeListener getPageListener() {
        return this.mPageListener;
    }

    /**
     * A setter method that sets the {@link com.ibm.mil.readyapps.summit.listeners.AutoInfinitePageChangeListener}
     * associated with this pager.
     *
     * @param listener The {@link com.ibm.mil.readyapps.summit.listeners.AutoInfinitePageChangeListener}
     *                 you want to associate with this.
     */
    public void setPageListener(AutoInfinitePageChangeListener listener) {
        this.mPageListener = listener;
    }

    public boolean pagesDidMove() {
        return this.pagesDidMove;
    }

    public void setPagesDidMove(boolean val) {
        this.pagesDidMove = val;
    }

    /**
     * Restarts the auto scrolling timer, performing the necessary preparations.
     */
    public void restartAutoScrolling() {
        this.currentPage = super.getCurrentItem();
        this.mTimer.start();
    }

    /**
     * Animates the pager to the next page.
     */
    private void nextPage() {
        this.currentPage = (this.currentPage + 1) % (this.pages);
        this.setCurrentItem(this.currentPage, true);

        // Check to see if the hot page rule got invoked on the parent's OnPageChangeListener
        if (this.currentPage == this.pages - 1 && this.pages > 1) {
            this.currentPage = 1;

            // No need to scroll because parent class handles this for us with its InfinitePageChangeListener
        }

        this.mTimer.cancel();
        this.mTimer.start();
    }

}
