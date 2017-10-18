package tyarai.com.lom.model;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

/**
 * Created by saimon on 19/10/17.
 */

@DatabaseTable(tableName = Illustration.TABLE_NAME)
public class Illustration extends CommonModel {

    public static final String TABLE_NAME = "illustrations";

    public static final String TITLE_COL = "title";
    public static final String DESCRITPION_COL = "description";


    @DatabaseField(columnName = TITLE_COL, dataType = DataType.STRING)
    private String title;

    @DatabaseField(columnName = DESCRITPION_COL, dataType = DataType.LONG_STRING)
    private String description;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
