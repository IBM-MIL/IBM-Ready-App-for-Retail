/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.models.realm;

import io.realm.RealmObject;

/**
 * Specialized form of a {@link com.ibm.mil.readyapps.summit.models.Product} for storing within
 * Realm.
 *
 * @author John Petitto
 */
public class RealmProduct extends RealmObject {
    private String id;
    private String name;
    private RealmDepartment department;
    private double price;
    private double salePrice;
    private String imageUrl;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public RealmDepartment getDepartment() {
        return department;
    }

    public void setDepartment(RealmDepartment department) {
        this.department = department;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public double getSalePrice() {
        return salePrice;
    }

    public void setSalePrice(double salePrice) {
        this.salePrice = salePrice;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

}
