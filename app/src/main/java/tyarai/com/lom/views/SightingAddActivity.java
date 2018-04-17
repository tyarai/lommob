package tyarai.com.lom.views;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.location.Location;
import android.location.LocationListener;
import android.location.LocationManager;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Bundle;
import android.os.Environment;
import android.provider.MediaStore;
import android.support.annotation.Nullable;
import android.support.design.widget.Snackbar;
import android.support.v7.app.ActionBar;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Log;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.TextView;

import org.androidannotations.annotations.AfterViews;
import org.androidannotations.annotations.Bean;
import org.androidannotations.annotations.Click;
import org.androidannotations.annotations.EActivity;
import org.androidannotations.annotations.ViewById;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import tyarai.com.lom.R;
import tyarai.com.lom.data.InfoImageDto;
import tyarai.com.lom.data.SightingDto;
import tyarai.com.lom.exceptions.DbException;
import tyarai.com.lom.manager.SightingManager;
import tyarai.com.lom.manager.SightingManagerImpl;
import tyarai.com.lom.views.utils.DateDialogAction;
import tyarai.com.lom.views.utils.ViewUtils;

/**
 * Created by saimon on 23/10/17.
 */
@EActivity(R.layout.sightings_add)
public class SightingAddActivity extends AppCompatActivity {

    private static final String TAG = SightingAddActivity.class.getSimpleName();

    public static final String EXTRA_SIGHTING = "sighting";
    private static final int REQUEST_SPECIE = 10;
    private static final int REQUEST_SITE = 20;

    @Bean(SightingManagerImpl.class)
    SightingManager sightingManager;

    @ViewById(R.id.sighting_choosespecies_btn)
    Button btnSelectSpecie;

    @ViewById(R.id.sighting_species_title)
    TextView txtSpecieTitle;
    @ViewById(R.id.sighting_species_trans)
    TextView txtSpecieTrans;
    Long specieId = -1L;

    @ViewById(R.id.sighting_sighting_title)
    TextView txtSiteTitle;
    Long siteId = -1L;

    @ViewById(R.id.sighting_image)
    ImageView sightingImage;

    @ViewById(R.id.sighting_chooseplace_btn)
    Button btnSelectSite;

    @ViewById(R.id.sighting_date_observation)
    EditText txtObservationDate;

    @ViewById(R.id.sighting_number_observed)
    EditText txtNumberObserved;

    @ViewById(R.id.sighting_longitude)
    EditText txtLongitude;

    @ViewById(R.id.sighting_latitude)
    EditText txtLatitude;

    @ViewById(R.id.sighting_altitude)
    EditText txtAltitude;

    @ViewById(R.id.sighting_setlocation_btn)
    Button btnSetLocationCoordinates;
    boolean capturingLocation = false;

    @ViewById(R.id.sighting_title)
    EditText txtTitle;

    LocationManager locationManager;
    SightingDto sightingDto = null;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Bundle extras = getIntent().getExtras();
        if (extras != null) {
            sightingDto = extras.getParcelable(EXTRA_SIGHTING);
        }
        ActionBar actionBar = getSupportActionBar();
        if (actionBar != null) {
            actionBar.setTitle(sightingDto == null || sightingDto.getId()==0 ? getString(R.string.sighting_add) : getString(R.string.edit_sighting));
            actionBar.setDisplayHomeAsUpEnabled(true);
        }
        this.overridePendingTransition(R.anim.activity_start_animation,
                R.anim.activity_end_animation);

        locationManager = (LocationManager) getSystemService(Context.LOCATION_SERVICE);
    }



    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        prepareData();
        outState.putParcelable(EXTRA_SIGHTING, sightingDto);
    }

    @AfterViews
    void initData() {

        if (sightingDto != null) {
            if (sightingDto != null) {
                txtLongitude.setText(ViewUtils.getStringValue(sightingDto.getLongitude()));
                txtLatitude.setText(ViewUtils.getStringValue(sightingDto.getLatitude()));
                txtAltitude.setText(ViewUtils.getStringValue(sightingDto.getAltitude()));
                txtNumberObserved.setText(ViewUtils.getStringValue(sightingDto.getNumberObserved()));
                txtSiteTitle.setText(ViewUtils.getStringValue(sightingDto.getWatchingSiteTitle()));
                siteId = sightingDto.getWatchingSiteId();
                if (sightingDto.getSpecieId() != null) {
                    txtSpecieTitle.setText(ViewUtils.getStringValue(sightingDto.getSpecieName()));
                    txtSpecieTitle.setVisibility(View.VISIBLE);
                    txtSpecieTrans.setText(ViewUtils.getStringValue(sightingDto.getSpecieTrans()));
                    txtSpecieTrans.setVisibility(View.VISIBLE);
                }
                specieId = sightingDto.getSpecieId();
                txtTitle.setText(ViewUtils.getStringValue(sightingDto.getTitle()));
                infoImageDto = sightingDto.getPhoto();
                if (sightingDto.getPhoto() != null && !TextUtils.isEmpty(sightingDto.getPhoto().getImageRaw())) {
                    byte[] decodedString = Base64.decode(sightingDto.getPhoto().getImageRaw(), Base64.DEFAULT);
                    Bitmap decodedByte = BitmapFactory.decodeByteArray(decodedString, 0, decodedString.length);
                    if (decodedByte != null) {
                        sightingImage.setImageBitmap(decodedByte);
                    }
                }
                else {
                    sightingImage.setImageBitmap(null);
                }
            }
        }

//        Log.d(TAG, "mapfilename ::: " + siteImagePath);
//        final int resourceImage = getResources().getIdentifier(RenameFromDb.renameFNoExtension(siteImagePath), "drawable", getPackageName());
//        if (resourceImage != 0) {
//                Glide.with(this)
//                        .load(resourceImage)
//                        .into(imageView);
//        }
//        descriptionView.setText(siteDesc);
//
//        imageView.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                Intent intent = new Intent(SightingAddActivity.this, FullScreenImageActivity.class);
//                intent.putExtra(FullScreenImageActivity.NAME, siteName);
//                intent.putExtra(FullScreenImageActivity.IMAGE_URL, resourceImage);
//                startActivity(intent);
//            }
//        });

        btnSelectSpecie.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(SightingAddActivity.this, SpecieListActivity_.class);
                startActivityForResult(intent, REQUEST_SPECIE);
            }
        });

        btnSelectSite.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent intent = new Intent(SightingAddActivity.this, SiteListActivity_.class);
                startActivityForResult(intent, REQUEST_SITE);
            }
        });

        txtObservationDate.setOnClickListener(new DateDialogAction(sightingDto == null ? new Date() : sightingDto.getObservationDate(), new Date()) {
            @Override
            protected Context getContext() {
                return SightingAddActivity.this;
            }

            @Override
            protected EditText getTxtDate() {
                return txtObservationDate;
            }
        });

        btnSetLocationCoordinates.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!capturingLocation) {
                    capturingLocation = true;
                    resetLocationValues();
                    btnSetLocationCoordinates.setText(getString(R.string.stop_location));
                    initGeoCoords();
                }
                else {
                    ViewUtils.stopLocationUpdates(SightingAddActivity.this, locationListener);
                    btnSetLocationCoordinates.setText(getString(R.string.sighting_setlocation));
                    capturingLocation = false;
                    locationManager.removeUpdates(locationListener);
                    locationListener = null;
                }
            }
        });

    }

    void resetLocationValues() {
        txtLatitude.setText("");
        txtAltitude.setText("");
        txtLongitude.setText("");
    }

    RadioGroup radioPhoto;
    RadioButton radioButton;
    AlertDialog dialog = null;
    final int CAPTURE_IMAGE = 0;
    final int CHOOSE_FILE = 1;
    String path;

    @Click(R.id.sighting_take_image_btn)
    public void takePicture() {

        if (path == null) {
            File filePath = new File(Environment.getExternalStorageDirectory(), "LOM");
            if (!filePath.exists()) {
                filePath.mkdirs();
            }
            path = filePath.getAbsolutePath() + "/sighting_image.jpg";
        }

        if (dialog == null) {

            final View baseDialogContentView = getLayoutInflater().inflate(R.layout.dialog_photo, null);

            dialog = new AlertDialog.Builder(this)
                    .setView(baseDialogContentView)
                    .setTitle(getString(R.string.load_image))
                    .setPositiveButton(getString(R.string.yes), new DialogInterface.OnClickListener() {
                        public void onClick(DialogInterface dialog, int id) {

                            radioPhoto = (RadioGroup) baseDialogContentView.findViewById(R.id.radioPhoto);

                            int selectedId = radioPhoto.getCheckedRadioButtonId();

                            // find the radiobutton by returned id
                            radioButton = (RadioButton) baseDialogContentView.findViewById(selectedId);
                            if (radioButton.getText().equals(
                                    getString(R.string.take_pict))) {
                                startCameraActivity();
                            } else {
                                startChooseFileActivity();
                            }

                            //dialog.dismiss();
                        }
                    })
                    .create();

        }

        dialog.show();

    }

    protected void startChooseFileActivity() {
        Intent i = new Intent(Intent.ACTION_PICK, MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        startActivityForResult(i, CHOOSE_FILE);
    }

    protected void startCameraActivity() {
        // Log message

        // Create new file with name mentioned in the path variable
        Log.d("path >>>", "path" + path);
        File file = new File(path);
        // Creates a Uri from a file
        Uri outputFileUri = Uri.fromFile(file);
        // Standard Intent action that can be sent to have the
        // camera application capture an image and return it.
        // You will be redirected to camera at this line
        Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);
        // Add the captured image in the path
        intent.putExtra(MediaStore.EXTRA_OUTPUT, outputFileUri);
        // Start result method - Method handles the output
        // of the camera activity
        startActivityForResult(intent, CAPTURE_IMAGE);
    }

    boolean imgCapFlag = false;
    boolean taken;
    InfoImageDto infoImageDto;
    Bitmap bitmap = null;

    protected void onPhotoTaken() {

        // Flag used by Activity life cycle methods
        taken = true;
        // Flag used to check whether image captured or not
        imgCapFlag = true;
        // BitmapFactory- Create an object
        BitmapFactory.Options options = new BitmapFactory.Options();
        // Set image size
        options.inSampleSize = 4;
        // Read bitmap from the path where captured image is stored
        bitmap = BitmapFactory.decodeFile(path, options);
        fitProfilImage(path);

    }

    private void drawMatrix(float rotate) {

        Matrix matrix = new Matrix();
        matrix.postRotate(rotate);

        Bitmap resizedBitmap = Bitmap.createBitmap(bitmap, 0, 0,
                bitmap.getWidth(), bitmap.getHeight(), matrix, true);
        bitmap = resizedBitmap;
//        sightingImage.setImageBitmap(getResizedBitmap(resizedBitmap, 350, 300));
        sightingImage.setImageBitmap(bitmap);
    }

    private void fitProfilImage(String m_path) {
        ExifInterface ei;
        try {
            ei = new ExifInterface(m_path);

            int orientation = ei.getAttributeInt(ExifInterface.TAG_ORIENTATION,
                    ExifInterface.ORIENTATION_NORMAL);

            switch (orientation) {
                case ExifInterface.ORIENTATION_ROTATE_90:
                    drawMatrix(90F);
                    break;
                case ExifInterface.ORIENTATION_ROTATE_180:
                    drawMatrix(180F);
                    break;
                case ExifInterface.ORIENTATION_ROTATE_270:
                    drawMatrix(270F);
                    break;
                default:
                    if (bitmap != null) {
                        sightingImage.setPadding(0, 0, 0, 0);
//                        sightingImage.setImageBitmap(getResizedBitmap(bitmap, 300, 300));
                        sightingImage.setImageBitmap(bitmap);
                    }
                    break;
            }

        } catch (IOException e) {
            e.printStackTrace();
        }

    }

    Bitmap getResizedBitmap(Bitmap bm, int newHeight, int newWidth) {

        int width = bm.getWidth();

        int height = bm.getHeight();

        float scaleWidth = ((float) newWidth) / width;

        float scaleHeight = ((float) newHeight) / height;

        // create a matrix for the manipulation

        Matrix matrix = new Matrix();

        // resize the bit map

        matrix.postScale(scaleWidth, scaleHeight);

        // recreate the new Bitmap

        Bitmap resizedBitmap = Bitmap.createBitmap(bm, 0, 0, width, height,
                matrix, false);

        return resizedBitmap;

    }

    byte[] convertBitmapToByte(Bitmap bm) {

        Bitmap bmp = getResizedBitmap(bm, 300, 300);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        bmp.compress(Bitmap.CompressFormat.JPEG, 100, baos); // bm is the bitmap
        // object
        byte[] b = baos.toByteArray();
        return b;
    }

    String encodingImageToBase64(byte[] b) {

        String encodedImage = Base64.encodeToString(b, Base64.DEFAULT);
        return encodedImage;
    }

    String imgbase64;
    String base[];
    String imgfilename;
    InfoImageDto initInfoImageDto() {
        if (bitmap != null) {
            byte[] imgbyte = convertBitmapToByte(bitmap);
            imgbase64 = encodingImageToBase64(imgbyte);
            base = imgbase64.split(",");
            String arr[] = path.split("/");
            imgfilename = arr[arr.length - 1];
            infoImageDto = new InfoImageDto();
            infoImageDto.setFilename(imgfilename);
            infoImageDto.setImageRaw(base[0]);
        }
        return infoImageDto;
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        switch(requestCode) {
            case (REQUEST_SPECIE) : {
                if (resultCode == Activity.RESULT_OK) {
                    specieId = data.getLongExtra(SpeciesListFragment.SPECIE_ID, -1);
                    String returnTitle = data.getStringExtra(SpeciesListFragment.SPECIE_TITLE);
                    txtSpecieTitle.setVisibility(View.VISIBLE);
                    txtSpecieTitle.setText(returnTitle);
                    String returnTrans = data.getStringExtra(SpeciesListFragment.SPECIE_TRANS);
                    txtSpecieTrans.setText(returnTrans);
                    txtSpecieTrans.setVisibility(View.VISIBLE);
                }
                else if (resultCode == SpeciesListFragment.RESULT_BOO) {
                    specieId = -1L;
                    txtSpecieTitle.setText("");
                    txtSpecieTrans.setText("");
                }
                break;
            }
            case (REQUEST_SITE) : {
                if (resultCode == Activity.RESULT_OK) {
                    siteId = data.getLongExtra(WatchingSiteListFragment.SITE_ID, -1);
                    String returnTitle = data.getStringExtra(WatchingSiteListFragment.SITE_TITLE);
                    txtSiteTitle.setVisibility(View.VISIBLE);
                    txtSiteTitle.setText(returnTitle);
                }
                else if (resultCode == WatchingSiteListFragment.RESULT_BOO) {
                    siteId = -1L;
                    txtSiteTitle.setText("");
                }
                break;
            }
            case CAPTURE_IMAGE:
                onPhotoTaken();
                initInfoImageDto();
                break;

            case CHOOSE_FILE:
                if (null != data) {
                    Uri selectedImage = data.getData();
                    String[] filePathColumn = { MediaStore.Images.Media.DATA };

                    Cursor cursor = this.getContentResolver().query(selectedImage, filePathColumn, null, null, null);
                    cursor.moveToFirst();

                    int columnIndex = cursor.getColumnIndex(filePathColumn[0]);
                    path = cursor.getString(columnIndex);
                    cursor.close();

                    bitmap = BitmapFactory.decodeFile(path);
                    // imvPhoto.setImageBitmap(getResizedBitmap(bitmap,350,300));

                    fitProfilImage(path);
                    initInfoImageDto();
                }
                break;

        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        MenuInflater inflater = getMenuInflater();
        inflater.inflate(R.menu.save_menu, menu);
        return super.onCreateOptionsMenu(menu);
    }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        int id = item.getItemId();
        switch (id) {
            case android.R.id.home:
                onBackPressed();
                return true;
            case R.id.action_save :
                prepareData();
                insertData(sightingDto);
                return true;
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onBackPressed() {

        new AlertDialog.Builder(this)
                .setMessage(getString(R.string.confirm_quit_page))
                .setPositiveButton(android.R.string.ok, new DialogInterface.OnClickListener() {

                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        SightingAddActivity.this.finish();
                    }
                })
                .setNegativeButton(R.string.cancelit, new DialogInterface.OnClickListener() {

                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        // TODO Auto-generated method stub
                    }
                })
                .create()
                .show()
        ;
    }

    private LocationListener locationListener;
    private  void initGeoCoords() {
        ViewUtils.initGeoCoords(this, locationManager, getLocationListener());
    }

    private LocationListener getLocationListener() {
        if (locationListener == null) {
            locationListener = new LocationListener() {
                @Override
                public void onLocationChanged(Location location) {
                    Log.d(TAG, "onlocationChanged an");
                    if (location != null)
                    {
                        txtLatitude.setText(ViewUtils.getStringValue(location.getLatitude()));
                        txtLongitude.setText(ViewUtils.getStringValue(location.getLongitude()));
                        txtAltitude.setText(ViewUtils.getStringValue(location.getAltitude()));
                    }
                    else {
                        Log.d(TAG, "onlocationChanged null retour");
                        resetLocationValues();
                    }
                    ViewUtils.stopLocationUpdates(SightingAddActivity.this, locationListener);
                    btnSetLocationCoordinates.setText(getString(R.string.sighting_setlocation));
                }

                @Override
                public void onStatusChanged(String provider, int status, Bundle extras) {
                    Log.d(TAG, "onStatusChanged");
                }

                @Override
                public void onProviderEnabled(String provider) {
                    Log.d(TAG, "onProviderEnabled");
                }

                @Override
                public void onProviderDisabled(String provider) {
                    Log.d(TAG, "onProviderDisabled");
                }
            };
        }
        return locationListener;
    }


    @Override
    public void onRequestPermissionsResult(int requestCode,
                                           String permissions[], int[] grantResults) {
        switch (requestCode) {
            case 11: {
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0
                        && grantResults[0] == PackageManager.PERMISSION_GRANTED) {

                    // permission was granted, yay!
//                    if (dataToEdit == null) {
                        initGeoCoords();
//                    }
                }
                else {
                    // permission denied, boo! Disable the
                    // functionality that depends on this permission.
                }
                return;
            }

            // other 'case' lines to check for other
            // permissions this app might request
        }
    }



    void prepareData() {
        try {
            if (sightingDto == null) {
                sightingDto = new SightingDto();
            }
            sightingDto.setAltitude(ViewUtils.getFloatValue(txtAltitude));
            sightingDto.setLatitude(ViewUtils.getFloatValue(txtLatitude));
            sightingDto.setLongitude(ViewUtils.getFloatValue(txtLongitude));
            sightingDto.setNumberObserved(ViewUtils.getIntValue(txtNumberObserved));
            sightingDto.setPhoto(infoImageDto);
            sightingDto.setTitle(txtTitle.getText().toString());
            sightingDto.setObservationDate(ViewUtils.getDateValue(txtObservationDate));
            sightingDto.setSpecieId(specieId);
            sightingDto.setSpecieName(txtSpecieTitle.getText().toString());
            sightingDto.setSpecieTrans(txtSpecieTrans.getText().toString());
            sightingDto.setWatchingSiteTitle(txtSiteTitle.getText().toString());
            sightingDto.setWatchingSiteId(siteId);
            sightingDto.setLastModifiedOnTablet(new Date());
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    AlertDialog validationDialog;
    AlertDialog getValidationDialog(List<String> validationMessages) {
        if (validationDialog == null) {
            validationDialog = new AlertDialog.Builder(this)
                    .setTitle(getString(R.string.invalidData))
                    .setMessage(ViewUtils.convertToStringOnePerLine(validationMessages))
                    .setNegativeButton(getString(R.string.closeit), null)
                    .create();
        }
        else {
            validationDialog.setMessage(ViewUtils.convertToStringOnePerLine(validationMessages));
        }
        return validationDialog;
    }

    void insertData(SightingDto data) {

        if (data == null) {
            Snackbar.make(btnSelectSite, getString(R.string.save_failed), Snackbar.LENGTH_LONG).show();
            return;
        }

        List<String> validationMessages = new ArrayList<>();
        if (sightingDto.getSpecieId() == null || sightingDto.getSpecieId() <=0) {
            validationMessages.add(getString(R.string.v_specie_req));
        }
        if (sightingDto.getWatchingSiteId() == null || sightingDto.getWatchingSiteId() <=0) {
            validationMessages.add(getString(R.string.v_site_req));
        }
        if (TextUtils.isEmpty(sightingDto.getTitle())) {
            validationMessages.add(getString(R.string.v_desc_req));
        }
        if (sightingDto.getPhoto() == null || TextUtils.isEmpty(sightingDto.getPhoto().getImageRaw())) {
            validationMessages.add(getString(R.string.v_photo_req));
        }

        if (validationMessages.isEmpty()) {
            try {
                if (data.getId() == 0) {
                    sightingManager.createSighting(data);
                }
                else {
                    sightingManager.updateSighting(data);
                }
                setResult(RESULT_OK);
                this.finish();
            } catch (DbException e) {
                e.printStackTrace();
                final Snackbar sn = Snackbar.make(btnSelectSite, getString(R.string.save_failed), Snackbar.LENGTH_LONG);
                sn.setAction("OK", new View.OnClickListener() {
                            @Override
                            public void onClick(View v) {
                                sn.dismiss();
                            }
                        }
                );
                sn.show();
            }
        }
        else {
            getValidationDialog(validationMessages).show();
        }


    }



}
