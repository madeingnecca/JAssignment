/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
/**
 *
 * @author Dax
 */
public class Util {

    public static void writeToFile(File f, String content) throws IOException {
        FileOutputStream fop = new FileOutputStream(f);
        fop.write(content.getBytes());
        fop.flush();
        fop.close();
    }

    static public boolean deleteDirectory(File path) {
        if (path.exists()) {
            File[] files = path.listFiles();
            for (int i = 0; i < files.length; i++) {
                if (files[i].isDirectory()) {
                    deleteDirectory(files[i]);
                } else {
                    files[i].delete();
                }
            }
        }
        return (path.delete());
    }
    
public static String htmlEntityDecode(String s) {
	
	int i = 0, j = 0, pos = 0;
	StringBuffer sb = new StringBuffer();
	while ((i = s.indexOf("&#", pos)) != -1 && (j = s.indexOf(';', i)) != -1) {
	    int n = -1;
	    for (i += 2; i < j; ++i) {
		char c = s.charAt(i);
		if ('0' <= c && c <= '9')
		    n = (n == -1 ? 0 : n * 10) + c - '0';
		else
		    break;
	    }
	    if (i != j)	n = -1;	    // malformed entity - abort
	    if (n != -1) {
		sb.append((char)n);
		i = j + 1;	    // skip ';'
	    }
	    else {
		for (int k = pos; k < i; ++k)
		    sb.append(s.charAt(k));
	    }
	    pos = i;
	}
	if (sb.length() == 0)
	    return s;
	else
	    sb.append(s.substring(pos, s.length()));
	return sb.toString();
	
    }
    
    
    public static String calculateDelay(long ms) {
        String delay = "";
        
        String[] singulars = new String[] { "giorno","ora","minuto","secondo" };
        String[] plurals = new String[] { "giorni","ore","minuti","secondi" };
        
        long[] factors = new long[]{1000 * 3600 * 24, 1000 * 3600, 1000 * 60, 1000};
        for (int i = 0; i < factors.length; i++) {
            int i_delay = (int) (ms / factors[i]);
            if (i_delay >= 1) {
                delay += " " + i_delay + " ";
                
                if ( i_delay == 1 )
                    delay += singulars[ i ];
                else
                    delay += plurals[ i ];
                
                ms = ms % factors[i];
            }
        }
        return delay;
    }
    
    
    private static String MY_FORMAT = "dd/MM/yyyy HH:mm";
    
    public static String dateToString(Date date) {
        
        if ( date == null ) return "???";
        
        SimpleDateFormat formatter = new SimpleDateFormat(MY_FORMAT);
        return formatter.format(date);
    }

    public static Date stringToDate(String date ) {
        SimpleDateFormat formatter = new SimpleDateFormat(MY_FORMAT);
        Date dataConvertita = null;
        try {
            dataConvertita = formatter.parse(date);
        } catch (ParseException e) {
        }
        return dataConvertita;
    }

    public static String stringToHTMLString(String string) {
        StringBuffer sb = new StringBuffer(string.length());
        // true if last char was blank
        boolean lastWasBlankChar = false;
        int len = string.length();
        char c;

        for (int i = 0; i < len; i++) {
            c = string.charAt(i);
            if (c == ' ') {
                // blank gets extra work,
                // this solves the problem you get if you replace all
                // blanks with &nbsp;, if you do that you loss 
                // word breaking
                if (lastWasBlankChar) {
                    lastWasBlankChar = false;
                    sb.append("&nbsp;");
                } else {
                    lastWasBlankChar = true;
                    sb.append(' ');
                }
            } else {
                lastWasBlankChar = false;
                //
                // HTML Special Chars
                if (c == '"') {
                    sb.append("&quot;");
                } else if (c == '&') {
                    sb.append("&amp;");
                } else if (c == '<') {
                    sb.append("&lt;");
                } else if (c == '>') {
                    sb.append("&gt;");
                } else if (c == '\n') // Handle Newline
                {
                    sb.append("<br/>");
                } else {
                    int ci = 0xffff & c;
                    if (ci < 160) // nothing special only 7 Bit
                    {
                        sb.append(c);
                    } else {
                        // Not 7 Bit use the unicode system
                        sb.append("&#");
                        sb.append(new Integer(ci).toString());
                        sb.append(';');
                    }
                }
            }
        }
        return sb.toString();
    }
    
    
}
