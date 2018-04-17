package tyarai.com.lom.views;

import android.app.Activity;
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

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EFragment;
import org.androidannotations.annotations.ViewById;

import java.util.List;

import tyarai.com.lom.BuildConfig;
import tyarai.com.lom.R;
import tyarai.com.lom.data.SightingDto;
import tyarai.com.lom.factory.SightingDtoFactory;
import tyarai.com.lom.factory.SightingDtoFactoryImpl;
import tyarai.com.lom.manager.CommonManager;
import tyarai.com.lom.manager.SightingManager;
import tyarai.com.lom.manager.SightingManagerImpl;
import tyarai.com.lom.model.CommonModel;
import tyarai.com.lom.model.Sighting;
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

    @Bean(SightingManagerImpl.class)
    SightingManager sightingManager;


    @ViewById(R.id.sightings_recyclerView)
    RecyclerView recyclerView;
    List<SightingDto> sightingsList;

    @ViewById(R.id.no_sightings)
    TextView txtNoSightings;

    @ViewById(R.id.sightings_count)
    TextView txtSightingCount;

    @ViewById(R.id.sightings_swipeContainer)
    SwipeRefreshLayout swipeContainer;

    ProgressBar progressBar;

    SightingListAdapter adapter;

    public static final int CREATE_SIGHTING = 12;
    public static final int EDIT_SIGHTING = 13;

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
                startActivityForResult(intent, CREATE_SIGHTING);
                return false;
            }
        });
    }

    @Override
    public void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (resultCode == Activity.RESULT_OK) {
            switch (requestCode) {
                case CREATE_SIGHTING :
                    loadData();
                    break;
                case EDIT_SIGHTING :
                    loadData();
                    break;
                default:
                    break;
            }
        }
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

            sightingsList = sightingManager.listSightings();
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
                txtSightingCount.setText("You have " + sightingsList.size() + (sightingsList.size() ==  1 ? " sighting" : " sightings"));
                recyclerView.setVisibility(View.VISIBLE);
                txtNoSightings.setVisibility(View.GONE);
            }

        } catch (Exception e) {
//            Log.d(TAG, e.getMessage());
            e.printStackTrace();
            showLoadingError();
        }
    }

    public void editSightingClickHandler(View v) {
        SightingDto clickedDataItem = (SightingDto) v.getTag();
        Intent intent = new Intent(getActivity(), SightingAddActivity_.class);
        intent.putExtra(SightingAddActivity.EXTRA_SIGHTING, clickedDataItem);
        startActivityForResult(intent, SightingListFragment.EDIT_SIGHTING);
    }
}
