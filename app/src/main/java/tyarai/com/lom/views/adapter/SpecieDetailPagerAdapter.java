package tyarai.com.lom.views.adapter;

import android.content.Context;
import android.content.Intent;
import android.support.v4.view.PagerAdapter;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.ScrollView;
import android.widget.TextView;


import com.bumptech.glide.Glide;

import tyarai.com.lom.R;
import tyarai.com.lom.views.utils.RenameFromDb;
import tyarai.com.lom.views.FullScreenImageActivity;


/**
 * Created by saimon
 * TODO add credit <div>Icons made by <a href="http://www.freepik.com" title="Freepik">Freepik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a> is licensed by <a href="http://creativecommons.org/licenses/by/3.0/" title="Creative Commons BY 3.0" target="_blank">CC 3.0 BY</a></div>
 */
public class SpecieDetailPagerAdapter extends PagerAdapter {

    private static final String TAG = SpecieDetailPagerAdapter.class.getSimpleName();

    private Context mContext;
    private String[] mResources;

    public SpecieDetailPagerAdapter(Context mContext, String[] mResources) {
        this.mContext = mContext;
        this.mResources = mResources;
    }

    @Override
    public int getCount() {
        return mResources.length;
    }

    @Override
    public boolean isViewFromObject(View view, Object object) {
        return view == ((ScrollView) object);
    }

    @Override
    public Object instantiateItem(ViewGroup container, int position) {

        View itemView = null;

        if (position == 0) {
            itemView = LayoutInflater.from(mContext).inflate(R.layout.specie_translate, container, false);
            TextView txtEnglish = (TextView) itemView.findViewById(R.id.specie_english);
            TextView txtOtherEnglish = (TextView) itemView.findViewById(R.id.specie_other_english);
            TextView txtMalagasy = (TextView) itemView.findViewById(R.id.specie_malagasy);
            TextView txtFrench = (TextView) itemView.findViewById(R.id.specie_french);
            TextView txtGerman = (TextView) itemView.findViewById(R.id.specie_german);
            try {
                String[] langs = mResources[0].split("##");
                txtEnglish.setText(langs[0]);
                txtOtherEnglish.setText(langs[1]);
                txtMalagasy.setText(langs[2]);
                txtFrench.setText(langs[3]);
                txtGerman.setText(langs[4]);
                container.addView(itemView);
            }
            catch (Exception e) {
                e.printStackTrace();
            }
        }
        else if (position == 1) {
            itemView = LayoutInflater.from(mContext).inflate(R.layout.specie_text, container, false);
            TextView txtIdentification = (TextView) itemView.findViewById(R.id.specie_prop_text);
            txtIdentification.setText(mResources[1]);
            container.addView(itemView);
        }
        else if (position == 2) {
            itemView = LayoutInflater.from(mContext).inflate(R.layout.specie_text, container, false);
            TextView txtNaturalHistory = (TextView) itemView.findViewById(R.id.specie_prop_text);
            txtNaturalHistory.setText(mResources[2]);
            container.addView(itemView);
        }
        else if (position == 3) {
            itemView = LayoutInflater.from(mContext).inflate(R.layout.specie_text, container, false);
            TextView txtConservationStatus = (TextView) itemView.findViewById(R.id.specie_prop_text);
            txtConservationStatus.setText(mResources[3]);
            container.addView(itemView);
        }
        else if (position == 4) {
            itemView = LayoutInflater.from(mContext).inflate(R.layout.specie_text, container, false);
            TextView txtWhereToSeeIt = (TextView) itemView.findViewById(R.id.specie_prop_text);
            txtWhereToSeeIt.setText(mResources[4]);
            container.addView(itemView);
        }
        else if (position == 5) {
            itemView = LayoutInflater.from(mContext).inflate(R.layout.specie_text, container, false);
            TextView txtGeographicRange = (TextView) itemView.findViewById(R.id.specie_prop_text);
            txtGeographicRange.setText(mResources[5]);
            container.addView(itemView);
        }
        else if (position == 6) {
            itemView = LayoutInflater.from(mContext).inflate(R.layout.specie_map, container, false);
            ImageView imageView = (ImageView) itemView.findViewById(R.id.specie_image);
            final String fname = RenameFromDb.renameFNoExtension(mResources[6]);
            Log.d(TAG, "map fname : " + fname);
            final int resourceImage = mContext.getResources().getIdentifier(fname, "drawable", mContext.getPackageName());
            if (resourceImage != 0) {
                Glide.with(mContext)
                        .load(resourceImage)
//                        .fit()
//                        .centerInside()
                        .into(imageView);
            }
            imageView.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    String title = "";
                    try {
                        String[] langs = mResources[0].split("##");
                        title = langs[0];
                    }
                    catch (Exception e) {
                        e.printStackTrace();
                    }
                    Intent intent = new Intent(mContext, FullScreenImageActivity.class);
                    intent.putExtra(FullScreenImageActivity.NAME, title);
                    intent.putExtra(FullScreenImageActivity.IMAGE_URL, resourceImage);
                    mContext.startActivity(intent);
                }
            });
            container.addView(itemView);
        }
        return itemView;


    }

    @Override
    public void destroyItem(ViewGroup container, int position, Object object) {
        container.removeView((ScrollView) object);
    }
}