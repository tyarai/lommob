package tyarai.com.lom.model;

import android.provider.BaseColumns;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;

import java.util.Date;

/**
 * Created by saimon on 19/10/17.
 */

public abstract class CommonModel {

    public static final String NID_COL = "nid";
    public static final String CDATE_COL = "cdate";
    public static final String MDATE_COL = "mdate";
    public static final String ACTIVE_COL = "active";



    @DatabaseField(columnName = BaseColumns._ID, generatedId = true, dataType = DataType.LONG)
    protected long id;

    @DatabaseField(columnName = NID_COL, dataType = DataType.LONG_OBJ)
    protected Long nid;

    @DatabaseField(columnName = CDATE_COL, dataType = DataType.DATE_LONG)
    protected Date postingDate;

    @DatabaseField(columnName = MDATE_COL, dataType = DataType.DATE_LONG)
    protected Date lastModifiedOnTablet;

    @DatabaseField(columnName = ACTIVE_COL, dataType = DataType.BOOLEAN)
    protected boolean active = true;


    public long getId() {
        return id;
    }

    public void setId(long id) {
        this.id = id;
    }

    public Long getNid() {
        return nid;
    }

    public void setNid(Long nid) {
        this.nid = nid;
    }

    public Date getPostingDate() {
        return postingDate;
    }

    public void setPostingDate(Date postingDate) {
        this.postingDate = postingDate;
    }

    public Date getLastModifiedOnTablet() {
        return lastModifiedOnTablet;
    }

    public void setLastModifiedOnTablet(Date lastModifiedOnTablet) {
        this.lastModifiedOnTablet = lastModifiedOnTablet;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
