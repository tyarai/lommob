package tyarai.com.lom.manager;

import java.util.List;

import tyarai.com.lom.data.SightingDto;
import tyarai.com.lom.exceptions.DbException;

/**
 * Created by saimon on 13/04/18.
 */

public interface SightingManager {

    List<SightingDto> listSightings();

    long createSighting(SightingDto data) throws DbException;

    void updateSighting(SightingDto data) throws DbException;

    void disableSighting(long id)  throws DbException;
}
