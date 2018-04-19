package tyarai.com.lom.views;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.support.annotation.Nullable;
import android.support.design.widget.Snackbar;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ProgressBar;

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
@EFragment(R.layout.register)
public class RegisterFragment extends BaseFrag {

    private static final String TAG = RegisterFragment.class.getSimpleName();

    @Bean(UserServiceImpl.class)
    UserService userService;

    @ViewById(R.id.register_username)
    EditText txtUsername;

    @ViewById(R.id.register_email)
    EditText txtEmail;

    @ViewById(R.id.register_password1)
    EditText txtPassword1;

    @ViewById(R.id.register_password2)
    EditText txtPassword2;

    @ViewById(R.id.register_signup)
    Button btnSignUp;

    @ViewById(R.id.register_term_ofuse)
    Button btnTermOfUse;

    @ViewById(R.id.register_privacy_policy)
    Button btnPrivacyPolicy;

    @ViewById(R.id.register_cancel)
    Button btnCancel;

    @ViewById(R.id.register_progress)
    ProgressBar progressBar;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        setHasOptionsMenu(true);
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @AfterViews
    void initData() {

        btnCancel.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                getActivity().getFragmentManager().popBackStackImmediate();
            }
        });

        btnTermOfUse.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                TermOfUseFragment termOfUseFragment = new TermOfUseFragment_();
                getActivity().getFragmentManager().beginTransaction()
                        .replace(R.id.main_layout, termOfUseFragment, null)
                        .addToBackStack(null)
                        .commit();
            }
        });

        btnPrivacyPolicy.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                PrivacyPolicyFragment privacyPolicyFragment = new PrivacyPolicyFragment_();
                getActivity().getFragmentManager().beginTransaction()
                        .replace(R.id.main_layout, privacyPolicyFragment, null)
                        .addToBackStack(null)
                        .commit();
            }
        });

        btnSignUp.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                boolean termsAccepted = SharedUtils.getBooleanPref(getActivity(), Constants.TERMS_OF_USE_ACCEPTED);
                if (!termsAccepted) {
                    Snackbar.make(btnSignUp, getString(R.string.read_terms_of_use), Snackbar.LENGTH_SHORT).show();
                    return;
                }
                boolean policyRead = SharedUtils.getBooleanPref(getActivity(), Constants.POLICY_READ);
                if (!policyRead) {
                    Snackbar.make(btnSignUp, getString(R.string.read_policy), Snackbar.LENGTH_SHORT).show();
                    return;
                }
                if (fieldsOK()) {
                    registerWs(txtUsername.getText().toString(),
                            txtEmail.getText().toString(), txtPassword1.getText().toString());
                }
            }
        });

        progressBar.setIndeterminate(true);

    }

    boolean fieldsOK() {
        boolean valid = true;
        txtUsername.setError(null);
        txtEmail.setError(null);
        txtPassword1.setError(null);
        txtPassword2.setError(null);
        if (TextUtils.isEmpty(txtUsername.getText().toString())) {
            txtUsername.setError(getString(R.string.username_required));
            valid = false;
        }
        if (TextUtils.isEmpty(txtEmail.getText().toString())) {
            txtEmail.setError(getString(R.string.email_required));
            valid = false;
        }
        if (TextUtils.isEmpty(txtPassword1.getText().toString())) {
            txtPassword1.setError(getString(R.string.password1_required));
            valid = false;
        }
        if (TextUtils.isEmpty(txtPassword2.getText().toString())) {
            txtPassword2.setError(getString(R.string.password2_required));
            valid = false;
        }
        if (valid) {
            if (!txtPassword1.getText().toString().equals(txtPassword2.getText().toString())) {
                txtPassword1.setError(getString(R.string.password_mismatch));
                valid = false;
            }
        }
        return valid;
    }

    String serverMessage = "";
    boolean registered = false;
    Runnable displayMessage = new Runnable() {
        @Override
        public void run() {
            Snackbar.make(btnSignUp, serverMessage, Snackbar.LENGTH_LONG).show();
        }
    };

    Handler insertHandler;
    RegisterRes res = null;
    void registerWs(final String username, final String email, final String password) {

        insertHandler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                progressBar.setVisibility(View.GONE);
                if (registered) {
                    new AlertDialog.Builder(getActivity())
                            .setMessage(getString(R.string.user_registered))
                            .setTitle(getString(R.string.registration))
                            .setPositiveButton(getString(R.string.ok), new DialogInterface.OnClickListener() {
                                @Override
                                public void onClick(DialogInterface dialogInterface, int i) {
                                    // add save data in fucking je sais pas quoi
                                    getActivity().getFragmentManager().popBackStackImmediate();
                                }
                            })
                            .create()
                            .show();
                }
                else {
                    getActivity().runOnUiThread(displayMessage);
                    if (displayMessage.equals(getString(R.string.register_failed)) && res != null) {
                        if (!TextUtils.isEmpty(res.getNameError())) {
                            txtUsername.setError(res.getNameError());
                        }
                        if (!TextUtils.isEmpty(res.getMailError())) {
                            txtEmail.setError(res.getMailError());
                        }
                        if (!TextUtils.isEmpty(res.getPasswordError())) {
                            txtPassword1.setError(res.getPasswordError());
                        }
                    }
                }
            }
        };
        serverMessage = getString(R.string.error_occured);
        progressBar.setVisibility(View.VISIBLE);
        new Thread()
        {
            public void run()
            {
                WsResult resp = userService.register(username, email, password);
                Log.d(TAG, "resppp : " + resp);
                if (resp.isOk() && TextUtils.isEmpty(resp.getMessage())) {
                    Log.d(TAG, "going to option 1");
                    ObjectMapper mapper = new ObjectMapper();
                    ResultRes rest = null;
                    try {
                        rest = mapper.readValue(resp.getContent(), ResultRes.class);
                        Log.d(TAG, "restttt : " + rest);
                        registered = true;
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                    if (rest == null) {
                        try {
                            res = mapper.readValue(resp.getContent(), RegisterRes.class);
                            serverMessage = getString(R.string.register_failed);
                            Log.d(TAG, "ressss : " + res);
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

@JsonIgnoreProperties(ignoreUnknown = true)
class ResultRes {

    String uid;
    String uri;

    public String getUid() {
        return uid;
    }
    public void setUid(String uid) {
        this.uid = uid;
    }
    public String getUri() {
        return uri;
    }
    public void setUri(String uri) {
        this.uri = uri;
    }

    @Override
    public String toString() {
        return "ResultRes{" +
                "uid='" + uid + '\'' +
                ", uri='" + uri + '\'' +
                '}';
    }
}

@JsonIgnoreProperties(ignoreUnknown = true)
class RegisterRes
{
    @JsonProperty(value = "name")
    String nameError;
    @JsonProperty(value = "mail")
    String mailError;
    @JsonProperty(value = "pass")
    String passwordError;

    public String getNameError() {
        return nameError;
    }
    public void setNameError(String nameError) {
        this.nameError = nameError;
    }
    public String getMailError() {
        return mailError;
    }
    public void setMailError(String mailError) {
        this.mailError = mailError;
    }
    public String getPasswordError() {
        return passwordError;
    }
    public void setPasswordError(String passwordError) {
        this.passwordError = passwordError;
    }

    @Override
    public String toString() {
        return "RegisterRes{" +
                "nameError='" + nameError + '\'' +
                ", mailError='" + mailError + '\'' +
                ", passwordError='" + passwordError + '\'' +
                '}';
    }
}
