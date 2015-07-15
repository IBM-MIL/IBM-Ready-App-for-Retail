/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.activities;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.res.Configuration;
import android.location.Location;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.widget.Toolbar;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.TextView;

import com.ibm.mil.readyapps.summit.R;
import com.ibm.mil.readyapps.summit.adapters.MenuAdapter;
import com.ibm.mil.readyapps.summit.fragments.DashboardFragment;
import com.ibm.mil.readyapps.summit.fragments.MultipleUserListFragment;
import com.ibm.mil.readyapps.summit.fragments.ProductDetailsFragment;
import com.ibm.mil.readyapps.summit.fragments.ProfileFragment;
import com.ibm.mil.readyapps.summit.utilities.EstimoteUtils.EstimoteManager;
import com.ibm.mil.readyapps.summit.utilities.FontCache;
import com.ibm.mil.readyapps.summit.utilities.WLAuthenticationHandler;
import com.ibm.mil.readyapps.summit.views.CircularProgressDialog;
import com.ibm.mil.readyapps.worklight.WLProcedureCaller;
import com.ibm.mqa.Log;
import com.ibm.mqa.MQA;
import com.worklight.wlclient.api.WLClient;
import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLResponse;
import com.worklight.wlclient.api.WLResponseListener;
import com.xtify.sdk.api.NotificationsPreference;
import com.xtify.sdk.api.XtifyLocation;
import com.xtify.sdk.api.XtifySDK;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * The main activity for the entire app. It contains the toolbar, navigation drawer and a container
 * for swapping out the different fragments of the app. Internally it leverages a fragment creator
 * interface for lazily instantiating a fragment. This prevents a fragment from being created
 * every time a user selects a menu item in the drawer to navigate to.
 *
 * @author John Petitto
 * @author Tanner Preiss
 */
public class MainActivity extends ActionBarActivity {
    private static final String TAG = MainActivity.class.getName();
    private static final String MQA_APP_KEY = "9e4b201e8ddc8da8874ba38ecb33efcec9823146";
    private static final String XTIFY_PROPERTIES = "xtify.properties";

    private DrawerLayout mDrawerLayout;
    private ActionBarDrawerToggle mDrawerToggle;
    private TextView mToolbarTitle;
    private WLAuthenticationHandler mAuthenticationHandler;

    // statically initialize fragment creators for the navigation drawer
    private static Map<Class<? extends Fragment>, FragmentCreator> mFragmentCreatorMap;

    static {
        mFragmentCreatorMap = new HashMap<>();
        mFragmentCreatorMap.put(DashboardFragment.class, new FragmentCreator() {
            @Override
            public Fragment createInstance() {
                return new DashboardFragment();
            }
        });
        mFragmentCreatorMap.put(MultipleUserListFragment.class, new FragmentCreator() {
            @Override
            public Fragment createInstance() {
                return new MultipleUserListFragment();
            }
        });
        mFragmentCreatorMap.put(ProductDetailsFragment.class, new FragmentCreator() {
            @Override
            public Fragment createInstance() {
                return new ProductDetailsFragment();
            }
        });
        mFragmentCreatorMap.put(ProfileFragment.class, new FragmentCreator() {
            @Override
            public Fragment createInstance() {
                return new ProfileFragment();
            }
        });
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        // replace action bar with new toolbar
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);
        getSupportActionBar().setDisplayShowCustomEnabled(true);
        getSupportActionBar().setDisplayShowTitleEnabled(false);

        // customize toolbar title typeface
        mToolbarTitle = (TextView) findViewById(R.id.toolbar_title);
        mToolbarTitle.setTypeface(FontCache.getFont(this, FontCache.FontName.OSWALD_REGULAR));

        // configure navigation drawer with toggle button (hamburger icon)
        mDrawerLayout = (DrawerLayout) findViewById(R.id.drawer_layout);
        mDrawerToggle = new ActionBarDrawerToggle(this, mDrawerLayout,
                R.string.drawer_open, R.string.drawer_close);
        mDrawerLayout.setDrawerListener(mDrawerToggle);

        // add menu adapter to the drawer's list view
        ListView drawerMenu = (ListView) findViewById(R.id.drawer_menu);
        drawerMenu.setAdapter(new MenuAdapter(this));
        drawerMenu.setOnItemClickListener(new DrawerItemClickListener());

        // start Estimote beacon monitoring
        EstimoteManager.getInstance(this).setupBeaconMonitoring();
        EstimoteManager.getInstance(this).setupBeaconRanging();

        // start Xtify notifications
        NotificationsPreference.setIcon(this, R.drawable.summit_logo_sm);
        Properties xtifyProperties = new Properties();
        try {
            xtifyProperties.load(this.getAssets().open(XTIFY_PROPERTIES));
        } catch (IOException e) {
            e.printStackTrace();
        }
        XtifySDK.start(getApplicationContext(),
                xtifyProperties.getProperty("googleProjectNum"),
                xtifyProperties.getProperty("xtifyAppKey"));

        connectWithWL();

        // MQA setup
        com.ibm.mqa.config.Configuration configuration = new com.ibm.mqa.config.Configuration.Builder(this)
                .withAPIKey(MQA_APP_KEY)
                .withMode(MQA.Mode.MARKET)
                .build();

        MQA.startNewSession(this, configuration);
    }

    @Override
    protected void onPostCreate(Bundle savedInstanceState) {
        super.onPostCreate(savedInstanceState);
        mDrawerToggle.syncState();
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
        mDrawerToggle.onConfigurationChanged(newConfig);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        return mDrawerToggle.onOptionsItemSelected(item) || super.onOptionsItemSelected(item);
    }

    @Override
    public void onBackPressed() {
        // close drawer if open
        if (mDrawerLayout.isDrawerOpen(GravityCompat.START)) {
            mDrawerLayout.closeDrawer(GravityCompat.START);
            return;
        }

        super.onBackPressed();
    }

    @Override
    protected void onStart() {
        super.onStart();
        EstimoteManager.getInstance(this).setupOnStart();
    }

    @Override
    protected void onResume() {
        super.onResume();
        EstimoteManager.getInstance(this).setupOnResume();
    }

    @Override
    protected void onStop() {
        super.onStop();

        EstimoteManager.getInstance(this).setupOnStop();

        // send Xtify notification if in demo mode
        SharedPreferences preferences = getSharedPreferences("UserPrefs", MODE_PRIVATE);
        if (preferences.getBoolean("demoMode", false)) {
            // send Xtify notification
            Location summitStoreLocation = new Location("");
            summitStoreLocation.setLatitude(30.267d);
            summitStoreLocation.setLongitude(-97.743d);

            XtifyLocation xtifyLocation = new XtifyLocation(getApplicationContext());
            xtifyLocation.updateLocation(summitStoreLocation,
                    new XtifyLocation.LocationUpdateListener() {
                        @Override
                        public void onUpdateComplete(boolean result, Location location) {
                            Log.d("NOTIFY", "you have completed the xtify notification");
                        }
                    });
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();

        EstimoteManager.getInstance(this).setupOnDestroy();

        // delete userId and demoMode from SharedPreferences
        SharedPreferences preferences = getSharedPreferences("UserPrefs", MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();
        editor.remove("userId");
        editor.remove("demoMode");
        editor.apply();
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        // if user authenticated in LoginActivity, run the handler if set
        if (requestCode == LoginActivity.AUTHENTICATION_REQUEST_CODE &&
                resultCode == RESULT_OK && mAuthenticationHandler != null) {
            mAuthenticationHandler.handle();
        }
    }

    private void connectWithWL() {
        WLClient wlClient = WLClient.createInstance(this);

        // display progress dialog while connecting to WL
        final CircularProgressDialog progressDialog = new CircularProgressDialog(this);
        progressDialog.start();

        wlClient.connect(new WLResponseListener() {
            @Override
            public void onSuccess(WLResponse wlResponse) {
                Log.i(TAG, "Connection to WL server successful!");

                progressDialog.stop();

                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        // load initial fragment
                        getSupportFragmentManager()
                                .beginTransaction()
                                .replace(R.id.content_frame, new DashboardFragment(),
                                        DashboardFragment.class.getName())
                                .commitAllowingStateLoss();
                    }
                });
            }

            @Override
            public void onFailure(WLFailResponse wlFailResponse) {
                Log.e(TAG, wlFailResponse.getErrorMsg());

                progressDialog.stop();

                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        new RetryDialog(MainActivity.this).show();
                    }
                });
            }
        }, WLProcedureCaller.defaultOptions());
    }

    @Override
    public void setTitle(CharSequence title) {
        mToolbarTitle.setText(title);
    }

    /**
     * Set the WL authentication handler that gets triggered after a user successfully authenticates
     * themselves inside the {@link com.ibm.mil.readyapps.summit.activities.LoginActivity}.
     *
     * @param handler Handles the event where the user authenticates with WL
     */
    public void setAuthenticationHandler(WLAuthenticationHandler handler) {
        mAuthenticationHandler = handler;
    }

    // allows you to lazily create a Fragment instance
    private interface FragmentCreator {
        Fragment createInstance();
    }

    private class DrawerItemClickListener implements ListView.OnItemClickListener {
        @Override
        public void onItemClick(AdapterView parent, View view, int position, long id) {
            mDrawerLayout.closeDrawer(GravityCompat.START);

            // match item position with Fragment class type, allowing us to use the fragment
            // creator map to lazily initialize an instance
            Class fragmentClass;
            switch (position) {
                case 0:
                    fragmentClass = DashboardFragment.class;
                    break;
                case 1:
                    fragmentClass = MultipleUserListFragment.class;
                    break;
                case 2:
                    fragmentClass = ProfileFragment.class;
                    break;
                default:
                    return;
            }

            // show login screen if user is not authenticated before proceeding to user lists
            if (fragmentClass == MultipleUserListFragment.class) {
                if (!LoginActivity.isUserAuthenticated(MainActivity.this)) {
                    setAuthenticationHandler(new WLAuthenticationHandler() {
                        @Override
                        public void handle() {
                            // proceed to desired fragment after user has successfully authenticated
                            getSupportFragmentManager()
                                    .beginTransaction()
                                    .replace(R.id.content_frame, new MultipleUserListFragment(),
                                            MultipleUserListFragment.class.getName())
                                    .addToBackStack(null)
                                    .commitAllowingStateLoss();
                        }
                    });

                    Intent intent = new Intent(MainActivity.this, LoginActivity.class);
                    startActivityForResult(intent, LoginActivity.AUTHENTICATION_REQUEST_CODE);
                    return;
                }
            }

            // only transition to selected item if it's not currently visible
            Fragment requestFragment = getSupportFragmentManager()
                    .findFragmentByTag(fragmentClass.getName());
            if (requestFragment == null || !requestFragment.isVisible()) {
                getSupportFragmentManager()
                        .beginTransaction()
                        .replace(R.id.content_frame,
                                mFragmentCreatorMap.get(fragmentClass).createInstance(),
                                fragmentClass.getName())
                        .addToBackStack(null)
                        .commit();
            }
        }
    }

    private class RetryDialog extends AlertDialog {
        public RetryDialog(Context context) {
            super(context);

            setMessage(getString(R.string.worklight_failure));
            setCancelable(false);
            setButton(BUTTON_NEUTRAL, getString(R.string.retry), new OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    if (isShowing()) {
                        dismiss();
                    }
                    connectWithWL();
                }
            });
            setButton(BUTTON_NEGATIVE, getString(R.string.cancel), new OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    finish();
                }
            });
        }
    }

}
