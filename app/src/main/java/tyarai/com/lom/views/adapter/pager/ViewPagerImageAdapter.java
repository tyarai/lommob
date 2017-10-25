package tyarai.com.lom.views.adapter.pager;

import android.content.Context;
import android.content.Intent;
import android.support.design.widget.Snackbar;
import android.support.v4.view.PagerAdapter;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.squareup.picasso.Picasso;

import tyarai.com.lom.R;
import tyarai.com.lom.views.FullScreenImagesActivity;
import tyarai.com.lom.views.FullScreenImagesActivity_;
import tyarai.com.lom.views.utils.RenameFromDb;
import tyarai.com.lom.views.FullScreenImageActivity;


/**
 * Created by saimon
 */
public class ViewPagerImageAdapter extends PagerAdapter {

    private static final String TAG = ViewPagerImageAdapter.class.getSimpleName();

    private Context mContext;
    private String[] mResources;
    private String[] mDescriptions;
    private String title;

    private boolean displayInfo;
    private boolean canZoom;
    private boolean multipleImage;

    public ViewPagerImageAdapter(Context mContext, String[] resources,
                                 String[] descriptions, boolean displayInfo,
                                 boolean canZoom) {
        this.mContext = mContext;
        this.mResources = resources;
        this.mDescriptions = descriptions;
        this.displayInfo = displayInfo;
        this.canZoom = canZoom;
        this.multipleImage = multipleImage;
    }

    @Override
    public int getCount() {
        return mResources.length;
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == ((RelativeLayout) object);
    }

    @Override
    public Object instantiateItem(ViewGroup container, final int position) {
        View itemView = LayoutInflater.from(mContext).inflate(R.layout.pager_image_item, container, false);

        final String fname = RenameFromDb.renameFNoExtension(mResources[position]);
        Log.d(TAG, "fname : " + fname);
        final ImageView imageView = itemView.findViewById(R.id.img_pager_item);
        final int resourceImage = mContext.getResources().getIdentifier(fname, "drawable", mContext.getPackageName());
        imageView.setTag(resourceImage);
        if (resourceImage != 0) {
            Picasso.with(mContext)
                    .load(resourceImage)
//                    .fit()
                    .placeholder(R.drawable.ic_more_horiz_black_48dp)
                    .into(imageView);
        }
        else {
            imageView.setImageResource(R.drawable.ic_more_horiz_black_48dp);
        }

        if (canZoom) {
//            if (multipleImage) {
                imageView.setOnClickListener(new View.OnClickListener() {
                    @Override
                    public void onClick(View v) {
                        Intent intent = new Intent(mContext, FullScreenImagesActivity_.class);
                        intent.putExtra(FullScreenImagesActivity.EXTRA_IMAGE_CURRENT_POSITION, position);
                        intent.putExtra(FullScreenImagesActivity.EXTRA_IMAGE_URLS, mResources);
                        mContext.startActivity(intent);
                    }
                });
//            }
//            else {
//                imageView.setOnClickListener(new View.OnClickListener() {
//                    @Override
//                    public void onClick(View v) {
//                        Intent intent = new Intent(mContext, FullScreenImageActivity.class);
//                        intent.putExtra(FullScreenImageActivity.NAME, getTitle());
//                        intent.putExtra(FullScreenImageActivity.IMAGE_URL, (Integer) imageView.getTag());
//                        mContext.startActivity(intent);
//                    }
//                });
//            }

        }



//        final ImageButton infoBtn = itemView.findViewById(R.id.img_pager_desc);
//        if (displayInfo) {
//            infoBtn.setVisibility(View.VISIBLE);
//            infoBtn.setOnClickListener(new View.OnClickListener() {
//                @Override
//                public void onClick(View view) {
//                    String text = mDescriptions[position];
//                    if (TextUtils.isEmpty(text)) {
//                        text = mContext.getString(R.string.no_description);
//                    }
//
//                    Snackbar snackbar = Snackbar.make(infoBtn, text, Snackbar.LENGTH_INDEFINITE)
//                            .setAction(mContext.getString(R.string.dismiss), new View.OnClickListener() {
//                                @Override
//                                public void onClick(View v) {
//                                }
//                            });
//                    View snackbarView = snackbar.getView();
//                    TextView textView = snackbarView.findViewById(android.support.design.R.id.snackbar_text);
//                    textView.setMaxLines(11);
//                    snackbar.show();
//                }
//            });
//        }
//        else {
//            infoBtn.setVisibility(View.GONE);
//        }

        container.addView(itemView);

        return itemView;
    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((RelativeLayout) object);
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }



}