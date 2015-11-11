/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.models.realm;

import io.realm.RealmList;
import io.realm.RealmObject;

/**
 * Specialized form of a {@link com.ibm.mil.readyapps.summit.models.UserList} for storing within
 * Realm.
 *
 * @author John Petitto
 */
public class RealmUserList extends RealmObject {
    private String name;
    private RealmList<RealmProduct> products;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public RealmList<RealmProduct> getProducts() {
        return products;
    }

    public void setProducts(RealmList<RealmProduct> products) {
        this.products = products;
    }

}
