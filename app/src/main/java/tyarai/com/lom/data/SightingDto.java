package tyarai.com.lom.data;

import android.os.Parcel;
import android.os.Parcelable;

import java.util.Date;

/**
 * Created by saimon on 05/04/18.
 */
public class SightingDto extends CommonDto implements Parcelable {

    private String uuid;

    private String title;

    private Integer numberObserved;

    private Float longitude;

    private Float latitude;

    private Float altitude;

    private Long specieId;

    private Long specieNid;

    private String specieName;

    private String specieTrans;

    private Long watchingSiteId;

    private String watchingSiteTitle;

    private Date observationDate;

    private InfoImageDto photo;

    private String photoFid;

    private boolean active;

    private boolean synced;



    public SightingDto() {
        super();
    }


    public SightingDto(Parcel in) {
        super(in);
        uuid=  in.readString();
        title = in.readString();
        numberObserved = (Integer) in.readValue(null);
        longitude = (Float) in.readValue(null);
        latitude = (Float) in.readValue(null);
        altitude = (Float) in.readValue(null);
        specieId = (Long) in.readValue(null);
        specieNid = (Long) in.readValue(null);
        specieName = in.readString();
        specieTrans = in.readString();
        watchingSiteId = (Long) in.readValue(null);
        watchingSiteTitle = in.readString();
        long nextLong = in.readLong();
        observationDate = nextLong == -1 ? null : new Date(nextLong);
        active = (Boolean) in.readValue(null);
        synced = (Boolean) in.readValue(null);
        photoFid = in.readString();
        photo = in.readParcelable(InfoImageDto.class.getClassLoader());
    }


    @Override
    public void writeToParcel(Parcel dest, int flags) {
        super.writeToParcel(dest,flags);
        dest.writeString(uuid);
        dest.writeString(title);
        dest.writeValue(numberObserved);
        dest.writeValue(longitude);
        dest.writeValue(latitude);
        dest.writeValue(altitude);
        dest.writeValue(specieId);
        dest.writeValue(specieNid);
        dest.writeString(specieName);
        dest.writeString(specieTrans);
        dest.writeValue(watchingSiteId);
        dest.writeString(watchingSiteTitle);
        dest.writeLong(observationDate == null ? -1 : observationDate.getTime());
        dest.writeValue(active);
        dest.writeValue(synced);
        dest.writeString(photoFid);
        dest.writeParcelable(photo, flags);
    }

    @Override
    public int describeContents() {
        return 0;
    }

    public static final Creator<SightingDto> CREATOR = new Creator<SightingDto>() {
        @Override
        public SightingDto createFromParcel(Parcel in) {
            return new SightingDto(in);
        }

        @Override
        public SightingDto[] newArray(int size) {
            return new SightingDto[size];
        }
    };

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Integer getNumberObserved() {
        return numberObserved;
    }

    public void setNumberObserved(Integer numberObserved) {
        this.numberObserved = numberObserved;
    }

    public Float getLongitude() {
        return longitude;
    }

    public void setLongitude(Float longitude) {
        this.longitude = longitude;
    }

    public Float getLatitude() {
        return latitude;
    }

    public void setLatitude(Float latitude) {
        this.latitude = latitude;
    }

    public Float getAltitude() {
        return altitude;
    }

    public void setAltitude(Float altitude) {
        this.altitude = altitude;
    }

    public String getSpecieName() {
        return specieName;
    }

    public void setSpecieName(String specieName) {
        this.specieName = specieName;
    }

    public String getSpecieTrans() {
        return specieTrans;
    }

    public void setSpecieTrans(String specieTrans) {
        this.specieTrans = specieTrans;
    }


    public String getWatchingSiteTitle() {
        return watchingSiteTitle;
    }

    public void setWatchingSiteTitle(String watchingSiteTitle) {
        this.watchingSiteTitle = watchingSiteTitle;
    }

    public Date getObservationDate() {
        return observationDate;
    }

    public void setObservationDate(Date observationDate) {
        this.observationDate = observationDate;
    }

    public InfoImageDto getPhoto() {
        return photo;
    }

    public void setPhoto(InfoImageDto photo) {
        this.photo = photo;
    }

    public Long getSpecieId() {
        return specieId;
    }

    public void setSpecieId(Long specieId) {
        this.specieId = specieId;
    }

    public Long getWatchingSiteId() {
        return watchingSiteId;
    }

    public void setWatchingSiteId(Long watchingSiteId) {
        this.watchingSiteId = watchingSiteId;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    @Override
    public boolean isActive() {
        return active;
    }

    @Override
    public void setActive(boolean active) {
        this.active = active;
    }

    public Long getSpecieNid() {
        return specieNid;
    }

    public void setSpecieNid(Long specieNid) {
        this.specieNid = specieNid;
    }

    public boolean isSynced() {
        return synced;
    }

    public void setSynced(boolean synced) {
        this.synced = synced;
    }

    public String getPhotoFid() {
        return photoFid;
    }

    public void setPhotoFid(String photoFid) {
        this.photoFid = photoFid;
    }
}
