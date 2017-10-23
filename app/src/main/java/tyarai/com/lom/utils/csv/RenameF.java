package tyarai.com.lom.utils.csv;

import android.text.TextUtils;

import java.io.File;

/**
 * Created by saimon on 23/10/17.
 */

public class RenameF {

    public static void main(String[] args) {
        String bd = "/mnt/teralinux/home/AndroidStudioProjects/LOM/app/src/main/res-photo/drawable/";
        File dir = new File(bd);

        if (dir.isDirectory()) {
            for (final File f : dir.listFiles()) {
                try {
                    File newfile =new File(bd + renameF(f.getName()));
                    f.renameTo(newfile);
                } catch (Exception e) {
                    e.printStackTrace();
                }


            }
        }
    }

    public static String renameF(String fname) {
        if (!TextUtils.isEmpty(fname)) {
            return "z_" + fname.replaceAll("[^a-zA-Z0-9//]", "_").replace("_jpg", ".jpg").toLowerCase();
        }
        return null;
    }

    public static String renameFNoExtension(String fname) {
        if (!TextUtils.isEmpty(fname)) {
            return "z_" + fname.replaceAll("[^a-zA-Z0-9//]", "_").replace("_jpg", "").toLowerCase();
        }
        return "";
    }
}
