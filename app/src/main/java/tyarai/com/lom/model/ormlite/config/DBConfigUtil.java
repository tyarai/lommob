package tyarai.com.lom.model.ormlite.config;


import com.j256.ormlite.android.apptools.OrmLiteConfigUtil;

import tyarai.com.lom.model.Author;
import tyarai.com.lom.model.Family;
import tyarai.com.lom.model.FamilyIllustration;
import tyarai.com.lom.model.Illustration;
import tyarai.com.lom.model.Links;
import tyarai.com.lom.model.Maps;
import tyarai.com.lom.model.Menus;
import tyarai.com.lom.model.Photograph;
import tyarai.com.lom.model.Specie;
import tyarai.com.lom.model.WatchingSite;


public class DBConfigUtil extends OrmLiteConfigUtil {

    private static final Class<?>[] sClasses = new Class[]{
            Author.class,
            Family.class,
            Illustration.class,
            FamilyIllustration.class,
            Links.class,
            Maps.class,
            Menus.class,
            Photograph.class,
            Specie.class,
            WatchingSite.class,
    };

    /**
     * You must run this method to regenerate res/raw/ormlite_config.txt
     * any time the database definitions are updated.
     * <p>
     * You need to update the Run Configuration for this class to set a
     * JRE, and remove the Android bootstrap entry. Instructions here:
     * http://ormlite.com/javadoc/ormlite-core/doc-files/ormlite_4.html
     * <p>
     * If you are adding a new ORM managed class you must add it to the
     * array of classes above.
     */
    public static void main(String[] args) throws Exception {
        writeConfigFile("ormlite_config.txt", sClasses); //ormlite_config.txt //./src/main/resources/ormlite_config.txt
    }

    // command to count methods in overall project
    // $ cd projects/adra/ws/asotry_droid/asotry_droid_view/ && cat target/classes.dex | head -c 92 | tail -c 4 | hexdump -e '1/4 "%d\n"'
    // ~/projects/adra/ws/asotry_droid/asotry_droid_view$ cat target/classes.dex | head -c 92 | tail -c 4 | hexdump -e '1/4 "%d\n"' => 64516
}
