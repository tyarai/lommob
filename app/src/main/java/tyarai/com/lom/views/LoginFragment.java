package tyarai.com.lom.views;

import android.content.Context;
import android.graphics.Typeface;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.StrictMode;
import android.support.annotation.Nullable;
import android.support.design.widget.Snackbar;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.ObjectMapper;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EFragment;
import org.androidannotations.annotations.ViewById;

import java.io.IOException;
import java.util.Date;
import java.util.List;

import tyarai.com.lom.MainActivity;
import tyarai.com.lom.R;
import tyarai.com.lom.data.Constants;
import tyarai.com.lom.service.UserService;
import tyarai.com.lom.service.UserServiceImpl;
import tyarai.com.lom.service.WsResult;
import tyarai.com.lom.views.utils.SharedUtils;
import tyarai.com.lom.views.utils.ViewUtils;

/**
 * Created by saimon on 18/04/18.
 */
@EFragment(R.layout.login)
public class LoginFragment extends BaseFrag {

    private static final String TAG = LoginFragment.class.getSimpleName();

    @Bean(UserServiceImpl.class)
    UserService userService;

    @ViewById(R.id.lemurs_title)
    TextView txtLemursTitle;

    @ViewById(R.id.lemurs_title_md)
    TextView txtLemursMad;

    @ViewById(R.id.lemurs_title_of)
    TextView txtLemursOf;

    @ViewById(R.id.login_signinbtn)
    Button btnSignIn;

    @ViewById(R.id.login_register)
    Button btnRegister;

    @ViewById(R.id.login_username)
    EditText txtLogin;

    @ViewById(R.id.login_password)
    EditText txtPassword;

    @ViewById(R.id.login_progress)
    ProgressBar progressBar;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        setHasOptionsMenu(true);
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @AfterViews
    void initData() {
        Typeface myTypeface = Typeface.createFromAsset(getActivity().getAssets(), "times_new_roman.ttf");
        txtLemursTitle.setTypeface(myTypeface);
        txtLemursMad.setTypeface(myTypeface);
        txtLemursOf.setTypeface(myTypeface);

        btnRegister.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                RegisterFragment registerFrag = new RegisterFragment_();
                getActivity().getFragmentManager().beginTransaction()
                        .replace(R.id.main_layout, registerFrag, null)
                        .addToBackStack(null)
                        .commit();
            }
        });

        btnSignIn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                signin();
            }
        });

        progressBar.setIndeterminate(true);
    }


    private void signin()
    {
        boolean credentialsOk = true;

        String login = txtLogin.getText().toString();
        String password = txtPassword.getText().toString();

        txtLogin.setError(null);
        txtPassword.setError(null);

        if (TextUtils.isEmpty(login)) {
            txtLogin.setError(getString(R.string.fill_login));
            credentialsOk = false;
        }
        if (TextUtils.isEmpty(password)) {
            txtPassword.setError(getString(R.string.fill_password));
            credentialsOk = false;
        }

        if (credentialsOk) {
            loginWs(login, password);
        }
    }

    String serverMessage = "";
    boolean loggedIn = false;
    Runnable displayMessage = new Runnable() {
        @Override
        public void run() {
            Snackbar.make(btnSignIn, serverMessage, Snackbar.LENGTH_LONG).show();
        }
    };

    Handler insertHandler;
    void loginWs(final String username, final String password) {

        insertHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                progressBar.setVisibility(View.GONE);
                btnSignIn.setEnabled(true);
                btnRegister.setEnabled(true);
                if (loggedIn) {
                    InputMethodManager imm = (InputMethodManager) getActivity().getSystemService(Context.INPUT_METHOD_SERVICE);
                    imm.hideSoftInputFromWindow(txtPassword.getWindowToken(), 0);
                    SightingListFragment sightingListFragment = new SightingListFragment_();
                    MainActivity activity = (MainActivity) getActivity();
                    activity.startFragment(sightingListFragment, null);
                }
                else {
                    getActivity().runOnUiThread(displayMessage);
                }
            }
        };
        serverMessage = getString(R.string.error_occured);
        progressBar.setVisibility(View.VISIBLE);
        btnSignIn.setEnabled(false);
        btnRegister.setEnabled(false);
        new Thread()
        {
            public void run()
            {
                WsResult resp = userService.login(username, password);
                if (resp.isOk() && TextUtils.isEmpty(resp.getMessage())) {
                    Log.d(TAG, "going to option 1");
                    ObjectMapper mapper = new ObjectMapper();
                    LoginRes res = null;
                    try {
                        res = mapper.readValue(resp.getContent(), LoginRes.class);
                        SharedUtils.writeToPref(getActivity(), Constants.SIGHTING_LOGGED_IN, true);
                        SharedUtils.writeToPref(getActivity(), Constants.SIGHTING_LOGGED_IN_TIME, (new Date()).getTime());
                        SharedUtils.writeToPref(getActivity(), Constants.USER_SESSION_ID, res.getSessid());
                        SharedUtils.writeToPref(getActivity(), Constants.USER_SESSION_NAME, res.getSessionName());
                        SharedUtils.writeToPref(getActivity(), Constants.USER_SESSION_TOKEN, res.getToken());
                        loggedIn = true;
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    if (res == null) {
                        Log.d(TAG, "going to option 1-b");
                        try {
                            ErrorWrapper wrapper = mapper.readValue(resp.getMessage(), ErrorWrapper.class);
                            List<String> values = wrapper.getValues();
                            serverMessage = ViewUtils.convertToStringOnePerLine(values);
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                    }
                }
                else {
                    if (!TextUtils.isEmpty(resp.getMessage())) {
                        Log.d(TAG, "going to option 2-b");
                        String message = resp.getMessage();
                        serverMessage = resp.getMessage();
                        if (message != null) {
                            String[] cc = message.split(":");
                            if (cc != null && cc.length > 1) {
                                serverMessage = cc[1];
                            }
                        }
                    }
                }
                insertHandler.sendEmptyMessage(0);
            }
        }.start();
    }
}

class ErrorWrapper {
    List<String> values;
    public List<String> getValues() {
        return values;
    }

    public void setValues(List<String> values) {
        this.values = values;
    }
}


@JsonIgnoreProperties(ignoreUnknown = true)
class LoginRes {
    String sessid;
    @JsonProperty(value="session_name")
    String sessionName;
    String token;

    public String getSessid() {
        return sessid;
    }
    public void setSessid(String sessid) {
        this.sessid = sessid;
    }
    public String getSessionName() {
        return sessionName;
    }
    public void setSessionName(String sessionName) {
        this.sessionName = sessionName;
    }
    public String getToken() {
        return token;
    }
    public void setToken(String token) {
        this.token = token;
    }

    @Override
    public String toString() {
        return "LoginRes{" +
                "sessid='" + sessid + '\'' +
                ", sessionName='" + sessionName + '\'' +
                ", token='" + token + '\'' +
                '}';
    }
}
