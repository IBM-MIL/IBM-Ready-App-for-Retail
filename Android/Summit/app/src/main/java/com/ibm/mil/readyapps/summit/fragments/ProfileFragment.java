/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.fragments;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.CompoundButton;
import android.widget.Switch;
import android.widget.TextView;

import com.ibm.mil.readyapps.summit.R;
import com.ibm.mil.readyapps.summit.activities.LoginActivity;
import com.ibm.mil.readyapps.summit.activities.MainActivity;
import com.ibm.mil.readyapps.summit.utilities.FontCache;

/**
 * Displays the user's profile page.
 *
 * @author Tanner Preiss
 */
public class ProfileFragment extends Fragment {
    private Button mLoginButton;

    public ProfileFragment() {
        // Required empty public constructor
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container,
                             Bundle savedInstanceState) {
        // Inflate the layout for this fragment
        View rootLayout = inflater.inflate(R.layout.fragment_profile, container, false);

        getActivity().setTitle(getString(R.string.profile_title));

        TextView username = (TextView) rootLayout.findViewById(R.id.profile_username);
        username.setTypeface(FontCache.getFont(getActivity(), FontCache.FontName.OSWALD_REGULAR));

        mLoginButton = (Button) rootLayout.findViewById(R.id.login_button);
        mLoginButton.setTypeface(FontCache.getFont(getActivity(), FontCache.FontName.OSWALD_REGULAR));
        mLoginButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                ((MainActivity) getActivity()).setAuthenticationHandler(null);
                Intent intent = new Intent(getActivity(), LoginActivity.class);
                getActivity().startActivityForResult(intent, LoginActivity.AUTHENTICATION_REQUEST_CODE);
            }
        });

        Switch demoSwitch = (Switch) rootLayout.findViewById(R.id.demo_switch);
        demoSwitch.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                SharedPreferences preferences = getActivity().getSharedPreferences("UserPrefs", Context.MODE_PRIVATE);
                SharedPreferences.Editor editor = preferences.edit();
                editor.putBoolean("demoMode", isChecked);
                editor.apply();
            }
        });

        return rootLayout;
    }

    @Override
    public void onResume() {
        super.onResume();

        // remove login button if user is already authenticated
        if (LoginActivity.isUserAuthenticated(getActivity())) {
            mLoginButton.setVisibility(View.GONE);
        }
    }

}
