/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.views;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.ibm.mil.readyapps.summit.R;

/**
 * A custom {@code Toast} that matches the design requirements for the Summit app.
 *
 * @author Blake Ball
 * @author John Petitto
 */
public class SummitToast extends Toast {
    private TextView mMessage;
    private ImageView mIcon;

    /**
     * Instantiates a {@code Toast} object inflated with a custom layout, duration, and position.
     * Call {@link #setMessage(CharSequence)} and
     * {@link #setIcon(android.graphics.drawable.Drawable)} to customize the content of the
     * {@code Toast}.
     *
     * @param context
     */
    public SummitToast(Context context) {
        super(context);

        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        View rootLayout = inflater.inflate(R.layout.toast_summit, null);
        setView(rootLayout);
        setDuration(Toast.LENGTH_LONG);
        setGravity(Gravity.BOTTOM | Gravity.FILL_HORIZONTAL, 0, 20);

        mMessage = (TextView) rootLayout.findViewById(R.id.message);
        mIcon = (ImageView) rootLayout.findViewById(R.id.icon);
    }

    /**
     * The text to appear inside the {@code Toast}.
     *
     * @param message
     */
    public void setMessage(CharSequence message) {
        mMessage.setText(message);
    }

    /**
     * The icon to appear inside the {@code Toast}.
     *
     * @param icon
     */
    public void setIcon(Drawable icon) {
        mIcon.setImageDrawable(icon);
    }
}
