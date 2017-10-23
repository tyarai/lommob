package tyarai.com.lom.views;

import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.Toast;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.ViewById;

import java.util.ArrayList;
import java.util.List;

import tyarai.com.lom.MainActivity;
import tyarai.com.lom.R;
import tyarai.com.lom.manager.CommonManager;
import tyarai.com.lom.model.CommonModel;
import tyarai.com.lom.model.Menus;
import tyarai.com.lom.model.Photograph;
import tyarai.com.lom.model.Specie;
import tyarai.com.lom.views.adapter.pager.ViewPagerAdapter;
import tyarai.com.lom.views.adapter.pager.ViewPagerImageAdapter;
import tyarai.com.lom.views.utils.ViewUtils;


/**
 * Created by saimon on 21/10/17.
 */
@EActivity(R.layout.specie_pager)
public class SpecieDetailActivity extends AppCompatActivity implements ViewPager.OnPageChangeListener {

    public static String EXTRA_SPECIE_ID = "specie_id";

    @Bean(CommonManager.class)
    CommonManager commonManager;

    @ViewById(R.id.specie_pager_introduction)
    ViewPager intro_images;

    @ViewById(R.id.specie_viewPagerCountDots)
    LinearLayout pager_indicator;

    private int dotsCount;
    private ImageView[] dots;
    private ViewPagerImageAdapter mAdapter;

    long lemurId;
    Specie specie;
    String[] lemurPhotographs = {};

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            lemurId = extras.getLong(EXTRA_SPECIE_ID, -1);
        }
    }

    @AfterViews
    void initData() {
        try {
            specie = commonManager.getSpecieDao().queryForId(lemurId);
            ArrayList<Long> photographNids = specie.getSpeciephotographNids();
            if (photographNids != null && !photographNids.isEmpty()) {
                List<Photograph> photographs = commonManager.getPhotographDao().queryBuilder().
                        where().in(CommonModel.NID_COL, photographNids).query();
                if (photographs != null) {
                    lemurPhotographs = new String[photographs.size()];
                    int i =0;
                    for (Photograph photograph : photographs) {
                        lemurPhotographs[i++] = photograph.getPhoto();
                    }
                }
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            ViewUtils.showLoadingError(this);
        }

        mAdapter = new ViewPagerImageAdapter(SpecieDetailActivity.this, lemurPhotographs);
        intro_images.setAdapter(mAdapter);
        intro_images.setCurrentItem(0);
        intro_images.setOnPageChangeListener(this);
        setUiPageViewController();

        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setTitle(specie == null ? getString(R.string.specie): specie.getEnglish());
            actionBar.setDisplayHomeAsUpEnabled(true);
        }
    }

    private void setUiPageViewController() {

        dotsCount = mAdapter.getCount();
        dots = new ImageView[dotsCount];

        for (int i = 0; i < dotsCount; i++) {
            dots[i] = new ImageView(this);
            dots[i].setImageDrawable(ContextCompat.getDrawable(this, R.drawable.nonselecteditem_dot));

            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
            );

            params.setMargins(4, 0, 4, 0);

            pager_indicator.addView(dots[i], params);
        }
        if (dots != null && dots.length > 0) {
            dots[0].setImageDrawable(ContextCompat.getDrawable(this, R.drawable.selecteditem_dot));
        }
    }


    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

    }

    @Override
    public void onPageSelected(int position) {
        for (int i = 0; i < dotsCount; i++) {
            dots[i].setImageDrawable(ContextCompat.getDrawable(this, R.drawable.nonselecteditem_dot));
        }
        if (dots != null && dots.length > 0) {
            dots[position].setImageDrawable(ContextCompat.getDrawable(this, R.drawable.selecteditem_dot));
        }
    }

    @Override
    public void onPageScrollStateChanged(int state) {

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
