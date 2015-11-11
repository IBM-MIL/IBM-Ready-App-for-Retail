package com.ibm.mil.readyapps.summit;

import android.app.Activity;

import junit.framework.Assert;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.annotation.Config;

import com.ibm.mil.readyapps.summit.activities.MainActivity;


@Config(emulateSdk = 18, reportSdk = 18)
@RunWith(RobolectricTestRunner.class)
public class ApplicationTest {

    @Test
    public void testActivityFound() {
        Activity activity = Robolectric.buildActivity(MainActivity.class).create().get();

        Assert.assertNotNull(activity);
    }
}