package tyarai.com.lom.service;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import tyarai.com.lom.data.SightingDto;
import tyarai.com.lom.views.utils.ViewUtils;

/**
 * Created by saimon on 06/05/18.
 */

public class SightingServiceImpl implements SightingService {

    public static String TAG = SightingServiceImpl.class.getSimpleName();

    @Override
    public WsResult postImage(String b64File, String filename, int filesize) {
        WsResult res = new WsResult();
        try {
            String url =  ServiceUrls.getUrl(ServiceUrls.POST_SIGHTING_IMAGE);
            RestTemplate restTemplate = ServiceUrls.getDefaultTemplate(url);
            HttpHeaders requestHeaders = new HttpHeaders();
            requestHeaders.setAccept(Collections.singletonList(new MediaType("application", "json")));

            MultiValueMap<String, String> req_payload = new LinkedMultiValueMap<>();
            req_payload.add("file[file]", b64File);
            req_payload.add("file[filename]", filename);
            req_payload.add("file[filepath]", "public://" + filename );
            req_payload.add("file[filesize]", String.valueOf(filesize));

            String responseContent = restTemplate.postForObject(url, req_payload, String.class);
            res.setOk(true);
            res.setContent(responseContent);
        }
        catch (HttpClientErrorException e) {
            e.printStackTrace();
            res.setMessage(e.getMessage());
        }
        return res;
    }

    @Override
    public WsResult postSighting(SightingDto sighting, String sessionId, String token) {
        WsResult res = new WsResult();
        try {
            String url =  ServiceUrls.getUrl(ServiceUrls.POST_SIGHTING);
            RestTemplate restTemplate = ServiceUrls.getDefaultTemplate(url);
            HttpHeaders requestHeaders = new HttpHeaders();
            requestHeaders.setAccept(Collections.singletonList(
                    new MediaType("application", "json")
            ));
            requestHeaders.set("Content-Type", "application/x-www-form-urlencoded");
            requestHeaders.set("X-CSRF-Token", token);
            requestHeaders.set("Cookie: session_name", sessionId);
            /*
            title=<title>&uuid=<uuid>&uid=<uid>&status=1&field_uuid=<uuid>&body=<title>&field_place_name=<place_name>
            &field_date=<date_au_format_yyyy-MM-dd>&field_associated_species=<species_nid>
            &field_lat=<latitude_float>&field_long=<longitude_float>&field_altitude=<altitude_float>
            &field_is_local=<isLocal_integer>&field_is_synced=<isSynced_integer>
            &field_count=<count_integer>&field_photo=<fid>&field_place_name_reference=<place_name_nid>
             */
            Map req_payload = new HashMap();
            req_payload.put("title", sighting.getTitle());
            req_payload.put("uuid", sighting.getUuid());
            req_payload.put("status", sighting.isActive());
            req_payload.put("field_uuid", sighting.getUuid());
            req_payload.put("field_place_name", sighting.getWatchingSiteTitle());
            req_payload.put("field_date", sighting.getPostingDate() == null ? "" :
                    ViewUtils.dateFormatterShort.format(sighting.getPostingDate()));
            req_payload.put("field_associated_species", sighting.getSpecieNid());
            req_payload.put("field_lat", sighting.getLatitude());
            req_payload.put("field_long", sighting.getLongitude());
            req_payload.put("field_altitude", sighting.getAltitude());
            req_payload.put("field_is_local", !sighting.isSynced());
            req_payload.put("field_is_synced", sighting.isSynced());
            req_payload.put("field_count", sighting.getNumberObserved());
            req_payload.put("field_photo", sighting.isSynced());

            HttpEntity<?> requestEntity = new HttpEntity<>(req_payload, requestHeaders);
            String responseContent = restTemplate.postForObject(url, requestEntity, String.class);
            res.setOk(true);
            res.setContent(responseContent);
        }
        catch (HttpClientErrorException e) {
            e.printStackTrace();
            res.setMessage(e.getMessage());
        }
        return res;
    }
}

class PostImageRes {
    String fid;

    @Override
    public String toString() {
        return "PostImageRes{" +
                "fid='" + fid + '\'' +
                '}';
    }
}

