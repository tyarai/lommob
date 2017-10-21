package tyarai.com.lom.views;

import android.app.Fragment;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v7.app.ActionBar;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.widget.FrameLayout;
import android.widget.TextView;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.EFragment;
import org.androidannotations.annotations.ViewById;

import tyarai.com.lom.MainActivity;
import tyarai.com.lom.R;
import tyarai.com.lom.manager.CommonManager;
import tyarai.com.lom.model.Menus;

/**
 * Created by saimon on 18/10/17.
 */
@EFragment(R.layout.origin)
public class OriginOfLemursFragment extends BaseFrag {

    @Bean(CommonManager.class)
    CommonManager commonManager;

    @ViewById(R.id.origin_lemur_txt)
    TextView txtOrigin;

    @AfterViews
    void initDataViews()
    {
        try {
            Menus origin = commonManager.getMenusDao().queryBuilder()
                    .where().eq(Menus.NAME_COL, "origin").queryForFirst();
            if (origin != null) {
                txtOrigin.setText(origin.getContent());
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            showLoadingError();
        }
    }


}
