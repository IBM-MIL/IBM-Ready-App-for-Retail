/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.utilities;

import android.content.Context;
import android.graphics.Typeface;

import java.util.HashMap;
import java.util.Map;

/**
 * Provides easy retrieval of custom typefaces for stylizing text-based widgets in Android. Refer
 * to the FontName enum type for the set of available fonts.
 *
 * @author John Petitto
 */
public final class FontCache {
    // Implementation derived from:
    // https://slothdevelopers.wordpress.com/2014/05/11/custom-fonts-in-textview-and-fontcache/

    private static Map<FontName, Typeface> fontMap = new HashMap<>();

    private FontCache() {
        throw new AssertionError("FontCache is non-instantiable");
    }

    /**
     * Retrieves the Typeface object corresponding to the specified font name
     *
     * @param context
     * @param fontName A predefined enumerated value corresponding to a custom font
     * @return A typeface for the specified font name
     */
    public static Typeface getFont(Context context, FontName fontName) {
        if (fontMap.containsKey(fontName)) {
            return fontMap.get(fontName);
        } else {
            Typeface tf = Typeface.createFromAsset(context.getAssets(), fontName.getFileName());
            fontMap.put(fontName, tf);
            return tf;
        }
    }

    /**
     * An enumeration of custom font names that are used for retrieving a Typeface
     * representation.
     */
    public enum FontName {
        // add more fonts as necessary
        OPEN_SANS_REGULAR("fonts/OpenSans-Regular.ttf"),
        OPEN_SANS_REGULAR_2("fonts/OpenSans-Regular2.ttf"),
        OPEN_SANS_SEMI_BOLD("fonts/OpenSans-Semibold.ttf"),
        OPEN_SANS_SEMI_BOLD_2("fonts/OpenSans-Semibold2.ttf"),
        OSWALD_REGULAR("fonts/Oswald-Regular.ttf"),
        OSWALD_LIGHT("fonts/Oswald-Light.ttf"),
        OSWALD_BOLD("fonts/Oswald-Bold.ttf");

        private final String fileName;

        private FontName(String fileName) {
            this.fileName = fileName;
        }

        private String getFileName() {
            return fileName;
        }
    }

}
