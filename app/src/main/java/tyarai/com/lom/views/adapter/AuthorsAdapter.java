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
import tyarai.com.lom.utils.csv.RenameF;
import tyarai.com.lom.views.AuthorDetailActivity;
import tyarai.com.lom.views.AuthorDetailActivity_;

/**
 * Created by saimon
 */
public class AuthorsAdapter extends RecyclerView.Adapter<AuthorsAdapter.ViewHolder> {
    private List<Author> authors;
    private Context context;
    // private Movie movie;

    public AuthorsAdapter(Context applicationContext, List<Author> movieArrayList) {
        this.context = applicationContext;
        this.authors = movieArrayList;
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.row_author, viewGroup, false);


        return new ViewHolder(view);

    }

    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int i) {
        viewHolder.name.setText(authors.get(i).getName());
        viewHolder.description.setText(authors.get(i).getDetail());

        Log.d("xxxxxxxxxxx", "fname : " + RenameF.renameFNoExtension(authors.get(i).getPhoto()));
        int resourceImage = context.getResources().getIdentifier(RenameF.renameFNoExtension(authors.get(i).getPhoto()), "drawable", context.getPackageName());
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

    @Override
    public int getItemCount() {
        return authors.size();
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        private TextView name, description, actors;
        private ImageView imageView;

        public ViewHolder(View view) {
            super(view);
            name = (TextView) view.findViewById(R.id.author_name);
            description = (TextView) view.findViewById(R.id.author_description);
            imageView = (ImageView) view.findViewById(R.id.author_cover);

            // on item click
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    // get position
                    int pos = getAdapterPosition();
                    // check if item still exists
                    if (pos != RecyclerView.NO_POSITION) {
                        Author clickedDataItem = authors.get(pos);
                        Intent intent = new Intent(context, AuthorDetailActivity_.class);
                        intent.putExtra(AuthorDetailActivity.IMAGE_PATH_EXTRA, clickedDataItem.getPhoto());
                        intent.putExtra(AuthorDetailActivity.DESC_EXTRA, clickedDataItem.getDetail());
                        intent.putExtra(AuthorDetailActivity.NAME_EXTRA, clickedDataItem.getName());
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                        context.startActivity(intent);
                    }
                }
            });
        }
    }

    /* Within the RecyclerView.Adapter class */
    // Clean all elements of the recycler
    public void clear() {
        authors.clear();
        notifyDataSetChanged();
    }

    //RecyclerView mRecycler;
    // Add a list of ites
    public void addAll(int position, List<Author> mov) {
        authors.addAll(0, mov);
        notifyItemInserted(0);
        //mRecycler.smoothScrollToPosition(0);
        notifyDataSetChanged();
    }
}