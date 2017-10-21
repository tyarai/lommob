package tyarai.com.lom.manager;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.JavaType;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.androidannotations.annotations.EBean;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import tyarai.com.lom.R;
import tyarai.com.lom.model.Author;
import tyarai.com.lom.model.CommonModel;
import tyarai.com.lom.model.Family;
import tyarai.com.lom.model.Illustration;
import tyarai.com.lom.model.Links;
import tyarai.com.lom.model.Maps;
import tyarai.com.lom.model.Menus;
import tyarai.com.lom.model.Photograph;
import tyarai.com.lom.model.Specie;

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

    static class PhotographDto {
        @JsonProperty(value = "_nid")
        public long nid;
        @JsonProperty(value = "_title")
        public String title;
        @JsonProperty(value = "_photograph")
        public String photo;
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

    static class LinksDto {
        @JsonProperty(value = "_id")
        public long nid;
        @JsonProperty(value = "_linkname")
        public String name;
        @JsonProperty(value = "_linkurl")
        public String url;
        @JsonProperty(value = "_linktitle")
        public String title;
    }


    static class SpecieDto {
        @JsonProperty(value = "_species_id")
        public long nid;
        @JsonProperty(value = "_title")
        public String title;
        @JsonProperty(value = "_profile_photograph_id")
        public long profilePhotographNid;
        @JsonProperty(value = "_family_id")
        public long familyNid;
        @JsonProperty(value = "_english")
        public String english;
        @JsonProperty(value = "_other_english")
        public String otherEnglish;
        @JsonProperty(value = "_french")
        public String french;
        @JsonProperty(value = "_german")
        public String german;
        @JsonProperty(value = "_malagasy")
        public String malagasy;
        @JsonProperty(value = "_identification")
        public String identification;
        @JsonProperty(value = "_natural_history")
        public String naturalHistory;
        @JsonProperty(value = "_geographic_range")
        public String geographicRange;
        @JsonProperty(value = "_conservation_status")
        public String conservationStatus;
        @JsonProperty(value = "_where_to_see_it")
        public String whereToSeetIt;
        @JsonProperty(value = "_map")
        public long mapNid;
        @JsonProperty(value = "_specie_photograph")
        public String speciePhotoGraphNids;
        @JsonProperty(value = "_favorite")
        public String favorite;

        @Override
        public String toString() {
            return "SpecieDto{" +
                    "nid=" + nid +
                    ", title='" + title + '\'' +
                    ", profilePhotographNid=" + profilePhotographNid +
                    ", familyNid=" + familyNid +
                    ", english='" + english + '\'' +
                    ", otherEnglish='" + otherEnglish + '\'' +
                    ", french='" + french + '\'' +
                    ", german='" + german + '\'' +
                    ", malagasy='" + malagasy + '\'' +
                    ", identification='" + identification + '\'' +
                    ", naturalHistory='" + naturalHistory + '\'' +
                    ", geographicRange='" + geographicRange + '\'' +
                    ", conservationStatus='" + conservationStatus + '\'' +
                    ", whereToSeetIt='" + whereToSeetIt + '\'' +
                    ", mapNid=" + mapNid +
                    ", speciePhotoGraphNids='" + speciePhotoGraphNids + '\'' +
                    ", favorite='" + favorite + '\'' +
                    '}';
        }
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
            parseLinks();
            parsePhotographs();
            parseSpecies();
        }

        void parseSpecies()
        {
            try {
                getSpecieDao().updateBuilder().updateColumnValue(CommonModel.ACTIVE_COL, false).update();
                Log.d(TAG, "parseSpecies....");
                List<SpecieDto> specieDtos = parseJson(context, R.raw.species,
                        Class.forName("tyarai.com.lom.manager.ParseCsvDataManager$SpecieDto"));
                if (specieDtos != null && !specieDtos.isEmpty()) {
                    for (SpecieDto specieItem : specieDtos) {
//                        Log.d(TAG, "specieItem : " + specieItem);
                        try {
                            Specie specie = getSpecieDao().queryBuilder()
                                    .where().eq(CommonModel.NID_COL, specieItem.nid).queryForFirst();
                            if (specie == null) {
                                specie = new Specie();
                            }
                            specie.setNid(specieItem.nid);
                            specie.setTitle(specieItem.title);
                            specie.setConservationStatus(specieItem.conservationStatus);
                            specie.setEnglish(specieItem.english);
                            specie.setFrench(specieItem.french);
                            specie.setOtherEnglish(specieItem.otherEnglish);
                            specie.setWhereToSeeIt(specieItem.whereToSeetIt);
                            specie.setNaturalHistory(specieItem.naturalHistory);
                            specie.setGerman(specieItem.german);
                            specie.setGeographicRange(specieItem.geographicRange);
                            specie.setIdentification(specieItem.identification);
                            specie.setMalagasy(specieItem.malagasy);
                            specie.setFavorite(specieItem.favorite);
                            specie.setFamily(getFamilyDao().queryBuilder().where().eq(CommonModel.NID_COL,
                                    specieItem.familyNid).queryForFirst());
                            specie.setMap(getMapsDao().queryBuilder().where().eq(CommonModel.NID_COL,
                                    specieItem.mapNid).queryForFirst());
                            specie.setProfilePhotograph(getPhotographDao().queryBuilder().where().eq(CommonModel.NID_COL,
                                    specieItem.profilePhotographNid).queryForFirst());
                            if (!TextUtils.isEmpty(specieItem.speciePhotoGraphNids)) {
                                String[] speciePhotoGraphNidss = specieItem.speciePhotoGraphNids.split(",");
                                ArrayList<Long> speciePhotoGraphNids = new ArrayList<>();
                                for (String s : speciePhotoGraphNidss) {
                                    speciePhotoGraphNids.add(Long.valueOf(s.trim()));
                                }
                                specie.setSpeciephotographNids(speciePhotoGraphNids);
                            }
                            specie.setActive(true);
                            getSpecieDao().createOrUpdate(specie);
                        } catch (NumberFormatException e) {
                            e.printStackTrace();
                        }
                    }
                }

                for (Specie sp : getSpecieDao().queryForAll()) {
                    Log.d(TAG, "specie : " + sp);
                }

                Log.d(TAG, "countSpecies: " + getSpecieDao().countOf());

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        void parseLinks()
        {
            try {
                getLinksDao().updateBuilder().updateColumnValue(CommonModel.ACTIVE_COL, false).update();
                Log.d(TAG, "parsePhotographs()....");
                List<LinksDto> linksDtos = parseJson(context, R.raw.links,
                        Class.forName("tyarai.com.lom.manager.ParseCsvDataManager$LinksDto"));
                if (linksDtos != null && !linksDtos.isEmpty()) {
                    for (LinksDto photoItem : linksDtos) {
                        try {
                            Links photo = getLinksDao().queryBuilder()
                                    .where().eq(CommonModel.NID_COL, photoItem.nid).queryForFirst();
                            if (photo == null) {
                                photo = new Links();
                            }
                            photo.setNid(photoItem.nid);
                            photo.setTitle(photoItem.title);
                            photo.setName(photoItem.name);
                            photo.setUrl(photoItem.url);
                            photo.setActive(true);
                            getLinksDao().createOrUpdate(photo);
                        } catch (NumberFormatException e) {
                            e.printStackTrace();
                        }
                    }
                }

                for (Links ph : getLinksDao().queryForAll()) {
                    Log.d(TAG, "link : " + ph);
                }

                Log.d(TAG, "countLinks : " + getLinksDao().countOf());

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        void parsePhotographs()
        {
            try {
                getPhotographDao().updateBuilder().updateColumnValue(CommonModel.ACTIVE_COL, false).update();
                Log.d(TAG, "parsePhotographs()....");
                List<PhotographDto> photographDtos = parseJson(context, R.raw.photographs,
                        Class.forName("tyarai.com.lom.manager.ParseCsvDataManager$PhotographDto"));
                if (photographDtos != null && !photographDtos.isEmpty()) {
                    for (PhotographDto photoItem : photographDtos) {
                        try {
                            Photograph photo = getPhotographDao().queryBuilder()
                                    .where().eq(CommonModel.NID_COL, photoItem.nid).queryForFirst();
                            if (photo == null) {
                                photo = new Photograph();
                            }
                            photo.setNid(photoItem.nid);
                            photo.setTitle(photoItem.title);
                            photo.setPhoto(photoItem.photo);
                            photo.setActive(true);
                            getPhotographDao().createOrUpdate(photo);
                        } catch (NumberFormatException e) {
                            e.printStackTrace();
                        }
                    }
                }

                for (Photograph ph : getPhotographDao().queryForAll()) {
                    Log.d(TAG, "photo : " + ph);
                }

                Log.d(TAG, "countPhoto : " + getPhotographDao().countOf());

            } catch (Exception e) {
                e.printStackTrace();
            }
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
                            if (!TextUtils.isEmpty(familyItem.illustrationNids)) {
                                String[] familyIllustrationNidss = familyItem.illustrationNids.split(",");
                                ArrayList<Long> familyIllustrationNids = new ArrayList<>();
                                for (String s : familyIllustrationNidss) {
                                    familyIllustrationNids.add(Long.valueOf(s.trim()));
                                }
                                family.setIllustrationNids(familyIllustrationNids);
                            }
                            family.setActive(true);
                            getFamilyDao().createOrUpdate(family);

                        } catch (NumberFormatException e) {
                            e.printStackTrace();
                        }
                    }
                }

                for (Family family : getFamilyDao().queryForAll()) {
                    Log.d(TAG, "family : " + family);
                }

                Log.d(TAG, "countFamily : " + getFamilyDao().countOf());

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
