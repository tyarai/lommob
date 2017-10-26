package tyarai.com.lom.views;

import android.content.Context;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.view.MenuItemCompat;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.SearchView;
import android.util.DisplayMetrics;
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

import java.util.ArrayList;
import java.util.List;

import tyarai.com.lom.R;
import tyarai.com.lom.manager.CommonManager;
import tyarai.com.lom.model.CommonModel;
import tyarai.com.lom.model.Specie;
import tyarai.com.lom.model.WatchingSite;
import tyarai.com.lom.views.adapter.SpecieAdapter;
import tyarai.com.lom.views.adapter.WatchingSiteAdapter;

/**
 * Created by saimon on 23/10/17.
 */
@EFragment(R.layout.simple_list_main)
public class WatchingSitesFragment extends BaseFrag
        implements SearchView.OnQueryTextListener
{

    private static final String TAG = WatchingSitesFragment.class.getSimpleName();

    @Bean(CommonManager.class)
    CommonManager commonManager;

    @ViewById(R.id.items_recycler_view)
    RecyclerView recyclerView;
    List<WatchingSite> watchingSitesList = new ArrayList<>();

    @ViewById(R.id.no_items)
    TextView txtNowatchingSites;

    WatchingSiteAdapter adapter;

    ProgressBar progressBar;


    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        setHasOptionsMenu(true);
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @AfterViews
    void initData(){

        progressBar = new ProgressBar(getActivity(), null, android.R.attr.progressBarStyleSmall);
        LinearLayoutManager layoutManager = new LinearLayoutManager(getActivity());
        recyclerView.setLayoutManager(layoutManager);
        DividerItemDecoration dividerItemDecoration = new DividerItemDecoration(recyclerView.getContext(),
                layoutManager.getOrientation());
        recyclerView.addItemDecoration(dividerItemDecoration);

        new LoadSpecieTask().execute();
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.search_menu, menu);
        final MenuItem searchItem = menu.findItem(R.id.action_search);
        final SearchView searchView = (SearchView) MenuItemCompat.getActionView(searchItem);
        searchView.setOnQueryTextListener(WatchingSitesFragment.this);
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

    private class LoadSpecieTask extends AsyncTask<Void, Void, List<WatchingSite>> {

        @Override
        protected List<WatchingSite> doInBackground(Void... voids) {
            try {
                return commonManager.getWatchingsiteDao().queryForEq(CommonModel.ACTIVE_COL, true)
                        ;
            }
            catch (Exception e) {
                Log.d(TAG, e.getMessage());
            }
            return new ArrayList<>();
        }

        @Override
        protected void onPostExecute(List<WatchingSite> watchingSites) {
            Log.d(TAG, "watchingSites size : " + watchingSites.size());
            if (watchingSites != null && !watchingSites.isEmpty()) {
//                for (WatchingSite ws :  watchingSites) {
//                    ws.setMapFilename(ws.getMap() != null ? ws.getMap().getName() : "");
//                    watchingSitesList.add(ws);
//                }
                watchingSitesList.addAll(watchingSites);
                adapter = new WatchingSiteAdapter(getActivity(), watchingSitesList);
                recyclerView.setAdapter(adapter);
                recyclerView.smoothScrollToPosition(0);
                progressBar.setVisibility(View.INVISIBLE);
            }
            else {
                txtNowatchingSites.setVisibility(View.VISIBLE);
            }


            super.onPostExecute(watchingSites);
        }
    }





}
