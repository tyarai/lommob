package tyarai.com.lom.views.utils;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;

/**
 * Created by saimon on 19/04/18.
 */

public class SharedUtils {

    public static void writeToPref(Activity context, String key, Object value) {
        SharedPreferences sharedPref = context.getPreferences(Context.MODE_PRIVATE);
        SharedPreferences.Editor editor = sharedPref.edit();
        if (value instanceof String) {
            editor.putString(key, String.valueOf(value));
        }
        else if (value instanceof Integer) {
            editor.putInt(key, (Integer)value);
        }
        else if (value instanceof Boolean) {
            editor.putBoolean(key, (Boolean)value);
        }
        else if (value instanceof Float) {
            editor.putFloat(key, (Float) value);
        }
        else if (value instanceof Long) {
            editor.putLong(key, (Long) value);
        }
        editor.commit();
    }

    public static boolean getBooleanPref(Activity context, String key) {
        SharedPreferences sharedPref = context.getPreferences(Context.MODE_PRIVATE);
        return sharedPref.getBoolean(key, false);
    }

    public static  String getStringPref(Activity context, String key) {
        SharedPreferences sharedPref = context.getPreferences(Context.MODE_PRIVATE);
        return sharedPref.getString(key, "");
    }

    public static  int getIntPref(Activity context, String key) {
        SharedPreferences sharedPref = context.getPreferences(Context.MODE_PRIVATE);
        return sharedPref.getInt(key, -1);
    }

    public static  Long getLongPref(Activity context, String key) {
        SharedPreferences sharedPref = context.getPreferences(Context.MODE_PRIVATE);
        return sharedPref.getLong(key, 0L);
    }
}
