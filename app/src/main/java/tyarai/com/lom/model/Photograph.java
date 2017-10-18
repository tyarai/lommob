package tyarai.com.lom.model;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

/**
 * Created by saimon on 19/10/17.
 */

@DatabaseTable(tableName = Photograph.TABLE_NAME)
public class Photograph extends CommonModel {

    public static final String TABLE_NAME = "photographs";

    public static final String TITLE_COL = "title";
    public static final String PHOTO_COL = "photo";


    @DatabaseField(columnName = TITLE_COL, dataType = DataType.STRING)
    private String title;

    @DatabaseField(columnName = PHOTO_COL, dataType = DataType.STRING)
    private String photo;

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }
}
