package tyarai.com.lom.service;

import android.util.Log;

import org.androidannotations.annotations.EBean;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;

import java.nio.charset.Charset;
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
            RestTemplate restTemplate = new RestTemplate();
            SimpleClientHttpRequestFactory reqFactory = (SimpleClientHttpRequestFactory) restTemplate.getRequestFactory();
            reqFactory.setConnectTimeout(1000 * 60 * 1); // 1mn
            reqFactory.setReadTimeout(1000 * 60 * 21);   // 1mn

            restTemplate.getMessageConverters().add(new StringHttpMessageConverter(Charset.forName("UTF-8")));

            String url = UserService.BASE_URL + UserService.LOGIN_URL;
            Log.d(TAG, "ws login url : " + url);

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
            RestTemplate restTemplate = new RestTemplate();
            SimpleClientHttpRequestFactory reqFactory = (SimpleClientHttpRequestFactory) restTemplate.getRequestFactory();
            reqFactory.setConnectTimeout(1000 * 60 * 1); // 1mn
            reqFactory.setReadTimeout(1000 * 60 * 21);   // 1mn

            restTemplate.getMessageConverters().add(new StringHttpMessageConverter(Charset.forName("UTF-8")));

            String url = UserService.BASE_URL + UserService.REGISTER_URL;
            Log.d(TAG, "ws register url : " + url);

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
