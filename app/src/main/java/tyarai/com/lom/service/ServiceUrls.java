package tyarai.com.lom.service;

import android.util.Log;

import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.web.client.RestTemplate;

import java.nio.charset.Charset;
import java.util.Collections;

/**
 * Created by saimon on 06/05/18.
 */

public class ServiceUrls {

    static String TAG = ServiceUrls.class.getSimpleName();

    static String BASE_URL = "https://www.lemursofmadagascar.com/html/lom_endpoint/api/v1/services/";
    static String LOGIN = "user/login.json";
    static String REGISTER = "user/register.json";
    static String POST_SIGHTING_IMAGE = "file.json";
    static String POST_SIGHTING = "new_sighting";

    static int READ_TIMEOUT = 1000 * 60 *1; // 1mn
    static int CONNECT_TIMEOUT = 1000* 60 * 1; //1mn

    static String getUrl(String path) {
        return BASE_URL + path;
    }

    static RestTemplate getDefaultTemplate(String url) {
        return getDefaultTemplate(url, CONNECT_TIMEOUT, READ_TIMEOUT);
    }

    static RestTemplate getDefaultTemplate(String url, int connectTimeOut, int readTimeOut) {
        RestTemplate restTemplate = new RestTemplate();
        SimpleClientHttpRequestFactory reqFactory = (SimpleClientHttpRequestFactory) restTemplate.getRequestFactory();
        reqFactory.setConnectTimeout(connectTimeOut);
        reqFactory.setReadTimeout(readTimeOut);

        restTemplate.getMessageConverters().add(new StringHttpMessageConverter(Charset.forName("UTF-8")));
        Log.d(TAG, "calling url : " + url);

        HttpHeaders requestHeaders = new HttpHeaders();
        requestHeaders.setAccept(Collections.singletonList(new MediaType("application", "json")));
        return restTemplate;
    }
}
