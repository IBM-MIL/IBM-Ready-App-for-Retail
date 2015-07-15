/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.utilities;

import com.ibm.mil.readyapps.worklight.ReadyAppsChallengeHandler;
import com.worklight.wlclient.api.WLResponse;

/**
 * A custom {@code ChallengeHandler} that can be used from within Summit.
 *
 * @author John Petitto
 * @see com.ibm.mil.readyapps.worklight.ReadyAppsChallengeHandler
 */
public class SummitChallengeHandler extends ReadyAppsChallengeHandler {
    public SummitChallengeHandler(String realm) {
        super(realm);
    }

    @Override
    public void handleChallenge(WLResponse response) {
        // handle challenge
    }

}
