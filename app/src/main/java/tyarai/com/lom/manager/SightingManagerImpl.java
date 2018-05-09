package tyarai.com.lom.manager;

import android.provider.BaseColumns;

import com.j256.ormlite.stmt.UpdateBuilder;

import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EBean;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import tyarai.com.lom.data.SightingDto;
import tyarai.com.lom.exceptions.DbException;
import tyarai.com.lom.factory.SightingDtoFactory;
import tyarai.com.lom.factory.SightingDtoFactoryImpl;
import tyarai.com.lom.model.CommonModel;
import tyarai.com.lom.model.Sighting;
import tyarai.com.lom.model.Specie;
import tyarai.com.lom.model.WatchingSite;

/**
 * Created by saimon on 13/04/18.
 */
@EBean
public class SightingManagerImpl extends DaoManager implements SightingManager {

    @Bean(SightingDtoFactoryImpl.class)
    SightingDtoFactory sightingDtoFactory;

    @Override
    public List<SightingDto> listSightings() {
        List<SightingDto> res = new ArrayList<>();
        List<Sighting> sightings = getSightingDao().queryForEq(CommonModel.ACTIVE_COL, true);
        if (sightings != null) {
            for (Sighting sighting : sightings) {
                res.add(sightingDtoFactory.sightingToDto(sighting));
            }
        }
        return res;
    }

    @Override
    public long createSighting(SightingDto data) throws DbException {
        try {
            Sighting sighting = new Sighting();
            sighting.setUuid(UUID.randomUUID().toString());
            sighting.setAltitude(data.getAltitude());
            sighting.setLongitude(data.getLongitude());
            sighting.setLatitude(data.getLatitude());
            sighting.setNumberObserved(data.getNumberObserved());
            if (data.getPhoto() != null) {
                sighting.setPhoto(data.getPhoto().getImageRaw());
            }
            sighting.setTitle(data.getTitle());
            sighting.setObservationDate(data.getObservationDate());
            if (data.getSpecieId() != null && data.getSpecieId() > 0)  {
                Specie specie = getSpecieDao().queryForId(data.getSpecieId());
                sighting.setSpecie(specie);
            }
            if (data.getWatchingSiteId() != null && data.getWatchingSiteId() > 0) {
                WatchingSite site = getWatchingsiteDao().queryForId(data.getWatchingSiteId());
                sighting.setWatchingSite(site);
            }
            data.setPostingDate(new Date());
            data.setLastModifiedOnTablet(new Date());
            getSightingDao().create(sighting);
            return sighting.getId();
        }
        catch (Exception e) {
            e.printStackTrace();
            throw new DbException(e);
        }
    }

    @Override
    public void updateSighting(SightingDto data) throws DbException {
        try {
            Sighting sighting = getSightingDao().queryForId(data.getId());
            sighting.setAltitude(data.getAltitude());
            sighting.setLongitude(data.getLongitude());
            sighting.setLatitude(data.getLatitude());
            sighting.setNumberObserved(data.getNumberObserved());
            if (data.getPhoto() != null && data.getPhoto().isPhotoChanged()) {
                sighting.setPhoto(data.getPhoto().getImageRaw());
                sighting.setPhotoFileName(data.getPhoto().getFilename());
                sighting.setPhotoFilePath(data.getPhoto().getPhotoFilePath());
                sighting.setPhotoFileSize(data.getPhoto().getPhotoFileSize());
            }
            sighting.setTitle(data.getTitle());
            sighting.setObservationDate(data.getObservationDate());
            if (data.getSpecieId() != null && data.getSpecieId() > 0)  {
                Specie specie = getSpecieDao().queryForId(data.getSpecieId());
                sighting.setSpecie(specie);
            }
            if (data.getWatchingSiteId() != null && data.getWatchingSiteId() > 0) {
                WatchingSite site = getWatchingsiteDao().queryForId(data.getWatchingSiteId());
                sighting.setWatchingSite(site);
            }
            data.setLastModifiedOnTablet(new Date());
            getSightingDao().update(sighting);
        }
        catch (Exception e) {
            e.printStackTrace();
            throw new DbException(e);
        }
    }

    @Override
    public void disableSighting(long id)  throws DbException {
        try {
            Sighting sighting = getSightingDao().queryForId(id);
            sighting.setActive(false);
            getSightingDao().update(sighting);
        }
        catch (Exception e) {
            e.printStackTrace();
            throw new DbException(e);
        }
    }


}
