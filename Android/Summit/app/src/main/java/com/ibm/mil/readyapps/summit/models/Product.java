/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.models;

import com.google.gson.Gson;
import com.google.gson.annotations.SerializedName;
import com.ibm.mil.readyapps.summit.utilities.Utils;

import java.util.List;

/**
 * Model class for a Product. Its serialized counter-part for storing in Realm is
 * {@link com.ibm.mil.readyapps.summit.models.realm.RealmProduct}. Instantiate a Product object
 * via a JSON deserializer or with the provided
 * {@link com.ibm.mil.readyapps.summit.models.Product.Builder}.
 *
 * @author John Petitto
 */
public class Product {
    @SerializedName("_id")
    private String id;
    private String name;
    private String description;
    private List<Color> colorOptions;
    private String availability;
    private int reviews;
    private boolean isRecommended;
    private int rating;
    private Department departmentObj;
    private List<String> category;
    private String type;
    private double priceRaw;
    private double salePriceRaw;
    private String price;
    private String salePrice;
    private String imageUrl;
    private Option option;
    private String location;

    private Product(Builder builder) {
        id = builder.id;
        name = builder.name;
        description = builder.description;
        colorOptions = builder.colorOptions;
        reviews = builder.reviews;
        isRecommended = builder.isRecommended;
        rating = builder.rating;
        departmentObj = builder.department;
        category = builder.category;
        type = builder.type;
        priceRaw = builder.priceRaw;
        salePriceRaw = builder.salePriceRaw;
        price = builder.price;
        salePrice = builder.salePrice;
        imageUrl = builder.imageUrl;
        option = builder.option;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public List<Color> getColorOptions() {
        return colorOptions;
    }

    public Department getDepartment() {
        return departmentObj;
    }

    public String getType() {
        return type;
    }

    public double getPriceRaw() {
        return priceRaw;
    }

    public double getSalePriceRaw() {
        return salePriceRaw;
    }

    public String getPrice() {
        return price;
    }

    public String getSalePrice() {
        return salePrice;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public void setAvailability(String availability) {
        this.availability = availability;
    }

    /**
     * Massages the data model to be used within a WebView.
     */
    public void prepareForInjection() {
        price = Utils.formatCurrency(priceRaw);
        if (salePriceRaw != 0) {
            salePrice = Utils.formatCurrency(salePriceRaw);
        }
        if (departmentObj != null) {
            location = departmentObj.getTitle();
        }
        if (option != null) {
            option.setName("Size");
        }
    }

    /**
     * A Builder that facilitates the creation of a Product.
     */
    public static class Builder {
        private String id;
        private String name;
        private String description;
        private List<Color> colorOptions;
        private int reviews;
        private boolean isRecommended;
        private int rating;
        private Department department;
        private List<String> category;
        private String type;
        private double priceRaw;
        private double salePriceRaw;
        private String price;
        private String salePrice;
        private String imageUrl;
        private Option option;
        private String location;

        public Builder id(String id) {
            this.id = id;
            return this;
        }

        public Builder name(String name) {
            this.name = name;
            return this;
        }

        public Builder description(String description) {
            this.description = description;
            return this;
        }

        public Builder colorOptions(List<Color> colorOptions) {
            this.colorOptions = colorOptions;
            return this;
        }

        public Builder reviews(int reviews) {
            this.reviews = reviews;
            return this;
        }

        public Builder isRecommended(boolean recommended) {
            this.isRecommended = isRecommended;
            return this;
        }

        public Builder rating(int rating) {
            this.rating = rating;
            return this;
        }

        public Builder department(Department department) {
            this.department = department;
            this.location = department.getTitle();
            return this;
        }

        public Builder category(List<String> category) {
            this.category = category;
            return this;
        }

        public Builder type(String type) {
            this.type = type;
            return this;
        }

        public Builder priceRaw(double priceRaw) {
            this.priceRaw = priceRaw;
            price = Utils.formatCurrency(priceRaw);
            return this;
        }

        public Builder salePriceRaw(double salePriceRaw) {
            this.salePriceRaw = salePriceRaw;
            salePrice = Utils.formatCurrency(salePriceRaw);
            return this;
        }

        public Builder imageUrl(String imageUrl) {
            this.imageUrl = imageUrl;
            return this;
        }

        public Builder option(Option option) {
            this.option = option;
            return this;
        }

        public Product build() {
            return new Product(this);
        }
    }

    @Override
    public String toString() {
        return new Gson().toJson(this);
    }

    /**
     * Model class for a Color within the context of a Product.
     */
    public static class Color {
        private String color;
        private String hexColor;
        private String url;
        private String productID;

        public String getColor() {
            return color;
        }

        public String getUrl() {
            return url;
        }

        public void setUrl(String url) {
            this.url = url;
        }

    }

    /**
     * Model class for an Option within the context of a Product.
     */
    public static class Option {
        private String name;
        private List<String> values;

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }
    }

}
