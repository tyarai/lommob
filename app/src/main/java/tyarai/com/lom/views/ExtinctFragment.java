package tyarai.com.lom.views;

import android.widget.TextView;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EFragment;
import org.androidannotations.annotations.ViewById;
import org.w3c.dom.Text;

import tyarai.com.lom.R;
import tyarai.com.lom.manager.CommonManager;
import tyarai.com.lom.model.Menus;

/**
 * Created by saimon on 21/10/17.
 */
@EFragment(R.layout.display_text)
public class ExtinctFragment extends BaseFrag {

    @Bean(CommonManager.class)
    CommonManager commonManager;

    @ViewById(R.id.display_me)
    TextView txtContent;


    @AfterViews
    void initData() {
        try {
            Menus origin = commonManager.getMenusDao().queryBuilder()
                    .where().eq(Menus.NAME_COL, "extinctlemurs").queryForFirst();
            if (origin != null) {
                txtContent.setText(origin.getContent());
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            showLoadingError();
        }
    }
}
