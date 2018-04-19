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
@EFragment(R.layout.termofuse)
public class TermOfUseFragment extends BaseFrag {

    @ViewById(R.id.terms_webview)
    WebView webView;

    @ViewById(R.id.terms_accept)
    Button termsAcceptBtn;

    @ViewById(R.id.terms_decline)
    Button termsDeclineBtn;

    @AfterViews
    void  init() {
        webView.loadUrl("file:///android_asset/termofuse.html");
        termsAcceptBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                SharedUtils.writeToPref(getActivity(), Constants.TERMS_OF_USE_ACCEPTED, true);
                getActivity().getFragmentManager().popBackStackImmediate();
            }
        });
        termsDeclineBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                SharedUtils.writeToPref(getActivity(), Constants.TERMS_OF_USE_ACCEPTED, false);
                getActivity().getFragmentManager().popBackStackImmediate();
            }
        });
    }
}
