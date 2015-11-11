/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.activities;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.v7.app.ActionBarActivity;

import com.ibm.mil.readyapps.summit.R;

/**
 * A simple activity for hosting a splash screen. This activity should be the application launch
 * activity as defined in the manifest file. The activity that follows the splash screen will
 * be launched automatically after a short period of time.
 *
 * @author John Petitto
 */
public class SplashActivity extends ActionBarActivity {
    private static final long SPLASH_DURATION = 2500;
    private Handler mHandler;
    private Runnable mRunnable;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash);
    }

    @Override
    public void onStart() {
        super.onStart();

        // proceed to main activity after the specified amount of time
        mRunnable = new Runnable() {
            @Override
            public void run() {
                startActivity(new Intent(SplashActivity.this, MainActivity.class));
                finish();
            }
        };
        mHandler = new Handler();
        mHandler.postDelayed(mRunnable, SPLASH_DURATION);
    }

    @Override
    public void onStop() {
        super.onStop();
        mHandler.removeCallbacks(mRunnable);
    }

}
