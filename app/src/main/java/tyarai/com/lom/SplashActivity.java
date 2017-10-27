package tyarai.com.lom;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;

import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.UiThread;

import tyarai.com.lom.manager.DatabaseManager;
import tyarai.com.lom.manager.ParceDataInterface;
import tyarai.com.lom.manager.ParseDataManager;
import tyarai.com.lom.views.IntroductionActivity_;

/**
 * Created by saimon on 18/10/17.
 */
@EActivity
public class SplashActivity extends AppCompatActivity {

    private static final String TAG = SplashActivity.class.getSimpleName();

    @Bean(ParseDataManager.class)
    ParceDataInterface parseCsv;


    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);

//        Thread timer= new Thread()
//        {
//            public void run()
//            {
//                try
//                {
//                    //Display for 2 seconds
//                    sleep(1000);
//                }
//                catch (InterruptedException e)
//                {
//                    e.printStackTrace();
//                }
//                finally
//                {
//                    // Start home activity
//                    startActivity(new Intent(SplashActivity.this, IntroductionActivity_.class));
//                    // close splash activity
//                    finish();
//                }
//            }
//        };
//        timer.start();
        delayedMethod();
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        delayedMethod();
    }


    @Override
    protected void onResume() {
        super.onResume();
    }



    void delayedMethod()
    {
        doInUiThreadAfterTwoSeconds();
    }

    @UiThread(delay=500)
    void doInUiThreadAfterTwoSeconds()
    {
        boolean USE_IN_MEMORY_DB = false;
        DatabaseManager.init(this, USE_IN_MEMORY_DB);
        if (!getInSharedDbState(SplashActivity.this)) {
            Snackbar.make(getWindow().getDecorView().getRootView(),
                    getString(R.string.data_loading), Snackbar.LENGTH_INDEFINITE).show();
            new DatabaseInitTask().execute();
        }
        else {
            returnResult(1);
        }
    }

    private class DatabaseInitTask extends AsyncTask<Void, Integer, Integer> {

        @Override
        protected Integer doInBackground(Void... params) {
            try {
                parseCsv.parseData(SplashActivity.this);
                SplashActivity.setInSharedDbState(SplashActivity.this);
                return 1;
            } catch (Exception e) {
                Log.e(TAG, "error init db :" + e.getMessage() );
                e.printStackTrace();
                return -1;
            }
        }

        protected void onPostExecute(Integer result) {
            returnResult(result);
        };

    }

    void returnResult(Integer result) {
        Intent returnIntent = getIntent();
        if (result != null) {
            returnIntent.putExtra("result",result);
        }
        setResult(RESULT_OK,returnIntent);
        Intent intent = new Intent(this, IntroductionActivity_.class);
        startActivity(intent);
        finish();
    }

    public static void setInSharedDbState(Context ctx) {
        SharedPreferences pref = ctx.getSharedPreferences("DB_STATE",	MODE_PRIVATE);
        SharedPreferences.Editor editor = pref.edit();
        editor.putBoolean("db_initialized", true);
        editor.commit();
    }

    public static boolean getInSharedDbState(Context ctx) {
        SharedPreferences pref = ctx.getSharedPreferences("DB_STATE",	MODE_PRIVATE);
        return pref.getBoolean("db_initialized", false);
    }

}
