package tyarai.com.lom.model;

import com.j256.ormlite.dao.ForeignCollection;
import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.field.ForeignCollectionField;
import com.j256.ormlite.table.DatabaseTable;

/**
 * Created by saimon on 19/10/17.
 */

@DatabaseTable(tableName = WatchingSite.TABLE_NAME)
public class WatchingSite extends CommonModel {

    public static final String TABLE_NAME = "watchingsite";

    public static final String TITLE_COL = "title";
    public static final String BODY_COL = "body";
    public static final String MAP_COL = "map_id";


    @DatabaseField(columnName = TITLE_COL, dataType = DataType.STRING)
    private String title;

    @DatabaseField(columnName = BODY_COL, dataType = DataType.LONG_STRING)
    private String body;

    @DatabaseField(columnName = MAP_COL, foreign = true, foreignAutoRefresh = true)
    private Maps map;

    /**
     * not mapped
     */
    private String mapFilename;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public Maps getMap() {
        return map;
    }

    public void setMap(Maps map) {
        this.map = map;
    }

    @Override
    public String toString() {
        return "WatchingSite{" +
                " | title='" + title + '\'' +
                " | body='" + body + '\'' +
                " | map=" + (map == null ? "" : map.getName()) +
                '}';
    }

    public String getMapFilename() {
        return mapFilename;
    }

    public void setMapFilename(String mapFilename) {
        this.mapFilename = mapFilename;
    }
}
