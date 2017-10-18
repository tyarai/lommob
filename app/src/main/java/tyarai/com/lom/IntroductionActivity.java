package tyarai.com.lom;

import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.ActionBar;
import android.util.Log;
import android.widget.FrameLayout;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.UiThread;

import tyarai.com.lom.manager.DatabaseManager;
import tyarai.com.lom.manager.ParceCsvDataInterface;
import tyarai.com.lom.manager.ParseCsvDataManager;

/**
 * Created by saimon on 18/10/17.
 */
@EActivity
public class IntroductionActivity extends MainActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        FrameLayout contentFrameLayout = (FrameLayout) findViewById(R.id.main_layout);
        getLayoutInflater().inflate(R.layout.introduction, contentFrameLayout);

        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setTitle(getString(R.string.introduction));
        }

    }


}
