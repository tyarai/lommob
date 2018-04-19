package tyarai.com.lom.views;

import android.graphics.Typeface;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.design.widget.Snackbar;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.EFragment;
import org.androidannotations.annotations.ViewById;

import tyarai.com.lom.R;
import tyarai.com.lom.data.Constants;
import tyarai.com.lom.views.utils.SharedUtils;

/**
 * Created by saimon on 18/04/18.
 */
@EFragment(R.layout.register)
public class RegisterFragment extends BaseFrag {

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
                Snackbar.make(btnSignUp, "Signup dafuck", Snackbar.LENGTH_SHORT).show();
            }
        });

    }



}
