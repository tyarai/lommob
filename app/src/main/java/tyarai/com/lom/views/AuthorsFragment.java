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
import tyarai.com.lom.views.adapter.AuthorsAdapter;

/**
 * Created by saimon on 21/10/17.
 */
@EFragment(R.layout.author_main)
public class AuthorsFragment extends BaseFrag {

    private static final String TAG = AuthorsFragment.class.getSimpleName();

    @Bean(CommonManager.class)
    CommonManager commonManager;

    //https://guides.codepath.com/android/Implementing-Pull-to-Refresh-Guide
    @ViewById(R.id.authors_recyclerView)
    RecyclerView recyclerView;
    List<Author> authorsList;

    @ViewById(R.id.no_authors)
    TextView txtNoAuthors;

    @ViewById(R.id.swipeContainer)
    SwipeRefreshLayout swipeContainer;

    ProgressBar progressBar;


    @AfterViews
    void initData(){

        // Configure the refreshing colors
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

            authorsList = commonManager.getAuthorDao().queryForEq(CommonModel.ACTIVE_COL, true);
            recyclerView.setAdapter(new AuthorsAdapter(getActivity(), authorsList));
            recyclerView.smoothScrollToPosition(0);
            //Toast.makeText(MainActivity.this, speciesList.toString(), Toast.LENGTH_SHORT).show();
            swipeContainer.setRefreshing(false);
            progressBar.setVisibility(View.INVISIBLE);

            if (authorsList.isEmpty()) {
                txtNoAuthors.setVisibility(View.VISIBLE);
            }

        } catch (Exception e) {
            Log.d(TAG, e.getMessage());
            showLoadingError();
        }
    }
}
