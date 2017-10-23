package tyarai.com.lom.views;

import android.content.Context;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.view.MenuItemCompat;
import android.support.v4.widget.SwipeRefreshLayout;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.SearchView;
import android.text.TextUtils;
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

import com.j256.ormlite.stmt.QueryBuilder;
import com.j256.ormlite.stmt.SelectArg;
import com.j256.ormlite.stmt.Where;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EFragment;
import org.androidannotations.annotations.ViewById;

import java.util.List;

import tyarai.com.lom.MainActivity;
import tyarai.com.lom.R;
import tyarai.com.lom.manager.CommonManager;
import tyarai.com.lom.model.CommonModel;
import tyarai.com.lom.model.Specie;
import tyarai.com.lom.views.adapter.SpecieAdapter;

/**
 * Created by saimon on 23/10/17.
 */
@EFragment(R.layout.species_main)
public class SpeciesFragment extends BaseFrag
        implements SearchView.OnQueryTextListener
{

    private static final String TAG = SpeciesFragment.class.getSimpleName();

    @Bean(CommonManager.class)
    CommonManager commonManager;

    @ViewById(R.id.species_recycler_view)
    RecyclerView recyclerView;
    List<Specie> speciesList;

    @ViewById(R.id.no_species)
    TextView txtNoSpecies;

    SpecieAdapter adapter;

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
        recyclerView.setLayoutManager(new LinearLayoutManager(getActivity()));
        recyclerView.setHasFixedSize(true);
        RecyclerView.LayoutManager layoutManager = new GridLayoutManager(getActivity(), calculateNoOfColumns(getActivity()));
        recyclerView.setLayoutManager(layoutManager);
        recyclerView.smoothScrollToPosition(0);
        loadData();
    }

    private int calculateNoOfColumns(Context context) {
        DisplayMetrics displayMetrics = context.getResources().getDisplayMetrics();
        float dpWidth = displayMetrics.widthPixels / displayMetrics.density;
        int noOfColumns = (int) (dpWidth / 180);
        return noOfColumns;
    }

    private void loadData() {

        try {

            speciesList = commonManager.getSpecieDao().queryForEq(CommonModel.ACTIVE_COL, true);
            adapter = new SpecieAdapter(getActivity(), speciesList);
            recyclerView.setAdapter(adapter);
            recyclerView.smoothScrollToPosition(0);
            progressBar.setVisibility(View.INVISIBLE);

            if (speciesList.isEmpty()) {
                txtNoSpecies.setVisibility(View.VISIBLE);
            }

        } catch (Exception e) {
            Log.d(TAG, e.getMessage());
            showLoadingError();
        }
    }

    @Override
    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
        inflater.inflate(R.menu.search_menu, menu);
        final MenuItem searchItem = menu.findItem(R.id.action_search);
        final SearchView searchView = (SearchView) MenuItemCompat.getActionView(searchItem);
        searchView.setOnQueryTextListener(SpeciesFragment.this);
    }

    @Override
    public boolean onQueryTextChange(String query) {
        adapter.filter(query);
        return false;
    }

    @Override
    public boolean onQueryTextSubmit(String query) {
//        doSearch(query);
        return false;
    }

//    private void doSearch(String query) {
//        try {
//            Where<Specie, Long> wh =  commonManager.getSpecieDao().queryBuilder().where();
//            wh.eq(CommonModel.ACTIVE_COL, true);
//            String filterTrimmed = "%" + query.trim() + "%";
//            if (!TextUtils.isEmpty(filterTrimmed)) {
//                speciesList= wh.and().like(Specie.TITLE_COL, new SelectArg(filterTrimmed)).query();
//                adapter = new SpecieAdapter(getActivity(), speciesList);
//                recyclerView.setAdapter(adapter);
//            }
//        }
//        catch (Exception e) {
//            e.printStackTrace();
//        }
//    }

//    @Override
//    public void onCreateOptionsMenu(Menu menu, MenuInflater inflater) {
//
//        // Implementing ActionBar Search inside a fragment
//        MenuItem item = menu.add("Search");
//        item.setIcon(R.drawable.ico_search); // sets icon
//        item.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS);
//        SearchView sv = new SearchView(getActivity());
//
//        // modifying the text inside edittext component
//        int id = sv.getContext().getResources().getIdentifier("android:id/search_src_text", null, null);
//        TextView textView = (TextView) sv.findViewById(id);
//        textView.setHint(getString(R.string.search_name));
//        textView.setHintTextColor(getResources().getColor(R.color.lightGray));
//        textView.setTextColor(getResources().getColor(android.R.color.white));
//
//        // implementing the listener
//        sv.setOnQueryTextListener(new SearchView.OnQueryTextListener() {
//            @Override
//            public boolean onQueryTextSubmit(String s) {
////                if (s.length() < 4) {
////                    Toast.makeText(getActivity(),
////                            "Your search query must not be less than 3 characters",
////                            Toast.LENGTH_LONG).show();
////                    return true;
////                } else {
////                    doSearch(s);
////                    return false;
////                }
//                doSearch(s);
//                return false;
//            }
//
//            @Override
//            public boolean onQueryTextChange(String newText) {
//                return true;
//            }
//        });
//        item.setActionView(sv);
//    }
//
//    private void doSearch(String query) {
//        try {
//            String filterTrimmed = "%" + query.trim() + "%";
//            speciesList = commonManager.getSpecieDao().queryBuilder()
//            .where().eq(CommonModel.ACTIVE_COL, true)
//            .and().like(Specie.TITLE_COL, new SelectArg(filterTrimmed)).query();
//            adapter = new SpecieAdapter(getActivity(), speciesList);
//            adapter.notifyDataSetChanged();
//        }
//        catch (Exception e) {
//            e.printStackTrace();
//        }
//    }

}
