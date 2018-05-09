package tyarai.com.lom.service;

/**
 * Created by saimon on 19/04/18.
 */

public interface UserService {

    WsResult login(String username, String password);

    WsResult register(String username, String email, String password);
}
