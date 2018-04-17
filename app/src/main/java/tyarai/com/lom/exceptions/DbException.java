package tyarai.com.lom.exceptions;

/**
 * Created by saimon on 13/04/18.
 */

public class DbException extends Exception {

    /**
     *
     */
    private static final long serialVersionUID = -6476177328470211309L;

    public DbException() {
        super();
        // TODO Auto-generated constructor stub
    }

    public DbException(String detailMessage, Throwable throwable) {
        super(detailMessage, throwable);
        // TODO Auto-generated constructor stub
    }

    public DbException(String detailMessage) {
        super(detailMessage);
        // TODO Auto-generated constructor stub
    }

    public DbException(Throwable throwable) {
        super(throwable);
        // TODO Auto-generated constructor stub
    }



}
