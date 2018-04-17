package tyarai.com.lom.data;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * Created by saimon on 12/04/18.
 */

public class InfoImageDto implements Parcelable {

    private String filename;
    private String imageRaw;
    public InfoImageDto()
    {

    }
    public String getFilename() {
        return filename;
    }
    public String getImageRaw() {
        return imageRaw;
    }
    public void setFilename(String filename) {
        this.filename = filename;
    }
    public void setImageRaw(String imageRaw) {
        this.imageRaw = imageRaw;
    }

    @Override
    public int describeContents() {
        return 0;
    }

    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(filename);
        dest.writeString(imageRaw);
    }

    public InfoImageDto(Parcel in) {
        this.filename = in.readString();
        this.imageRaw = in.readString();
    }

    public static final Parcelable.Creator<InfoImageDto> CREATOR = new Parcelable.Creator<InfoImageDto>() {
        @Override
        public InfoImageDto createFromParcel(Parcel source) {
            return new InfoImageDto(source);
        }

        @Override
        public InfoImageDto[] newArray(int size) {
            return new InfoImageDto[size];
        }
    };

}
