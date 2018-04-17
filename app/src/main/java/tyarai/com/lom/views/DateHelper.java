package tyarai.com.lom.views;

import java.util.Calendar;
import java.util.Date;

/**
 * Created by saimon on 07/04/18.
 */

public class DateHelper {

    public static void clearHourPartOfDate(Calendar startingDate) {
        if (startingDate != null) {
            startingDate.set(Calendar.HOUR_OF_DAY, 0);
            startingDate.set(Calendar.MINUTE, 0);
            startingDate.set(Calendar.SECOND, 0);
            startingDate.set(Calendar.MILLISECOND, 0);
        }
    }

    public static Date clearHourPartOfDate(Date startingDate) {
        if (startingDate != null) {
            Calendar cal  = Calendar.getInstance();
            cal.setTime(startingDate);
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            cal.set(Calendar.MILLISECOND, 0);
            return cal.getTime();
        }
        return null;
    }
}
