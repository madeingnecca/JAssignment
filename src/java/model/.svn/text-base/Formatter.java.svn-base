/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package model;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.Serializable;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.test.TestError;

public abstract class Formatter{
        
    public abstract String format( String src );
    
    public String formatWithoutErrors( String src ) {
        
        String result = "<table class=\"sourcecode\" cellspacing=\"0\">";
        
        StringReader sr = new StringReader( src );
        BufferedReader br = new BufferedReader( sr );
        String line = null;
        int lineno = 1;
        try {
            while ((line = br.readLine()) != null) {
                result += "<tr>";
                result += "<td class=\"linenumberTD\">" + ( lineno++ ) + "</td>";
                result += "<td class=\"codeTD\"><pre>" + util.Util.stringToHTMLString(line) + "</pre></td>";
                result += "</tr>";
            }
        } catch (IOException ex) {
            Logger.getLogger(Formatter.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        result += "</table>";
        return result;
    }    
}
