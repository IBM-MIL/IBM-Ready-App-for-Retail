/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.fragments;

import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewGroup;

import com.google.gson.Gson;
import com.ibm.mil.readyapps.summit.R;
import com.ibm.mil.readyapps.summit.activities.LoginActivity;
import com.ibm.mil.readyapps.summit.activities.MainActivity;
import com.ibm.mil.readyapps.summit.models.Product;
import com.ibm.mil.readyapps.summit.utilities.Utils;
import com.ibm.mil.readyapps.summit.utilities.WLAuthenticationHandler;
import com.ibm.mil.readyapps.summit.utilities.WLPropertyReader;
import com.ibm.mil.readyapps.summit.views.CircularProgressDialog;
import com.ibm.mil.readyapps.webview.MILWebView;
import com.ibm.mil.readyapps.webview.OnPageChangeListener;
import com.ibm.mil.readyapps.worklight.WLProcedureCaller;
import com.ibm.mqa.Log;
import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLResponse;
import com.worklight.wlclient.api.WLResponseListener;

import java.util.List;

/**
 * Displays the product details for a specific {@link com.ibm.mil.readyapps.summit.models.Product}
 * inside of a WebView. Use {@link #newInstance(String)} to specify the
 *
 * @author John Petitto
 * @{@link com.ibm.mil.readyapps.summit.models.Product}. Takes care of the logic for displaying
 * {@link com.ibm.mil.readyapps.summit.fragments.MultipleUserListFragment} and
 * {@link com.ibm.mil.readyapps.summit.fragments.CreateListFragment} in overlay mode.
 */
public class ProductDetailsFragment extends Fragment implements OnPageChangeListener {
    private static final String TAG = ProductDetailsFragment.class.getName();
    private static final String BUNDLE_KEY = "productId";

    private MILWebView webView;
    private View overlay;
    private Product product;
    private CircularProgressDialog progressDialog;

    public ProductDetailsFragment() {
        // Required empty public constructor
    }

    /**
     * Static factory method for an instantiating a new fragment that is configured to display
     * the {@link com.ibm.mil.readyapps.summit.models.Product} for the id passed in.
     *
     * @param productId The id of the product to be displayed.
     * @return A new instance of the fragment configured for the desired
     * {@link com.ibm.mil.readyapps.summit.models.Product}.
     */
    public static ProductDetailsFragment newInstance(String productId) {
        ProductDetailsFragment fragment = new ProductDetailsFragment();
        Bundle bundle = new Bundle();
        bundle.putString(BUNDLE_KEY, productId);
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        View rootLayout = inflater.inflate(R.layout.fragment_product_details, container, false);

        webView = (MILWebView) rootLayout.findViewById(R.id.web_view);
        webView.setOnPageChangeListener(this);

        overlay = rootLayout.findViewById(R.id.overlay);

        // fetch product details for WebView
        getProductDetails();

        // Inflate the layout for this fragment
        return rootLayout;
    }

    private void getProductDetails() {
        WLProcedureCaller wlProcedureCaller = new WLProcedureCaller("SummitAdapter",
                "getProductById", new CircularProgressDialog(getActivity()));
        Object[] params = new Object[]{getArguments().getString(BUNDLE_KEY)};
        wlProcedureCaller.invoke(params, new ProductResponseListener());
    }

    /**
     * Hides the overlay displayed on top of the fragment.
     */
    public void hideOverlay() {
        overlay.setVisibility(View.GONE);
        enableWebViewInteraction(true);
    }

    @Override
    public void onPageChange(List<String> pathComponents) {
        Log.i(TAG, "Product JSON: " + product);

        WLPropertyReader wlPropertyReader = new WLPropertyReader(getActivity());
        product.setImageUrl(wlPropertyReader.serverUrl() + product.getImageUrl());
        for (Product.Color color : product.getColorOptions()) {
            color.setUrl(wlPropertyReader.serverUrl() + color.getUrl());
        }
        product.prepareForInjection();

        getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                progressDialog.stop();
            }
        });

        webView.injectData(new Gson().toJson(product, Product.class));
    }

    @Override
    public void performNativeOperation(String operation) {
        // detect native operation to perform
        switch (operation) {
            case "AddToList":
                addToList();
                break;
        }
    }

    // show add item to list overlay for current product
    private void addToList() {
        // show login screen if user is not authenticated
        if (!LoginActivity.isUserAuthenticated(getActivity())) {
            ((MainActivity) getActivity()).setAuthenticationHandler(new WLAuthenticationHandler() {
                @Override
                public void handle() {
                    addToList();
                }
            });

            Intent intent = new Intent(getActivity(), LoginActivity.class);
            getActivity().startActivityForResult(intent, LoginActivity.AUTHENTICATION_REQUEST_CODE);
            return;
        }

        // show user list screen in overlay mode
        MultipleUserListFragment fragment = MultipleUserListFragment.newInstance(true);
        fragment.setProduct(product);

        getChildFragmentManager()
                .beginTransaction()
                .replace(R.id.fragment_container, fragment)
                .commitAllowingStateLoss();

        overlay.setVisibility(View.VISIBLE);
        enableWebViewInteraction(false);
    }

    private void enableWebViewInteraction(final boolean enable) {
        webView.setOnTouchListener(new View.OnTouchListener() {
            @Override
            public boolean onTouch(View v, MotionEvent event) {
                return !enable;
            }
        });
    }

    private class ProductResponseListener implements WLResponseListener {
        @Override
        public void onSuccess(WLResponse wlResponse) {
            Log.i(TAG, wlResponse.getResponseText());

            product = Utils.mapJsonToClass(wlResponse.getResponseJSON().toString(), Product.class);

            getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    WLProcedureCaller wlProcedureCaller = new WLProcedureCaller("SummitAdapter",
                            "productIsAvailable", new CircularProgressDialog(getActivity()));

                    // get product and user ids for params
                    String productId = product.getId();
                    SharedPreferences preferences = getActivity()
                            .getSharedPreferences("UserPrefs", Context.MODE_PRIVATE);
                    String userId = preferences.getString("userId", "none");
                    Object[] params = new Object[]{userId, productId};

                    Log.i(TAG, "Product ID: " + productId);
                    Log.i(TAG, "User ID: " + userId);

                    wlProcedureCaller.invoke(params, new ProductAvailabilityResponseListener());
                }
            });
        }

        @Override
        public void onFailure(WLFailResponse wlFailResponse) {
            Log.i(TAG, wlFailResponse.getErrorMsg());

            getActivity().runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    new AlertDialog.Builder(getActivity())
                            .setTitle(getString(R.string.worklight_failure))
                            .setMessage(getString(R.string.product_failure))
                            .setPositiveButton(getString(R.string.retry), new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    getProductDetails();
                                }
                            })
                            .setNegativeButton(getString(R.string.cancel), new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialog, int which) {
                                    getFragmentManager().popBackStackImmediate();
                                }
                            })
                            .show();
                }
            });
        }
    }

    private class ProductAvailabilityResponseListener implements WLResponseListener {
        @Override
        public void onSuccess(WLResponse wlResponse) {
            Log.i(TAG, wlResponse.getResponseText());

            String productAvailability = "";

            // see if availability exists
            if (wlResponse.getResponseJSON().has("result")) {
                // show if availability is in stock or out of stock
                if (wlResponse.getResponseJSON().optBoolean("result")) {
                    productAvailability = getString(R.string.in_stock);
                } else {
                    productAvailability = getString(R.string.out_stock);
                }
            }

            displayProductWithAvailability(productAvailability);
        }

        @Override
        public void onFailure(WLFailResponse wlFailResponse) {
            Log.i(TAG, wlFailResponse.getErrorMsg());
            displayProductWithAvailability("");
        }
    }

    private void displayProductWithAvailability(String availability) {
        product.setAvailability(availability);
        product.prepareForInjection();

        getActivity().runOnUiThread(new Runnable() {
            @Override
            public void run() {
                progressDialog = new CircularProgressDialog(getActivity());
                progressDialog.start();
                getActivity().setTitle(product.getName());
                webView.launchUrl("index.html");
            }
        });
    }

}
