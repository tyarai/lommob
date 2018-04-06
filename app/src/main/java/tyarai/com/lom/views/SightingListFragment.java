package tyarai.com.lom.views;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.view.MenuItemCompat;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.SearchView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EFragment;
import org.androidannotations.annotations.ViewById;
import org.w3c.dom.Text;

import java.util.List;

import tyarai.com.lom.BuildConfig;
import tyarai.com.lom.R;
import tyarai.com.lom.manager.CommonManager;
import tyarai.com.lom.model.CommonModel;
import tyarai.com.lom.model.Family;
import tyarai.com.lom.model.Sighting;
import tyarai.com.lom.views.adapter.FamiliesAdapter;
import tyarai.com.lom.views.adapter.SightingListAdapter;

/**
 * Created by saimon on 25/10/17.
 */
@EFragment(R.layout.sightings_main)
public class SightingListFragment extends BaseFrag implements SearchView.OnQueryTextListener {

    public static final String FRAGMENT_TAG =
            BuildConfig.APPLICATION_ID + ".SightingListFragmentTag";

    private static final String TAG = SightingListFragment.class.getSimpleName();

    @Bean(CommonManager.class)
    CommonManager commonManager;

    @ViewById(R.id.sightings_recyclerView)
    RecyclerView recyclerView;
    List<Sighting> sightingsList;

    @ViewById(R.id.no_sightings)
    TextView txtNoSightings;

    @ViewById(R.id.sightings_count)
    TextView txtSightingCount;

    @ViewById(R.id.sightings_swipeContainer)
    SwipeRefreshLayout swipeContainer;

    ProgressBar progressBar;

    SightingListAdapter adapter;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        setHasOptionsMenu(true);
        return super.onCreateView(inflater, container, savedInstanceState);
    }

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

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.search_menu_add, menu);
        final MenuItem searchItem = menu.findItem(R.id.sa_action_search);
        final SearchView searchView = (SearchView) MenuItemCompat.getActionView(searchItem);
        searchView.setOnQueryTextListener(SightingListFragment.this);

        final MenuItem addItem = menu.findItem(R.id.sa_action_add);
        addItem.setOnMenuItemClickListener(new MenuItem.OnMenuItemClickListener() {
            @Override
            public boolean onMenuItemClick(MenuItem item) {
                Intent intent = new Intent(getActivity(), SightingAddActivity_.class);
//                intent.putExtra(SpecieDetailActivity.EXTRA_SPECIE_ID, clickedDataItem.getId());
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);
                return false;
            }
        });
    }

    @Override
    public boolean onQueryTextChange(String query) {
        adapter.filter(query);
        return false;
    }

    @Override
    public boolean onQueryTextSubmit(String query) {
        return false;
    }



    private void loadData() {

        try {

            sightingsList = commonManager.getSightingDao().queryForEq(CommonModel.ACTIVE_COL, true);
//            if (sightingsList != null) {
//                for (Sighting sighting : sightingsList) {
//                    if (family.getIllustrationNids() != null && !family.getIllustrationNids().isEmpty()) {
//                        family.setIllustrations(commonManager.getIllustrationDao()
//                                .queryBuilder()
//                                .where().in(CommonModel.NID_COL, family.getIllustrationNids())
//                                .query()
//                        );
//                    }
//                }
//            }
            adapter = new SightingListAdapter(getActivity(), sightingsList);
            recyclerView.setAdapter(adapter);
            recyclerView.smoothScrollToPosition(0);
            swipeContainer.setRefreshing(false);
            progressBar.setVisibility(View.INVISIBLE);

            if (sightingsList.isEmpty()) {
                txtNoSightings.setVisibility(View.VISIBLE);
                recyclerView.setVisibility(View.GONE);
            }
            else {
                txtSightingCount.setVisibility(View.VISIBLE);
                txtSightingCount.setText("You have " + sightingsList.size() + " sightings");
                recyclerView.setVisibility(View.VISIBLE);
                txtNoSightings.setVisibility(View.GONE);
            }

        } catch (Exception e) {
            Log.d(TAG, e.getMessage());
            showLoadingError();
        }
    }
}
