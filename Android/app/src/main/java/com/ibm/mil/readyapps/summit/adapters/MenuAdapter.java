/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation <2015>. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.adapters;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.ibm.mil.readyapps.summit.R;

/**
 * The data adapter for the {@link com.ibm.mil.readyapps.summit.activities.MainActivity}
 * navigation drawer.
 *
 * @author Alyson Cabral
 * @author John Petitto
 */
public class MenuAdapter extends BaseAdapter {
    private String[] mTitles;
    private int[] mIcons;
    private Context mContext;

    public MenuAdapter(Context context) {
        mContext = context;
        mTitles = mContext.getResources().getStringArray(R.array.menu_items);
        mIcons = new int[]{
                R.drawable.shop_selected,
                R.drawable.list_selected,
                R.drawable.cart_selected,
                R.drawable.store_selected,
                R.drawable.profile_selected};
    }

    @Override
    public int getCount() {
        return mTitles.length;
    }

    @Override
    public Object getItem(int position) {
        return mTitles[position];
    }

    @Override
    public long getItemId(int position) {
        return position;
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        View row;
        if (convertView == null) {
            LayoutInflater menuInflator = (LayoutInflater)
                    mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
            row = menuInflator.inflate(R.layout.menu_row, parent, false);
        } else {
            row = convertView;
        }

        TextView rowText = (TextView) row.findViewById(R.id.row_text);
        rowText.setText(mTitles[position]);
        ImageView rowIcon = (ImageView) row.findViewById(R.id.row_icon);
        rowIcon.setImageResource(mIcons[position]);

        return row;
    }

}