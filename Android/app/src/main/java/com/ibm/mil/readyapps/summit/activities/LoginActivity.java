/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.activities;

import android.app.AlertDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.graphics.Typeface;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.reflect.TypeToken;
import com.ibm.mil.readyapps.summit.R;
import com.ibm.mil.readyapps.summit.models.Product;
import com.ibm.mil.readyapps.summit.models.UserList;
import com.ibm.mil.readyapps.summit.utilities.FontCache;
import com.ibm.mil.readyapps.summit.utilities.RealmDataManager;
import com.ibm.mil.readyapps.summit.utilities.SummitChallengeHandler;
import com.ibm.mil.readyapps.summit.utilities.Utils;
import com.ibm.mil.readyapps.summit.utilities.WLPropertyReader;
import com.ibm.mil.readyapps.summit.views.CircularProgressDialog;
import com.ibm.mil.readyapps.worklight.WLProcedureCaller;
import com.ibm.mqa.Log;
import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLResponse;
import com.worklight.wlclient.api.WLResponseListener;

import org.json.JSONObject;

import java.lang.reflect.Type;
import java.util.List;

/**
 * Responsible for logging in, authenticating with WL, and gathering a user's default data. A
 * previously authenticated user is automatically logged out when the activity is started. Obtain
 * a return result by using
 * {@link com.ibm.mil.readyapps.summit.activities.LoginActivity#AUTHENTICATION_REQUEST_CODE}.
 *
 * @author John Petitto
 */
public class LoginActivity extends ActionBarActivity {
    private static final String TAG = LoginActivity.class.getName();

    private EditText mEmailField;
    private EditText mPasswordField;

    /**
     * The request code for the calling activity that is expecting a result returned from
     * {@link com.ibm.mil.readyapps.summit.activities.LoginActivity} regarding the user's
     * authentication status.
     */
    public static final int AUTHENTICATION_REQUEST_CODE = 1;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_login);

        // logout user so they can re-authenticate
        SummitChallengeHandler.logout();
        SharedPreferences preferences = getSharedPreferences("UserPrefs", MODE_PRIVATE);
        SharedPreferences.Editor editor = preferences.edit();
        editor.remove("userId");
        editor.apply();

        mEmailField = (EditText) findViewById(R.id.username_field);
        mPasswordField = (EditText) findViewById(R.id.password_field);

        Typeface customTypeface = FontCache.getFont(this, FontCache.FontName.OPEN_SANS_SEMI_BOLD);
        mEmailField.setTypeface(customTypeface);
        mPasswordField.setTypeface(customTypeface);

        Button loginButton = (Button) findViewById(R.id.submit_login_button);
        loginButton.setTypeface(FontCache.getFont(this, FontCache.FontName.OSWALD_REGULAR));
        loginButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                submitLogin();
            }
        });

        // route soft keyboard login completion to submitLogin listener
        mPasswordField.setOnEditorActionListener(new TextView.OnEditorActionListener() {
            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                boolean handled = false;
                if (actionId == EditorInfo.IME_ACTION_DONE) {
                    submitLogin();
                    handled = true;
                }
                return handled;
            }
        });
    }

    private void submitLogin() {
        String email = mEmailField.getText().toString();
        String password = mPasswordField.getText().toString();

        WLProcedureCaller wlProcedureCaller =
                new WLProcedureCaller("SummitAdapter", "submitAuthentication",
                        new CircularProgressDialog(this));

        Object[] params = new Object[]{email, password};
        wlProcedureCaller.invoke(params, new LoginResponseListener());
    }

    private class LoginResponseListener implements WLResponseListener {
        @Override
        public void onSuccess(WLResponse wlResponse) {
            JSONObject jsonResponse = wlResponse.getResponseJSON();
            Log.i(TAG, "Login success JSON response: " + jsonResponse.toString());

            final String userId = jsonResponse.optString("result");

            // store user id in shared preferences for future retrieval
            SharedPreferences preferences = getSharedPreferences("UserPrefs", Context.MODE_PRIVATE);
            SharedPreferences.Editor editor = preferences.edit();
            editor.putString("userId", userId);
            editor.apply();

            // for logging purposes only
            String storedUserId = preferences.getString("userId", "none");
            Log.i(TAG, "User ID stored in shared prefs: " + storedUserId);

            // obtain user's default lists
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    WLProcedureCaller wlProcedureCaller = new WLProcedureCaller("SummitAdapter",
                            "getDefaultList", new CircularProgressDialog(LoginActivity.this));
                    Object[] params = new Object[]{userId};
                    wlProcedureCaller.invoke(params, new DefaultListResponseListener());
                }
            });
        }

        @Override
        public void onFailure(WLFailResponse wlFailResponse) {
            JSONObject jsonResponse = wlFailResponse.getResponseJSON();

            String errorMessage = "Unknown Failure";
            try {
                JSONObject onAuthRequired = jsonResponse.getJSONObject("onAuthRequired");
                errorMessage = onAuthRequired.getString("errorMessage");
            } catch (Exception ex) {
                ex.printStackTrace();
            }

            // notify user login failed
            final String displayErrorMessage = errorMessage;
            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    new AlertDialog.Builder(LoginActivity.this)
                            .setTitle("Login Failed")
                            .setMessage(displayErrorMessage)
                            .create()
                            .show();
                }
            });
        }
    }

    private class DefaultListResponseListener implements WLResponseListener {
        @Override
        public void onSuccess(WLResponse wlResponse) {
            String json = wlResponse.getResponseJSON().toString();
            Log.i(TAG, json);

            if (WLProcedureCaller.isAuthenticated(wlResponse)) {
                // parse json from response
                JsonArray jsonArray = Utils.getRawResultArray(json);
                Type type = new TypeToken<List<UserList>>() {
                }.getType();
                List<UserList> defaultLists = new Gson().fromJson(jsonArray, type);

                // massage product urls
                String serverUrl = new WLPropertyReader(LoginActivity.this).serverUrl();
                for (UserList userList : defaultLists) {
                    RealmDataManager.createList(LoginActivity.this, userList.getName());
                    for (Product product : userList.getProducts()) {
                        product.setImageUrl(serverUrl + product.getImageUrl());
                        for (Product.Color color : product.getColorOptions()) {
                            color.setUrl(serverUrl + color.getUrl());
                        }
                        RealmDataManager.addItem(LoginActivity.this, userList.getName(), product);
                    }
                }

                dismissLogin();
            }
        }

        @Override
        public void onFailure(WLFailResponse wlFailResponse) {
            Log.e(TAG, wlFailResponse.getErrorMsg());
            dismissLogin();
        }
    }

    private void dismissLogin() {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                setResult(RESULT_OK);
                finish();
            }
        });
    }

    /**
     * Verifies if a user was previously authenticated with WL in the current session of the app.
     *
     * @param context
     * @return is user currently authenticated
     */
    public static boolean isUserAuthenticated(Context context) {
        SharedPreferences preferences = context.getSharedPreferences("UserPrefs", Context.MODE_PRIVATE);
        String userId = preferences.getString("userId", null);
        return userId != null;
    }

}
