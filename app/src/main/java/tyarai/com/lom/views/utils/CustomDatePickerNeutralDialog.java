package tyarai.com.lom.views.utils;

import android.app.DatePickerDialog;
import android.content.Context;

public class CustomDatePickerNeutralDialog extends DatePickerDialog {

    public CustomDatePickerNeutralDialog(Context context, OnDateSetListener callBack,
                            int year, int monthOfYear, int dayOfMonth) {
    	
        super(context, 0, callBack, year, monthOfYear, dayOfMonth);

        setButton(BUTTON_POSITIVE, ("Ok"), this);
        setButton(BUTTON_NEUTRAL, ("Effacer"), this); // ADD THIS
        setButton(BUTTON_NEGATIVE, ("Annuler"), this);
        
    }
}

