package tyarai.com.lom.manager;

import android.content.Context;
import android.util.Log;

import org.androidannotations.annotations.EBean;

import java.io.InputStream;
import java.util.List;

import tyarai.com.lom.R;
import tyarai.com.lom.model.Author;
import tyarai.com.lom.utils.csv.CsvFile;

/**
 * Created by saimon on 19/10/17.
 */
@EBean
public class ParseCsvDataManager extends DaoManager implements ParceCsvDataInterface {

    private static List<String[]> parseCsv(final Context context, int id) {
        InputStream inputStream = context.getResources().openRawResource(R.raw.authors);
        CsvFile csvFile = new CsvFile(inputStream);
        return csvFile.read();
    }


    public void parseData(final Context context) {

        for(String[] data : parseCsv(context, R.raw.authors) ) {
            try {
                Author author = new Author();
                author.setNid(Long.valueOf(data[0]));
                author.setName(data[1]);
                author.setDetail(data[2]);
                author.setPhoto(data[3]);
                getAuthorDao().create(author);
            }
            catch (NumberFormatException e) {
                e.printStackTrace();
            }
        }

        Log.d("XXXX", "countAuthor : " + getAuthorDao().countOf());

        for (Author author : getAuthorDao().queryForAll()) {
            Log.d("XXXX", "author : " + author);
        }

    }
}
