package tyarai.com.lom.views.adapter;


import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.bumptech.glide.Glide;

import java.util.ArrayList;
import java.util.List;

import tyarai.com.lom.R;
import tyarai.com.lom.model.Specie;
import tyarai.com.lom.views.SpecieDetailActivity;
import tyarai.com.lom.views.SpecieDetailActivity_;
import tyarai.com.lom.views.utils.RenameFromDb;

/**
 * Created by saimon
 */
public class SpecieListAdapter extends RecyclerView.Adapter<SpecieListAdapter.ViewHolder> {

    private static final String TAG = SpecieListAdapter.class.getSimpleName();

    private List<Specie> listItems, filterList;
    private Context context;
    private int selected = -1;

    public SpecieListAdapter(Context applicationContext, List<Specie> specieArrayList) {
        this.context = applicationContext;
        this.listItems = new ArrayList<>(specieArrayList);
        this.filterList = new ArrayList<>();
        this.filterList.addAll(this.listItems);
    }

    public void setSelected(int position) {
        this.selected = position;
        notifyDataSetChanged();
    }

    public Specie getSelected() {
        try {
            if (selected >= 0 && filterList != null) {
                return filterList.get(selected);
            }
        }
        catch (NullPointerException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.species_row, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int i) {
        Specie listItem = filterList.get(i);
        viewHolder.name.setText(listItem.getTitle());
        viewHolder.descriptionView.setText(listItem.getEnglish());
        if (i == selected) {
            viewHolder.selectImageView.setVisibility(View.VISIBLE);
        }
        else {
            viewHolder.selectImageView.setVisibility(View.GONE);
        }
        if (listItem != null) {
            String fname = RenameFromDb.renameFNoExtension(listItem.getProfilePhotograph().getPhoto());
            Log.d(TAG, "specie fname : " + fname);
            int resourceImage = context.getResources().getIdentifier(fname, "drawable", context.getPackageName());
            if (resourceImage != 0) {
                Glide.with(context)
                        .load(resourceImage)
                        .into(viewHolder.imageView);
            }
        }
    }

    @Override
    public int getItemCount() {
        return (null != filterList ? filterList.size() : 0);
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        private TextView name;
        private TextView descriptionView;
        private ImageView imageView;
        private ImageView selectImageView;

        public ViewHolder(View view) {
            super(view);
            name = (TextView) view.findViewById(R.id.specie_name);
            imageView = (ImageView) view.findViewById(R.id.specie_image);
            descriptionView = (TextView) view.findViewById(R.id.specie_description);
            selectImageView = (ImageView) view.findViewById(R.id.select_specie);
        }
    }



    // Do Search...
    public void filter(final String text) {

        // Searching could be complex..so we will dispatch it to a different thread...
        new Thread(new Runnable() {
            @Override
            public void run() {

                // Clear the filter list
                filterList.clear();

                // If there is no search value, then add all original list items to filter list
                if (TextUtils.isEmpty(text)) {
                    filterList.addAll(listItems);

                } else {
                    // Iterate in the original List and add it to filter list...
                    for (Specie item : listItems) {
                        if (item.getTitle().toLowerCase().contains(text.toLowerCase()) ||
                                item.getEnglish().toLowerCase().contains(text.toLowerCase())) {
                            // Adding Matched items
                            filterList.add(item);
                        }
                    }
                }

                // Set on UI Thread
                ((Activity) context).runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        // Notify the List that the DataSet has changed...
                        notifyDataSetChanged();
                    }
                });

            }
        }).start();

    }



}