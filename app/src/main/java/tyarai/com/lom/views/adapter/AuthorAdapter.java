package tyarai.com.lom.views.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.squareup.picasso.Picasso;

import java.util.List;

import tyarai.com.lom.R;
import tyarai.com.lom.model.Author;
import tyarai.com.lom.utils.csv.RenameF;

public class AuthorAdapter extends ArrayAdapter<Author> {
	
	private List<Author> listData ;
	private LayoutInflater layoutInflater;
	private Context context;

	public AuthorAdapter(Context aContext, List<Author> listData) {
		super(aContext, R.layout.row_author, listData);
		this.listData = listData;
		this.context = aContext;
		this.layoutInflater = LayoutInflater.from(aContext);
	}	
	
	
	public View getView(int position, View convertView, ViewGroup parent) {

        View v = convertView;
        ViewHolder holder;
        if (v == null) {
            v = layoutInflater.inflate(R.layout.row_author, parent, false);

            holder = new ViewHolder();

            holder.name = (TextView) v.findViewById(R.id.author_name);
            holder.description = (TextView) v.findViewById(R.id.author_description);
            holder.imageView = (ImageView) v.findViewById(R.id.author_cover);

            v.setTag(holder);

        } else {
            holder = (ViewHolder) v.getTag();
        }

        Author item = listData.get(position);
        holder.name.setText(item.getName());
        holder.description.setText(item.getDetail());

        int resourceImage = context.getResources().getIdentifier(RenameF.renameFNoExtension(item.getPhoto()), "drawable", context.getPackageName());
        Picasso.with(context)
                .load(resourceImage)
                .fit().centerCrop()
                .placeholder(R.drawable.ic_more_horiz_black_36dp)
                .into(holder.imageView);
      
        return v;
    }	
	

	static class ViewHolder {
        private TextView name, description;
        private ImageView imageView;
	}
		
	
}

