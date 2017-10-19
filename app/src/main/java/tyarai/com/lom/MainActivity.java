package tyarai.com.lom;

import android.os.Bundle;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.view.View;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.AdapterView;
import android.widget.ListView;

import java.util.ArrayList;

import tyarai.com.lom.views.adapter.navigation.DrawerListAdapter;
import tyarai.com.lom.views.adapter.navigation.NavItem;

public class MainActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    DrawerLayout drawer;
    ListView mDrawerList;
    ArrayList<NavItem> mNavItems = new ArrayList<NavItem>();
    DrawerListAdapter adapter;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
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
                selectItemFromDrawer(position);
            }
        });
    }


    private void selectItemFromDrawer(int position) {
        drawer.closeDrawers();
    }

    @Override
    public void onBackPressed() {
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
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
}
