package tyarai.com.lom.model;

import com.j256.ormlite.field.DataType;
import com.j256.ormlite.field.DatabaseField;
import com.j256.ormlite.table.DatabaseTable;

@DatabaseTable(tableName = Menus.TABLE_NAME)
public class Menus extends CommonModel{
	
	public static final String TABLE_NAME = "menus";

	public static final String NAME_COL = "name";
	public static final String CONTENT_COL = "content";

	@DatabaseField(columnName = NAME_COL, dataType = DataType.STRING)
	private String name;

	@DatabaseField(columnName = CONTENT_COL, dataType = DataType.LONG_STRING)
	private String content;


	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}
}
