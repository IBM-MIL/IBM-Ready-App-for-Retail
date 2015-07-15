/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 * This sample program is provided AS IS and may be used, executed, copied and modified without
 * royalty payment by customer (a) for its own instruction and study, (b) in order to develop
 * applications designed to run with an IBM product, either for customer's own internal use or for
 * redistribution by customer, as part of such an application, in customer's own products.
 */

package com.ibm.mil.readyapps.worklight;

import android.util.Log;

import com.worklight.wlclient.WLRequestListener;
import com.worklight.wlclient.api.WLClient;
import com.worklight.wlclient.api.WLFailResponse;
import com.worklight.wlclient.api.WLResponse;
import com.worklight.wlclient.api.challengehandler.ChallengeHandler;

import org.json.JSONException;

/**
 * A basic abstract implementation for a WL Challenge Handler designed for inheritance.
 * The handleChallenge method is implemented by the inheriting child class. A utility function
 * for logout is provided as well.
 *
 * @author Ketaki Borkar
 * @author John Petitto
 */
public abstract class ReadyAppsChallengeHandler extends ChallengeHandler {
    private static final String TAG = ReadyAppsChallengeHandler.class.getName();

    public static final String CLIENT_REALM = "SingleStepAuthRealm";

    public ReadyAppsChallengeHandler(String realm) {
        super(realm);
    }

    /**
     * Override this method to write behavior that is run when WL authentication is successful.
     * Ensure that the parent's implementation is invoked by calling super(response).
     *
     * @param response
     */
    @Override
    public void onSuccess(WLResponse response) {
        submitSuccess(response);
    }

    /**
     * Override this method to write behavior that is run when WL authentication fails.
     * Ensure that the parent's implementation is invoked by calling super(response).
     *
     * @param response
     */
    @Override
    public void onFailure(WLFailResponse response) {
        submitFailure(response);
    }

    /**
     * Used by the challenge handler to determine if authentication was successful or not. This
     * method cannot be overridden and is used as part of the internal implementation.
     *
     * @param response
     * @return indicates whether WL authentication succeeded or not
     */
    @Override
    public final boolean isCustomResponse(WLResponse response) {
        try {
            if (response != null &&
                    response.getResponseJSON() !=null &&
                    response.getResponseJSON().isNull("authRequired") != true &&
                    response.getResponseJSON().getBoolean("authRequired") == true) {
                return true;
            }
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * When a non-authenticated WL user invokes a protected procedure, this method will be called.
     * A typical implementation will direct the user to login (via an intent to a login activity)
     * in order to authenticate the user with WL.
     *
     * @param response
     */
    @Override
    public abstract void handleChallenge(WLResponse response);

    /**
     * Utility method for logging out an existing authenticated WL user. This is necessary for a
     * second WL user to be authenticated. If no user is currently authenticated with WL then this
     * call is silent.
     */
    public static final void logout() {
        WLClient client = WLClient.getInstance();
        client.logout(ReadyAppsChallengeHandler.CLIENT_REALM, new WLRequestListener() {
            @Override
            public void onSuccess(WLResponse wlResponse) {
                Log.i(TAG, wlResponse.getResponseText());
            }

            @Override
            public void onFailure(WLFailResponse wlFailResponse) {
                Log.e(TAG, wlFailResponse.getErrorMsg());
            }
        });
    }

}
