/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.utilities.EstimoteUtils;

import android.app.Activity;
import android.content.Context;
import android.graphics.Typeface;
import android.text.style.StyleSpan;
import android.widget.ArrayAdapter;

import com.estimote.sdk.Beacon;
import com.estimote.sdk.Utils;
import com.ibm.mil.readyapps.summit.R;
import com.ibm.mil.readyapps.summit.models.Department;
import com.ibm.mil.readyapps.summit.models.Product;
import com.ibm.mil.readyapps.summit.utilities.AndroidUtils;
import com.ibm.mil.readyapps.summit.utilities.RealmDataManager;
import com.ibm.mil.readyapps.summit.views.SummitToast;
import com.ibm.mqa.Log;

import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;

public class DepartmentProximityBeaconStrategy implements BeaconStrategy {
    private static final String TAG = DepartmentProximityBeaconStrategy.class.getName();

    /* mBeaconToDepartmentMap is a map of the beacons currently assigned to departments
            K: Beacon ID (String)
            V: Department assigned to beacon (Department object) */
    private static HashMap<String, Department> mBeaconToDepartmentMap;
    /* mCurrentDepartmentToMap maintains the current department awaiting assignment to a beacon. */
    private static int mCurrentDepartmentToMap = 0;
    /* mDepartmentList is a cache of the store's full department list */
    private static List<Department> mDepartmentList;
    /* mProductList is the list of products for a given wishlist in the application. */
    private List<Product> mProductList;
    /* mProductListName is the name of the product list, used for Realm.io queries. */
    private String mProductListName;
    /* mListAdapter is a reference to the list adapter holding the current product list.*/
    private ArrayAdapter<Product> mListAdapter;
    /* mParentContext the context controlling this strategy. */
    private Context mParentContext;
    /* prevNearestDept maintains the value for the previously discovered department. */
    private String prevNearestDept = "";

    public DepartmentProximityBeaconStrategy(Context parentContext, ArrayAdapter<Product> listAdapter,
                                             List<Product> productList, String listName, List<Department> departmentList) {
        mProductList = productList;
        mDepartmentList = departmentList;
        mProductListName = listName;
        mListAdapter = listAdapter;
        mParentContext = parentContext;
        mBeaconToDepartmentMap = new HashMap<>();
        mCurrentDepartmentToMap = 0;
    }

    @Override
    public void onEnteredRegion() {
          /*The DepartmentProximityBeaconStrategy does not use estimote monitoring and so
            onEnteredRegion() is not used. */
    }

    @Override
    public void onExitedRegion() {
        /*The DepartmentProximityBeaconStrategy does not use estimote monitoring and so
            onExitedRegion() is not used. */
    }

    @Override
    public void onDiscoveredBeacons(List<Beacon> rangedBeacons) {
        Beacon nearestBeacon = rangedBeacons.get(0);
        Log.d("DEBUGGER", "onDiscoveredBeacons");
        synchronized (this) {
            /* Use the EstimoteSDK to calculate the proximity of the beacon. */
            boolean isBeaconImmediate
                    = Utils.proximityFromAccuracy(Utils.computeAccuracy(nearestBeacon)) == Utils.Proximity.IMMEDIATE;
            /* reorder the product list only if the beacon is IMMEDIATE (as defined by Estimote SDK). */
            if (isBeaconImmediate) {
                Department nearestDepartment
                        = getDepartmentAssignedToBeacon(getFullUniqueBeaconID(nearestBeacon));

                Log.d("DEBUGGER", prevNearestDept + "  " + nearestBeacon.getMajor() + "-" + nearestBeacon.getMinor() + " ----> " + nearestDepartment.getTitle());
                /* check if the department assigned is null, this occurs if there are more beacons,
                        then departments. Also check that the previous nearest department (prevNearestDepartment)
                        is not the same as the current nearestdepartment, implying the user has not changed
                        location and is in the same department. */
                if (nearestDepartment != null && !prevNearestDept.equals(nearestDepartment.getId())) {
//                    prevNearestDept = nearestDepartment.getId();
                    reorderItemListForNearestDepartment(nearestDepartment);
                }
            } else {
                Log.d("DEBUGGER", "NOT CLOSE ENOUGH REVERTING TO OLD LIST");
                /* if no beacons are immediate, then revert the product list to the natural order
                        of the list (the items are in order by when they are added to the list). */
                prevNearestDept = "---";
                mProductList.clear();
                mProductList.addAll(RealmDataManager.getUserList(mParentContext, mProductListName).getProducts());
                ((Activity) mParentContext).runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        mListAdapter.notifyDataSetChanged();
                    }
                });
            }
        }
    }

    @Override
    public void onNoDiscoveredBeacons() {
        /* onNoDiscoveredBeacons() is not implemented for DepartmentBeaconStrategy as this strategy
                does not do anything if no beacons are around. */
    }

    /**
     * reorderItemListForNearestDepartment will reorder the list of items such that all of the items
     * that are in the nearest department (determined by Estimote beacon proximity) are moved
     * to the top of the list. If the nearest beacon is not in IMMEDIATE proximity, then the order
     * of the list is the order in which the products are added.
     *
     * @param nearestDepartment the department that is nearest to the device, as determined by the
     *                          beacons.
     */
    private void reorderItemListForNearestDepartment(final Department nearestDepartment) {

        if (mProductList.size() > 1) {
            Log.d("DEBUGGER", "reordering the list.");

            Collections.sort(mProductList, new Comparator<Product>() {
                @Override
                public int compare(Product lhs, Product rhs) {
                    /* If two products next to each other in the productList have the same
                      departmentID, then do not change their ordering. (return 0) */
                    if (lhs.getDepartment().getId().equals(rhs.getDepartment().getId())) {
                        return 0;
                    }
                    /* If the first item (lhs) has the same department as the nearestDepartment
                       then maintain ordering by returning -1, this implies that the first (lhs)
                       is "less than" the second item (rhs) and remains on the left.    */
                    else if (lhs.getDepartment().getId().equals(nearestDepartment.getId())) {
                        return -1;
                    }
                    /* If the second item (rhs) has the same department as the nearestDepartment
                       then return 1, this implies the first item (lhs) is "greater than"
                       the second item (lhs) and the left hand side is moved to the right. */
                    else if (rhs.getDepartment().getId().equals(nearestDepartment.getId())) {
                        return 1;
                    }
                    /* if neither of the items have a department matching the nearestDepartment
                        then maintain their original order by returning 0. */
                    return 0;
                }
            });
        }

        ((Activity) mParentContext).runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Log.d("DEBUGGER", "Reordering for department " + nearestDepartment.getTitle());

                mListAdapter.notifyDataSetChanged();
                    /* if the product list contains a product with the same department as the
                           nearestDepartment then show a small notification (android toast) which
                           displays a message indicating the user has entered the department. */
                if (hasItemInDept(mProductList, nearestDepartment)) {
                    prevNearestDept = nearestDepartment.getId();
                    SummitToast toast = new SummitToast(mParentContext);
                    String toastMessage = mParentContext.getString(R.string.welcome_to) + " " + nearestDepartment.getTitle() + "!";
                    toast.setMessage(AndroidUtils.spanSubstring(toastMessage, nearestDepartment.getTitle(), new StyleSpan(Typeface.BOLD)));
                    toast.setIcon(mParentContext.getResources().getDrawable(R.drawable.location_sm_white));
                    toast.show();

                }
            }
        });

    }

    /**
     * hasItemInDept() checks if the provided product list has items in the provided department.
     *
     * @param productList the list of products to check for a department.
     * @param department  the department to check against the products in the product list.
     * @return true: the product list contains at least one product with the same department
     * as the provided department parameter.
     * false: the product list does not contain no products with the provided department
     * parameter.
     */
    private boolean hasItemInDept(List<Product> productList, Department department) {
        for (Product product : productList) {
            if (product.getDepartment().getId().equals(department.getId())) {
                return true;
            }
        }
        return false;
    }

    /**
     * getDepartmentAssignedToBeacon() returns the department assigned for the provided Beacon id.
     * If a department was previously assigned to the beacon, then this department is returned.
     * If no department is assigned to the beacon, then this method assigns a department to the
     * beacon and maintains which department will be assigned in a consecutive call to this
     * method.
     *
     * @param idForBeaconToAssign full
     * @return
     */
    private Department getDepartmentAssignedToBeacon(String idForBeaconToAssign) {
        /* First try to obtain the department from the map */
        Department assignedDepartment = mBeaconToDepartmentMap.get(idForBeaconToAssign);

        if (assignedDepartment != null) {
            return assignedDepartment;
        } else if (mCurrentDepartmentToMap < mDepartmentList.size()) {
            assignedDepartment = mDepartmentList.get(mCurrentDepartmentToMap);
            mBeaconToDepartmentMap.put(idForBeaconToAssign, assignedDepartment);

            /* increment mCurrentDepartmentToMap to maintain which department to assign in
                    consecutive call of this method. */
            mCurrentDepartmentToMap++;

            return assignedDepartment;
        }
        return null;
    }

    /**
     * getFullUniqueBeaconID returns a unique beacon id given a beacon.
     * The format of the ID is: "<Beacon Major ID>-<Beacon Minor ID>"
     * The above format includes a hyphen in between the major and minor id.
     * NOTE: The unique beacon id does not include the larger UUID included with beacons.
     * The UUID is not included for demo purposes, this allows a demo user to use any
     * Estimote Beacons without defining a specific UUID. The Beacon object does not contain
     * the UUID and so it has to be defined elsewhere in the project, which is more
     * restricting to demos.
     *
     * @param beaconToParse the Beacon object the user wishes to obtain a unique id for.
     * @return uniqueBeaconID the unique beacon ID associated with the provided beacon parameter.
     * The format of the uniqueBeaconID is "<Beacon Major ID>-<Beacon Minor ID>".
     * The format includes a hyphen in between the major and minor id.
     */
    private String getFullUniqueBeaconID(Beacon beaconToParse) {
        String uniqueBeaconID = Integer.toString(beaconToParse.getMajor()) + "-" +
                Integer.toString(beaconToParse.getMinor());
        return uniqueBeaconID;
    }

}
