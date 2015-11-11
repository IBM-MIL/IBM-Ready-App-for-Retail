/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.utilities;

/**
 * An interface for defining the desired behavior when a user successfully authenticates. To
 * register an instance of WLAuthenticationHandler, call
 * {@link com.ibm.mil.readyapps.summit.activities.MainActivity#setAuthenticationHandler(WLAuthenticationHandler)}.
 */
public interface WLAuthenticationHandler {
    /**
     * Handle the event where the user authenticates with WL.
     */
    void handle();
}
