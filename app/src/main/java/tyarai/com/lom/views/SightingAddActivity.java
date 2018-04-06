package tyarai.com.lom.views;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.util.Log;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
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
@EActivity(R.layout.sightings_add)
public class SightingAddActivity extends AppCompatActivity {

    private static final String TAG = SightingAddActivity.class.getSimpleName();
    private static final int REQUEST_SPECIE = 10;
    private static final int REQUEST_SITE = 20;

//    public static String IMAGE_PATH_EXTRA = "siteImagePath";
//    public static String DESC_EXTRA = "siteDesc";
//    public static String NAME_EXTRA = "siteName";

//    @ViewById(R.id.site_image_header)
//    ImageView imageView;
//
//    @ViewById(R.id.site_text)
//    TextView descriptionView;

    @ViewById(R.id.sighting_choosespecies_btn)
    Button selectSpecieBtn;

    @ViewById(R.id.sighting_species_title)
    TextView specieTitle;
    @ViewById(R.id.sighting_species_trans)
    TextView specieTrans;
    Long specieId = -1L;


    String siteImagePath;
    String siteDesc;
    String siteName;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Bundle extras = getIntent().getExtras();
        if (extras != null) {
//            siteImagePath = extras.getString(IMAGE_PATH_EXTRA);
//            siteDesc = extras.getString(DESC_EXTRA);
//            siteName = extras.getString(NAME_EXTRA);
        }
        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setTitle(TextUtils.isEmpty(siteName) ? getString(R.string.sighting_add) : siteName);
            actionBar.setDisplayHomeAsUpEnabled(true);
        }
        this.overridePendingTransition(R.anim.activity_start_animation,
                R.anim.activity_end_animation);
    }

    @AfterViews
    void initData() {
//        Log.d(TAG, "mapfilename ::: " + siteImagePath);
//        final int resourceImage = getResources().getIdentifier(RenameFromDb.renameFNoExtension(siteImagePath), "drawable", getPackageName());
//        if (resourceImage != 0) {
//                Glide.with(this)
//                        .load(resourceImage)
//                        .into(imageView);
//        }
//        descriptionView.setText(siteDesc);
//
//        imageView.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                Intent intent = new Intent(SightingAddActivity.this, FullScreenImageActivity.class);
//                intent.putExtra(FullScreenImageActivity.NAME, siteName);
//                intent.putExtra(FullScreenImageActivity.IMAGE_URL, resourceImage);
//                startActivity(intent);
//            }
//        });

        selectSpecieBtn.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(SightingAddActivity.this, SpecieListActivity_.class);
                startActivityForResult(intent, REQUEST_SPECIE);
            }
        });
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch(requestCode) {
            case (REQUEST_SPECIE) : {
                if (resultCode == Activity.RESULT_OK) {
                    specieId = data.getLongExtra(SpeciesListFragment.SPECIE_ID, -1);
                    String returnTitle = data.getStringExtra(SpeciesListFragment.SPECIE_TITLE);
                    specieTitle.setVisibility(View.VISIBLE);
                    specieTitle.setText(returnTitle);
                    String returnTrans = data.getStringExtra(SpeciesListFragment.SPECIE_TRANS);
                    specieTrans.setText(returnTrans);
                    specieTrans.setVisibility(View.VISIBLE);
                }
                else if (resultCode == SpeciesListFragment.RESULT_BOO) {
                    specieId = -1L;
                    specieTitle.setText("");
                    specieTrans.setText("");
                }
                break;
            }
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
