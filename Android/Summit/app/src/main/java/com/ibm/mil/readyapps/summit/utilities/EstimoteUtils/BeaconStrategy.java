/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.utilities.EstimoteUtils;

import com.estimote.sdk.Beacon;

import java.util.List;

public interface BeaconStrategy {

    /**
     * onEnteredRegion() defines the behavior for an application when a device enters a region.
     * This method is called only when estimotes are monitoring. Monitoring is a slower
     * periodic scan that can run in the background.
     */
    public void onEnteredRegion();

    /**
     * onExitedRegion() defines the behavior for an application when a device exits a region.
     * This method is called only when monitoring with estimotes. Monitoring is a slower
     * periodic scan that can run in the background.
     */
    public void onExitedRegion();

    /**
     * onDiscoveredBeacons() defines the behavior for an application when a device is in range of
     * of beacons. This method is called when estimotes are ranging. Ranging is a continual
     * scan for beacons and occurs when the application is in the foreground.
     *
     * @param rangedBeacons rangedBeacons is a list of the beacons in range, sorted by accuracy.
     *                      rangedBeacons.get(0) will return the "closest" beacon.
     *                      Please see the estimote sdk for more details.
     * @pre rangedBeacons() has at least one beacon ranged. As the EstimoteManager, which handles
     * BeaconStrategies, will call onDiscoveredBeacons if the list is not empty.
     */
    public void onDiscoveredBeacons(List<Beacon> rangedBeacons);

    /**
     * onNoDiscoveredBeacons() defines the behavior for an application when a device is out of range
     * of any beacons. This method is called when estimotes are ranging. Ranging is a continual
     * scan for beacons and occurs when the application is in the foreground.
     */
    public void onNoDiscoveredBeacons();

}
