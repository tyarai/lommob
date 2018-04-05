package tyarai.com.lom.model;

import android.provider.BaseColumns;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

import java.util.Date;

/**
 * Created by saimon on 19/10/17.
 */
@DatabaseTable(tableName = Comment.TABLE_NAME)
public class Comment extends  CommonModel {

    public static final String TABLE_NAME = "comment";

    public static final String CONTENT_COL      = "content";

    @DatabaseField(columnName = CONTENT_COL, dataType = DataType.LONG_STRING)
    private String content;

    public Comment() {
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }
}
