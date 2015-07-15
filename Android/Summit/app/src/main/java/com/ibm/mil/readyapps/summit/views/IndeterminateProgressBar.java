/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.views;

import android.app.Activity;
import android.content.Context;
import android.util.AttributeSet;
import android.widget.ProgressBar;

import com.ibm.mil.readyapps.worklight.WLProcedureCaller;

/**
 * An indeterminate progress bar that complies with the WLProcedureCaller.ProgressView interface.
 * To apply a style, declare the progress bar statically via XML and use the style attribute.
 *
 * @author John Petitto
 */
public class IndeterminateProgressBar extends ProgressBar implements WLProcedureCaller.ProgressView {

    public IndeterminateProgressBar(Context context) {
        super(context);

        if (isInEditMode()) {
            return;
        }

        setIndeterminate(true);
    }

    public IndeterminateProgressBar(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public IndeterminateProgressBar(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }

    @Override
    public void start() {
        if (getContext() instanceof Activity) {
            ((Activity) getContext()).runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    setVisibility(VISIBLE);
                }
            });
        }
    }

    @Override
    public void stop() {
        if (getContext() instanceof Activity) {
            ((Activity) getContext()).runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    setVisibility(GONE);
                }
            });
        }
    }

}
