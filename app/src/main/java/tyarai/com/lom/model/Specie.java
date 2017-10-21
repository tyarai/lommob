package tyarai.com.lom.model;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

import java.util.ArrayList;
import java.util.Arrays;

/**
 * Created by saimon on 19/10/17.
 */

@DatabaseTable(tableName = Specie.TABLE_NAME)
public class Specie extends CommonModel {

    public static final String TABLE_NAME = "species";

    public static final String TITLE_COL = "title";
    public static final String PROFILE_PHOTO_COL = "photo_id";
    public static final String MAP_COL = "map_id";
    public static final String FAMILY_COL = "family_id" ;
    public static final String ENGLISH_COL = "english";
    public static final String WHERETOSEEIT_COL = "wheretoseeit";
    public static final String OTHER_ENGLISH__COL = "other_english";
    public static final String FRENCH_COL = "french";
    public static final String GERMAN_COL = "german";
    public static final String MALAGASY_COL = "malagasy";
    public static final String IDENTIFICATION_COL = "identification";
    public static final String NATURALHISTORY__COL = "natural_history";
    public static final String GEO_RANGE_COL = "geo_range";
    public static final String CONSERVATION_STATUS_COL = "conservation_status";
    public static final String FAVORITE_COL = "favorite";
    public static final String SPECIE_PHOTOGRAPH_NIDS = "specie_photograph_nids";


    @DatabaseField(columnName = TITLE_COL, dataType = DataType.STRING)
    private String title;

    @DatabaseField(columnName = ENGLISH_COL, dataType = DataType.LONG_STRING)
    private String english;

    @DatabaseField(columnName = OTHER_ENGLISH__COL, dataType = DataType.LONG_STRING)
    private String otherEnglish;

    @DatabaseField(columnName = FRENCH_COL, dataType = DataType.LONG_STRING)
    private String french;

    @DatabaseField(columnName = GERMAN_COL, dataType = DataType.LONG_STRING)
    private String german;

    @DatabaseField(columnName = MALAGASY_COL, dataType = DataType.LONG_STRING)
    private String malagasy;

    @DatabaseField(columnName = IDENTIFICATION_COL, dataType = DataType.LONG_STRING)
    private String identification;

    @DatabaseField(columnName = NATURALHISTORY__COL, dataType = DataType.LONG_STRING)
    private String naturalHistory;

    @DatabaseField(columnName = GEO_RANGE_COL, dataType = DataType.LONG_STRING)
    private String geographicRange;

    @DatabaseField(columnName = CONSERVATION_STATUS_COL, dataType = DataType.LONG_STRING)
    private String conservationStatus;

    @DatabaseField(columnName = WHERETOSEEIT_COL, dataType = DataType.LONG_STRING)
    private String whereToSeeIt;

    @DatabaseField(columnName = FAVORITE_COL, dataType = DataType.LONG_STRING)
    private String favorite;

    @DatabaseField(columnName = PROFILE_PHOTO_COL, foreign = true, foreignAutoRefresh = true)
    private Photograph profilePhotograph;

    @DatabaseField(columnName = FAMILY_COL, foreign = true, foreignAutoRefresh = true)
    private Family family;

    @DatabaseField(columnName = MAP_COL, foreign = true, foreignAutoRefresh = true)
    private Maps map;

    @DatabaseField(columnName = SPECIE_PHOTOGRAPH_NIDS, dataType = DataType.SERIALIZABLE)
    private ArrayList<Long> speciephotographNids = new ArrayList<>();


    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getEnglish() {
        return english;
    }

    public void setEnglish(String english) {
        this.english = english;
    }

    public String getOtherEnglish() {
        return otherEnglish;
    }

    public void setOtherEnglish(String otherEnglish) {
        this.otherEnglish = otherEnglish;
    }

    public String getFrench() {
        return french;
    }

    public void setFrench(String french) {
        this.french = french;
    }

    public String getGerman() {
        return german;
    }

    public void setGerman(String german) {
        this.german = german;
    }

    public String getMalagasy() {
        return malagasy;
    }

    public void setMalagasy(String malagasy) {
        this.malagasy = malagasy;
    }

    public String getIdentification() {
        return identification;
    }

    public void setIdentification(String identification) {
        this.identification = identification;
    }

    public String getNaturalHistory() {
        return naturalHistory;
    }

    public void setNaturalHistory(String naturalHistory) {
        this.naturalHistory = naturalHistory;
    }

    public String getGeographicRange() {
        return geographicRange;
    }

    public void setGeographicRange(String geographicRange) {
        this.geographicRange = geographicRange;
    }

    public String getConservationStatus() {
        return conservationStatus;
    }

    public void setConservationStatus(String conservationStatus) {
        this.conservationStatus = conservationStatus;
    }

    public String getWhereToSeeIt() {
        return whereToSeeIt;
    }

    public void setWhereToSeeIt(String whereToSeeIt) {
        this.whereToSeeIt = whereToSeeIt;
    }

    public String getFavorite() {
        return favorite;
    }

    public void setFavorite(String favorite) {
        this.favorite = favorite;
    }

    public Photograph getProfilePhotograph() {
        return profilePhotograph;
    }

    public void setProfilePhotograph(Photograph profilePhotograph) {
        this.profilePhotograph = profilePhotograph;
    }


    public Family getFamily() {
        return family;
    }

    public void setFamily(Family family) {
        this.family = family;
    }

    public Maps getMap() {
        return map;
    }

    public void setMap(Maps map) {
        this.map = map;
    }

    public ArrayList<Long> getSpeciephotographNids() {
        return speciephotographNids;
    }

    public void setSpeciephotographNids(ArrayList<Long> speciephotographNids) {
        this.speciephotographNids = speciephotographNids;
    }

    @Override
    public String toString() {
        return "Specie{" +
                " nid='" + nid + '\'' +
                ", title='" + title + '\'' +
                ", english='" + english + '\'' +
                ", otherEnglish='" + otherEnglish + '\'' +
                ", french='" + french + '\'' +
                ", german='" + german + '\'' +
                ", malagasy='" + malagasy + '\'' +
                ", identification='" + identification + '\'' +
                ", naturalHistory='" + naturalHistory + '\'' +
                ", geographicRange='" + geographicRange + '\'' +
                ", conservationStatus='" + conservationStatus + '\'' +
                ", whereToSeeIt='" + whereToSeeIt + '\'' +
                ", favorite='" + favorite + '\'' +
                ", profilePhotograph=" + (profilePhotograph == null ? "" : profilePhotograph.id) +
                ", family=" + (family == null ? "" : family.id) +
                ", map=" + (map == null ? "" : map.id) +
                ", speciephotographNids=" + (speciephotographNids == null ? "" : Arrays.toString(speciephotographNids.toArray())) +
                '}';
    }
}
