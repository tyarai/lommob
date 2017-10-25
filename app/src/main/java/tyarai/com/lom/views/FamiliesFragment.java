package tyarai.com.lom.views;

import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EFragment;
import org.androidannotations.annotations.ViewById;

import java.util.List;

import tyarai.com.lom.R;
import tyarai.com.lom.manager.CommonManager;
import tyarai.com.lom.model.Author;
import tyarai.com.lom.model.CommonModel;
import tyarai.com.lom.model.Family;
import tyarai.com.lom.model.Illustration;
import tyarai.com.lom.views.adapter.AuthorsAdapter;
import tyarai.com.lom.views.adapter.FamiliesAdapter;

/**
 * Created by saimon on 25/10/17.
 */
@EFragment(R.layout.families_main)
public class FamiliesFragment extends BaseFrag {

    private static final String TAG = FamiliesFragment.class.getSimpleName();

    @Bean(CommonManager.class)
    CommonManager commonManager;

    @ViewById(R.id.families_recyclerView)
    RecyclerView recyclerView;
    List<Family> familiesList;

    @ViewById(R.id.no_families)
    TextView txtNoFamily;

    @ViewById(R.id.families_swipeContainer)
    SwipeRefreshLayout swipeContainer;

    ProgressBar progressBar;

    @AfterViews
    void initData(){

        swipeContainer.setColorSchemeResources(android.R.color.holo_orange_dark);
        swipeContainer.setOnRefreshListener(new SwipeRefreshLayout.OnRefreshListener() {
            @Override
            public void onRefresh() {
                loadData();
            }
        });

        progressBar = new ProgressBar(getActivity(), null, android.R.attr.progressBarStyleSmall);
        recyclerView.setLayoutManager(new LinearLayoutManager(getActivity()));
        recyclerView.smoothScrollToPosition(0);
        loadData();
    }


    private void loadData() {

        try {

            familiesList = commonManager.getFamilyDao().queryForEq(CommonModel.ACTIVE_COL, true);
            if (familiesList != null) {
                for (Family family : familiesList) {
                    if (family.getIllustrationNids() != null && !family.getIllustrationNids().isEmpty()) {
                        family.setIllustrations(commonManager.getIllustrationDao()
                                .queryBuilder()
                                .where().in(CommonModel.NID_COL, family.getIllustrationNids())
                                .query()
                        );
                    }
                }
            }
            recyclerView.setAdapter(new FamiliesAdapter(getActivity(), familiesList));
            recyclerView.smoothScrollToPosition(0);
            swipeContainer.setRefreshing(false);
            progressBar.setVisibility(View.INVISIBLE);

            if (familiesList.isEmpty()) {
                txtNoFamily.setVisibility(View.VISIBLE);
                recyclerView.setVisibility(View.GONE);
            }

        } catch (Exception e) {
            Log.d(TAG, e.getMessage());
            showLoadingError();
        }
    }
}
