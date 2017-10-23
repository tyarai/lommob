package tyarai.com.lom.views;

import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.ViewById;

import java.util.ArrayList;
import java.util.List;

import tyarai.com.lom.R;
import tyarai.com.lom.manager.CommonManager;
import tyarai.com.lom.model.CommonModel;
import tyarai.com.lom.model.Photograph;
import tyarai.com.lom.model.Specie;
import tyarai.com.lom.views.adapter.SpecieDetailPagerAdapter;
import tyarai.com.lom.views.adapter.pager.ViewPagerImageAdapter;
import tyarai.com.lom.views.utils.ViewUtils;


/**
 * Created by saimon on 21/10/17.
 */
@EActivity(R.layout.specie_pager)
public class SpecieDetailActivity extends AppCompatActivity {

    public static String EXTRA_SPECIE_ID = "specie_id";

    @Bean(CommonManager.class)
    CommonManager commonManager;

    @ViewById(R.id.specie_pager_images)
    ViewPager intro_images;

    @ViewById(R.id.specie_viewPagerCountDots)
    LinearLayout image_indicator;

    @ViewById(R.id.specie_pager_detail)
    ViewPager pager_detail;

    @ViewById(R.id.specie_detailIndicatorImages)
    LinearLayout detail_indicator;

    private int dotsCount;
    private ImageView[] dots;
    private ViewPagerImageAdapter imageAdapter;
    private SpecieDetailPagerAdapter detailAdapter;

    private int swiperCount;
    private ImageView[] swipers;

    long lemurId;
    Specie specie;
    String[] lemurPhotographs = {};
    String[] lemurDetails = {};

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
            lemurDetails = new String[7];
            lemurDetails[0] = ViewUtils.getNonEmptyString(specie.getOtherEnglish()) + "##"  +
                                ViewUtils.getNonEmptyString(specie.getMalagasy()) + "##"  +
                                ViewUtils.getNonEmptyString(specie.getFrench())  + "##"  +
                                ViewUtils.getNonEmptyString(specie.getGerman());
            lemurDetails[1] = ViewUtils.getNonEmptyString(specie.getIdentification());
            lemurDetails[2] = ViewUtils.getNonEmptyString(specie.getNaturalHistory());
            lemurDetails[3] = ViewUtils.getNonEmptyString(specie.getConservationStatus());
            lemurDetails[4] = ViewUtils.getNonEmptyString(specie.getWhereToSeeIt());
            lemurDetails[5] = ViewUtils.getNonEmptyString(specie.getGeographicRange());
            lemurDetails[6] = ViewUtils.getNonEmptyString(specie.getMap() == null ? "" : specie.getMap().getName());

            setupImageList();
            setupDetailList();
        }
        catch (Exception e) {
            e.printStackTrace();
            ViewUtils.showLoadingError(this);
        }

        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setTitle(specie == null ? getString(R.string.specie): specie.getEnglish());
            actionBar.setDisplayHomeAsUpEnabled(true);
        }

    }

    private void setupDetailList() {

        final int[] drawablesOff = new int[] {
                R.drawable.flag_off, R.drawable.btn_info_lemur_off, R.drawable.btn_natural_history_off,
                R.drawable.btn_status_off, R.drawable.btn_where_to_see_off, R.drawable.btn_geographic_off,
                R.drawable.btn_map_off
        };
        final int[] drawablesOn = new int[] {
                R.drawable.flag_on, R.drawable.btn_info_lemur_on, R.drawable.btn_natural_history_on,
                R.drawable.btn_status_on, R.drawable.btn_where_to_see_on, R.drawable.btn_geographic_on,
                R.drawable.btn_map_on
        };

        detailAdapter = new SpecieDetailPagerAdapter(SpecieDetailActivity.this, lemurDetails);
        pager_detail.setAdapter(detailAdapter);
        pager_detail.setCurrentItem(0);

        swiperCount = lemurDetails.length; //detailAdapter.getCount();
        swipers = new ImageView[swiperCount];

        for (int i = 0; i < swiperCount; i++) {
            swipers[i] = new ImageView(this);
            swipers[i].setImageDrawable(ContextCompat.getDrawable(this, drawablesOff[i]));

            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
            );

            params.setMargins(4, 0, 4, 0);

            final int j = i;
            swipers[i].setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    pager_detail.setCurrentItem(j);
                }
            });

            detail_indicator.addView(swipers[i], params);

        }
        if (swipers != null && swipers.length > 0) {
            swipers[0].setImageDrawable(ContextCompat.getDrawable(this, drawablesOn[0]));
        }

        pager_detail.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                for (int i = 0; i < swiperCount; i++) {
                    swipers[i].setImageDrawable(ContextCompat.getDrawable(SpecieDetailActivity.this, drawablesOff[i]));
                }
                if (swipers != null && swipers.length > 0) {
                    swipers[position].setImageDrawable(ContextCompat.getDrawable(SpecieDetailActivity.this, drawablesOn[position]));
                }
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });
    }




    private void setupImageList() {

        imageAdapter = new ViewPagerImageAdapter(SpecieDetailActivity.this, lemurPhotographs);
        imageAdapter.setTitle(specie.getEnglish());
        intro_images.setAdapter(imageAdapter);
        intro_images.setCurrentItem(0);
        intro_images.setOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                for (int i = 0; i < dotsCount; i++) {
                    dots[i].setImageDrawable(ContextCompat.getDrawable(SpecieDetailActivity.this, R.drawable.nonselecteditem_dot));
                }
                if (dots != null && dots.length > 0) {
                    dots[position].setImageDrawable(ContextCompat.getDrawable(SpecieDetailActivity.this, R.drawable.selecteditem_dot));
                }
            }

            @Override
            public void onPageScrollStateChanged(int state) {

            }
        });

        dotsCount = imageAdapter.getCount();
        dots = new ImageView[dotsCount];

        for (int i = 0; i < dotsCount; i++) {
            dots[i] = new ImageView(this);
            dots[i].setImageDrawable(ContextCompat.getDrawable(this, R.drawable.nonselecteditem_dot));

            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
            );

            params.setMargins(4, 0, 4, 0);

            image_indicator.addView(dots[i], params);
        }
        if (dots != null && dots.length > 0) {
            dots[0].setImageDrawable(ContextCompat.getDrawable(this, R.drawable.selecteditem_dot));
        }
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
