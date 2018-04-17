package tyarai.com.lom.factory;

import tyarai.com.lom.data.SightingDto;
import tyarai.com.lom.model.Sighting;

/**
 * Created by saimon on 17/04/18.
 */

public interface SightingDtoFactory {
    SightingDto sightingToDto(Sighting sighting);
}
