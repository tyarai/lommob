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
import tyarai.com.lom.model.Sighting;
import tyarai.com.lom.views.SpecieDetailActivity;
import tyarai.com.lom.views.SpecieDetailActivity_;
import tyarai.com.lom.views.utils.RenameFromDb;
import tyarai.com.lom.views.utils.ViewUtils;

/**
 * Created by saimon
 */
public class SightingListAdapter extends RecyclerView.Adapter<SightingListAdapter.ViewHolder> {

    private static final String TAG = SightingListAdapter.class.getSimpleName();

    private List<Sighting> listItems, filterList;
    private Context context;

    public SightingListAdapter(Context applicationContext, List<Sighting> specieArrayList) {
        this.context = applicationContext;
        this.listItems = new ArrayList<>(specieArrayList);
        this.filterList = new ArrayList<>();
        this.filterList.addAll(this.listItems);
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.species_row, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int i) {
        Sighting listItem = filterList.get(i);
        viewHolder.titleView.setText(listItem.getTitle());
        viewHolder.numberObservedView.setText(listItem.getNumberObserved());
        viewHolder.observationDateView.setText(ViewUtils.dateToStringSemiShort(listItem.getObservationDate()));
        if (listItem.getSpecie() != null) {
            viewHolder.specieNameView.setText(listItem.getSpecie().getEnglish());
        }
        if (listItem.getWatchingSite() != null) {
            viewHolder.watchingSiteNameView.setText(listItem.getWatchingSite().getTitle());
        }

//        String base64Image = listItem.getPhoto();
//        if (!TextUtils.isEmpty(base64Image)) {
//            byte[] decodedString = Base64.decode(base64Image, Base64.DEFAULT);
//            Bitmap decodedByte = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);
//            if (decodedByte != null) {
//                viewHolder.imageView.setImageBitmap(decodedByte);
//            }
//        }

//        String fname = RenameFromDb.renameFNoExtension(listItem.getProfilePhotograph().getPhoto());
//        Log.d(TAG, "specie fname : " + fname);
//        int resourceImage = context.getResources().getIdentifier(fname, "drawable", context.getPackageName());
//        if (resourceImage != 0) {
//            Glide.with(context)
//                    .load(resourceImage)
//                    .into(viewHolder.imageView);
//        }

    }

    @Override
    public int getItemCount() {
        return (null != filterList ? filterList.size() : 0);
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        private TextView titleView;
        private TextView specieNameView;
        private TextView watchingSiteNameView;
        private TextView observationDateView;
        private TextView numberObservedView;
        private ImageView imageView;

        public ViewHolder(View view) {
            super(view);
            titleView = (TextView) view.findViewById(R.id.sighting_item_title);
            imageView = (ImageView) view.findViewById(R.id.sighting_item_image);
            specieNameView = (TextView) view.findViewById(R.id.sighting_item_specie);
            watchingSiteNameView = (TextView) view.findViewById(R.id.sighting_item_site);
            numberObservedView = (TextView) view.findViewById(R.id.sighting_item_number_observed);
            observationDateView = (TextView) view.findViewById(R.id.sighting_item_observation_date);
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
                    for (Sighting item : listItems) {
                        if (item.getTitle().toLowerCase().contains(text.toLowerCase())) {
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