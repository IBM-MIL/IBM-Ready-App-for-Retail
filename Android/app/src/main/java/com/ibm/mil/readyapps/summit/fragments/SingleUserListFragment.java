/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.fragments;

import android.app.Activity;
import android.content.Context;
import android.graphics.Paint;
import android.graphics.drawable.ColorDrawable;
import android.os.Build;
import android.os.Bundle;
import android.support.v4.app.ListFragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonPrimitive;
import com.google.gson.reflect.TypeToken;
import com.ibm.mil.readyapps.summit.R;
import com.ibm.mil.readyapps.summit.models.Department;
import com.ibm.mil.readyapps.summit.models.Product;
import com.ibm.mil.readyapps.summit.models.UserList;
import com.ibm.mil.readyapps.summit.utilities.AndroidUtils;
import com.ibm.mil.readyapps.summit.utilities.DownloadImageTask;
import com.ibm.mil.readyapps.summit.utilities.EstimoteUtils.BeaconStrategy;
import com.ibm.mil.readyapps.summit.utilities.EstimoteUtils.DepartmentProximityBeaconStrategy;
import com.ibm.mil.readyapps.summit.utilities.EstimoteUtils.EstimoteManager;
import com.ibm.mil.readyapps.summit.utilities.FontCache;
import com.ibm.mil.readyapps.summit.utilities.RealmDataManager;
import com.ibm.mil.readyapps.summit.utilities.Utils;
import com.ibm.mil.readyapps.worklight.WLProcedureCaller;
import com.ibm.mqa.Log;
import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLResponse;
import com.worklight.wlclient.api.WLResponseListener;

import java.lang.reflect.Type;
import java.util.List;

/**
 * Displays the items added to a user's list. Instantiate the fragment by calling
 * {@link #newInstance(String)} with the name of the list to be displayed.
 *
 * @author John Petitto
 * @author Tanner Preiss
 */
public class SingleUserListFragment extends ListFragment {
    private static final String TAG = SingleUserListFragment.class.getName();
    private static final String BUNDLE_KEY = "listName";

    private BeaconStrategy mBeaconStrategy;
    private String mListName;
    private List<Product> products;

    public SingleUserListFragment() {
        // Required empty public constructor
    }

    /**
     * Static factory method for an instantiating a new fragment that is configured to display
     * the {@link com.ibm.mil.readyapps.summit.models.UserList} for the list name passed in.
     *
     * @param listName The name of {@link com.ibm.mil.readyapps.summit.models.UserList} to be
     *                 displayed.
     * @return A new instance of the fragment configured to display the desired
     * {@link com.ibm.mil.readyapps.summit.models.UserList}.
     */
    public static SingleUserListFragment newInstance(String listName) {
        SingleUserListFragment fragment = new SingleUserListFragment();
        Bundle bundle = new Bundle();
        bundle.putString(BUNDLE_KEY, listName);
        fragment.setArguments(bundle);
        return fragment;
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        Bundle bundle = getArguments();
        if (bundle != null) {
            mListName = bundle.getString(BUNDLE_KEY);
        }
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        getActivity().setTitle(mListName);

        UserList userList = RealmDataManager.getUserList(getActivity(), mListName);
        products = userList.getProducts();

        getAllDepartments();

        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @Override
    public void onStart() {
        super.onStart();
    }

    @Override
    public void onResume() {
        super.onResume();
        EstimoteManager.getInstance(getActivity()).registerStrategy(mBeaconStrategy);
    }

    @Override
    public void onPause() {
        EstimoteManager.getInstance(getActivity()).unregisterStrategy(mBeaconStrategy);
        super.onPause();
    }

    @Override
    public void onViewCreated(View view, Bundle savedInstanceState) {
        super.onViewCreated(view, savedInstanceState);

        // enables ripple effect over each list item
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            getListView().setDrawSelectorOnTop(true);
        }

        addFooterView(savedInstanceState);

        getListView().setDivider(new ColorDrawable(android.R.color.transparent));
        getListView().setDividerHeight(AndroidUtils.pixelsToDip(getActivity(), 3));

        setListAdapter(new ProductAdapter(getActivity(), R.layout.item_single_user_list, products));
    }

    private void addFooterView(Bundle bundle) {
        View footerView = getLayoutInflater(bundle).inflate(R.layout.footer_price_total, null);

        // calculate total price of list
        double totalPrice = 0;
        for (Product product : products) {
            // use sale price if available, regular price otherwise
            if (product.getSalePriceRaw() != 0) {
                totalPrice += product.getSalePriceRaw();
            } else {
                totalPrice += product.getPriceRaw();
            }
        }
        TextView priceTotal = (TextView) footerView.findViewById(R.id.price_total);
        priceTotal.setTypeface(FontCache.getFont(getActivity(), FontCache.FontName.OSWALD_REGULAR));
        priceTotal.setText(Utils.formatCurrency(totalPrice));

        getListView().addFooterView(footerView);
    }

    @Override
    public void onListItemClick(ListView l, View v, int position, long id) {
        super.onListItemClick(l, v, position, id);

        // ignore footer
        if (position == products.size()) {
            return;
        }

        String productId = products.get(position).getId();
        getFragmentManager()
                .beginTransaction()
                .replace(R.id.content_frame, ProductDetailsFragment.newInstance(productId))
                .addToBackStack(null)
                .commit();
    }

    private static class ProductAdapter extends ArrayAdapter<Product> {
        Context context;
        int layoutResourceId;
        List<Product> data;

        public ProductAdapter(Context context, int layoutResourceId, List<Product> data) {
            super(context, layoutResourceId, data);
            this.context = context;
            this.layoutResourceId = layoutResourceId;
            this.data = data;
        }

        static class ViewHolder {
            ImageView thumbnail;
            TextView name;
            TextView price;
            TextView oldPrice;
            TextView location;
            ImageView flag;
        }

        @Override
        public void notifyDataSetChanged() {
            super.notifyDataSetChanged();
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            View row = convertView;
            ViewHolder holder;

            if (row == null) {
                LayoutInflater inflater = ((Activity) context).getLayoutInflater();
                row = inflater.inflate(layoutResourceId, parent, false);

                holder = new ViewHolder();
                holder.thumbnail = (ImageView) row.findViewById(R.id.thumbnail);
                holder.name = (TextView) row.findViewById(R.id.name);
                holder.price = (TextView) row.findViewById(R.id.price);
                holder.oldPrice = (TextView) row.findViewById(R.id.old_price);
                holder.location = (TextView) row.findViewById(R.id.location);
                holder.flag = (ImageView) row.findViewById(R.id.flag);

                row.setTag(holder);
            } else {
                holder = (ViewHolder) row.getTag();
            }

            Product product = data.get(position);
            holder.name.setText(product.getName());
            holder.location.setText(product.getDepartment().getTitle());

            if (product.getSalePriceRaw() == 0) {
                holder.oldPrice.setVisibility(View.GONE);
                holder.price.setText(product.getPrice());
            } else {
                holder.price.setText(product.getSalePrice());
                holder.oldPrice.setText(product.getPrice());
                holder.oldPrice.setPaintFlags(holder.oldPrice.getPaintFlags() | Paint.STRIKE_THRU_TEXT_FLAG);
            }

            new DownloadImageTask(holder.thumbnail).execute(product.getImageUrl());

            return row;
        }
    }


    /**
     * getAllDepartments()
     */
    private void getAllDepartments() {
        if (mBeaconStrategy == null) {
            WLProcedureCaller wlProcedureCaller = new WLProcedureCaller("SummitAdapter", "getAllDepartments");
            wlProcedureCaller.invoke(null, new DepartmentsResponseListener());
        }
    }

    private class DepartmentsResponseListener implements WLResponseListener {
        @Override
        public void onSuccess(WLResponse wlResponse) {

            Log.i(TAG, wlResponse.getResponseText());
            Log.d("DEBUGGER", "Worklight : getAllDepartments SUCCEED");

            String json = wlResponse.getResponseJSON().toString();
            Log.d("DEBUGGER", json);
            JsonParser parser = new JsonParser();
            JsonObject jsonObject = parser.parse(json).getAsJsonObject();
            JsonPrimitive resultPrimitive = jsonObject.getAsJsonPrimitive("result");
            JsonArray resultObject = parser.parse(resultPrimitive.getAsString()).getAsJsonArray();

            Type departmentType = new TypeToken<List<Department>>() {
            }.getType();

            List<Department> departmentList = new Gson().fromJson(resultObject, departmentType);
            for (Department department : departmentList) {
                Log.i(TAG, "Department Name: " + department.getTitle());
            }
            Log.d("DEBUGGER", Integer.toString(departmentList.size()));
            mBeaconStrategy = new DepartmentProximityBeaconStrategy(getActivity(),
                    (ArrayAdapter) getListAdapter(), products, mListName, departmentList);
            EstimoteManager.getInstance(getActivity()).registerStrategy(mBeaconStrategy);
        }

        @Override
        public void onFailure(WLFailResponse wlFailResponse) {
            Log.d("DEBUGGER", "Worklight : getAllDepartments FAILED");
            Log.i(TAG, wlFailResponse.getErrorMsg());
        }
    }

}
