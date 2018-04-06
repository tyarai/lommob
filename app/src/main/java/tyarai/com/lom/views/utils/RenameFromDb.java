package tyarai.com.lom.views.utils;

import android.text.TextUtils;
import android.util.Log;

import org.jsoup.parser.Parser;

/**
 * Created by saimon on 23/10/17.
 */

public class RenameFromDb {

    private static final String TAG = RenameFromDb.class.getSimpleName();

    public static String renameFNoExtension(String fname) {
        Log.d(TAG, "original :" + fname);
        if (!TextUtils.isEmpty(fname)) {
            // unescape html fname because db return escaped filenames
            String fx = Parser.unescapeEntities(fname, false);
            String rebuilt = "z_" + fx.replaceAll("[^a-zA-Z0-9//]", "_")
                    .replace("_jpg", "")
                    .toLowerCase();
            Log.d(TAG, "rebuild :" + rebuilt);
            return rebuilt;
        }
        return "";
    }
}
