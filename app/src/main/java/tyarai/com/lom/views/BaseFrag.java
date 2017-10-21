package tyarai.com.lom.views;

import android.app.Fragment;
import android.widget.Toast;

import tyarai.com.lom.R;

/**
 * Created by saimon on 21/10/17.
 */

public class BaseFrag extends Fragment {

    public void showLoadingError() {
        Toast.makeText(getActivity(), getString(R.string.data_not_found), Toast.LENGTH_LONG).show();
    }
}
