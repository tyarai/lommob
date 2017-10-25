package tyarai.com.lom.model;

import com.j256.ormlite.dao.ForeignCollection;
import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.field.ForeignCollectionField;
import com.j256.ormlite.table.DatabaseTable;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Created by saimon on 19/10/17.
 */

@DatabaseTable(tableName = Family.TABLE_NAME)
public class Family extends CommonModel{

    public static final String TABLE_NAME = "families";

    public static final String FAMILY_COL = "family";
    public static final String DESCRIPTION_COL = "description";

    public static final String ILLUSTRATION_NIDS = "illustration_nids" ;

    @DatabaseField(columnName = FAMILY_COL, dataType = DataType.STRING)
    private String family;

    @DatabaseField(columnName = DESCRIPTION_COL, dataType = DataType.LONG_STRING)
    private String description;

    @DatabaseField(columnName = ILLUSTRATION_NIDS, dataType = DataType.SERIALIZABLE)
    private ArrayList<Long> illustrationNids = new ArrayList<>();

    /**
     * Not mapped
     */
    private List<Illustration> illustrations = new ArrayList<>();


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


    public ArrayList<Long> getIllustrationNids() {
        return illustrationNids;
    }

    public void setIllustrationNids(ArrayList<Long> illustrationNids) {
        this.illustrationNids = illustrationNids;
    }

    @Override
    public String toString() {
        return "Family{" +
                " | nid=" + nid +
                " | family=" + family +
                " | description=" + description +
                " | illustrationNids=" + illustrationNids == null ? "" : Arrays.toString(illustrationNids.toArray()) +
                '}';
    }

    public List<Illustration> getIllustrations() {
        return illustrations;
    }

    public void setIllustrations(List<Illustration> illustrations) {
        this.illustrations = illustrations;
    }
}
