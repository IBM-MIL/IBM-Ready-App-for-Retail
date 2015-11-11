/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.listeners;

import android.view.MotionEvent;
import android.view.View;

import com.ibm.mil.readyapps.summit.views.AutoInfiniteViewPager;

/**
 * Implementation of the {@link android.view.View.OnTouchListener} interface designed to
 * detect when the user has tapped on the pager.
 * <p/>
 * We use this instead of the {@link android.support.v4.view.ViewPager.OnPageChangeListener}'s
 * {@link com.ibm.mil.readyapps.summit.listeners.AutoInfinitePageChangeListener#onPageScrolled(int, float, int) onPageScrolled} function because that function will
 * get called every single time the {@link com.ibm.mil.readyapps.summit.views.AutoInfiniteViewPager#setCurrentItem(int, boolean) setCurrentItem} function
 * gets called and will exhibit strange behavior when the second argument to that method is set
 * to {@code false}.
 * <p/>
 * Therefore, we simply use this listener to determine if the user has touched the pager and,
 * if so, cancel the auto scroll timer.
 *
 * @author Jonathan Ballands
 */
public class AutoInfiniteTouchListener implements View.OnTouchListener {

    /**
     * The pager that this listener is listening to.
     */
    private AutoInfiniteViewPager mPager;

    /**
     * Constructs a new {@link com.ibm.mil.readyapps.summit.listeners.AutoInfiniteTouchListener}.
     *
     * @param p The {@link com.ibm.mil.readyapps.summit.views.AutoInfiniteViewPager} this listener
     *          should listen to.
     */
    public AutoInfiniteTouchListener(final AutoInfiniteViewPager p) {
        this.mPager = p;
    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        if (event.getAction() == MotionEvent.ACTION_DOWN) {
            this.mPager.mTimer.cancel();
        } else if (event.getAction() == MotionEvent.ACTION_UP && !this.mPager.pagesDidMove()) {
            this.mPager.restartAutoScrolling();
        }

        // Return false to let Android know that this listener doesn't satisfy the pager
        return false;
    }

}