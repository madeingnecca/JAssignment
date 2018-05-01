package model;

import de.hunsicker.jalopy.Jalopy;


public class JavaFormatter extends Formatter {

    @Override
    public String format(String src) {
        String theCode;
        try {
            theCode = src;
            Jalopy formatter = new Jalopy();
            StringBuffer output = new StringBuffer();
            formatter.setInput(theCode, "");
            formatter.setOutput(output);
            formatter.format();
            theCode = output.toString();
            if ( formatter.getState() == Jalopy.State.ERROR )
                theCode = src;
        } catch ( Exception e ) {
            theCode = src;
        }

        return theCode;
    }

}
