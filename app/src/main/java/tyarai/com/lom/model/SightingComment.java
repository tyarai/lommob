package tyarai.com.lom.model;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

/**
 * Created by saimon on 19/10/17.
 */
@DatabaseTable(tableName = SightingComment.TABLE_NAME)
public class SightingComment extends  CommonModel {

    public static final String TABLE_NAME       = "sighting_comment";
    private static final String SIGHTING_COL    = "sighting_id";
    private static final String COMMENT_COL     = "comment_id";

    @DatabaseField(columnName = SIGHTING_COL, foreign = true, foreignAutoRefresh = true)
    private Sighting sighting;

    @DatabaseField(columnName = COMMENT_COL, foreign = true, foreignAutoRefresh = true)
    private Comment comment;


    public SightingComment() {
    }

    public Sighting getSighting() {
        return sighting;
    }

    public void setSighting(Sighting sighting) {
        this.sighting = sighting;
    }

    public Comment getComment() {
        return comment;
    }

    public void setComment(Comment comment) {
        this.comment = comment;
    }
}
