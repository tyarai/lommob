package tyarai.com.lom.views;

import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EFragment;
import org.androidannotations.annotations.ViewById;

import tyarai.com.lom.R;
import tyarai.com.lom.manager.CommonManager;
import tyarai.com.lom.model.Menus;

/**
 * Created by saimon on 21/10/17.
 */
@EFragment(R.layout.about)
public class AboutFragment extends BaseFrag {

    @ViewById(R.id.about_image_cons)
    ImageView conservationImageView;

    @AfterViews
    void initData() {
        Glide.with(this)
                .load(R.drawable.ci_logo)
                .into(conservationImageView);
    }

}
