package tyarai.com.lom.service;

/**
 * Created by saimon on 19/04/18.
 */

public class WsResult {

    int httpCode = 200;

    String message = "";

    String content = "";

    boolean ok = false;

    public int getHttpCode() {
        return httpCode;
    }

    public void setHttpCode(int httpCode) {
        this.httpCode = httpCode;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public boolean isOk() {
        return ok;
    }

    public void setOk(boolean ok) {
        this.ok = ok;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    @Override
    public String toString() {
        return "WsResult{" +
                "httpCode=" + httpCode +
                ", message='" + message + '\'' +
                ", content='" + content + '\'' +
                ", ok=" + ok +
                '}';
    }
}
