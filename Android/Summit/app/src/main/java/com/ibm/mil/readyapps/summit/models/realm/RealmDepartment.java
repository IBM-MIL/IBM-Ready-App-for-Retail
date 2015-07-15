/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.models.realm;

import io.realm.RealmObject;

/**
 * Specialized form of a {@link com.ibm.mil.readyapps.summit.models.Department} for storing within
 * Realm.
 *
 * @author John Petitto
 */
public class RealmDepartment extends RealmObject {
    private String id;
    private String title;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

}
