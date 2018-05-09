package tyarai.com.lom.factory;

import org.androidannotations.annotations.EBean;

import tyarai.com.lom.data.InfoImageDto;
import tyarai.com.lom.data.SightingDto;
import tyarai.com.lom.model.Sighting;

/**
 * Created by saimon on 17/04/18.
 */

@EBean
public class SightingDtoFactoryImpl implements SightingDtoFactory {

    @Override
    public SightingDto sightingToDto(Sighting sighting) {
        if (sighting != null) {
            SightingDto res = new SightingDto();
            res.setActive(sighting.isActive());
            res.setLastModifiedOnTablet(sighting.getLastModifiedOnTablet());
            res.setId(sighting.getId());
            res.setUuid(sighting.getUuid());
            res.setTitle(sighting.getTitle());
            res.setSynced(sighting.isSynced());
            res.setPostingDate(sighting.getPostingDate());
            if (sighting.getWatchingSite() != null) {
                res.setWatchingSiteTitle(sighting.getWatchingSite().getTitle());
                res.setWatchingSiteId(sighting.getWatchingSite().getId());
            }
            if (sighting.getSpecie() != null) {
                res.setSpecieTrans(sighting.getSpecie().getEnglish());
                res.setSpecieName(sighting.getSpecie().getTitle());
                res.setSpecieId(sighting.getSpecie().getId());
                res.setSpecieNid(sighting.getSpecie().getNid());
            }
            res.setNumberObserved(sighting.getNumberObserved());
            res.setNid(sighting.getNid());
            res.setActive(sighting.isActive());
            res.setLongitude(sighting.getLongitude());
            res.setLatitude(sighting.getLatitude());
            res.setAltitude(sighting.getAltitude());
            res.setObservationDate(sighting.getObservationDate());
            if (sighting.getPhoto() != null) {
                InfoImageDto photo = new InfoImageDto();
                photo.setImageRaw(sighting.getPhoto());
                photo.setPhotoFilePath(sighting.getPhotoFilePath());
                photo.setPhotoFileSize(sighting.getPhotoFileSize());
                res.setPhoto(photo);
            }
            res.setPhotoFid(sighting.getPhotoFid());
            return res;
        }
        return null;
    }
}


