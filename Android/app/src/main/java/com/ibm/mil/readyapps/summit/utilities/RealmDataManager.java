/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.utilities;

import android.content.Context;

import com.ibm.mil.readyapps.summit.models.Department;
import com.ibm.mil.readyapps.summit.models.Product;
import com.ibm.mil.readyapps.summit.models.UserList;
import com.ibm.mil.readyapps.summit.models.realm.RealmDepartment;
import com.ibm.mil.readyapps.summit.models.realm.RealmProduct;
import com.ibm.mil.readyapps.summit.models.realm.RealmUserList;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import io.realm.Realm;
import io.realm.RealmList;
import io.realm.RealmResults;

/**
 * Facilitates the storing and retrieval of data model objects to and from Realm for local
 * data persistence. It abstracts away the necessary serializing and de-serializing mechanisms
 * that must take place in order to operate with Realm.
 * <p/>
 * Note: You should not interact with the Realm-prefixed data model classes directly from the
 * client.
 *
 * @author John Petitto
 * @see com.ibm.mil.readyapps.summit.models.realm.RealmDepartment
 * @see com.ibm.mil.readyapps.summit.models.realm.RealmProduct
 * @see com.ibm.mil.readyapps.summit.models.realm.RealmUserList
 */
public final class RealmDataManager {

    private RealmDataManager() {
        throw new AssertionError("ProductDataManager is non-instantiable");
    }

    /**
     * Creates an empty {@link com.ibm.mil.readyapps.summit.models.UserList} with the given name
     * inside Realm. If a {@link com.ibm.mil.readyapps.summit.models.UserList} with this name
     * already exists, the operation is not performed.
     *
     * @param context
     * @param listName The name of the {@link com.ibm.mil.readyapps.summit.models.UserList} to be
     *                 created.
     * @return {@code true} if the list was successfully created, {@code false} if it already
     * exists.
     */
    public static boolean createList(Context context, String listName) {
        // see if list name already exists before creating it
        Realm realm = Realm.getInstance(context);
        if (realm.where(RealmUserList.class).contains("name", listName).findAll().isEmpty()) {
            // list name does not already exist, persist it
            realm.beginTransaction();
            RealmUserList userList = realm.createObject(RealmUserList.class);
            userList.setName(listName);
            realm.commitTransaction();

            return true;
        }

        return false;
    }

    /**
     * Stores a {@link com.ibm.mil.readyapps.summit.models.Product} into a
     * {@link com.ibm.mil.readyapps.summit.models.UserList} with the specified name. The operation
     * is not performed if no {@link com.ibm.mil.readyapps.summit.models.UserList} is found for the
     * specified name or the same {@link com.ibm.mil.readyapps.summit.models.Product} already
     * exists for a {@link com.ibm.mil.readyapps.summit.models.UserList}.
     *
     * @param context
     * @param listName The name of the {@link com.ibm.mil.readyapps.summit.models.UserList} that
     *                 the {@link com.ibm.mil.readyapps.summit.models.Product} will be stored to.
     * @param product  The {@link com.ibm.mil.readyapps.summit.models.Product} being stored.
     * @return {@code true} if the {@link com.ibm.mil.readyapps.summit.models.Product} was
     * successfully added to the list, {@code false} otherwise.
     */
    public static boolean addItem(Context context, String listName, Product product) {
        Realm realm = Realm.getInstance(context);
        RealmResults<RealmUserList> queryResult =
                realm.where(RealmUserList.class).equalTo("name", listName).findAll();

        // list does not exist, cannot add item
        if (queryResult.isEmpty()) {
            return false;
        }

        // check if item is a duplicate before adding
        RealmList<RealmProduct> realmProducts = queryResult.get(0).getProducts();
        if (!isDuplicateProduct(product, realmProducts)) {
            realm.beginTransaction();
            realmProducts.add(convertProduct(realm, product));
            realm.commitTransaction();
            return true;
        }

        return false;
    }

    private static boolean isDuplicateProduct(Product product, RealmList<RealmProduct> products) {
        for (RealmProduct realmProduct : products) {
            if (product.getName().equals(realmProduct.getName())) {
                return true;
            }
        }

        return false;
    }

    /**
     * Retrieves the {@link com.ibm.mil.readyapps.summit.models.UserList} with the specified name
     * from storage.
     *
     * @param context
     * @param listName The name of the {@link com.ibm.mil.readyapps.summit.models.UserList} to be
     *                 retrieved.
     * @return The {@link com.ibm.mil.readyapps.summit.models.UserList} stored in Realm for the
     * specified name.
     */
    public static UserList getUserList(Context context, String listName) {
        Realm realm = Realm.getInstance(context);
        RealmResults<RealmUserList> queryResult =
                realm.where(RealmUserList.class).equalTo("name", listName).findAll();
        return parseUserList(queryResult.get(0));
    }

    private static RealmProduct convertProduct(Realm realm, Product product) {
        RealmProduct convertedProduct = realm.createObject(RealmProduct.class);

        convertedProduct.setId(product.getId());
        convertedProduct.setName(product.getName());
        convertedProduct.setDepartment(convertDepartment(realm, product.getDepartment()));
        convertedProduct.setPrice(product.getPriceRaw());
        convertedProduct.setSalePrice(product.getSalePriceRaw());
        convertedProduct.setImageUrl(product.getImageUrl());

        return convertedProduct;
    }

    private static RealmDepartment convertDepartment(Realm realm, Department department) {
        RealmDepartment convertedDepartment = realm.createObject(RealmDepartment.class);
        convertedDepartment.setId(department.getId());
        convertedDepartment.setTitle(department.getTitle());
        return convertedDepartment;
    }

    /**
     * Retrieves all {@link com.ibm.mil.readyapps.summit.models.UserList} objects stored within
     * Realm.
     *
     * @param context
     * @return All {@link com.ibm.mil.readyapps.summit.models.UserList} objects stored in Realm.
     */
    public static List<UserList> getLists(Context context) {
        Realm realm = Realm.getInstance(context);
        RealmResults<RealmUserList> queryResult = realm.where(RealmUserList.class).findAll();
        List<UserList> userLists = new ArrayList<>();
        for (RealmUserList item : queryResult) {
            userLists.add(parseUserList(item));
        }
        return userLists;
    }

    private static UserList parseUserList(RealmUserList userList) {
        List<Product> products = new ArrayList<>();
        for (RealmProduct item : userList.getProducts()) {
            products.add(parseProduct(item));
        }
        Collections.reverse(products);
        return new UserList(userList.getName(), products);
    }

    private static Product parseProduct(RealmProduct product) {
        return new Product.Builder()
                .id(product.getId())
                .name(product.getName())
                .priceRaw(product.getPrice())
                .salePriceRaw(product.getSalePrice())
                .department(parseDepartment(product.getDepartment()))
                .imageUrl(product.getImageUrl())
                .build();
    }

    private static Department parseDepartment(RealmDepartment department) {
        return new Department.Builder(department.getId(), department.getTitle()).build();
    }

}
