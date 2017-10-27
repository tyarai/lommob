package tyarai.com.lom.views;

import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.view.MenuItem;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.HorizontalScrollView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.ViewById;

import tyarai.com.lom.R;
import tyarai.com.lom.views.adapter.pager.ViewPagerImageAdapter;


/**
 * Created by saimon on 25/10/17.
 */
@EActivity(R.layout.activity_view_pager_demo)
public class FullScreenImagesActivity extends AppCompatActivity implements ViewPagerImageAdapter.InfoDisplayListener {

    public static String EXTRA_IMAGE_URLS = "image_urls";
    public static String EXTRA_IMAGE_DESCS = "image_descs";
    public static String EXTRA_IMAGE_CURRENT_POSITION = "current_position";


    @ViewById(R.id.pager_introduction)
    ViewPager images;

    @ViewById(R.id.viewPagerCountDots)
    LinearLayout image_indicator;

    @ViewById(R.id.horizontal_info_layout)
    HorizontalScrollView infoLayout;

    @ViewById(R.id.image_info)
    TextView txtInfoImage;


    private int dotsCount;
    private ImageView[] dots;
    private ViewPagerImageAdapter imageAdapter;

    int currentPosition = 0;
    String[] illustrations = {};
    String[] descs = {};


    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            currentPosition = extras.getInt(EXTRA_IMAGE_CURRENT_POSITION, 0);
            illustrations = extras.getStringArray(EXTRA_IMAGE_URLS);
            descs = extras.getStringArray(EXTRA_IMAGE_DESCS);
            if (descs == null && illustrations != null && illustrations.length > 0) {
                descs = new String[illustrations.length];
            }
        }
        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setDisplayHomeAsUpEnabled(true);
        }
    }


    @AfterViews
    void initData() {
        imageAdapter = new ViewPagerImageAdapter(FullScreenImagesActivity.this, illustrations,
                descs, false, false);
        imageAdapter.setInfoDisplayListener(this);
        images.setAdapter(imageAdapter);
        images.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                for (int i = 0; i < dotsCount; i++) {
                    dots[i].setImageDrawable(ContextCompat.getDrawable(FullScreenImagesActivity.this, R.drawable.nonselecteditem_dot));
                }
                if (dots != null && dots.length > 0) {
                    dots[position].setImageDrawable(ContextCompat.getDrawable(FullScreenImagesActivity.this, R.drawable.selecteditem_dot));
                }
                if (infoDisplayed && descs != null && position < descs.length) {
                    setInfo(descs[position]);
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

        images.setCurrentItem(currentPosition);
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

    boolean infoDisplayed = false;
    @Override
    public void setInfo(String text) {
        infoDisplayed = true;
        infoLayout.setVisibility(View.VISIBLE);
        txtInfoImage.setText(text);
    }


}
