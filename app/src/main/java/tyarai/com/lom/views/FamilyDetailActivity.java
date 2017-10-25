package tyarai.com.lom.views;

import android.os.Bundle;
import android.support.v4.content.ContextCompat;
import android.support.v4.view.ViewPager;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.view.MenuItem;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.ViewById;

import java.util.ArrayList;
import java.util.List;

import tyarai.com.lom.R;
import tyarai.com.lom.manager.CommonManager;
import tyarai.com.lom.model.CommonModel;
import tyarai.com.lom.model.Family;
import tyarai.com.lom.model.Illustration;
import tyarai.com.lom.views.adapter.pager.ViewPagerImageAdapter;
import tyarai.com.lom.views.utils.ViewUtils;


/**
 * Created by saimon on 25/10/17.
 */
@EActivity(R.layout.family_pager)
public class FamilyDetailActivity extends AppCompatActivity {

    public static String EXTRA_FAMILY_ID = "family_id";

    @Bean(CommonManager.class)
    CommonManager commonManager;

    @ViewById(R.id.family_pager_images)
    ViewPager family_images;

    @ViewById(R.id.family_viewPagerCountDots)
    LinearLayout image_indicator;

    @ViewById(R.id.family_description)
    TextView family_description;

    private int dotsCount;
    private ImageView[] dots;
    private ViewPagerImageAdapter imageAdapter;

    long familyId;
    Family family;
    String[] familyIllustrations = {};
    String[] familyIllustrationsDesc = {};

    @Override
    protected void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);

        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            familyId = extras.getLong(EXTRA_FAMILY_ID, -1);
        }
    }

    @AfterViews
    void initData() {
        try {
            family = commonManager.getFamilyDao().queryForId(familyId);
            ArrayList<Long> illustrationNids = family.getIllustrationNids();
            if (illustrationNids != null && !illustrationNids.isEmpty()) {
                List<Illustration> illustrations = commonManager.getIllustrationDao().queryBuilder().
                        where().in(CommonModel.NID_COL, illustrationNids).query();
                if (illustrations != null) {
                    familyIllustrations = new String[illustrations.size()];
                    familyIllustrationsDesc = new String[illustrations.size()];
                    int i =0;
                    for (Illustration illustration : illustrations) {
                        familyIllustrations[i] = illustration.getTitle();
                        familyIllustrationsDesc[i++] = TextUtils.isEmpty(illustration.getDescription()) ? "" : illustration.getDescription();
                    }
                }
            }
            family_description.setText(family.getDescription());
            setupImageList();
        }
        catch (Exception e) {
            e.printStackTrace();
            ViewUtils.showLoadingError(this);
        }

        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setTitle(family == null ? getString(R.string.specie): family.getFamily());
            actionBar.setDisplayHomeAsUpEnabled(true);
        }
    }



    private void setupImageList() {

        imageAdapter = new ViewPagerImageAdapter(FamilyDetailActivity.this, familyIllustrations,
                familyIllustrationsDesc, true, true);
        imageAdapter.setTitle(family.getFamily());
        family_images.setAdapter(imageAdapter);
        family_images.setCurrentItem(0);
        family_images.addOnPageChangeListener(new ViewPager.OnPageChangeListener() {
            @Override
            public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

            }

            @Override
            public void onPageSelected(int position) {
                for (int i = 0; i < dotsCount; i++) {
                    dots[i].setImageDrawable(ContextCompat.getDrawable(FamilyDetailActivity.this, R.drawable.nonselecteditem_dot));
                }
                if (dots != null && dots.length > 0) {
                    dots[position].setImageDrawable(ContextCompat.getDrawable(FamilyDetailActivity.this, R.drawable.selecteditem_dot));
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
