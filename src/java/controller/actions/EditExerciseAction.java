/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller.actions;

import controller.*;
import dao.AssignmentDAO;
import dao.SubmissionDAO;
import dao.TextDAO;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.servlet.http.HttpSession;
import model.Assignment;
import model.Student;
import model.Submission;
import model.Text;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.upload.FormFile;
import org.apache.struts.validator.DynaValidatorForm;

/**
 *
 * @author Dax
 */
public class EditExerciseAction extends org.apache.struts.action.Action {

    
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        HttpSession session = request.getSession();
        
        if ( session == null ) {
            return mapping.findForward( Constants.LOGIN_FRWD );
        }
        
        ActionErrors errors = new ActionErrors();
        DynaValidatorForm dvf = ( DynaValidatorForm ) form;
        Assignment as = null;
        int exerciseNumber;
        String codice;
        String pseudo;
        String fileCode;
        
        try {
            Integer assignmentID = ( Integer ) dvf.get( "assignmentID" );
            AssignmentDAO adao = AssignmentDAO.getInstance();
            as = (Assignment) adao.getRecord( assignmentID.intValue() );
            exerciseNumber = ( Integer ) dvf.get( "ordinal" );
            codice = ( String ) dvf.get( "exerciseText" );
            pseudo = ( String ) dvf.get( "pseudoText" );
            FormFile fileToUpload = (FormFile) dvf.get("exerciseTextFile");
            fileCode = new String( fileToUpload.getFileData() );
        }
        catch ( Exception e ) {
            return mapping.findForward( Constants.LOGIN_FRWD );    
        }        
        
        Text theExercise = new Text();
        theExercise.setAssignment(as);
        theExercise.setOrdinal(exerciseNumber);
        theExercise = (Text) TextDAO.getInstance().getRecord( theExercise );
        
        Student stud = (Student) session.getAttribute(Constants.USER_SESSION_KEY);
        Submission submission = (Submission) stud.getSubmissions().get(theExercise);
        
        if ( submission == null ) {
            /* crea submission e inizializzala coi valori ..*/ 
            submission = new Submission();
        }
        
        Date deadline = as.getDeadline();
        Date today = new Date();
        
        if ( deadline.compareTo( today ) < 0  ) {
            /* ormai e' troppo tardi.. */
            Long msDeadline = deadline.getTime();
            Long msToday = today.getTime();
            Long msExpired = msToday - msDeadline;
            String expired =  calculateDelay( msExpired );
            errors.add( ActionMessages.GLOBAL_MESSAGE, new ActionMessage( "errors.expired", expired ));
            this.saveErrors(request, errors);
        }
        else {
            /* posso consegnare ancora */
            if ( !codice.equals("") && !fileCode.equals(""))
                submission.setExerciseText( fileCode );
            else {
                if ( fileCode.equals("") )
                    submission.setExerciseText( codice );
                
                if ( codice.equals("") )
                    submission.setExerciseText( fileCode );    
            }
            
            submission.setPseudoText(pseudo);
            submission.setText(theExercise);
            
            SubmissionDAO.getInstance().saveRecord( submission );
        }
        
        request.setAttribute( Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_SUB_EX);
        request.setAttribute( Constants.ASSIGNMENT_REQUEST_KEY, as );
        request.setAttribute( Constants.ORDINAL_REQUEST_KEY, exerciseNumber );
        return mapping.findForward( Constants.LOGGED_STUD_FRWD );
    }
    
    private String calculateDelay( long ms ) {
        String delay = "";
        String[] bo = new String[] { "giorno/i", "ora/e", "minuto/i", "secondo/i" };
        long[] factors = new long[] { 1000 * 3600 * 24, 1000 * 3600, 1000 * 60, 1000  };
        for ( int i = 0; i < factors.length; i++ ) {
            int i_delay = (int) (ms / factors[i]);
            if ( i_delay > 1 ) {
                delay = i_delay + " " + bo[ i ];
                break;
            }
        }
        return delay;
    }
    
}