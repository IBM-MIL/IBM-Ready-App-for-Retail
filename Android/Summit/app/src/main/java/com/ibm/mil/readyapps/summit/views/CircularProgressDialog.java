/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.views;

import android.app.Dialog;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.view.Window;

import com.ibm.mil.readyapps.summit.R;
import com.ibm.mil.readyapps.worklight.WLProcedureCaller;

/**
 * A custom dialog that is used for displaying a circular progress icon that animates. It's
 * configured to work properly as a ProgressView passed to a WLProcedureCaller object.
 *
 * @author John Petitto
 */
public class CircularProgressDialog extends Dialog implements WLProcedureCaller.ProgressView {

    public CircularProgressDialog(Context context) {
        super(context);

        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.dialog_progress_circular);
        getWindow().setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));
        setCancelable(false);
    }

    @Override
    public void start() {
        show();
    }

    @Override
    public void stop() {
        // checking for isShowing() prevents a possible memory leak
        if (isShowing()) {
            dismiss();
        }
    }

}
