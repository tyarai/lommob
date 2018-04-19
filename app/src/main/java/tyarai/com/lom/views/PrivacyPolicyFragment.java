package tyarai.com.lom.views;

import android.view.View;
import android.webkit.WebView;
import android.widget.Button;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.EFragment;
import org.androidannotations.annotations.ViewById;

import tyarai.com.lom.R;
import tyarai.com.lom.data.Constants;
import tyarai.com.lom.views.utils.SharedUtils;

/**
 * Created by saimon on 19/04/18.
 */
@EFragment(R.layout.privacy_policy)
public class PrivacyPolicyFragment extends BaseFrag {

    @ViewById(R.id.policy_webview)
    WebView webView;

    @ViewById(R.id.privacy_read)
    Button privacyReadBtn;

    @AfterViews
    void  init() {
        webView.loadUrl("file:///android_asset/termofuse.html");
        privacyReadBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                SharedUtils.writeToPref(getActivity(), Constants.POLICY_READ, true);
                getActivity().getFragmentManager().popBackStackImmediate();
            }
        });
    }
}
