package tyarai.com.lom.model.ormlite.config;


import android.content.Context;
import net.sqlcipher.SQLException;
import net.sqlcipher.Cursor;
import net.sqlcipher.database.SQLiteDatabase;
import android.util.Log;

import com.j256.ormlite.cipher.android.apptools.OrmLiteSqliteOpenHelper;
import com.j256.ormlite.dao.RuntimeExceptionDao;
import com.j256.ormlite.support.ConnectionSource;
import com.j256.ormlite.table.TableUtils;

import tyarai.com.lom.model.Author;
import tyarai.com.lom.model.Family;
import tyarai.com.lom.model.Illustration;
import tyarai.com.lom.model.Links;
import tyarai.com.lom.model.Maps;
import tyarai.com.lom.model.Menus;
import tyarai.com.lom.model.Photograph;
import tyarai.com.lom.model.Specie;
import tyarai.com.lom.model.WatchingSite;


public class DataBaseHelper extends OrmLiteSqliteOpenHelper {
	
	public static String TAG = DataBaseHelper.class.getSimpleName(); 

    // DB CONFIG
    public static int DB_VERSION = 1;


    public static String DB_NAME = "lom_db";

    private static DataBaseHelper sInstance;
    
    private static final String BOOLEAN_TYPE 	= "SMALLINT";
    private static final String SHORT_TYPE 		= "SMALLINT";
    private static final String STRING_TYPE 	= "VARCHAR";
    private static final String DATE_TYPE 		= "BIGINT";
    private static final String FLOAT_TYPE 		= "FLOAT";
    private static final String LONG_TYPE 		= "BIGINT";
    private static final String LIST_TYPE 		= "BLOB";    
    private static final String INTEGER_TYPE 	= "INTEGER";
    

    public static void init(Context context, boolean isInMemory) {    	
        sInstance = new DataBaseHelper(context, isInMemory);        
    }

    public static DataBaseHelper getInstance() {
        if (sInstance == null) {
            throw new InstantiationError();        	
        }
        return sInstance;
    }
    
    public int getDbVersion() {
    	return getReadableDatabase(getPassword()).getVersion();
    }

    private DataBaseHelper(Context context, boolean isInMemory) {    	
        
    	super(context, (isInMemory ? null : DB_NAME), null, DB_VERSION,
    			DataBaseHelper.class.getResourceAsStream("ormlite_config.txt")); //R.raw.ormlite_config //0x7f00000
    }

	@Override
	public void onCreate(SQLiteDatabase db, ConnectionSource connectionSource) {
		try {
			TableUtils.createTable(connectionSource, Menus.class);
			TableUtils.createTable(connectionSource, Author.class);
			TableUtils.createTable(connectionSource, Family.class);
			TableUtils.createTable(connectionSource, Illustration.class);
			TableUtils.createTable(connectionSource, Links.class);
			TableUtils.createTable(connectionSource, Maps.class);
			TableUtils.createTable(connectionSource, Photograph.class);
			TableUtils.createTable(connectionSource, Specie.class);
			TableUtils.createTable(connectionSource, WatchingSite.class);

		} catch (SQLException e) {
			Log.e(DataBaseHelper.class.getName(), "Can't create database", e);
			throw new RuntimeException(e);
		} catch (java.sql.SQLException e) {
			e.printStackTrace();
		}
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, ConnectionSource connectionSource,
			int oldVersion, int newVersion) {
		
//		try {
//
//
//			RuntimeExceptionDao<Menus, Long> queryDao = getRDao(Menus.class);
//
//			if (oldVersion < 2) {
//
//			}
//
//
//		} catch (java.sql.SQLException e) {
//			Log.e(DataBaseHelper.class.getName(), "Can't handle databases updates", e);
//			throw new RuntimeException(e); // TODO à tester et traiter cette connerie hein, don't put it there for the fun
//		}
		
	}

	@Override
	protected String getPassword() {
		return "tgiploj88.+";
	}


	private void dropColumn(SQLiteDatabase db, final String tableName, final String columnName, final RuntimeExceptionDao<Menus, Long> queryDao)
	{
		if (existsColumnInTable(db, tableName, columnName)) {
			Log.d(TAG, "dropping column " + tableName + "." + columnName);
			int numRowsAffected = queryDao.executeRaw("ALTER TABLE "  + tableName + " DROP COLUMN '" + columnName + ";" );
			Log.d(TAG, "numRowsAffected :" + numRowsAffected);
		}
	}
	
	
	private void addColumn(SQLiteDatabase db, final String tableName, final String columnName, final String columnType, final RuntimeExceptionDao<Menus, Long> queryDao) 
	{
		if (!existsColumnInTable(db, tableName, columnName)) {
			Log.d(TAG, "adding column " + tableName + "." + columnName);
			int numRowsAffected = queryDao.executeRaw("ALTER TABLE "  + tableName + " ADD COLUMN '" + columnName + "' " +  columnType  + ";" );
			Log.d(TAG, "numRowsAffected :" + numRowsAffected);
		}
	}

	
	private boolean existsColumnInTable(SQLiteDatabase inDatabase, String inTable, String columnToCheck) {

		Cursor mCursor = null;
		boolean isExist = true;
		try {
			mCursor = inDatabase.rawQuery("PRAGMA table_info("+inTable+")",null);
			int value = mCursor.getColumnIndex(columnToCheck);
			
			Log.d(TAG, inTable + "." + columnToCheck + " => exists = " + value);

			if(value == -1)
			{
				isExist = false;
			}

		} catch (Exception Exp) {			
			Log.d(TAG, "existsColumnInTable when checking whether a column exists in the table, an error occurred: " + Exp.getMessage());
			isExist = false;
		} finally {
			if (mCursor != null) mCursor.close();
		}

		return isExist;
	}

	private <T> RuntimeExceptionDao<T, Long> getRDao(Class<T> clazz) {
		return getInstance().getRuntimeExceptionDao(clazz);
	}
	
	
	
}

