/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.models;

import java.util.List;

/**
 * Model class for a UserList. Its serialized counter-part for storing in Realm is
 * {@link com.ibm.mil.readyapps.summit.models.realm.RealmUserList}. Instantiate a UserList object
 * via a JSON deserializer or with the provided constructor.
 *
 * @author John Petitto
 */
public class UserList {
    private String name;
    private List<Product> products;

    public UserList(String name, List<Product> products) {
        this.name = name;
        this.products = products;
    }

    public String getName() {
        return name;
    }

    public List<Product> getProducts() {
        return products;
    }

}
