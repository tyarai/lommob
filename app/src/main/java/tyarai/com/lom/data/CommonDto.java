package tyarai.com.lom.data;

import android.os.Parcel;
import android.os.Parcelable;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;

import java.util.Date;

/**
 * Created by saimon on 13/04/18.
 */
public class CommonDto implements Parcelable {

    protected long id;
    protected Long nid;
    protected Date postingDate;
    protected Date lastModifiedOnTablet;
    protected boolean active;

    public CommonDto() {
        super();
    }

    public CommonDto(Parcel in) {
        id = in.readLong();
        long nextLong = in.readLong();
        nid = nextLong == -1 ? null : nextLong;
        nextLong = in.readLong();
        postingDate = nextLong == -1 ? null : new Date(nextLong);
        nextLong = in.readLong();
        lastModifiedOnTablet = nextLong == -1 ? null : new Date(nextLong);
        active = (Boolean) in.readValue(null);
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeLong(id);
        dest.writeLong(nid == null ? -1 : nid);
        dest.writeLong(postingDate == null ? -1 : postingDate.getTime());
        dest.writeLong(lastModifiedOnTablet == null ? -1 : lastModifiedOnTablet.getTime());
        dest.writeValue(active);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<CommonDto> CREATOR = new Creator<CommonDto>() {
        @Override
        public CommonDto createFromParcel(Parcel in) {
            return new CommonDto(in);
        }

        @Override
        public CommonDto[] newArray(int size) {
            return new CommonDto[size];
        }
    };

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
