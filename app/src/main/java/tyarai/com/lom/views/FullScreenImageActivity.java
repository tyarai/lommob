package tyarai.com.lom.views;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.view.MenuItem;
import android.widget.ImageView;

import com.bumptech.glide.Glide;

import tyarai.com.lom.R;

/**
 * Created by saimon on 23/10/17.
 */

public class FullScreenImageActivity extends AppCompatActivity {

    public static final java.lang.String NAME = "name";
    public static final java.lang.String IMAGE_URL = "image_url";

    String name;
    int imageDrawableId;

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.full_screen_image);
        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            name = extras.getString(NAME, "");
            imageDrawableId = extras.getInt(IMAGE_URL, -1);
        }
        ActionBar bar = getSupportActionBar();
        if (bar != null) {
            bar.setTitle(name);
            bar.setDisplayHomeAsUpEnabled(true);
        }
        ImageView imageView = (ImageView) findViewById(R.id.fs_image);
        if (imageDrawableId != -1) {
            Glide.with(this)
                    .load(imageDrawableId)
                    .into(imageView);
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
