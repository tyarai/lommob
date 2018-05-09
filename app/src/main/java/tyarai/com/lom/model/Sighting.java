package tyarai.com.lom.model;

import com.j256.ormlite.dao.ForeignCollection;
import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.field.ForeignCollectionField;
import com.j256.ormlite.table.DatabaseTable;

import java.util.Date;

/**
 * Created by saimon on 05/04/18.
 */

@DatabaseTable(tableName = Sighting.TABLE_NAME)
public class Sighting extends CommonModel {

    public static final String TABLE_NAME           = "sighting";

    public static final String TITLE_COL            = "title";
    public static final String UUID_COL             = "uuid";
    public static final String NUMBER_COL           = "number_observed";
    public static final String PHOTO_COL            = "photo";
    public static final String PHOTO_FID_COL         = "photo_fid";
    public static final String OBSERVATION_DATE_COL = "observation_date";
    public static final String LONGITUDE_COL        = "longitude";
    public static final String LATITUDE_COL         = "latitude";
    public static final String ALTITUDE_COL         = "altitude";
    public static final String SPECIE_COL           = "specie_id";
    public static final String WATCHING_SITE_COL    = "watching_site_id";
    public static final String SYNCED_COL           = "synced";
    public static final String PHOTO_PATH_COL       = "photo_path";
    public static final String PHOTO_NAME_COL       = "photo_name";
    public static final String PHOTO_SIZE_COL       = "photo_size";


    @DatabaseField(columnName = UUID_COL, dataType = DataType.STRING)
    private String uuid;


    @DatabaseField(columnName = TITLE_COL, dataType = DataType.STRING)
    private String title;

    @DatabaseField(columnName = NUMBER_COL, dataType = DataType.INTEGER_OBJ)
    private Integer numberObserved;

    @DatabaseField(columnName = LONGITUDE_COL, dataType = DataType.FLOAT_OBJ)
    private Float longitude;

    @DatabaseField(columnName = LATITUDE_COL, dataType = DataType.FLOAT_OBJ)
    private Float latitude;

    @DatabaseField(columnName = ALTITUDE_COL, dataType = DataType.FLOAT_OBJ)
    private Float altitude;


    @DatabaseField(columnName = SPECIE_COL, foreign = true, foreignAutoRefresh = true)
    private Specie specie;

    @DatabaseField(columnName = WATCHING_SITE_COL, foreign = true, foreignAutoRefresh = true)
    private WatchingSite watchingSite;

    @DatabaseField(columnName = OBSERVATION_DATE_COL, dataType = DataType.DATE_LONG)
    private Date observationDate;

    @DatabaseField(columnName = PHOTO_COL, dataType = DataType.SERIALIZABLE, canBeNull = true)
    private String photo;

    @DatabaseField(columnName = PHOTO_FID_COL, dataType = DataType.STRING, canBeNull = true)
    private String photoFid;

    @DatabaseField(columnName = PHOTO_PATH_COL, dataType = DataType.STRING, canBeNull = true)
    private String photoFilePath;

    @DatabaseField(columnName = PHOTO_NAME_COL, dataType = DataType.STRING, canBeNull = true)
    private String photoFileName;

    @DatabaseField(columnName = PHOTO_SIZE_COL, dataType = DataType.INTEGER)
    private int photoFileSize;

    @DatabaseField(columnName = SYNCED_COL, dataType = DataType.BOOLEAN)
    private boolean synced;

    @ForeignCollectionField(eager = false)
    private ForeignCollection<SightingComment> comments;


    public void addComment(SightingComment comment) {
        if (this.comments != null) {
            this.comments.add(comment);
        }
    }

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

    public Specie getSpecie() {
        return specie;
    }

    public void setSpecie(Specie specie) {
        this.specie = specie;
    }

    public WatchingSite getWatchingSite() {
        return watchingSite;
    }

    public void setWatchingSite(WatchingSite watchingSite) {
        this.watchingSite = watchingSite;
    }

    public Date getObservationDate() {
        return observationDate;
    }

    public void setObservationDate(Date observationDate) {
        this.observationDate = observationDate;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public ForeignCollection<SightingComment> getComments() {
        return comments;
    }

    public void setComments(ForeignCollection<SightingComment> comments) {
        this.comments = comments;
    }

    public String getUuid() {
        return uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
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

    public String getPhotoFilePath() {
        return photoFilePath;
    }

    public void setPhotoFilePath(String photoFilePath) {
        this.photoFilePath = photoFilePath;
    }

    public String getPhotoFileName() {
        return photoFileName;
    }

    public void setPhotoFileName(String photoFileName) {
        this.photoFileName = photoFileName;
    }

    public int getPhotoFileSize() {
        return photoFileSize;
    }

    public void setPhotoFileSize(int photoFileSize) {
        this.photoFileSize = photoFileSize;
    }
}
