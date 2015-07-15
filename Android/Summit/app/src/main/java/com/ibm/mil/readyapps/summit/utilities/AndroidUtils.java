/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.utilities;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Typeface;
import android.graphics.drawable.Drawable;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.style.StyleSpan;
import android.util.TypedValue;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;

import com.ibm.mil.readyapps.summit.R;
import com.ibm.mil.readyapps.summit.views.SummitToast;

import java.io.ByteArrayOutputStream;

/**
 * A collection of utility functions that interact with the Android APIs.
 *
 * @author John Petitto
 */
public final class AndroidUtils {

    private AndroidUtils() {
        throw new AssertionError("AndroidUtils is non-instantiable");
    }

    /**
     * Converts pixels to density-independent pixels (dip).
     *
     * @param context
     * @param pixels
     * @return the converted number of pixels based on the display metrics
     */
    public static int pixelsToDip(Context context, int pixels) {
        return (int) TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP,
                pixels, context.getResources().getDisplayMetrics());
    }

    /**
     * Decodes a base-64 byte array representation into a Bitmap. Call the
     * setImageBitmap method on an ImageView with the returned Bitmap object.
     *
     * @param data the raw base-64 image data
     * @return the converted Bitmap that can be used as an ImageView source
     */
    public static Bitmap decodeBase64Image(byte[] data) {
        return BitmapFactory.decodeByteArray(data, 0, data.length);
    }

    /**
     * The lowest quality, highest compression value used by
     * {@link #encodeBase64Image(android.content.Context, int, int)}.
     */
    public static final int LOWEST_QUALITY = 0;

    /**
     * The highest quality, lowest compression value used by
     * {@link #encodeBase64Image(android.content.Context, int, int)}.
     */
    public static final int HIGHEST_QUALITY = 100;

    /**
     * Encodes an ImageView into a base-64 byte array representation. Encoding compression uses
     * highest quality available.
     *
     * @param context
     * @param res     the resource id of an ImageView
     * @return the raw base-64 image data
     */
    public static byte[] encodeBase64Image(Context context, int res) {
        return encodeBase64Image(context, res, HIGHEST_QUALITY);
    }

    /**
     * Encodes an ImageView into a base-64 byte array representation. Encoding compression depends
     * on the quality parameter passed. 0 is the most compressed (lowest quality) and 100 is the
     * least compressed (highest quality).
     *
     * @param context
     * @param res     the resource id of an ImageView
     * @param quality The amount of compression, where 0 is the lowest quality and 100 is the
     *                highest
     * @return the raw base-64 image data compressed accordingly
     */
    public static byte[] encodeBase64Image(Context context, int res, int quality) {
        // ensure quality is between 0 and 100 (inclusive)
        quality = Math.max(LOWEST_QUALITY, Math.min(HIGHEST_QUALITY, quality));

        Bitmap bitmap = BitmapFactory.decodeResource(context.getResources(), res);
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, quality, stream);
        return stream.toByteArray();
    }

    /**
     * Dismisses the soft keyboard if it's present on the screen, otherwise this call is silent.
     *
     * @param context
     * @param editText the EditText that the soft keyboard is "attached" to
     */
    public static void closeSoftKeyboard(Context context, EditText editText) {
        InputMethodManager manager = (InputMethodManager)
                context.getSystemService(Context.INPUT_METHOD_SERVICE);
        manager.hideSoftInputFromWindow(editText.getWindowToken(), 0);
    }

    /**
     * Generate a SpannableString that styles a specific sub-sequence of a CharSequence object.
     *
     * @param sequence    The original text.
     * @param subSequence A sub-sequence of the original text.
     * @param styleSpan   The style to be applied to the sub-sequence.
     * @return A SpannableString with the style applied to only the sub-sequence of the original
     * text.
     */
    public static SpannableString spanSubstring(CharSequence sequence, CharSequence subSequence, StyleSpan styleSpan) {
        SpannableString spannableString = new SpannableString(sequence);
        int startIndex = spannableString.toString().indexOf(subSequence.toString());
        int endIndex = startIndex + subSequence.toString().length();
        spannableString.setSpan(styleSpan, startIndex, endIndex, Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
        return spannableString;
    }

    /**
     * In Summit, use this to show that a {@link com.ibm.mil.readyapps.summit.models.Product} was
     * successfully added to a {@link com.ibm.mil.readyapps.summit.models.UserList}.
     *
     * @param context
     * @param listName The name of the {@link com.ibm.mil.readyapps.summit.models.UserList}.
     */
    public static void showAddedProductToast(Context context, String listName) {
        String rawMessage = context.getString(R.string.product_added) + " " + listName + "!";
        CharSequence styledMessage = AndroidUtils.spanSubstring(rawMessage, listName,
                new StyleSpan(Typeface.BOLD));
        Drawable icon = context.getResources().getDrawable(R.drawable.check_sm_white);
        showToast(context, styledMessage, icon);
    }

    /**
     * In Summit, use this to show that the {@link com.ibm.mil.readyapps.summit.models.Product}
     * trying to be added is already contained inside the desired
     * {@link com.ibm.mil.readyapps.summit.models.UserList}.
     *
     * @param context
     */
    public static void showDuplicateItemToast(Context context) {
        showToast(context, context.getString(R.string.duplicate_item), null);
    }

    /**
     * Displays a {@link com.ibm.mil.readyapps.summit.views.SummitToast} with the specified
     * message and icon.
     *
     * @param context
     * @param message The message to be displayed within the toast.
     * @param icon    The icon to be displayed within the toast.
     */
    public static void showToast(Context context, CharSequence message, Drawable icon) {
        SummitToast toast = new SummitToast(context);
        toast.setMessage(message);
        toast.setIcon(icon);
        toast.show();
    }

}
