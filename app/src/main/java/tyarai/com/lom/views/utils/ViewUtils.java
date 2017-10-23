package tyarai.com.lom.views.utils;

import android.content.Context;
import android.widget.Toast;

import tyarai.com.lom.R;

/**
 * Created by saimon on 23/10/17.
 */

public class ViewUtils {

    public static void showLoadingError(final Context context) {
        Toast.makeText(context, context.getString(R.string.data_not_found), Toast.LENGTH_LONG).show();
    }
}
