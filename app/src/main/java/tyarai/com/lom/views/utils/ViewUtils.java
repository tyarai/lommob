package tyarai.com.lom.views.utils;

import android.content.Context;
import android.widget.Toast;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

import tyarai.com.lom.R;

/**
 * Created by saimon on 23/10/17.
 */

public class ViewUtils {

    public static SimpleDateFormat dateFormatterSemiShortDash = new SimpleDateFormat("yyyy-MMM-dd", Locale.FRANCE);

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

}
