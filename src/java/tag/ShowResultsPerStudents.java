/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package tag;


import java.io.IOException;
import java.util.List;
import javax.servlet.jsp.tagext.TagSupport;
import model.*;
import controller.Constants;


public class ShowResultsPerStudents extends TagSupport {

    
    static final String[] VALUES = new String[]{"<img alt=\"\" title=\"corretto\" src=\"../images/ok.png\" />",
            "<img alt=\"\" title=\"non corretto\" src=\"../images/ko.png\" />",
            "Consegnato",
            "Non consegnato",
            "Non richiesto",
            "<img alt=\"\" title=\"\" src=\"../images/none.png\" />",
            "<img alt=\"\" title=\"risultato non trovato\" src=\"../images/qm.jpg\" />",
             "<img alt=\"\" title=\"da controllare\" src=\"../images/human.gif\" />"
    };    
    
    private List<Student>           submitters;
    private Assignment              assignment;
    
    public ShowResultsPerStudents() {}
    
    

    public int doStartTag() throws javax.servlet.jsp.JspTagException {
        return SKIP_BODY;
    }
    
    
    public int doEndTag() throws javax.servlet.jsp.JspTagException {
   
        List<Text> texts = getAssignment().getTexts();
        
        String output = "";
        
        if ( submitters == null || submitters.size() == 0) {
            
            output += VALUES[ Common.KO ] + " Nessuna consegna effettuata";
            
            try {
                pageContext.getOut().write(output);
            } catch (IOException ex) {

            }
            return EVAL_PAGE;
        }
        
        output += "<table class=\"submissions\">" +
                    "<tr><th>Studente</th>";
                
        for ( Text t : texts ) {
            output += "<th><table style=\"width:100%;\">" +
                    "<tr><td colspan=\"3\">Es. "+t.getOrdinal()+"</td></tr>" +
                    "<tr>" +
                    "<td style=\"width:33%;text-align:center;\"><img src=\"../images/c.png\" title=\"compilazione\"/></td>" +
                    "<td style=\"width:33%;text-align:center;\"><img src=\"../images/e.png\" title=\"esecuzione\"/></td>" +
                    "<td style=\"width:33%;text-align:center;\"><img src=\"../images/p.png\" title=\"pseudocodice\"/></td>" +
                    "</tr>" +
                    "</table>" +
                    "</th>";
        }
        
        output += "<th>Totale</th></tr>";
        
        boolean tested = getAssignment().isCorrected();
        int astate = Assignment.getState(assignment);
        
        boolean count = true;
        
        String baseHref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_SUBMISSIONS_2;
        baseHref += "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + getAssignment().getId();
        
        for ( Student s : getSubmitters() ) {
            
            String trclass = count? "even" : "odd";
            String labelStudente = s.getCognome() + " " + s.getNome();
            labelStudente = labelStudente.toUpperCase();
            String hrefStudente = baseHref + "&" + Constants.STUDENT_REQUEST_KEY + "=" + s.getLogin();
            
            output += "<tr class="+trclass+">" +
                    "<td><a href="+hrefStudente+">"+labelStudente+"</a></td>";
            String totale = "";            
    
            int currentPartial = Common.OK;
            
            for ( Text t : texts ) {
                
                int[] results = Common.getResults( s, t, astate );

                int esitoCompilazione = results[ 0 ];
                int esitoEsecuzione = results[ 1 ];
                int esitoPseudocode = results[ 2 ];
                int parziale = results[ 3 ];

                currentPartial = Common.getPartial( currentPartial, parziale );

                String strCompilazione = VALUES[esitoCompilazione];
                String strEsecuzione = VALUES[esitoEsecuzione];
                String strPseudocode = VALUES[esitoPseudocode];
                String strPartial  = VALUES[ parziale ];
                
                output += "<td><table style=\"width:100%;\"><tr>";

                
                 if (tested) 
                     output += "<td style= \"width:33%;text-align:center;\">"+strCompilazione+"</td>" +
                    "<td style=\"width:33%;text-align:center;\">"+strEsecuzione+"</td>" +
                    "<td style=\"width:33%;text-align:center;\">"+strPseudocode+"</td>";
                 else 
                     output += "<td>"+strPartial+"</td>";

                output += "</tr></table></td>";
           }
            
            output += "<td>"+VALUES[ currentPartial ]+"</td></tr>";
            
            count = !count;
        }
        
        output += "</table>";
        
        try {
            pageContext.getOut().write(output);
        } catch (IOException ex) {
            
        }
        
        return EVAL_PAGE;
    }

    public List<Student> getSubmitters() {
        return submitters;
    }

    public void setSubmitters(List<Student> submitters) {
        this.submitters = submitters;
    }

    public Assignment getAssignment() {
        return assignment;
    }

    public void setAssignment(Assignment assignment) {
        this.assignment = assignment;
    }
    
    
}
