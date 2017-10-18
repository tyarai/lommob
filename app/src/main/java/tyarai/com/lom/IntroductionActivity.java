package tyarai.com.lom;

import android.os.Bundle;
import android.support.constraint.ConstraintLayout;
import android.support.v7.app.ActionBar;
import android.widget.FrameLayout;

/**
 * Created by saimon on 18/10/17.
 */

public class IntroductionActivity extends MainActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

        FrameLayout contentFrameLayout = (FrameLayout) findViewById(R.id.main_layout);
        getLayoutInflater().inflate(R.layout.introduction, contentFrameLayout);

        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setTitle(getString(R.string.introduction));

    }
}
}
