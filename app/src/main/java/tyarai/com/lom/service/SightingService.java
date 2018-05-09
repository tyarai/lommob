package tyarai.com.lom.service;

import tyarai.com.lom.data.SightingDto;

/**
 * Created by saimon on 06/05/18.
 */

public interface SightingService {

    WsResult postImage(String b64File, String filename, int filesize);

    WsResult postSighting(SightingDto sighting, String sessionId, String token);
}
