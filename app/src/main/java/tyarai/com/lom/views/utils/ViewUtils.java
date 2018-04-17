package tyarai.com.lom.views.utils;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageManager;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.text.TextUtils;
import android.util.Log;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import tyarai.com.lom.R;
import tyarai.com.lom.views.DateHelper;

/**
 * Created by saimon on 23/10/17.
 */

public class ViewUtils {

    private static final String TAG = ViewUtils.class.getSimpleName();

    public static SimpleDateFormat dateFormatterSemiShortDash = new SimpleDateFormat("MMM dd, yyyy", Locale.FRANCE);
    public static SimpleDateFormat dateFormatterShort = new SimpleDateFormat("yyyy-MM-dd", Locale.FRANCE);

    public static void showLoadingError(final Context context) {
        Toast.makeText(context, context.getString(R.string.data_not_found), Toast.LENGTH_LONG).show();
    }

    public static String getNonEmptyString(String value) {
        return value == null ? "" : value;
    }


    public static String dateToStringSemiShort(final Date date) {
        if (date == null) {
            return "...";
        }
        else return dateFormatterSemiShortDash.format(date);
    }


    public static Date getDateFromDatePicker(DatePicker datePicker) {
        int day = datePicker.getDayOfMonth();
        int month = datePicker.getMonth();
        int year = datePicker.getYear();


        Calendar calendar = Calendar.getInstance();
        calendar.set(year, month, day);

        return calendar.getTime();
    }


    private static long MIN_TIME_BW_UPDATES = 1000; //1000
    private static float MIN_DISTANCE_CHANGE_FOR_UPDATES = 0;
    public static void initGeoCoords(final Activity activity, LocationManager locationManager, LocationListener locationListener) {
        try {
            if (locationManager != null) {
                Log.d(TAG, "tay atooooo");
                if (ContextCompat.checkSelfPermission(activity, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED
                        && ContextCompat.checkSelfPermission(activity, Manifest.permission.ACCESS_COARSE_LOCATION) == PackageManager.PERMISSION_GRANTED)
                {
                    Log.d(TAG, "tay kanakana");
                    // update last know location
                    locationManager.requestLocationUpdates(
                            LocationManager.NETWORK_PROVIDER,
                            MIN_TIME_BW_UPDATES,
                            MIN_DISTANCE_CHANGE_FOR_UPDATES, locationListener);
//                    Location location = locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER);
//                    locationListener.onLocationChanged(location);
//					if (location == null) {
//
//					}
//                    if (location != null) {
//                        res.setLatitude(location.getLatitude());
//                        res.setLongitude(location.getLongitude());
//                        res.setAltitude(location.getAltitude());
//                    }
//                    else {
//                        Log.d(TAG, "initGeoCoords() - location NULL !");
//
//                    }
                }
                else {
                    Log.d(TAG, "initGeoCoords() - permissions NOT GRANTED !");
                    // requestPermission from user
                    ActivityCompat.requestPermissions(activity,
                            new String[]{ Manifest.permission.ACCESS_FINE_LOCATION, Manifest.permission.ACCESS_COARSE_LOCATION },
                            11);

                }
            }
            else {
                Log.d(TAG, "tay nullllll");
                Log.d(TAG, "initGeoCoords() - locationManager NULL !");
            }
        } catch (Exception e) {
            Log.d(TAG, "initGeoCoords() ERROR ..... ");
            e.printStackTrace();
        }
    }

    public  static void stopLocationUpdates(final Activity activity, LocationListener locationListener) {
        LocationManager locationManager = (LocationManager) activity.getSystemService(Context.LOCATION_SERVICE);
        if (locationManager != null) {
            locationManager.removeUpdates(locationListener);
        }
    }

    public static String getStringValue(Object str) {
        if (str == null || TextUtils.isEmpty(str.toString())) {
            return "";
        } else {
            return str.toString();
        }
    }


    public static Integer getIntValue(final TextView strField) {
        if (!TextUtils.isEmpty(strField.getText())) {
            try {
                return Integer.valueOf(strField.getText().toString());
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    public static Integer getIntValue(final EditText strField) {
        if (!TextUtils.isEmpty(strField.getText())) {
            try {
                return Integer.valueOf(strField.getText().toString());
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    public static Float getFloatValue(final EditText strField) {
        if (!TextUtils.isEmpty(strField.getText())) {
            try {
                return Float.valueOf(strField.getText().toString());
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    public static Double getDoubleValue(final EditText strField) {
        if (!TextUtils.isEmpty(strField.getText())) {
            try {
                return Double.valueOf(strField.getText().toString());
            } catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    public static Date getDateValue(final EditText dateField) {
        if (dateField != null &&  !TextUtils.isEmpty(dateField.getText())) {
            try {
                return DateHelper.clearHourPartOfDate(dateFormatterSemiShortDash.parse(dateField.getText().toString()));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    public static Date getDateValue(final TextView dateField) {
        if (dateField != null && !TextUtils.isEmpty(dateField.getText())) {
            try {
                return DateHelper.clearHourPartOfDate(dateFormatterSemiShortDash.parse(dateField.getText().toString()));
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        return null;
    }

    public static Date getFromDate(TextView dateField) {
        return DateHelper.clearHourPartOfDate(getDateValue(dateField));
    }


    public static String objToStr(Object value) {
        String res = "";
        if (value != null) {
            return String.valueOf(value);
        }
        return res;
    }

    public static String convertToStringOnePerLine(List<String> messages) {
        StringBuilder res = new StringBuilder("");
        if (messages != null) {
            for (String message : messages) {
                res.append("- " + message);
                res.append("\n");
            }
        }
        return res.toString();
    }
}
