package tyarai.com.lom.model;

import com.j256.ormlite.dao.ForeignCollection;
import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.field.ForeignCollectionField;
import com.j256.ormlite.table.DatabaseTable;

/**
 * Created by saimon on 19/10/17.
 */

@DatabaseTable(tableName = Family.TABLE_NAME)
public class Family extends CommonModel{

    public static final String TABLE_NAME = "families";

    public static final String FAMILY_COL = "family";
    public static final String DESCRIPTION_COL = "description";

    public static final String ILLUSTRATION_FIELD = "illustrations";

    @DatabaseField(columnName = FAMILY_COL, dataType = DataType.STRING)
    private String family;

    @DatabaseField(columnName = DESCRIPTION_COL, dataType = DataType.LONG_STRING)
    private String description;

    @ForeignCollectionField(eager = false)
    private ForeignCollection<Illustration> illustrations;

    private void addIllustration(Illustration illustration) {
        if (illustrations != null) {
            illustrations.add(illustration);
        }
    }


    public String getFamily() {
        return family;
    }

    public void setFamily(String family) {
        this.family = family;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public ForeignCollection<Illustration> getIllustrations() {
        return illustrations;
    }

    public void setIllustrations(ForeignCollection<Illustration> illustrations) {
        this.illustrations = illustrations;
    }
}
