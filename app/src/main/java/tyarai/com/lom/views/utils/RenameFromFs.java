package tyarai.com.lom.views.utils;

import java.io.File;

/**
 * Created by saimon on 23/10/17.
 * Renames the file on fs, code is different when renaming from db
 * because db returns html equivalence on filename
 */
public class RenameFromFs {

    public static void main(String[] args) {
        String bd = "/mnt/teralinux/home/AndroidStudioProjects/LOM/app/src/main/res-photo/drawable/";
        //String bd = "/mnt/teralinux/data/LOM/test/";
        File dir = new File(bd);

        
        if (dir.isDirectory()) { // make sure it's a directory
            for (final File f : dir.listFiles()) {           
            
                try {
                    File newfile =new File(bd + renameF(f.getName()));
                    f.renameTo(newfile);                                       
                } catch (Exception e) {                    
                    e.printStackTrace();
                }            

            }
        }
        
             
        //System.out.println(renameF("CheirogaleusP&amp;B"));
        
    }    
    public static String renameF(String fname) {        
            return "z_" + fname.replaceAll("[^a-zA-Z0-9//]", "_").replace("_jpg", ".jpg").toLowerCase();
        
    }
}
