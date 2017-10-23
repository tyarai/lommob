package tyarai.com.lom.views.adapter.pager;

import android.content.Context;
import android.support.v4.view.PagerAdapter;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.LinearLayout;

import com.squareup.picasso.Picasso;

import tyarai.com.lom.R;
import tyarai.com.lom.utils.csv.RenameF;


/**
 * Created by saimon
 */
public class ViewPagerImageAdapter extends PagerAdapter {

    private static final String TAG = ViewPagerImageAdapter.class.getSimpleName();

    private Context mContext;
    private String[] mResources;

    public ViewPagerImageAdapter(Context mContext, String[] mResources) {
        this.mContext = mContext;
        this.mResources = mResources;
    }

    @Override
    public int getCount() {
        return mResources.length;
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == ((LinearLayout) object);
    }

    @Override
    public Object instantiateItem(ViewGroup container, int position) {
        View itemView = LayoutInflater.from(mContext).inflate(R.layout.pager_image_item, container, false);

        String fname = RenameF.renameFNoExtension(mResources[position]);
        Log.d(TAG, "fname : " + fname);
        ImageView imageView = itemView.findViewById(R.id.img_pager_item);
        int resourceImage = mContext.getResources().getIdentifier(fname, "drawable", mContext.getPackageName());
        if (resourceImage != 0) {
            Picasso.with(mContext)
                    .load(resourceImage)
                    //.fit().centerCrop()
                    .placeholder(R.drawable.ic_more_horiz_black_48dp)
                    .into(imageView);
        }
        else {
            imageView.setImageResource(R.drawable.ic_more_horiz_black_48dp);
        }

        container.addView(itemView);

        return itemView;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((LinearLayout) object);
    }
}