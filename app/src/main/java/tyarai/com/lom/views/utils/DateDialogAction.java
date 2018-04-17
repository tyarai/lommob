package tyarai.com.lom.views.utils;

import android.app.AlertDialog;
import android.app.DatePickerDialog;
import android.content.Context;
import android.text.InputType;
import android.view.View;
import android.widget.DatePicker;
import android.widget.EditText;

import tyarai.com.lom.views.DateHelper;

import java.util.Calendar;
import java.util.Date;

/**
 * Created by saimon on 27/05/17.
 */
public abstract class DateDialogAction implements View.OnClickListener {

    protected  abstract Context getContext();

    protected abstract EditText getTxtDate();

    protected void onPositiveButtonClicked() {};

    protected void onNegativeButtonClicked() {};



    Date initialDate;
    Date maxDate;
    Calendar newCalendar = Calendar.getInstance();
    CustomDatePickerClearDialog dateDpd;

    public DateDialogAction() {
        super();
    }

    public DateDialogAction(Date initialDate, final Date maxDate) {
        super();
        this.initialDate = initialDate;
        this.maxDate = maxDate;
        getTxtDate().setInputType(InputType.TYPE_NULL);
        getTxtDate().setFocusable(false);
        if (initialDate != null) {
            newCalendar.setTime(initialDate);
            getTxtDate().setText(ViewUtils.dateFormatterSemiShortDash.format(initialDate));
        } else {
            getTxtDate().setText("");
        }
    }


    @Override
    public void onClick(View view) {
        getDateDpd().show();
        if (getTxtDate() != null) {
            Calendar c = Calendar.getInstance();
            Date dateValue = ViewUtils.getDateValue(getTxtDate());
            if (dateValue != null) {
                c.setTime(dateValue);
            }
            getDateDpd().getDatePicker().updateDate(c.get(Calendar.YEAR), c.get(Calendar.MONTH), c.get(Calendar.DATE));
        }
        dateDpd.getButton(AlertDialog.BUTTON_NEGATIVE).setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        dateDpd.dismiss();
                        onNegativeButtonClicked();
                    }
                });
        dateDpd.getButton(AlertDialog.BUTTON_POSITIVE).setOnClickListener(
                new View.OnClickListener() {
                    @Override
                    public void onClick(View view) {
                        dateDpd.dismiss();
                        getTxtDate().setText(ViewUtils.dateFormatterSemiShortDash.format(ViewUtils.getDateFromDatePicker(dateDpd.getDatePicker())));
                        onPositiveButtonClicked();
                    }
                });
//        ViewUtils.initDialog(dateDpd);
    }

    CustomDatePickerClearDialog getDateDpd() {
        if (dateDpd == null) {
            dateDpd = new CustomDatePickerClearDialog(getContext(), new DatePickerDialog.OnDateSetListener() {

                public void onDateSet(DatePicker view, int year, int monthOfYear, int dayOfMonth) {
                    // nothing to do
                }

            },newCalendar.get(Calendar.YEAR), newCalendar.get(Calendar.MONTH), newCalendar.get(Calendar.DAY_OF_MONTH));
            if (maxDate != null) {
                Calendar cc = Calendar.getInstance();
                cc.setTime(maxDate);
                cc.add(Calendar.DATE, 1);
                dateDpd.getDatePicker().setMaxDate(DateHelper.clearHourPartOfDate(cc.getTime()).getTime());
            }
        }
        return dateDpd;
    }

}
