package tyarai.com.lom.views;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
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
@EActivity(R.layout.author_detail)
public class AuthorDetailActivity extends AppCompatActivity {

    public static String IMAGE_PATH_EXTRA = "authImagePath";
    public static String DESC_EXTRA = "authDesc";
    public static String NAME_EXTRA = "authName";

    @ViewById(R.id.author_image_header)
    ImageView imageView;

    @ViewById(R.id.author_text)
    TextView descriptionView;

    String authImagePath;
    String authDesc;
    String authName;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            authImagePath = extras.getString(IMAGE_PATH_EXTRA);
            authDesc = extras.getString(DESC_EXTRA);
            authName = extras.getString(NAME_EXTRA);
        }
        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setTitle(TextUtils.isEmpty(authName) ? getString(R.string.author) : authName);
            actionBar.setDisplayHomeAsUpEnabled(true);
        }
        this.overridePendingTransition(R.anim.activity_start_animation,
                R.anim.activity_end_animation);
    }

    @AfterViews
    void initData() {
        final int resourceImage = getResources().getIdentifier(RenameFromDb.renameFNoExtension(authImagePath), "drawable", getPackageName());
        if (resourceImage != 0) {
                Glide.with(this)
                        .load(resourceImage)
                        .into(imageView);
        }
        descriptionView.setText(authDesc);

        imageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(AuthorDetailActivity.this, FullScreenImageActivity.class);
                intent.putExtra(FullScreenImageActivity.NAME, authName);
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
