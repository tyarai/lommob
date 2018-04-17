package tyarai.com.lom.views.adapter;


import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import tyarai.com.lom.R;
import tyarai.com.lom.model.WatchingSite;
import tyarai.com.lom.views.SiteDetailActivity;
import tyarai.com.lom.views.SiteDetailActivity_;

/**
 * Created by saimon
 */
public class WatchingSiteListAdapter extends RecyclerView.Adapter<WatchingSiteListAdapter.ViewHolder> {

    private static final String TAG = WatchingSiteListAdapter.class.getSimpleName();

    private List<WatchingSite> listItems, filterList;
    private Context context;

    public WatchingSiteListAdapter(Context applicationContext, List<WatchingSite> WatchingSiteArrayList) {
        this.context = applicationContext;
        this.listItems = new ArrayList<>(WatchingSiteArrayList);
        this.filterList = new ArrayList<>();
        this.filterList.addAll(this.listItems);
    }

    @Override
    public ViewHolder onCreateViewHolder(ViewGroup viewGroup, int i) {
        View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.simple_row, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int i) {
        WatchingSite listItem = filterList.get(i);
        viewHolder.name.setText(listItem.getTitle());
        viewHolder.description.setText(listItem.getBody());
    }

    @Override
    public int getItemCount() {
        return (null != filterList ? filterList.size() : 0);
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        private TextView name;
        private TextView description;

        public ViewHolder(View view) {
            super(view);
            name = (TextView) view.findViewById(R.id.sp_name);
            description = (TextView) view.findViewById(R.id.sp_description);

            // on item click
            itemView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    int pos = getAdapterPosition();
                    if (pos != RecyclerView.NO_POSITION) {
                        WatchingSite clickedDataItem = filterList.get(pos);
                        Intent intent = new Intent(context, SiteDetailActivity_.class);
                        intent.putExtra(SiteDetailActivity.IMAGE_PATH_EXTRA,
                                clickedDataItem.getMap() == null ? "" : clickedDataItem.getMap().getName());
                        intent.putExtra(SiteDetailActivity.DESC_EXTRA, clickedDataItem.getBody());
                        intent.putExtra(SiteDetailActivity.NAME_EXTRA, clickedDataItem.getTitle());
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

                filterList.clear();

                if (TextUtils.isEmpty(text)) {
                    filterList.addAll(listItems);

                } else {
                    for (WatchingSite item : listItems) {
                        if (item.getTitle().toLowerCase().contains(text.toLowerCase())) {
                            filterList.add(item);
                        }
                    }
                }

                // Set on UI Thread
                ((Activity) context).runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        notifyDataSetChanged();
                    }
                });

            }
        }).start();

    }



}