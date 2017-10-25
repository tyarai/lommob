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
import tyarai.com.lom.model.Family;
import tyarai.com.lom.model.Specie;
import tyarai.com.lom.views.FamilyDetailActivity;
import tyarai.com.lom.views.FamilyDetailActivity_;
import tyarai.com.lom.views.SpecieDetailActivity;
import tyarai.com.lom.views.SpecieDetailActivity_;
import tyarai.com.lom.views.utils.RenameFromDb;

/**
 * Created by saimon
 */
public class FamiliesAdapter extends RecyclerView.Adapter<FamiliesAdapter.ViewHolder> {

    private static final String TAG = FamiliesAdapter.class.getSimpleName();

    private List<Family> families;
    private Context context;

    public FamiliesAdapter(Context applicationContext, List<Family> familiesArrayList) {
        this.context = applicationContext;
        this.families = familiesArrayList;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(viewGroup.getContext())
                .inflate(R.layout.families_row, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int i) {
        Family family = families.get(i);
        viewHolder.name.setText(family.getFamily());
        viewHolder.description.setText(family.getDescription());

        if (family.getIllustrations() != null && !family.getIllustrations().isEmpty()) {
            String fname = RenameFromDb.renameFNoExtension(family.getIllustrations().get(0).getTitle());
            Log.d(TAG, "family illustration fname : " + fname);
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
        return families.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        private TextView name, description;
        private ImageView imageView;

        public ViewHolder(View view) {
            super(view);
            name = view.findViewById(R.id.family_name);
            description = view.findViewById(R.id.family_description);
            imageView = view.findViewById(R.id.family_cover);

            // on item click
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int pos = getAdapterPosition();
                    // check if item still exists
                    if (pos != RecyclerView.NO_POSITION) {
                        Family clickedDataItem = families.get(pos);
                        Intent intent = new Intent(context, FamilyDetailActivity_.class);
                        intent.putExtra(FamilyDetailActivity.EXTRA_FAMILY_ID, clickedDataItem.getId());
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        context.startActivity(intent);
                    }
                }
            });
        }
    }

    public void clear() {
        families.clear();
        notifyDataSetChanged();
    }

    public void addAll(int position, List<Family> fam) {
        families.addAll(0, fam);
        notifyItemInserted(0);
        notifyDataSetChanged();
    }
}