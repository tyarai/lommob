package tyarai.com.lom.manager;

import android.content.Context;

import tyarai.com.lom.exceptions.DbException;

/**
 * Created by saimon on 19/10/17.
 */

public interface ParceDataInterface {

    void parseData(final Context context) throws DbException;
}
