package tyarai.com.lom.manager;

import com.j256.ormlite.dao.RuntimeExceptionDao;

import java.util.Map;

import tyarai.com.lom.model.Author;
import tyarai.com.lom.model.Family;
import tyarai.com.lom.model.FamilyIllustration;
import tyarai.com.lom.model.Illustration;
import tyarai.com.lom.model.Links;
import tyarai.com.lom.model.Maps;
import tyarai.com.lom.model.Menus;
import tyarai.com.lom.model.Photograph;
import tyarai.com.lom.model.Specie;
import tyarai.com.lom.model.WatchingSite;
import tyarai.com.lom.model.ormlite.config.DataBaseHelper;

public abstract class DaoManager {

	private DataBaseHelper helper;	

	private static RuntimeExceptionDao<Author, Long> authorDao;
	private static RuntimeExceptionDao<Family, Long> familyDao;
	private static RuntimeExceptionDao<Illustration, Long> illustrationDao;
	private static RuntimeExceptionDao<FamilyIllustration, Long> familyIllustrationDao;
	private static RuntimeExceptionDao<Links, Long> linksDao;
	private static RuntimeExceptionDao<Maps, Long> mapsDao;
	private static RuntimeExceptionDao<Menus, Long> menusDao;
	private static RuntimeExceptionDao<Photograph, Long> photographDao;
	private static RuntimeExceptionDao<Specie, Long> specieDao;
	private static RuntimeExceptionDao<WatchingSite, Long> watchingsiteDao;

	protected DataBaseHelper getHelper() {
		if (helper == null) {
			try {
				helper = DatabaseManager.getInstance().getHelper();
			} catch (NullPointerException e) {
				e.printStackTrace();
			}
		}
		return helper;
	}	

	public RuntimeExceptionDao<Author, Long> getAuthorDao() {
		if (authorDao == null) {
			authorDao = getHelper().getRuntimeExceptionDao(Author.class);
		}
		return authorDao;
	}

	public RuntimeExceptionDao<Family, Long> getFamilyDao() {
		if (familyDao == null) {
			familyDao = getHelper().getRuntimeExceptionDao(Family.class);
		}
		return familyDao;
	}

	public RuntimeExceptionDao<Illustration, Long> getIllustrationDao() {
		if (illustrationDao == null) {
			illustrationDao = getHelper().getRuntimeExceptionDao(Illustration.class);
		}
		return illustrationDao;
	}

	public RuntimeExceptionDao<Links, Long> getLinksDao() {
		if (linksDao == null) {
			linksDao = getHelper().getRuntimeExceptionDao(Links.class);
		}
		return linksDao;
	}

	public RuntimeExceptionDao<Maps, Long> getMapsDao() {
		if (mapsDao == null) {
			mapsDao = getHelper().getRuntimeExceptionDao(Maps.class);
		}
		return mapsDao;
	}

	public RuntimeExceptionDao<Menus, Long> getMenusDao() {
		if (menusDao == null) {
			menusDao = getHelper().getRuntimeExceptionDao(Menus.class);
		}
		return menusDao;
	}

	public RuntimeExceptionDao<Photograph, Long> getPhotographDao() {
		if (photographDao == null) {
			photographDao = getHelper().getRuntimeExceptionDao(Photograph.class);
		}
		return photographDao;
	}

	public RuntimeExceptionDao<Specie, Long> getSpecieDao() {
		if (specieDao == null) {
			specieDao = getHelper().getRuntimeExceptionDao(Specie.class);
		}
		return specieDao;
	}

	public RuntimeExceptionDao<WatchingSite, Long> getWatchingsiteDao() {
		if (watchingsiteDao == null) {
			watchingsiteDao = getHelper().getRuntimeExceptionDao(WatchingSite.class);
		}
		return watchingsiteDao;
	}

	public RuntimeExceptionDao<FamilyIllustration, Long> getFamilyIllustrationDao() {
		if (familyIllustrationDao == null) {
			familyIllustrationDao = getHelper().getRuntimeExceptionDao(FamilyIllustration.class);
		}
		return familyIllustrationDao;
	}
}

