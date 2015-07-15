/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.utilities;

import com.google.gson.Gson;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.google.gson.JsonPrimitive;
import com.google.gson.reflect.TypeToken;

/**
 * A collection of general-purpose utility methods.
 *
 * @author John Petitto
 */
public final class Utils {

    private Utils() {
        throw new AssertionError("Utils is non-instantiable");
    }

    /**
     * Takes a variable amount of "untyped" reference arguments and determines if at least one of
     * them is null.
     *
     * @param args A variable amount of "untyped" references.
     * @return {@code true} if all arguments are non-null, {@code false} otherwise.
     */
    public static boolean notNull(Object... args) {
        for (Object arg : args) {
            if (arg == null) {
                return false;
            }
        }

        return true;
    }

    /**
     * Formats a floating-point ({@code double}) value into a dollar-based ($) currency.
     *
     * @param amount The money amount to be formatted.
     * @return A formatted {@code String} representation of the amount passed in.
     */
    public static String formatCurrency(double amount) {
        return String.format("$%.2f", amount);
    }

    private static JsonElement getJsonPrimitive(String json) {
        JsonParser parser = new JsonParser();
        JsonObject jsonObject = parser.parse(json).getAsJsonObject();
        JsonPrimitive jsonPrimitive = jsonObject.getAsJsonPrimitive("result");
        return parser.parse(jsonPrimitive.getAsString());
    }

    /**
     * Given a properly formatted JSON string with a "result" key, it will return its value as a
     * {@code JsonObject} from the Gson library.
     *
     * @param json JSON formatted string with a top-level "result" key.
     * @return The value of the "result" key as a {@code JsonObject}.
     */
    public static JsonObject getRawResultObject(String json) {
        return getJsonPrimitive(json).getAsJsonObject();
    }

    /**
     * Given a properly formatted JSON string with a "result" key, it will return its as a
     * {@code JsonArray} from the Gson library.
     *
     * @param json JSON formatted string with a top-level "result" key.
     * @return The value of the "result" key as a {@code JsonArray}.
     */
    public static JsonArray getRawResultArray(String json) {
        return getJsonPrimitive(json).getAsJsonArray();
    }

    /**
     * De-serializes a properly formatted JSON string with a "result" key into an object of the
     * specified {@code Class} type.
     *
     * @param json     JSON formatted string with a top-level "result" key.
     * @param classOfT The class that the JSON will be de-serialized to.
     * @param <T>
     * @return An object of type {@code classOfT} that contains the de-serialized JSON data.
     */
    public static <T> T mapJsonToClass(String json, Class<T> classOfT) {
        return new Gson().fromJson(getRawResultObject(json), classOfT);
    }

    /**
     * De-serializes a properly formatted JSON string with a "result" key into a {@code Collection}
     * of the specified {@code TypeToken}.
     *
     * @param json  JSON formatted string with a top-level "result" key.
     * @param token The type of a parameterized {@code Collection} that the JSON will be
     *              de-serialized to.
     * @param <T>
     * @return A {@code Collection} built from the type of {@code token} that contains the
     * de-serialized JSON data.
     */
    public static <T> T mapJsonToCollection(String json, TypeToken<T> token) {
        return new Gson().fromJson(getRawResultObject(json), token.getType());
    }

}
