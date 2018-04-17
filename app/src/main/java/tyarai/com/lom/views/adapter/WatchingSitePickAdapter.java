package tyarai.com.lom.views.adapter;


import android.app.Activity;
import android.content.Context;
import android.support.v7.widget.RecyclerView;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import java.util.ArrayList;
import java.util.List;

import tyarai.com.lom.R;
import tyarai.com.lom.model.WatchingSite;

/**
 * Created by saimon
 */
public class WatchingSitePickAdapter extends RecyclerView.Adapter<WatchingSitePickAdapter.ViewHolder> {

    private static final String TAG = WatchingSitePickAdapter.class.getSimpleName();

    private List<WatchingSite> listItems, filterList;
    private Context context;
    private int selected = -1;

    public WatchingSitePickAdapter(Context applicationContext, List<WatchingSite> specieArrayList) {
        this.context = applicationContext;
        this.listItems = new ArrayList<>(specieArrayList);
        this.filterList = new ArrayList<>();
        this.filterList.addAll(this.listItems);
    }

    public void setSelected(int position) {
        this.selected = position;
        notifyDataSetChanged();
    }

    public WatchingSite getSelected() {
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
        View view = LayoutInflater.from(viewGroup.getContext()).inflate(R.layout.simple_row_add, viewGroup, false);
        return new ViewHolder(view);
    }

    @Override
    public void onBindViewHolder(ViewHolder viewHolder, int i) {
        WatchingSite listItem = filterList.get(i);
        viewHolder.name.setText(listItem.getTitle());
        if (i == selected) {
            viewHolder.selectItemView.setVisibility(View.VISIBLE);
        }
        else {
            viewHolder.selectItemView.setVisibility(View.GONE);
        }
    }

    @Override
    public int getItemCount() {
        return (null != filterList ? filterList.size() : 0);
    }

    public class ViewHolder extends RecyclerView.ViewHolder {
        private TextView name;
        private ImageView selectItemView;

        public ViewHolder(View view) {
            super(view);
            name = (TextView) view.findViewById(R.id.site_name);
            selectItemView = (ImageView) view.findViewById(R.id.site_pick_arrow);
        }
    }



    // Do Search...
    public void filter(final String text) {

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