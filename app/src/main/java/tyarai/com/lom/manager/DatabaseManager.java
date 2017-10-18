package tyarai.com.lom.manager;

import tyarai.com.lom.model.ormlite.config.DataBaseHelper;

import android.content.Context;

public class DatabaseManager {
	
	public static enum Task {
        CREATE_DB, INIT_DATA;
    }

	static private DatabaseManager instance;
	

	static public void init(Context ctx, boolean isInMemory) {
		if (null==instance) {
			instance = new DatabaseManager(ctx, isInMemory);
		}
	}

	static public DatabaseManager getInstance() {
		return instance;
	}

	private DataBaseHelper helper;
	
	private DatabaseManager(Context ctx, boolean isInMemory) {
		DataBaseHelper.init(ctx, isInMemory);
		helper = DataBaseHelper.getInstance();
	}	
	

	protected DataBaseHelper getHelper() {
		return helper;
	}	
	
	
	
}
