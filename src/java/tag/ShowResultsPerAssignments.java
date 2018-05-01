/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package tag;


import java.io.IOException;
import java.util.List;
import javax.servlet.jsp.tagext.TagSupport;
import model.*;


public class ShowResultsPerAssignments extends TagSupport {
    
    private List<Student>           submitters;
    private List<Assignment>        assignments;
    
    public ShowResultsPerAssignments() {}
    

    public int doStartTag() throws javax.servlet.jsp.JspTagException {
        return SKIP_BODY;
    }
    
    
    public int doEndTag() throws javax.servlet.jsp.JspTagException {
   
        String output = "";
        
        int max = -1;
        for ( Assignment a : getAssignments() ) {

           List texts = a.getTexts();
           int size = texts.size();
           if ( max < size  )
               max = size;
        }
        
        for ( Student s : submitters ) {
            
            output += "<a name=\""+s.getLogin()+"\" id=\""+s.getLogin()+"\"></a>" +
                "<h2>" + s.getCognome().toUpperCase() + " " + s.getNome().toUpperCase() + " - " + s.getMatricola()+"</h2>" +
                "<table class=\"submissions\">" +
                    "<tr><th>Esercitazione</th>";
        
        
            for ( int z = 0; z < max; z++ ) {
                
                output += "<th>" +
                       "<table style=\"width:100%;\">"+
                       "<tr><td colspan=\"3\">Es. "+(z+1)+"</td></tr>"+
                                "<tr>"+
                                    "<td style=\"width:33%;text-align:center;\"><img src=\"../images/c.png\" title=\"compilazione\"/></td>" +
                                    "<td style=\"width:33%;text-align:center;\"><img src=\"../images/e.png\" title=\"esecuzione\"/></td>" +
                                    "<td style=\"width:33%;text-align:center;\"><img src=\"../images/p.png\" title=\"pseudocodice\"/></td>" +
                                "</tr>" +
                            "</table>" +
                        "</th>";
             }
                   
                output += "</tr>";
                
                boolean count = true;
                for ( Assignment a : getAssignments() ) {

                    int astate = Assignment.getState(a);

                    boolean tested = a.isCorrected();
                    String trclass = count? "even" : "odd";
                    count = !count;
                    output += "<tr class=\""+trclass+"\">" +
                        "<td>"+a.getTitle()+"</td>";
                    
                    List texts = a.getTexts();
                    int tsize = texts.size();

                    int currentPartial = Common.OK;
                    
                    for ( int z = 0; z < max; z++ ) {
                            if ( z >= tsize ) {                                
                                output += "<td></td>";
                            }
                            else {
                                Text temp = ( Text ) texts.get( z );
                                
                                int[] results = Common.getResults( s, temp, astate );

                                int esitoCompilazione = results[ 0 ];
                                int esitoEsecuzione = results[ 1 ];
                                int esitoPseudocode = results[ 2 ];
                                int parziale = results[ 3 ];

                                currentPartial = Common.getPartial( currentPartial, parziale );

                                String strCompilazione =  tag.ShowResultsPerStudents.VALUES[esitoCompilazione];
                                String strEsecuzione =  tag.ShowResultsPerStudents.VALUES[esitoEsecuzione];
                                String strPseudocode =  tag.ShowResultsPerStudents.VALUES[esitoPseudocode];
                                String strPartial  =  tag.ShowResultsPerStudents.VALUES[ parziale ];
                                
                                output += "<td>" +
                                    "<table style=\"width:100%;\">" +
                                        "<tr>";
                                if (tested) 
                                     output += "<td style= \"width:33%;text-align:center;\">"+strCompilazione+"</td>" +
                                    "<td style=\"width:33%;text-align:center;\">"+strEsecuzione+"</td>" +
                                    "<td style=\"width:33%;text-align:center;\">"+strPseudocode+"</td>" +
                                    "</td>";
                                 else 
                                     output += "<td>"+strPartial+"</td>";

                                output += "</tr></table></td>";
                        }
                    }
                    output += "</tr>";
                }
                output += "</table>";
        }
        
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

    public List<Assignment> getAssignments() {
        return assignments;
    }

    public void setAssignments(List<Assignment> assignments) {
        this.assignments = assignments;
    }

    
    
}
