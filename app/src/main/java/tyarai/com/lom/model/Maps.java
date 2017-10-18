package tyarai.com.lom.model;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

/**
 * Created by saimon on 19/10/17.
 */

@DatabaseTable(tableName = Maps.TABLE_NAME)
public class Maps extends CommonModel {

    public static final String TABLE_NAME = "maps";
    public static final String NAME_COL = "name";

    @DatabaseField(columnName = NAME_COL, dataType = DataType.LONG_STRING)
    private String name;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}
