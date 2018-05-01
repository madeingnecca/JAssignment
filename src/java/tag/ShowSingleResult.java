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


public class ShowSingleResult extends TagSupport {

    static final String[] VALUES_STUD = new String[]{"<img alt=\"\" title=\"corretto\" src=\"images/ok.png\" />",
            "<img alt=\"\" title=\"non corretto\" src=\"images/ko.png\" />",
            "Consegnato",
            "Non consegnato",
            "Non richiesto",
            "<img alt=\"\" title=\"\" src=\"images/none.png\" />",
            "<img alt=\"\" title=\"risultato non trovato\" src=\"images/qm.jpg\" />",
            "<img alt=\"\" title=\"da controllare\" src=\"images/human.gif\" />"
    }; 
    
    
    private Assignment      assignment;
    private Student         stud;
    
    public ShowSingleResult() {}
    
    public int doStartTag() throws javax.servlet.jsp.JspTagException {
        return SKIP_BODY;
    }
    
    
    public int doEndTag() throws javax.servlet.jsp.JspTagException {
   
        String output = "";
        
        
        output += "<table class=\"texts\">" +
                "<tr>" +
                "<th>Titolo</th><th>Linguaggio</th><th>Compilazione</th><th>Esecuzione</th><th>Pseudocodice</th><th>Esito</th>" +
                "</tr>";
    
        boolean count = true;

        String basehref = Constants.CHANGE_PAGE_STUD + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_SUB_EX;

        List<Text> texts = assignment.getTexts();
        int astate = Assignment.getState(assignment);

        for ( Text currentText : texts ) {

            String href = basehref;
            href +=  "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + assignment.getId();
            href +=  "&" + Constants.ORDINAL_REQUEST_KEY + "=" + currentText.getOrdinal();

            String trclass = count? "even" : "odd";

            int[] results = Common.getResults( getStud(),currentText, astate );

            int esitoCompilazione = results[ 0 ];
            int esitoEsecuzione = results[ 1 ];
            int esitoPseudocode = results[ 2 ];
            int parziale = results[ 3 ];

            String strCompilazione = VALUES_STUD[esitoCompilazione];
            String strEsecuzione = VALUES_STUD[esitoEsecuzione];
            String strPseudocode = VALUES_STUD[esitoPseudocode];
            String strPartial  = VALUES_STUD[ parziale ];

            output += "<tr class=\""+trclass+"\">" +
            "<td><a href="+href+">Es "+currentText.getOrdinal()+"</a></td>" +
            "<td>"+currentText.getLanguage().getExt()+"</td>" +
            "<td>"+strCompilazione+"</td>" +
            "<td>"+strEsecuzione+"</td>" +
            "<td>"+strPseudocode+"</td>" +
            "<td>"+strPartial+"</td>" +
            "</tr>";
            count = !count;
        }
    
        output += "</table>";
        
        try {
            pageContext.getOut().write(output);
        } catch (IOException ex) {
            
        }
        
        return EVAL_PAGE;
    }

    public Assignment getAssignment() {
        return assignment;
    }

    public void setAssignment(Assignment assignment) {
        this.assignment = assignment;
    }

    public Student getStud() {
        return stud;
    }

    public void setStud(Student stud) {
        this.stud = stud;
    }
    
    
}
