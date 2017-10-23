package tyarai.com.lom.views;

import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBar;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;

import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;

import tyarai.com.lom.MainActivity;
import tyarai.com.lom.R;
import tyarai.com.lom.manager.CommonManager;
import tyarai.com.lom.model.Menus;
import tyarai.com.lom.views.adapter.pager.ViewPagerAdapter;


/**
 * Created by saimon on 21/10/17.
 */
@EActivity
public class IntroductionActivity extends MainActivity implements ViewPager.OnPageChangeListener
         {

    @Bean(CommonManager.class)
    CommonManager commonManager;

    protected View view;
    private ViewPager intro_images;
    private LinearLayout pager_indicator;
    private int dotsCount;
    private ImageView[] dots;
    private ViewPagerAdapter mAdapter;

    private String[] mTextOriginLemur = {

    };

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
        view = LayoutInflater.from(this).inflate(R.layout.activity_view_pager_demo, frmLayout);

        intro_images = (ViewPager) view.findViewById(R.id.pager_introduction);

        pager_indicator = (LinearLayout) view.findViewById(R.id.viewPagerCountDots);

        try {
            Menus origin = commonManager.getMenusDao().queryBuilder()
                    .where().eq(Menus.NAME_COL, "introduction").queryForFirst();
            if (origin != null) {
                mTextOriginLemur = origin.getContent().split("###########################################################");
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            showLoadingError();
        }

        mAdapter = new ViewPagerAdapter(IntroductionActivity.this, mTextOriginLemur);
        intro_images.setAdapter(mAdapter);
        intro_images.setCurrentItem(0);
        intro_images.setOnPageChangeListener(this);
        setUiPageViewController();

        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setTitle(getString(R.string.introduction));
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

        dots[0].setImageDrawable(ContextCompat.getDrawable(this, R.drawable.selecteditem_dot));
    }


    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

    }

    @Override
    public void onPageSelected(int position) {
        for (int i = 0; i < dotsCount; i++) {
            dots[i].setImageDrawable(ContextCompat.getDrawable(this, R.drawable.nonselecteditem_dot));
        }
        dots[position].setImageDrawable(ContextCompat.getDrawable(this, R.drawable.selecteditem_dot));
    }

    @Override
    public void onPageScrollStateChanged(int state) {

    }



}
