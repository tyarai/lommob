package tyarai.com.lom.views;

import android.app.FragmentManager;
import android.app.FragmentTransaction;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.view.MenuItem;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.EActivity;

import tyarai.com.lom.R;

/**
 * Created by saimon on 23/10/17.
 */
@EActivity(R.layout.fragment_container)
public class SiteListActivity extends AppCompatActivity {


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FragmentManager fm = getFragmentManager();
        FragmentTransaction fragmentTransaction = fm.beginTransaction();
        fragmentTransaction.replace(R.id.frameLayout, new WatchingSiteListFragment_());
        fragmentTransaction.commit();

        Bundle extras = getIntent().getExtras();
        if (extras != null) {
//            siteImagePath = extras.getString(IMAGE_PATH_EXTRA);
        }
        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setTitle(getString(R.string.choose_site));
            actionBar.setDisplayHomeAsUpEnabled(true);
        }
        this.overridePendingTransition(R.anim.activity_start_animation,
                R.anim.activity_end_animation);
    }

    @AfterViews
    void initData() {

    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        switch (id) {
            case android.R.id.home:
                onBackPressed();
                return true;
        }
        return super.onOptionsItemSelected(item);
    }
}
