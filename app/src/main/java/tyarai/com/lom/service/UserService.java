package tyarai.com.lom.service;

import android.util.Log;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.web.client.RestTemplate;

import java.nio.charset.Charset;
import java.text.SimpleDateFormat;
import java.util.Collections;

/**
 * Created by saimon on 19/04/18.
 */

public interface UserService {

    final static String BASE_URL = "https://www.lemursofmadagascar.com/html/lom_endpoint/api/v1/services/";
    final static String LOGIN_URL = "user/login.json";

    WsResult login(String username, String password);


}
