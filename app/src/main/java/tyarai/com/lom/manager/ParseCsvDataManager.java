package tyarai.com.lom.manager;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonTypeInfo;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.androidannotations.annotations.EBean;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import tyarai.com.lom.R;
import tyarai.com.lom.model.Author;
import tyarai.com.lom.model.CommonModel;
import tyarai.com.lom.model.Family;
import tyarai.com.lom.model.FamilyIllustration;
import tyarai.com.lom.model.Illustration;
import tyarai.com.lom.model.Maps;
import tyarai.com.lom.model.Menus;
import tyarai.com.lom.utils.csv.CsvFile;

/**
 * Created by saimon on 19/10/17.
 * Used razorsql to generate json data (in src/main/res/raw folder) from lom.sqlite
 */
@EBean
public class ParseCsvDataManager extends DaoManager implements ParceCsvDataInterface {

    private static final String TAG = ParseCsvDataManager.class.getSimpleName();


    public void parseData(final Context context) {
        new Parser(context).startParsing();
    }

    private <T> List<T> parseJson(final Context context, int id, Class<?> clz) {
        try
        {
            ObjectMapper mapper = new ObjectMapper();
            InputStream inputStream = context.getResources().openRawResource(id);
            JavaType type = mapper.getTypeFactory().constructCollectionType(List.class, clz);
            List <T> result = mapper.readValue(inputStream, type);
            return result;
        }
        catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }


    static class AuthorDto {
        @JsonProperty(value="_id")
        public long nid;
        @JsonProperty(value="_name")
        public String name;
        @JsonProperty(value="_details")
        public String details;
        @JsonProperty(value="_photo")
        public String photo;
    }

    static class IllustrationDto {
        @JsonProperty(value = "_nid")
        public long nid;
        @JsonProperty(value = "_illustration")
        public String title;
        @JsonProperty(value = "_illustration_description")
        public String description;
    }

    static class MenuDto {
        @JsonProperty(value = "_nid")
        public long nid;
        @JsonProperty(value = "_menu_name")
        public String title;
        @JsonProperty(value = "_menu_content")
        public String content;
    }

    static class MapDto {
        @JsonProperty(value = "_nid")
        public long nid;
        @JsonProperty(value = "_file_name")
        public String filename;
    }

    static class FamilyDto {
        @JsonProperty(value = "_nid")
        public long nid;
        @JsonProperty(value = "_family")
        public String family;
        @JsonProperty(value = "_family_description")
        public String description;
        @JsonProperty(value = "_illustration")
        public String illustrationNids;
    }

    class Parser {
        Context context;
        public Parser(final Context context) {
            this.context = context;
        }

        void startParsing() {
            parseAuthors();
            parseIllustrations();
            parseFamilies();
            parseMenus();
            parseMaps();
        }

        void parseMaps()
        {
            try {
                getMapsDao().updateBuilder().updateColumnValue(CommonModel.ACTIVE_COL, false).update();
                Log.d(TAG, "parseMaps()....");
                List<MapDto> maps = parseJson(context, R.raw.maps,
                        Class.forName("tyarai.com.lom.manager.ParseCsvDataManager$MapDto"));
                if (maps != null && !maps.isEmpty()) {
                    for (MapDto mapItem : maps) {
                        try {
                            Maps map = getMapsDao().queryBuilder()
                                    .where().eq(CommonModel.NID_COL, mapItem.nid).queryForFirst();
                            if (map == null) {
                                map = new Maps();
                            }
                            map.setNid(mapItem.nid);
                            map.setName(mapItem.filename);
                            map.setActive(true);
                            getMapsDao().createOrUpdate(map);
                        } catch (NumberFormatException e) {
                            e.printStackTrace();
                        }
                    }
                }

                for (Maps map : getMapsDao().queryForAll()) {
                    Log.d(TAG, "map : " + map);
                }

                Log.d(TAG, "countMap : " + getMapsDao().countOf());

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        void parseMenus()
        {
            try {
                getMenusDao().updateBuilder().updateColumnValue(CommonModel.ACTIVE_COL, false).update();
                Log.d(TAG, "parseMenus()....");
                List<MenuDto> menus = parseJson(context, R.raw.menus,
                        Class.forName("tyarai.com.lom.manager.ParseCsvDataManager$MenuDto"));
                if (menus != null && !menus.isEmpty()) {
                    for (MenuDto menuItem : menus) {
                        try {
                            Menus menu = getMenusDao().queryBuilder()
                                    .where().eq(CommonModel.NID_COL, menuItem.nid).queryForFirst();
                            if (menu == null) {
                                menu = new Menus();
                            }
                            menu.setNid(menuItem.nid);
                            menu.setName(menuItem.title);
                            menu.setContent(menuItem.content);
                            menu.setActive(true);
                            getMenusDao().createOrUpdate(menu);
                        } catch (NumberFormatException e) {
                            e.printStackTrace();
                        }
                    }
                }

                for (Menus menu : getMenusDao().queryForAll()) {
                    Log.d(TAG, "menu : " + menu);
                }

                Log.d(TAG, "countMenu : " + getMenusDao().countOf());

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        void parseFamilies()
        {
            try {
                getFamilyDao().updateBuilder().updateColumnValue(CommonModel.ACTIVE_COL, false).update();
                getFamilyIllustrationDao().deleteBuilder().delete();
                Log.d(TAG, "parseFamilies....");
                List<FamilyDto> families = parseJson(context, R.raw.families,
                        Class.forName("tyarai.com.lom.manager.ParseCsvDataManager$FamilyDto"));
                if (families != null && !families.isEmpty()) {
                    for (FamilyDto familyItem : families) {
                        try {
                            Family family = getFamilyDao().queryBuilder()
                                    .where().eq(CommonModel.NID_COL, familyItem.nid).queryForFirst();
                            if (family == null) {
                                family = new Family();
                            }
                            family.setNid(familyItem.nid);
                            family.setFamily(familyItem.family);
                            family.setDescription(familyItem.description);
                            getFamilyDao().assignEmptyForeignCollection(family, Family.ILLUSTRATION_FIELD);
                            family.setActive(true);
                            getFamilyDao().createOrUpdate(family);
                            if (!TextUtils.isEmpty(familyItem.illustrationNids)) {
                                String[] familyIllustrationNids = familyItem.illustrationNids.split(",");
                                if (familyIllustrationNids != null) {
                                    Log.d(TAG, "familyIllustrationNids " + Arrays.toString(familyIllustrationNids));
                                    for (String nidS : familyIllustrationNids) {
                                        long nid = Long.valueOf(nidS);
                                        Illustration illustration = getIllustrationDao().queryBuilder()
                                                .where().eq(CommonModel.NID_COL, nid).queryForFirst();
                                        if (illustration != null) {
                                            FamilyIllustration familyIllustration = new FamilyIllustration();
                                            familyIllustration.setIllustration(illustration);
                                            family.addIllustration(familyIllustration);
                                        }
                                    }
                                }
                            }

                        } catch (NumberFormatException e) {
                            e.printStackTrace();
                        }
                    }
                }

                for (Family family : getFamilyDao().queryForAll()) {
                    Log.d(TAG, "family : " + family);
                }

                Log.d(TAG, "countFamily : " + getFamilyDao().countOf());
                Log.d(TAG, "familyIllustrations : " + getFamilyIllustrationDao().countOf());

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        void parseIllustrations()
        {
            try {
                getIllustrationDao().updateBuilder().updateColumnValue(CommonModel.ACTIVE_COL, false).update();
                Log.d(TAG, "parseIllustrations()....");
                List<IllustrationDto> illustrations = parseJson(context, R.raw.illustrations,
                        Class.forName("tyarai.com.lom.manager.ParseCsvDataManager$IllustrationDto"));
                if (illustrations != null && !illustrations.isEmpty()) {
                    for (IllustrationDto illustrationItem : illustrations) {
                        try {
                            Illustration illustr = getIllustrationDao().queryBuilder()
                                    .where().eq(CommonModel.NID_COL, illustrationItem.nid).queryForFirst();
                            if (illustr == null) {
                                illustr = new Illustration();
                            }
                            illustr.setNid(illustrationItem.nid);
                            illustr.setTitle(illustrationItem.title);
                            illustr.setDescription(illustrationItem.description);
                            illustr.setActive(true);
                            getIllustrationDao().createOrUpdate(illustr);
                        } catch (NumberFormatException e) {
                            e.printStackTrace();
                        }
                    }
                }

                for (Illustration illustration : getIllustrationDao().queryForAll()) {
                    Log.d(TAG, "illustration : " + illustration);
                }

                Log.d(TAG, "countIllustration : " + getIllustrationDao().countOf());

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        void parseAuthors()
        {
            try {
                getAuthorDao().updateBuilder().updateColumnValue(CommonModel.ACTIVE_COL, false).update();
                Log.d(TAG, "parseAuthors()....");
                List<AuthorDto> authors = parseJson(context, R.raw.authors, Class.forName("tyarai.com.lom.manager.ParseCsvDataManager$AuthorDto"));
                if (authors != null && !authors.isEmpty()) {
                    for (AuthorDto authorItem : authors) {
                        try {
                            Author author = getAuthorDao().queryBuilder()
                                    .where().eq(CommonModel.NID_COL, authorItem.nid).queryForFirst();
                            if (author == null) {
                                author = new Author();
                            }
                            author.setNid(authorItem.nid);
                            author.setName(authorItem.name);
                            author.setDetail(authorItem.details);
                            author.setPhoto(authorItem.photo);
                            author.setActive(true);
                            getAuthorDao().createOrUpdate(author);
                        } catch (NumberFormatException e) {
                            e.printStackTrace();
                        }
                    }
                }

                for (Author author : getAuthorDao().queryForAll()) {
                    Log.d(TAG, "author : " + author);
                }

                Log.d(TAG, "countAuthor : " + getAuthorDao().countOf());

            } catch (Exception e) {
                e.printStackTrace();
            }


        }
    }

}
