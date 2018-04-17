package tyarai.com.lom.views;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.design.widget.Snackbar;
import android.support.v4.view.MenuItemCompat;
import android.support.v7.widget.DividerItemDecoration;
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

import java.util.ArrayList;
import java.util.List;

import tyarai.com.lom.R;
import tyarai.com.lom.manager.CommonManager;
import tyarai.com.lom.model.CommonModel;
import tyarai.com.lom.model.WatchingSite;
import tyarai.com.lom.views.adapter.WatchingSitePickAdapter;

/**
 * Created by saimon on 23/10/17.
 */
@EFragment(R.layout.simple_list_main)
public class WatchingSiteListFragment extends BaseFrag
        implements SearchView.OnQueryTextListener
{

    private static final String TAG = WatchingSiteListFragment.class.getSimpleName();

    @Bean(CommonManager.class)
    CommonManager commonManager;

    @ViewById(R.id.items_recycler_view)
    RecyclerView recyclerView;
    List<WatchingSite> watchingSiteList = new ArrayList<>();

    @ViewById(R.id.no_items)
    TextView txtNoSites;

    WatchingSitePickAdapter adapter;

    @ViewById(R.id.pb_vertical)
    ProgressBar progressBar;

    int selected = -1;

    @Nullable
    @Override
    public View onCreateView(LayoutInflater inflater, @Nullable ViewGroup container, Bundle savedInstanceState) {
        setHasOptionsMenu(true);
        return super.onCreateView(inflater, container, savedInstanceState);
    }

    @AfterViews
    void initData(){

        progressBar.setIndeterminate(true);
        progressBar.setVisibility(View.VISIBLE);
        LinearLayoutManager layoutManager = new LinearLayoutManager(getActivity());
        recyclerView.setLayoutManager(layoutManager);
        DividerItemDecoration dividerItemDecoration = new DividerItemDecoration(recyclerView.getContext(),
                layoutManager.getOrientation());
        recyclerView.addItemDecoration(dividerItemDecoration);

        recyclerView.addOnItemTouchListener(
                new RecyclerItemClickListener(getActivity(), recyclerView, new RecyclerItemClickListener.OnItemClickListener() {
                    @Override
                    public void onItemClick(View view, int position) {
                        selectSite(position);
                    }

                    @Override
                    public void onLongItemClick(View view, int position) {
                        selectSite(position);
                    }
                })
        );

        new LoadSiteTask().execute();
    }

    Snackbar snackbar;
    public static String SITE_ID = "site_id";
    public static String SITE_TITLE = "site_title";
    public static int RESULT_BOO = -1;

    private void selectSite(final int position) {
        if (position == selected) {
            adapter.setSelected(-1);
            selected = -1;
            if (snackbar != null) {
                snackbar.dismiss();
            }
        }
        else {
            adapter.setSelected(position);
            selected = position;
            snackbar = Snackbar.make(recyclerView, getString(R.string.select_site), Snackbar.LENGTH_INDEFINITE);
            snackbar.setAction("DONE", new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    snackbar.dismiss();
                    WatchingSite site = adapter.getSelected();
                    Intent resultIntent = new Intent();
                    if (site != null) {
                        resultIntent.putExtra(SITE_ID, site.getId() );
                        resultIntent.putExtra(SITE_TITLE, site.getTitle() );
                        getActivity().setResult(Activity.RESULT_OK, resultIntent);
                    }
                    else {
                        getActivity().setResult(RESULT_BOO, resultIntent);
                    }
                    getActivity().finish();
                }
            });
            snackbar.show();
        }
    }


        @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.search_menu, menu);
        final MenuItem searchItem = menu.findItem(R.id.action_search);
        final SearchView searchView = (SearchView) MenuItemCompat.getActionView(searchItem);
        searchView.setOnQueryTextListener(WatchingSiteListFragment.this);
    }

    @Override
    public boolean onQueryTextChange(String query) {
        adapter.filter(query);
        if (snackbar != null) {
            snackbar.dismiss();
        }
        return false;
    }

    @Override
    public boolean onQueryTextSubmit(String query) {
        return false;
    }


    private class LoadSiteTask extends AsyncTask<Void, Void, List<WatchingSite>> {

        @Override
        protected List<WatchingSite> doInBackground(Void... voids) {
            try {
                return commonManager.getWatchingsiteDao().queryForEq(CommonModel.ACTIVE_COL, true);
            }
            catch (Exception e) {
                Log.d(TAG, e.getMessage());
            }
            return new ArrayList<>();
        }

        @Override
        protected void onPostExecute(List<WatchingSite> sites) {
            Log.d(TAG, "sites size : " + sites.size());
            watchingSiteList.addAll(sites);
            adapter = new WatchingSitePickAdapter(getActivity(), watchingSiteList);
            recyclerView.setAdapter(adapter);
            recyclerView.smoothScrollToPosition(0);
            progressBar.setVisibility(View.GONE);

            if (watchingSiteList.isEmpty()) {
                txtNoSites.setVisibility(View.VISIBLE);
            }
            super.onPostExecute(sites);
        }
    }


}

