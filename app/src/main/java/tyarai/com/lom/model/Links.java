package tyarai.com.lom.model;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

/**
 * Created by saimon on 19/10/17.
 */

@DatabaseTable(tableName = Links.TABLE_NAME)
public class Links extends CommonModel {

    public static final String TABLE_NAME = "links";

    public static final String NAME_COL = "name";
    public static final String TITLE_COL = "title";
    public static final String URL_COL = "url";


    @DatabaseField(columnName = NAME_COL, dataType = DataType.STRING)
    private String name;

    @DatabaseField(columnName = TITLE_COL, dataType = DataType.STRING)
    private String title;

    @DatabaseField(columnName = URL_COL, dataType = DataType.LONG_STRING)
    private String url;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    @Override
    public String toString() {
        return "Links{" +
                " | nid=" + nid  +
                " | name=" + name  +
                " | title=" + title +
                " | url=" + url +
                '}';
    }
}
