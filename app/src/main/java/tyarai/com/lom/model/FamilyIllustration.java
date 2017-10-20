package tyarai.com.lom.model;

import android.provider.BaseColumns;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

/**
 * Created by saimon on 19/10/17.
 */

@DatabaseTable(tableName = FamilyIllustration.TABLE_NAME)
public class FamilyIllustration {

    public static final String TABLE_NAME 	    = "family_illustration";

    public static final String FAMILY_COL       = "family_id";
    public static final String ILLUSTRATION_COL = "illusration_id";


    @DatabaseField(columnName = BaseColumns._ID, generatedId = true, dataType = DataType.LONG)
    private long id;

    @DatabaseField(foreign = true, foreignAutoRefresh = true, columnName = FAMILY_COL, canBeNull = false)
    private Family family;

    @DatabaseField(foreign = true, foreignAutoRefresh = true, columnName = ILLUSTRATION_COL, canBeNull = false)
    private Illustration illustration;

    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public Family getFamily() {
        return family;
    }

    public void setFamily(Family family) {
        this.family = family;
    }

    public Illustration getIllustration() {
        return illustration;
    }

    public void setIllustration(Illustration illustration) {
        this.illustration = illustration;
    }
}
