/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2014. All Rights Reserved.
 * This sample program is provided AS IS and may be used, executed, copied and modified without
 * royalty payment by customer (a) for its own instruction and study, (b) in order to develop
 * applications designed to run with an IBM product, either for customer's own internal use or for
 * redistribution by customer, as part of such an application, in customer's own products.
 */

package com.ibm.mil.readyapps.webview;

import java.util.List;

/**
 * Listen for changes to an @{code MILWebView} widget. To listen for changes to a specific
 * {@code MILWebView}, pass an {@code MILWebViewListener} to its {@code registerListener} method.
 *
 * @see MILWebView
 * @see MILWebView#setOnPageChangeListener(OnPageChangeListener)
 *
 * @author John Petitto
 */
public interface OnPageChangeListener {
    /**
     * Notifies the listener of a page change.
     *
     * @param pathComponents   the url of the new page separated into components by slashes and
     *                         hash marks
     */
    void onPageChange(List<String> pathComponents);

    /**
     * Notifies the listener of a native operation to perform.
     *
     * @param operation     the name of the native operation to perform
     */
    void performNativeOperation(String operation);
}
