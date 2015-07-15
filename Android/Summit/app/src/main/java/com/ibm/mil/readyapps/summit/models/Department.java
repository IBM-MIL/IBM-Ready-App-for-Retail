/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.models;

import com.google.gson.annotations.SerializedName;

/**
 * Model class for a Department. Its serialized counter-part for storing in Realm is
 * {@link com.ibm.mil.readyapps.summit.models.realm.RealmDepartment}. Instantiate a Department
 * object via a JSON deserializer or with the provided
 * {@link com.ibm.mil.readyapps.summit.models.Department.Builder}.
 *
 * @author John Petitto
 */
public class Department {
    @SerializedName("_id")
    private String id;
    private String title;
    private int aisle;
    private boolean isFeatured;
    private String type;
    private String imageUrl;

    public String getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    /**
     * A Builder that facilitates the creation of a Department.
     */
    public static class Builder {
        // required parameters
        private final String id;
        private final String title;

        // optional parameters
        private int aisle;
        private boolean isFeatured;
        private String type;
        private String imageUrl;

        /**
         * id and title are both required parameters for building a Department object.
         *
         * @param id    the id of the Department
         * @param title the title, or name, of the Department
         */
        public Builder(String id, String title) {
            this.id = id;
            this.title = title;
        }

        public Builder aisle(int aisle) {
            this.aisle = aisle;
            return this;
        }

        public Builder isFeatured(boolean featured) {
            isFeatured = featured;
            return this;
        }

        public Builder type(String type) {
            this.type = type;
            return this;
        }

        public Builder imageUrl(String imageUrl) {
            this.imageUrl = imageUrl;
            return this;
        }

        public Department build() {
            return new Department(this);
        }
    }

    private Department(Builder builder) {
        id = builder.id;
        title = builder.title;
        aisle = builder.aisle;
        isFeatured = builder.isFeatured;
        type = builder.type;
        imageUrl = builder.imageUrl;
    }

}
