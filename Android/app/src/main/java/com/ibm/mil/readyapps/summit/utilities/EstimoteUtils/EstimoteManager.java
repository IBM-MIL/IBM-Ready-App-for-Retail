/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.utilities.EstimoteUtils;

import android.app.Activity;
import android.app.NotificationManager;
import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.os.RemoteException;

import com.ibm.mqa.Log;

import com.estimote.sdk.Beacon;
import com.estimote.sdk.BeaconManager;
import com.estimote.sdk.Region;

import java.util.ArrayList;
import java.util.List;

public class EstimoteManager {

    private static final String estimoteRegionName = "MIL_LAB";
    private BeaconManager mBeaconManager;
    private Activity mRootActivity;
    private NotificationManager mNotificationManager;

    private List<BeaconStrategy> mBeaconStrategies;


    private static EstimoteManager instance = null;
    /**
     * ALL_ESTIMOTE_BEACONS_REGION is the beacon region that will be scanned.
     * If set to all null parameters then the region is set to all/any region scanned.
     */
    private static Region ALL_ESTIMOTE_BEACONS_REGION;
    /**
     * hasBluetooth is a boolean that is true if the device currently has Bluetooth Low Energy
     */
    private static boolean hasBluetooth;

    private EstimoteManager(Activity newRootActivity) {
        mRootActivity = newRootActivity;
        mBeaconManager
                = new BeaconManager(mRootActivity.getApplicationContext());
        mNotificationManager
                = (NotificationManager) mRootActivity.getSystemService(Context.NOTIFICATION_SERVICE);
        ALL_ESTIMOTE_BEACONS_REGION
                = new Region(estimoteRegionName, null, null, null);
        mBeaconStrategies = new ArrayList<>();
    }

    /**
     * getInstance() returns the singleton instance of the EstimoteManager class.
     *
     * @param managersActivity the Activity that owns the EstimoteManager.
     * @return EstimoteManager singleton instance.
     */
    public static synchronized EstimoteManager getInstance(Activity managersActivity) {
        if (instance == null) {
            instance = new EstimoteManager(managersActivity);
            hasBluetooth = managersActivity.getPackageManager()
                    .hasSystemFeature(PackageManager.FEATURE_BLUETOOTH_LE);
        }
        return instance;
    }

    /**
     * setupBeaconMonitoring() is a wrapper for BeaconManager.setMonitoringListener()
     * and notifies the BeaconStrategy(s) when onEnteredRegion() and onExitedRegion() is
     * called, so that the BeaconStrategy can implement the specific actions required when
     * entering and exiting a region.
     */
    public void setupBeaconMonitoring() {
        //check if device has Bluetooth LE enabled.
        if (!hasBluetooth) {
            return;
        }
        mBeaconManager.setBackgroundScanPeriod(10000, 5000);

        mBeaconManager.setMonitoringListener(new BeaconManager.MonitoringListener() {
            @Override
            public void onEnteredRegion(Region region, List<Beacon> beacons) {
                if (mBeaconStrategies.size() > 0) {
                    for (BeaconStrategy beaconStrategy : mBeaconStrategies) {
                        Log.d("DEBUGGER", beaconStrategy.getClass().toString());
                        beaconStrategy.onEnteredRegion();
                    }
                }
            }

            @Override
            public void onExitedRegion(Region region) {
                if (mBeaconStrategies.size() > 0) {
                    for (BeaconStrategy beaconStrategy : mBeaconStrategies) {
                        beaconStrategy.onExitedRegion();
                    }
                }
            }
        });
    }

    /**
     * setupBeaconRanging is a wrapper for BeaconManager.setRangingListener() and notifies
     * the BeaconStrategy(s) when onBeaconsDiscovered() is called, so that the BeaconStrategy
     * can implement the specific actions required when beacons are discovered. This method
     * also notifies the beaconStrategy when no beacons have been ranged via BeaconStrategy's
     * method : onNoDiscoveredBeacons() and notifies the beaconStrategy when beacons are
     * discovered via BeaconStrategy's method : onDiscoveredBeacons().
     */
    public void setupBeaconRanging() {
        //check if device has Bluetooth LE enabled.
        if (!hasBluetooth) {
            return;
        }
        mBeaconManager.setRangingListener(new BeaconManager.RangingListener() {
            @Override
            public void onBeaconsDiscovered(Region region, final List<Beacon> rangedBeacons) {
                if (mBeaconStrategies.size() > 0) {
                    mRootActivity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            if (rangedBeacons.isEmpty()) {
                                for (BeaconStrategy beaconStrategy : mBeaconStrategies) {
                                    beaconStrategy.onNoDiscoveredBeacons();
                                }
                            } else {
                                for (BeaconStrategy beaconStrategy : mBeaconStrategies) {
                                    beaconStrategy.onDiscoveredBeacons(rangedBeacons);
                                }
                            }
                        }
                    });
                }
            }
        });
    }

    /**
     * registerStrategy() adds a beacon strategy to the EstimoteManager's list of beaconStrategies
     * so that multiple strategies can be deployed throughout an application.
     *
     * @param beaconStrategyToAdd the BeaconStrategy to be added and managed by the EstimoteManager.
     * @return true  : the beaconStrategyToAdd is successfully added to the list of BeaconStrategies.
     * false : the beaconStrategyToAdd is not sucessfully added.
     */
    public boolean registerStrategy(BeaconStrategy beaconStrategyToAdd) {
        Log.d("DEBUGGER", "registering....");
        if (beaconStrategyToAdd != null && !mBeaconStrategies.contains(beaconStrategyToAdd)
                && mBeaconStrategies.add(beaconStrategyToAdd)) {
            Log.d("DEBUGGER", "register success");
            return true;
        }
        Log.d("DEBUGGER", "register failed");
        return false;
    }

    /**
     * registerStrategy() removes a beacon strategy fom the EstimoteManager's list of beaconStrategies
     *
     * @param beaconStrategyToRemove the BeaconStrategy to be added and managed by the EstimoteManager.
     * @return true  : the beaconStrategyToRemove is successfully removed from the list of BeaconStrategies.
     * false : the beaconStrategyToRemove is not sucessfully added.
     */
    public boolean unregisterStrategy(BeaconStrategy beaconStrategyToRemove) {
        if (mBeaconStrategies.remove(beaconStrategyToRemove)) {
            return true;
        }
        return false;
    }

    /**
     * enableBluetoothService() spawns an activity to prompt the user to start
     * bluetooth on the device.
     */
    private void enableBluetoothService() {

        BluetoothAdapter mBluetoothAdapter;
        final BluetoothManager bluetoothManager =
                (BluetoothManager) mRootActivity.getSystemService(Context.BLUETOOTH_SERVICE);
        mBluetoothAdapter = bluetoothManager.getAdapter();

        if (mBluetoothAdapter == null || !mBluetoothAdapter.isEnabled()) {
            Intent enableBtIntent = new Intent(BluetoothAdapter.ACTION_REQUEST_ENABLE);
            mRootActivity.startActivityForResult(enableBtIntent, 1234);
        }

    }

    /**
     * setupOnStart() is a helper method for all estimote services that need to be controlled/initialized
     * during Android's lifecycle onStart() method. This method currently enables Bluetooth.
     */
    public void setupOnStart() {
        enableBluetoothService();
    }

    /**
     * setupOnStop() is a helper method for all estimote services that need to be controlled/initialized
     * during Android's lifecycle onStop() method. This method notifies the beaconManager to
     * stop ranging. This method is fully executed only if the device has bluetooth low energy
     * enabled.
     */
    public void setupOnStop() {
        Log.d("DEBUGGER", "in setupOnSTOP");
        //check if device has Bluetooth LE enabled.
        if (!hasBluetooth) {
            return;
        }
        try {
            mBeaconManager.stopRanging(ALL_ESTIMOTE_BEACONS_REGION);
        } catch (RemoteException e) {
            e.printStackTrace();
        }
    }

    /**
     * setupOnStop() is a helper method for all estimote services that need to be controlled/initialized
     * during Android's lifecycle onStop() method. This method connects to the beaconManager
     * and notifies the beaconManager to start monitoring and start ranging. This method is
     * fully executed only if the device has bluetooth low energy enabled.
     */
    public void setupOnResume() {
        Log.d("DEBUGGER", "in setupOnRESUME");
        //check if device has Bluetooth LE enabled.
        if (!hasBluetooth) {
            return;
        }
        mBeaconManager.connect(new BeaconManager.ServiceReadyCallback() {
            @Override
            public void onServiceReady() {
                try {
                    mBeaconManager.startMonitoring(ALL_ESTIMOTE_BEACONS_REGION);
                    mBeaconManager.startRanging(ALL_ESTIMOTE_BEACONS_REGION);
                } catch (RemoteException e) {
                    Log.d("ESTIMOTE", "Error during startMonitoring() call in initOnResume()");
                }
            }
        });
    }

    /**
     * setupOnDestroy() is a helper method for all estimote services that need to be controlled/initialized
     * during Android's lifecycle onDestroy() method. This method removes all of the beacon strategies
     * currently registered to the Estimote Manager and then disconnects from the beacon manager.
     * This method is fully executed only if the device has bluetooth low energy enabled.
     */
    public void setupOnDestroy() {
        Log.d("DEBUGGER", "in setupOnDESTROY");
        //check if device has Bluetooth LE enabled.
        if (!hasBluetooth) {
            return;
        }

        for (BeaconStrategy beaconStrategy : mBeaconStrategies) {
            mBeaconStrategies.remove(beaconStrategy);
        }
        mBeaconManager.disconnect();
    }

}
