package tyarai.com.lom.views;

import android.os.Bundle;
import android.support.v4.view.ViewPager;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageButton;
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
 * This code is not for public use. please give proper reference for code you have used.
 * Please give credits or add link to www.androprogrammer.com from your site.
 */
@EActivity
public class OriginActivity extends MainActivity implements ViewPager.OnPageChangeListener
         { //View.OnClickListener

    @Bean(CommonManager.class)
    CommonManager commonManager;

    protected View view;
//    private ImageButton btnNext, btnFinish;
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
//        btnNext = (ImageButton) view.findViewById(R.id.btn_next);
//        btnFinish = (ImageButton) view.findViewById(R.id.btn_finish);

        pager_indicator = (LinearLayout) view.findViewById(R.id.viewPagerCountDots);

//        btnNext.setOnClickListener(this);
//        btnFinish.setOnClickListener(this);

        try {
            Menus origin = commonManager.getMenusDao().queryBuilder()
                    .where().eq(Menus.NAME_COL, "origin").queryForFirst();
            if (origin != null) {
                mTextOriginLemur = origin.getContent().split("###");
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            showLoadingError();
        }

        mAdapter = new ViewPagerAdapter(OriginActivity.this, mTextOriginLemur);
        intro_images.setAdapter(mAdapter);
        intro_images.setCurrentItem(0);
        intro_images.setOnPageChangeListener(this);
        setUiPageViewController();
    }


    private void setUiPageViewController() {

        dotsCount = mAdapter.getCount();
        dots = new ImageView[dotsCount];

        for (int i = 0; i < dotsCount; i++) {
            dots[i] = new ImageView(this);
            dots[i].setImageDrawable(getResources().getDrawable(R.drawable.nonselecteditem_dot));

            LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
                    LinearLayout.LayoutParams.WRAP_CONTENT,
                    LinearLayout.LayoutParams.WRAP_CONTENT
            );

            params.setMargins(4, 0, 4, 0);

            pager_indicator.addView(dots[i], params);
        }

        dots[0].setImageDrawable(getResources().getDrawable(R.drawable.selecteditem_dot));
    }


//    @Override
//    public void onClick(View v) {
//        switch (v.getId()) {
//            case R.id.btn_next:
//                intro_images.setCurrentItem((intro_images.getCurrentItem() < dotsCount)
//                        ? intro_images.getCurrentItem() + 1 : 0);
//                break;
//
//            case R.id.btn_finish:
//                finish();
//                break;
//        }
//    }

    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

    }

    @Override
    public void onPageSelected(int position) {
        for (int i = 0; i < dotsCount; i++) {
            dots[i].setImageDrawable(getResources().getDrawable(R.drawable.nonselecteditem_dot));
        }

        dots[position].setImageDrawable(getResources().getDrawable(R.drawable.selecteditem_dot));

//        if (position + 1 == dotsCount) {
//            btnNext.setVisibility(View.GONE);
//            btnFinish.setVisibility(View.VISIBLE);
//        } else {
//            btnNext.setVisibility(View.VISIBLE);
//            btnFinish.setVisibility(View.GONE);
//        }
    }

    @Override
    public void onPageScrollStateChanged(int state) {

    }



}
