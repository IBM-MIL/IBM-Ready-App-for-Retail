/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.utilities;

import android.content.Context;

import java.io.IOException;
import java.util.Properties;

/**
 * Helper class for retrieving values from a Worklight client property file.
 *
 * @author John Petitto
 */
public final class WLPropertyReader {
    private static final String FILE_NAME = "wlclient.properties";
    private static Properties properties;

    /**
     * The properties are read into memory on the initial creation of this class and then re-used
     * on successive initializations.
     *
     * @param context
     */
    public WLPropertyReader(Context context) {
        if (properties == null) {
            properties = new Properties();
            try {
                properties.load(context.getAssets().open(FILE_NAME));
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    public String serverProtocol() {
        return properties.getProperty("wlServerProtocol");
    }

    public String serverHost() {
        return properties.getProperty("wlServerHost");
    }

    public String serverPort() {
        return properties.getProperty("wlServerPort");
    }

    public String serverContext() {
        return properties.getProperty("wlServerContext");
    }

    public String appId() {
        return properties.getProperty("wlAppId");
    }

    public String appVersion() {
        return properties.getProperty("wlAppVersion");
    }

    public String environment() {
        return properties.getProperty("wlEnvironment");
    }

    public String uniqueId() {
        return properties.getProperty("wlUid");
    }

    public String platformVersion() {
        return properties.getProperty("wlPlatformVersion");
    }

    /**
     * A helper method for returning the full WL server URL with proper formatting.
     *
     * @return A properly formatted server URL for the WL connection.
     */
    public String serverUrl() {
        return serverProtocol() + "://" + serverHost() + ":" + serverPort() + serverContext();
    }

}
