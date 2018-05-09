package tyarai.com.lom.service;

import org.androidannotations.annotations.EBean;
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

/**
 * Created by saimon on 19/04/18.
 */
@EBean
public class UserServiceImpl implements UserService {

    private static final String TAG = UserServiceImpl.class.getSimpleName();


    @Override
    public WsResult login(String username, String password)
    {
        WsResult res = new WsResult();
        try {
            String url =  ServiceUrls.getUrl(ServiceUrls.LOGIN);
            RestTemplate restTemplate = ServiceUrls.getDefaultTemplate(url);
            HttpHeaders requestHeaders = new HttpHeaders();
            requestHeaders.setAccept(Collections.singletonList(new MediaType("application", "json")));

            Map req_payload = new HashMap();
            req_payload.put("username", username);
            req_payload.put("password", password);

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

    @Override
    public WsResult register(String username, String email, String password)
    {
        WsResult res = new WsResult();
        try {
            String url =  ServiceUrls.getUrl(ServiceUrls.REGISTER);
            RestTemplate restTemplate = ServiceUrls.getDefaultTemplate(url);
            HttpHeaders requestHeaders = new HttpHeaders();
            requestHeaders.setAccept(Collections.singletonList(new MediaType("application", "json")));

            MultiValueMap<String, String> parametersMap = new LinkedMultiValueMap<>();
            parametersMap.add("account[name]", username);
            parametersMap.add("account[mail]", email);
            parametersMap.add("account[pass]", password);

            String responseContent = restTemplate.postForObject(url, parametersMap, String.class);
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
