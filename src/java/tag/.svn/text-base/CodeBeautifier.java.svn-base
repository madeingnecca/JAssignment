/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package tag;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.StringReader;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.jsp.JspTagException;
import javax.servlet.jsp.tagext.TagSupport;
import model.test.TestError;
import model.*;

public class CodeBeautifier extends TagSupport {
    private Submission sub;
    private boolean compile;
    private boolean test;
    private boolean admin = false;
    private boolean onlykey = false;
    
    public CodeBeautifier() {
        super();
    }
    
    @Override
    public int doStartTag() throws javax.servlet.jsp.JspTagException {
        return SKIP_BODY;
    }
    
    private String formatWithErrors( String src, List<TestError> errors ) {
        
        String result = "<table class=\"sourcecode\" cellspacing=\"0\">";
        
        if ( errors == null )
            errors = new ArrayList<TestError>();
        
        StringReader sr = new StringReader( src );
        BufferedReader br = new BufferedReader( sr );
        String line = null;
        int lineno = 1;
        int errorIndex = 0;
        int errorSize = errors.size();
        
        try {

            while ((line = br.readLine()) != null) {
                
                String toput = "";
                
                if ( errorIndex < errorSize ) {
                    /* ha senso controllare gli errori solo se ce ne possono essere ancora */
                    TestError te = ( TestError ) errors.get( errorIndex );
                    if ( te.getLine() == lineno ) {
                        toput = "<tr class=\"errorLineTR\">";
                        toput += "<td class=\"errorLineTD\"></td>";
                        errorIndex++;
                        while ( errorIndex < errorSize ) {
                            te = ( TestError ) errors.get( errorIndex );
                            if ( te.getLine() > lineno ) break;
                            else errorIndex++;
                        }
                        
                    }
                    else {
                        toput = "<tr>";
                        toput += "<td class=\"linenumberTD\">" + lineno + "</td>";
                    }
                }
                else {
                    toput = "<tr>";
                    toput += "<td class=\"linenumberTD\">" + lineno + "</td>";
                }
                
                
                result += toput;
                line = util.Util.stringToHTMLString(line);
                result += "<td class=\"codeTD\"><pre>" + line + "</pre></td>";
                result += "</tr>";
                lineno++;
            }
        } catch (IOException ex) {
            /* non ci sara' mai un errore.. sto leggendo una stringa..*/
        }
        
        result += "</table>";
        
        return "<div class=\"sourcecodeWrapper\">" + result + "</div>";
    }
    
    private String doSingleLegend( List<TestError> errors, boolean compile ) {
        String result = "";
        
        int size = ( errors == null || errors.size() == 0 ) ? 0 : errors.size();
       
        result += "<table class=\"legend\">";
        result += "<tr><td colspan=\"3\">";
        
        String path = "";
        if ( this.isAdmin() ) {
            path = "../";
        }
        
        if ( size == 0 ) {
            result += "<img src=\"" + path + "images/ok.png" + "\" alt=\"\" />&nbsp;";
        }
        else {
            result += "<img src=\"" + path + "images/ko.png" + "\" alt=\"\" />&nbsp;";
        }
        
        if ( compile ) {
            result += "Errori in compilazione: " + size;
        }
        else {
            result += "Errori in esecuzione: " + size;
        }
        
        result += "</td></tr>";
        
        if ( size == 0 ) return result + "</table>";
        
        
        
        result += "<tr><th>Linea</th><th>Codice errore</th><th>Descrizione</th></tr>";
        
        for ( TestError te : errors ) {
            
            String trclass = "errorLineTR";
            
            result += "<tr class=\""+trclass+"\">";
            
            result += "<td>"+te.getLine()+"</td><td>"+te.getCode()+"</td><td>"+te.getError()+"</td>";
            
            result += "</tr>";
        }
        
        result += "</table>";
        
        return result;
    }
    
    @Override
    public int doEndTag() throws javax.servlet.jsp.JspTagException {
        try
        {
            List<TestError> errori = new ArrayList();
            
            String output = "";
            
             String path = "";
             if ( this.isAdmin() ) {
                path = "../";
             }
            
            if ( sub != null ) {
            
                if ( sub.getText().getAssignment().isCorrected() ) {
                    String legend = "";
                    boolean resultsAvailable = true;
                    if ( isCompile() || isTest() ) {
                        if ( sub.getResult() == null ) {
                            legend += "<p><img src=\"" + path + "images/qm.jpg" + "\" alt=\"\" />&nbsp;Risultato test automatico non trovato</p>";
                            resultsAvailable = false;
                        }
                    }
                    
                    if ( resultsAvailable ) {
                        switch ( sub.getResult().getReturnCode() ) {
                            case Result.NOT_TESTED: {
                                legend += "<p><img src=\"" + path + "images/qm.jpg" + "\" alt=\"\" />&nbsp;Risultato test automatico non valido</p>";
                                break;
                            }
                            case Result.EXECUTES_OK: {
                            }
                            case Result.EXECUTES_KO: { 
                                if ( isCompile() ) {
                                    errori = sub.getResult().getCompilerErrors();
                                    legend += doSingleLegend( errori, true );
                                }
                                
                                if ( isTest() ) {
                                    errori = sub.getResult().getExecErrors();
                                    legend += doSingleLegend( errori, false );
                                } 
                                break;
                            }
                            case Result.COMPILES_KO: {
                                if ( isCompile() ) {
                                    errori = sub.getResult().getCompilerErrors();
                                    legend += doSingleLegend( errori, true );
                                }                           
                                break;
                            }
                            case Result.COMPILES_OK: {
                                
                                if ( isCompile() ) {
                                    errori = sub.getResult().getCompilerErrors();
                                    legend += doSingleLegend( errori, true );
                                }
                                
                                if ( isTest() ) {
                                    if ( sub.getText().isHumanNeeded() ) {
                                        legend += "<p><img src=\"" + path + "images/human.gif" + "\" alt=\"\" />&nbsp;Test manuale necessario ma ancora da effettuare</p>";
                                    }
                                    else {
                                        legend += "<p><img src=\"" + path + "images/qm.gif" + "\" alt=\"\" />&nbsp;Risultato test automatico/manuale non presente</p>";
                                    }
                                }
                                break;
                            }                    
                        }
                    }

                    if ( !this.isOnlykey() )
                        output += formatWithErrors( sub.getExerciseText(), errori);

                    output += legend;
                } else {
                    if ( !this.isOnlykey() )
                        output += formatWithErrors( sub.getExerciseText(), null );
                    else 
                        output += "<p>Esercizio ancora da correggere</p>";
                }
            }
            else {

                output = "<img src=\"" + path + "images/ko.png" + "\" alt=\"\" />&nbsp;Esercizio non consegnato";;
            }
            
            pageContext.getOut().write( output  );
        }
        catch(java.io.IOException e)
        {
            throw new JspTagException("IO Error: " + e.getMessage());
        }
        return EVAL_PAGE;
    }


    public Submission getSub() {
        return sub;
    }
    
    public void setSub( Submission s ) {
        sub = s;
    }

    public boolean isCompile() {
        return compile;
    }

    public void setCompile(boolean compile) {
        this.compile = compile;
    }

    public boolean isTest() {
        return test;
    }

    public void setTest(boolean test) {
        this.test = test;
    }

    public boolean isAdmin() {
        return admin;
    }

    public void setAdmin(boolean admin) {
        this.admin = admin;
    }

    public boolean isOnlykey() {
        return onlykey;
    }

    public void setOnlykey(boolean onlykey) {
        this.onlykey = onlykey;
    }
  
}
