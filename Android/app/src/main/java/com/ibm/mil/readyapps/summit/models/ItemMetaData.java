/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.models;

/**
 * Model class for storing the meta data of an item displayed on
 * {@link com.ibm.mil.readyapps.summit.fragments.DashboardFragment}.
 *
 * @author John Petitto
 */
public class ItemMetaData {
    private String imageUrl;
    private String _id;
    private String type;
    private String _rev;

    public String getImageUrl() {
        return imageUrl;
    }

    public String getId() {
        return _id;
    }

    /**
     * @return The type of object it is describing
     */
    public String getType() {
        return type;
    }

}
