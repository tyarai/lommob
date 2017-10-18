package tyarai.com.lom.model;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

/**
 * Created by saimon on 19/10/17.
 */

@DatabaseTable(tableName = Specie.TABLE_NAME)
public class Specie extends CommonModel {

    public static final String TABLE_NAME = "species";

    public static final String TITLE_COL = "title";
    public static final String PROFILE_PHOTO_COL = "photo_id";
    public static final String FAMILY_COL = "family_id";
    public static final String FAMILY_PHOTO_COL = "family_photo" ;
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
    private static final String FAVORITE_COL = "favorite";


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

    @DatabaseField(columnName = FAMILY_PHOTO_COL, foreign = true, foreignAutoRefresh = true)
    private Photograph familyPhotograph;

    @DatabaseField(columnName = FAMILY_COL, foreign = true, foreignAutoRefresh = true)
    private Family family;


}
