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

import com.squareup.picasso.Picasso;

import java.util.ArrayList;
import java.util.List;

import tyarai.com.lom.R;
import tyarai.com.lom.model.Specie;
import tyarai.com.lom.views.utils.RenameFromDb;
import tyarai.com.lom.views.SpecieDetailActivity;
import tyarai.com.lom.views.SpecieDetailActivity_;

/**
 * Created by saimon
 */
public class SpecieAdapter extends RecyclerView.Adapter<SpecieAdapter.ViewHolder> {

    private static final String TAG = SpecieAdapter.class.getSimpleName();

    private List<Specie> listItems, filterList;
    private Context context;

    public SpecieAdapter(Context applicationContext, List<Specie> specieArrayList) {
        this.context = applicationContext;
        this.listItems = new ArrayList<>(specieArrayList);
        this.filterList = new ArrayList<>();
        this.filterList.addAll(this.listItems);
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.species_item, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int i) {
        Specie listItem = filterList.get(i);
        viewHolder.name.setText(listItem.getTitle());
        if (listItem != null) {
            String fname = RenameFromDb.renameFNoExtension(listItem.getProfilePhotograph().getPhoto());
            Log.d(TAG, "specie fname : " + fname);
            int resourceImage = context.getResources().getIdentifier(fname, "drawable", context.getPackageName());
            if (resourceImage != 0) {
                Picasso.with(context)
                        .load(resourceImage)
                        .fit().centerCrop()
                        .placeholder(R.drawable.ic_more_horiz_black_48dp)
                        .into(viewHolder.imageView);
            }
            else {
                viewHolder.imageView.setImageResource(R.drawable.ic_more_horiz_black_48dp);
            }
        }
        else {
            viewHolder.imageView.setImageResource(R.drawable.ic_more_horiz_black_48dp);
        }
    }

    @Override
    public int getItemCount() {
        return (null != filterList ? filterList.size() : 0);
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        private TextView name;
        private ImageView imageView;

        public ViewHolder(View view) {
            super(view);
            name = view.findViewById(R.id.species_text);
            imageView = view.findViewById(R.id.species_image);

            // on item click
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    // get position
                    int pos = getAdapterPosition();
                    // check if item still exists
                    if (pos != RecyclerView.NO_POSITION) {
                        Specie clickedDataItem = filterList.get(pos);
                        Intent intent = new Intent(context, SpecieDetailActivity_.class);
                        intent.putExtra(SpecieDetailActivity.EXTRA_SPECIE_ID, clickedDataItem.getId());
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        context.startActivity(intent);
                    }
                }
            });
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