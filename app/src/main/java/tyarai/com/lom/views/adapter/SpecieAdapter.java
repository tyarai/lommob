package tyarai.com.lom.views.adapter;


import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.squareup.picasso.Picasso;

import java.util.List;

import tyarai.com.lom.R;
import tyarai.com.lom.model.Author;
import tyarai.com.lom.model.Specie;
import tyarai.com.lom.utils.csv.RenameF;
import tyarai.com.lom.views.AuthorDetailActivity;
import tyarai.com.lom.views.AuthorDetailActivity_;

/**
 * Created by saimon
 */
public class SpecieAdapter extends RecyclerView.Adapter<SpecieAdapter.ViewHolder> {

    private static final String TAG = SpecieAdapter.class.getSimpleName();

    private List<Specie> species;
    private Context context;

    public SpecieAdapter(Context applicationContext, List<Specie> specieArrayList) {
        this.context = applicationContext;
        this.species = specieArrayList;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.species_item, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int i) {
        viewHolder.name.setText(species.get(i).getTitle());
        if (species.get(i).getProfilePhotograph() != null) {
            String fname = RenameF.renameFNoExtension(species.get(i).getProfilePhotograph().getPhoto());
            Log.d(TAG, "fname : " + fname);
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
        return species.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        private TextView name;
        private ImageView imageView;

        public ViewHolder(View view) {
            super(view);
            name = (TextView) view.findViewById(R.id.species_text);
            imageView = (ImageView) view.findViewById(R.id.species_image);

            // on item click
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    // get position
                    int pos = getAdapterPosition();
                    // check if item still exists
                    if (pos != RecyclerView.NO_POSITION) {
                        Specie clickedDataItem = species.get(pos);
//                        Intent intent = new Intent(context, AuthorDetailActivity_.class);
//                        intent.putExtra(AuthorDetailActivity.IMAGE_PATH_EXTRA, clickedDataItem.getPhoto());
//                        intent.putExtra(AuthorDetailActivity.DESC_EXTRA, clickedDataItem.getDetail());
//                        intent.putExtra(AuthorDetailActivity.NAME_EXTRA, clickedDataItem.getName());
//                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//                        context.startActivity(intent);
                    }
                }
            });
        }
    }

    /* Within the RecyclerView.Adapter class */
    // Clean all elements of the recycler
    public void clear() {
        species.clear();
        notifyDataSetChanged();
    }

    //RecyclerView mRecycler;
    // Add a list of ites
    public void addAll(int position, List<Specie> spe) {
        species.addAll(0, spe);
        notifyItemInserted(0);
        //mRecycler.smoothScrollToPosition(0);
        notifyDataSetChanged();
    }
}