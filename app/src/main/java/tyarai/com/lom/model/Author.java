package tyarai.com.lom.model;



import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

/**
 * Created by saimon on 19/10/17.
 */

@DatabaseTable(tableName = Author.TABLE_NAME)
public class Author extends CommonModel {

    public static final String TABLE_NAME = "authors";

    public static final String NAME_COL = "name";
    public static final String DETAIL_COL = "details";
    public static final String PHOTO_COL = "photo";

    @DatabaseField(columnName = NAME_COL, dataType = DataType.STRING)
    private String name;

    @DatabaseField(columnName = DETAIL_COL, dataType = DataType.LONG_STRING)
    private String detail;

    @DatabaseField(columnName = PHOTO_COL, dataType = DataType.STRING)
    private String photo;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDetail() {
        return detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }


    @Override
    public String toString() {
        return "Author{ " +
                "nid=" + nid +
                " | name=" + name +
                " | detail=" + (detail == null ? "null" : detail.substring(0,20) ) +
                " | photo=" + photo +
                '}';
    }
}
