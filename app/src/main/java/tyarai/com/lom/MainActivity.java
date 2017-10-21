package tyarai.com.lom;

import android.app.Activity;
import android.app.Fragment;
import android.app.FragmentManager;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.AdapterView;
import android.widget.FrameLayout;
import android.widget.ListView;
import android.widget.Toast;

import java.util.ArrayList;

import tyarai.com.lom.views.IntroductionFragment;
import tyarai.com.lom.views.IntroductionFragment_;
import tyarai.com.lom.views.OriginActivity;
import tyarai.com.lom.views.OriginActivity_;
import tyarai.com.lom.views.OriginOfLemursFragment_;
import tyarai.com.lom.views.adapter.navigation.DrawerListAdapter;
import tyarai.com.lom.views.adapter.navigation.NavItem;

public class MainActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    DrawerLayout drawer;
    ListView mDrawerList;
    ArrayList<NavItem> mNavItems = new ArrayList<NavItem>();
    DrawerListAdapter adapter;
    boolean canExit;
    CharSequence mTitle;

    protected FrameLayout frmLayout;

    static final int MENU_INTRO = 0;
    static final int MENU_ORIGIN = 1;
    static final int MENU_EXTINCT = 2;
    static final int MENU_AUTHORS = 3;
    static final int MENU_SPECIES = 4;
    static final int MENU_FAMILIES = 5;
    static final int MENU_SITES = 6;
    static final int MENU_LEMUR_LIST = 7;
    static final int MENU_POSTS = 8;
    static final int ABOUT = 9;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        frmLayout = (FrameLayout)findViewById(R.id.main_layout);
        setSupportActionBar(toolbar);

//        FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab);
//        fab.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                Snackbar.make(view, "Replace with your own action", Snackbar.LENGTH_LONG)
//                        .setAction("Action", null).show();
//            }
//        });

        drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
            this,
                drawer,
                toolbar,
                R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.setDrawerListener(toggle);
        toggle.syncState();

//        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
//        navigationView.setItemIconTintList(null);
//        navigationView.setNavigationItemSelectedListener(this);


        mNavItems.add(new NavItem(getString(R.string.introduction), "", R.drawable.ico_infos));
        mNavItems.add(new NavItem(getString(R.string.lemur_origin), "", R.drawable.origin));
        mNavItems.add(new NavItem(getString(R.string.lemur_extinct), "", R.drawable.extinct));
        mNavItems.add(new NavItem(getString(R.string.authors), "", R.drawable.author));
        mNavItems.add(new NavItem(getString(R.string.species), "101 taxa and couting", R.drawable.ico_specy));
        mNavItems.add(new NavItem(getString(R.string.families), "5 families", R.drawable.ico_families));
        mNavItems.add(new NavItem(getString(R.string.sites), "Best place to go", R.drawable.ico_map));
        mNavItems.add(new NavItem(getString(R.string.watching), "My lemur life list", R.drawable.ico_eye));
        mNavItems.add(new NavItem(getString(R.string.posts), "Online posts", R.drawable.ico_posts));
        mNavItems.add(new NavItem(getString(R.string.about), "", R.drawable.about));


        // Populate the Navigtion Drawer with options
//        mDrawerPane = (RelativeLayout) findViewById(R.id.drawerPane);
        mDrawerList = (ListView) findViewById(R.id.navList);
        adapter = new DrawerListAdapter(this, mNavItems);
        mDrawerList.setAdapter(adapter);

        // Drawer Item click listeners
        mDrawerList.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                mDrawerList.setItemChecked(position, true);
                setTitle(mNavItems.get(position).getmTitle());
                drawer.closeDrawers();
                selectItemFromDrawer(position);
            }
        });
    }

    @Override
    public void setTitle(CharSequence title) {
        mTitle = title;
        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setTitle(mTitle);
        }
    }



    private void selectItemFromDrawer(int position) {
        switch (position) {
            case MENU_INTRO:
                startFragment(new IntroductionFragment_(), null);
                break;
            case MENU_ORIGIN:
                startActivity(OriginActivity_.class);
                break;
            default:
                break;
        }

    }

    protected void startActivity(Class<?> clazz) {
        Intent intent = new Intent(this, clazz);
        startActivity(intent);
    }

    protected void startFragment(Fragment fragment, Bundle args) {
        if (args != null) {
            fragment.setArguments(args);
        }
        // Insert the fragment by replacing any existing fragment
        FragmentManager fragmentManager = getFragmentManager();
        fragmentManager.beginTransaction()
                .replace(R.id.main_layout, fragment)
                .commit();

    }

    @Override
    public void onBackPressed() {
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            if(canExit)
                super.onBackPressed();
            else{
                canExit = true;
                Toast.makeText(getApplicationContext(), getString(R.string.appquit_message), Toast.LENGTH_SHORT).show();
            }
            mHandler.sendEmptyMessageDelayed(1, 2000/*time interval to next press in milli second*/);// if not pressed within 2seconds then will be setted(canExit) as false
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        int id = item.getItemId();

        if (id == R.id.nav_introduction) {
            // Handle the camera action
        } else if (id == R.id.nav_lemur_origin) {

        } else if (id == R.id.nav_lemur_extinct) {

        } else if (id == R.id.nav_authors) {

        } else if (id == R.id.nav_species) {

        } else if (id == R.id.nav_families) {

        } else if (id == R.id.nav_watching) {

        } else if (id == R.id.nav_posts) {

        } else if (id == R.id.nav_about) {

        }


        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }



    public Handler mHandler = new Handler(){

        public void handleMessage(android.os.Message msg) {

            switch (msg.what) {
                case 1:
                    canExit = false;
                    break;
                default:
                    break;
            }
        }
    };

    public void showLoadingError() {
        Toast.makeText(this, getString(R.string.data_not_found), Toast.LENGTH_LONG).show();
    }

}
