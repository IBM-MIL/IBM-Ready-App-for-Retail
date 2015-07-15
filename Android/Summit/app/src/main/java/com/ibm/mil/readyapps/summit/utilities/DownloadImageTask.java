/*
 * Licensed Materials - Property of IBM
 * © Copyright IBM Corporation 2015. All Rights Reserved.
 */

package com.ibm.mil.readyapps.summit.utilities;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.util.LruCache;
import android.widget.ImageView;

import java.net.URL;

/**
 * Downloads an image from a network with a URL asynchronously. There is a caching mechanism
 * implemented within the {@code AsyncTask} to avoid unnecessary network calls.
 *
 * @author John Petitto
 */
public class DownloadImageTask extends AsyncTask<String, Void, Bitmap> {
    private static LruCache<String, Bitmap> bitmapCache;
    private ImageView imageView;

    /**
     * The {@code ImageView} that will be backed by the downloaded bitmap from the given URL.
     *
     * @param imageView The {@code ImageView} that will hold the downloaded bitmap.
     */
    public DownloadImageTask(ImageView imageView) {
        this.imageView = imageView;

        if (bitmapCache == null) {
            int maxMemory = (int) (Runtime.getRuntime().maxMemory() / 1024);
            bitmapCache = new LruCache<String, Bitmap>(maxMemory / 8) {
                @Override
                protected int sizeOf(String key, Bitmap bitmap) {
                    return bitmap.getByteCount() / 1024;
                }
            };
        }
    }

    @Override
    protected Bitmap doInBackground(String... urls) {
        String url = urls[0];

        // see if bitmap is cached
        if (bitmapCache.get(url) != null) {
            return bitmapCache.get(url);
        }

        // bitmap not cached, pull in with url
        Bitmap bitmap = null;
        try {
            bitmap = BitmapFactory.decodeStream(new URL(url).openStream());
            bitmapCache.put(url, bitmap);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return bitmap;
    }

    @Override
    protected void onPostExecute(Bitmap result) {
        imageView.setImageBitmap(result);
    }
}
