/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.views;

import android.content.Context;
import android.support.annotation.NonNull;
import android.util.AttributeSet;
import android.view.GestureDetector;
import android.view.GestureDetector.SimpleOnGestureListener;
import android.view.MotionEvent;
import android.widget.ScrollView;

public class NestingScrollView extends ScrollView {

    private GestureDetector mGestureDetector;

    public NestingScrollView(Context c, AttributeSet attrs) {
        super(c, attrs);

        // Allows view to render in a visual editor
        if (isInEditMode()) {
            return;
        }

        this.mGestureDetector = new GestureDetector(c, new SimpleOnGestureListener() {

            @Override
            public boolean onScroll(MotionEvent e1, MotionEvent e2, float distX, float distY) {
                return Math.abs(distY) > Math.abs(distX);
            }

        });
        this.setFadingEdgeLength(0);
    }

    @Override
    public boolean onInterceptTouchEvent(@NonNull MotionEvent ev) {
        return super.onInterceptTouchEvent(ev) && mGestureDetector.onTouchEvent(ev);
    }

}
