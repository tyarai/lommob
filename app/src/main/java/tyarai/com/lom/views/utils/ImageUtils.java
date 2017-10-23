package tyarai.com.lom.views.utils;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import java.io.IOException;
import java.io.InputStream;

/**
 * Created by saimon on 23/10/17.
 */

public class ImageUtils {

    public static Bitmap getBitmapFromAssets(final Context context, String fileName) {
        try {
            InputStream is = context.getAssets().open(fileName);
            Bitmap bitmap = BitmapFactory.decodeStream(is);
            return bitmap;
        }
        catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }



}
