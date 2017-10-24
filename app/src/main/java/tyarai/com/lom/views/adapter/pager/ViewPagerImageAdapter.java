package tyarai.com.lom.views.adapter.pager;

import android.content.Context;
import android.content.Intent;
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
import tyarai.com.lom.views.FullScreenImageActivity;


/**
 * Created by saimon
 */
public class ViewPagerImageAdapter extends PagerAdapter {

    private static final String TAG = ViewPagerImageAdapter.class.getSimpleName();

    private Context mContext;
    private String[] mResources;
    private String title;

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

        final String fname = RenameF.renameFNoExtension(mResources[position]);
        Log.d(TAG, "fname : " + fname);
        final ImageView imageView = itemView.findViewById(R.id.img_pager_item);
        final int resourceImage = mContext.getResources().getIdentifier(fname, "drawable", mContext.getPackageName());
        imageView.setTag(resourceImage);
        if (resourceImage != 0) {
            Picasso.with(mContext)
                    .load(resourceImage)
//                    .fit().centerInside()
                    .placeholder(R.drawable.ic_more_horiz_black_48dp)
                    .into(imageView);
        }
        else {
            imageView.setImageResource(R.drawable.ic_more_horiz_black_48dp);
        }

        imageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(mContext, FullScreenImageActivity.class);
                intent.putExtra(FullScreenImageActivity.NAME, getTitle());
                intent.putExtra(FullScreenImageActivity.IMAGE_URL, (Integer)imageView.getTag());
                mContext.startActivity(intent);
            }
        });

        container.addView(itemView);

        return itemView;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((LinearLayout) object);
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

}