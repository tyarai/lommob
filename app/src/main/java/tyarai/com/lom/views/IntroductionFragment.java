package tyarai.com.lom.views;

import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.util.Log;
import android.widget.FrameLayout;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.EFragment;
import org.androidannotations.annotations.UiThread;

import tyarai.com.lom.R;
import tyarai.com.lom.manager.CommonManager;
import tyarai.com.lom.manager.DatabaseManager;
import tyarai.com.lom.manager.ParceCsvDataInterface;
import tyarai.com.lom.manager.ParseCsvDataManager;
import tyarai.com.lom.views.BaseFrag;

/**
 * Created by saimon on 18/10/17.
 */
@EFragment(R.layout.introduction)
public class IntroductionFragment extends BaseFrag {

    @Bean(CommonManager.class)
    CommonManager commonManager;

    @AfterViews
    void initDataViews()
    {

    }
}
