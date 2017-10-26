package tyarai.com.lom.views;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.ViewById;

import tyarai.com.lom.R;
import tyarai.com.lom.views.utils.RenameFromDb;

/**
 * Created by saimon on 23/10/17.
 */
@EActivity(R.layout.watching_site_detail)
public class SiteDetailActivity extends AppCompatActivity {

    private static final String TAG = SiteDetailActivity.class.getSimpleName();

    public static String IMAGE_PATH_EXTRA = "siteImagePath";
    public static String DESC_EXTRA = "siteDesc";
    public static String NAME_EXTRA = "siteName";

    @ViewById(R.id.site_image_header)
    ImageView imageView;

    @ViewById(R.id.site_text)
    TextView descriptionView;

    String siteImagePath;
    String siteDesc;
    String siteName;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            siteImagePath = extras.getString(IMAGE_PATH_EXTRA);
            siteDesc = extras.getString(DESC_EXTRA);
            siteName = extras.getString(NAME_EXTRA);
        }
        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setTitle(TextUtils.isEmpty(siteName) ? getString(R.string.site) : siteName);
            actionBar.setDisplayHomeAsUpEnabled(true);
        }
        this.overridePendingTransition(R.anim.activity_start_animation,
                R.anim.activity_end_animation);
    }

    @AfterViews
    void initData() {
        Log.d(TAG, "mapfilename ::: " + siteImagePath);
        final int resourceImage = getResources().getIdentifier(RenameFromDb.renameFNoExtension(siteImagePath), "drawable", getPackageName());
        if (resourceImage != 0) {
                Glide.with(this)
                        .load(resourceImage)
                        .into(imageView);
        }
        descriptionView.setText(siteDesc);

        imageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(SiteDetailActivity.this, FullScreenImageActivity.class);
                intent.putExtra(FullScreenImageActivity.NAME, siteName);
                intent.putExtra(FullScreenImageActivity.IMAGE_URL, resourceImage);
                startActivity(intent);
            }
        });
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
