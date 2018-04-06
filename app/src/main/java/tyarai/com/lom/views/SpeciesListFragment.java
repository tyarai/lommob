package tyarai.com.lom.views;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.design.widget.Snackbar;
import android.support.v4.view.MenuItemCompat;
import android.support.v7.widget.DividerItemDecoration;
import android.support.v7.widget.GridLayoutManager;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.SearchView;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.GestureDetector;
import android.view.LayoutInflater;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.MotionEvent;
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
import tyarai.com.lom.views.adapter.SpecieAdapter;
import tyarai.com.lom.views.adapter.SpecieListAdapter;

/**
 * Created by saimon on 23/10/17.
 */
@EFragment(R.layout.simple_list_main)
public class SpeciesListFragment extends BaseFrag
        implements SearchView.OnQueryTextListener
{

    private static final String TAG = SpeciesListFragment.class.getSimpleName();

    @Bean(CommonManager.class)
    CommonManager commonManager;

    @ViewById(R.id.items_recycler_view)
    RecyclerView recyclerView;
    List<Specie> speciesList = new ArrayList<>();

    @ViewById(R.id.no_items)
    TextView txtNoSpecies;

    SpecieListAdapter adapter;

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
                        selectSpecie(position);
                    }

                    @Override
                    public void onLongItemClick(View view, int position) {
                        selectSpecie(position);
                    }
                })
        );

        new LoadSpecieTask().execute();
    }

    Snackbar snackbar;
    public static String SPECIE_ID = "specie_id";
    public static String SPECIE_TITLE = "specie_title";
    public static String SPECIE_TRANS = "specie_trans";
    public static int RESULT_BOO = -1;

    private void selectSpecie(final int position) {
        if (position == selected) {
            adapter.setSelected(-1);
            if (snackbar != null) {
                snackbar.dismiss();
            }
        }
        else {
            adapter.setSelected(position);
            selected = position;
            snackbar = Snackbar.make(recyclerView, getString(R.string.select_species), Snackbar.LENGTH_INDEFINITE);
            snackbar.setAction("DONE", new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    snackbar.dismiss();
                    Specie specie = adapter.getSelected();
                    Intent resultIntent = new Intent();
                    if (specie != null) {
                        resultIntent.putExtra(SPECIE_ID, specie.getId() );
                        resultIntent.putExtra(SPECIE_TITLE, specie.getTitle() );
                        resultIntent.putExtra(SPECIE_TRANS, specie.getEnglish() );
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
        searchView.setOnQueryTextListener(SpeciesListFragment.this);
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


    private class LoadSpecieTask extends AsyncTask<Void, Void, List<Specie>> {

        @Override
        protected List<Specie> doInBackground(Void... voids) {
            try {
                return commonManager.getSpecieDao().queryForEq(CommonModel.ACTIVE_COL, true);
            }
            catch (Exception e) {
                Log.d(TAG, e.getMessage());
            }
            return new ArrayList<>();
        }

        @Override
        protected void onPostExecute(List<Specie> species) {
            Log.d(TAG, "species size : " + species.size());
            speciesList.addAll(species);
            adapter = new SpecieListAdapter(getActivity(), speciesList);
            recyclerView.setAdapter(adapter);
            recyclerView.smoothScrollToPosition(0);
            progressBar.setVisibility(View.GONE);

            if (speciesList.isEmpty()) {
                txtNoSpecies.setVisibility(View.VISIBLE);
            }
            super.onPostExecute(species);
        }
    }


}

class RecyclerItemClickListener implements RecyclerView.OnItemTouchListener {
    private OnItemClickListener mListener;

    public interface OnItemClickListener {
        public void onItemClick(View view, int position);

        public void onLongItemClick(View view, int position);
    }

    GestureDetector mGestureDetector;

    public RecyclerItemClickListener(Context context, final RecyclerView recyclerView, OnItemClickListener listener) {
        mListener = listener;
        mGestureDetector = new GestureDetector(context, new GestureDetector.SimpleOnGestureListener() {
            @Override
            public boolean onSingleTapUp(MotionEvent e) {
                return true;
            }

            @Override
            public void onLongPress(MotionEvent e) {
                View child = recyclerView.findChildViewUnder(e.getX(), e.getY());
                if (child != null && mListener != null) {
                    mListener.onLongItemClick(child, recyclerView.getChildAdapterPosition(child));
                }
            }
        });
    }

    @Override
    public boolean onInterceptTouchEvent(RecyclerView view, MotionEvent e) {
        View childView = view.findChildViewUnder(e.getX(), e.getY());
        if (childView != null && mListener != null && mGestureDetector.onTouchEvent(e)) {
            mListener.onItemClick(childView, view.getChildAdapterPosition(childView));
            return true;
        }
        return false;
    }

    @Override
    public void onTouchEvent(RecyclerView view, MotionEvent motionEvent) {
    }

    @Override
    public void onRequestDisallowInterceptTouchEvent(boolean disallowIntercept) {
    }
}
