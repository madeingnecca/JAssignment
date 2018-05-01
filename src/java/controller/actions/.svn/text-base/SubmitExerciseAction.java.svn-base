/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller.actions;

import controller.*;
import dao.AssignmentDAO;
import dao.StudentDAO;
import dao.SubmissionDAO;
import dao.TextDAO;
import de.hunsicker.jalopy.Jalopy;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.Date;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.*;

import javax.servlet.http.HttpSession;
import model.Assignment;
import model.Formatter;
import model.Language;
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
public class SubmitExerciseAction extends org.apache.struts.action.Action {

    
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        HttpSession session = request.getSession();
        
        if ( session == null ) {
            return mapping.findForward( Constants.LOGIN_FRWD );
        }
        
        ActionErrors errors = new ActionErrors();
        ActionMessages msgs = new ActionMessages();
        
        DynaValidatorForm dvf = ( DynaValidatorForm ) form;
        Assignment as = null;
        int exerciseNumber;
        String codice;
        String pseudo;
        
        try {
            Integer assignmentID = ( Integer ) dvf.get( "assignmentID" );
            AssignmentDAO adao = AssignmentDAO.getInstance();
            as = (Assignment) adao.getRecord( assignmentID.intValue() );
            exerciseNumber = ( Integer ) dvf.get( "ordinal" );
            codice = ( String ) dvf.get( "exerciseText" );
            pseudo = ( String ) dvf.get( "pseudoText" );
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
        
        submission.setLogin(stud);
        
        Date deadline = as.getDeadline();
        Date today = new Date();
        
        boolean saved = true;
        
        if ( !Assignment.canEdit( Assignment.getState( as )) ) {
            /* ormai e' troppo tardi.. */
            Long msDeadline = deadline.getTime();
            Long msToday = today.getTime();
            Long msExpired = msToday - msDeadline;
            String expired =  Util.calculateDelay( msExpired );
            errors.add( ActionMessages.GLOBAL_MESSAGE, new ActionMessage( "errors.expired", expired ));
        }
        else {
            
            String theCode = codice;

            if ( theCode.equals("")   )
                msgs.add( ActionMessages.GLOBAL_MESSAGE, new ActionMessage( "messages.nocode" ));
            
            if ( theExercise.isPseudocodeRequested() && pseudo.equals("")   )
                msgs.add( ActionMessages.GLOBAL_MESSAGE, new ActionMessage( "messages.nopseudo" ));
            
            submission.setPseudoText(pseudo);
            submission.setText(theExercise);
            
            stud.doSubmit(submission);
            
            Language subLanguage = submission.getText().getLanguage();
            Formatter formatter = subLanguage.getFormatter();
            
            theCode = formatter.format(theCode);
            submission.setExerciseText(theCode);
            
            saved = saved && SubmissionDAO.getInstance().saveRecord( submission );
        }
        
        if ( saved ) {
            msgs.add( ActionMessages.GLOBAL_MESSAGE, new ActionMessage( "messages.saveok" ));
        } else {
            stud.unsubmit(submission);
            msgs.add( ActionMessages.GLOBAL_MESSAGE, new ActionMessage( "messages.savenotok", "errore generico jdbc" ));
        }
        
        if ( !errors.isEmpty() )
            this.saveErrors(request, errors);
        else 
            this.saveMessages( request, msgs );
        
        request.setAttribute( Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_SUB_EX);
        request.setAttribute( Constants.ASSIGNMENT_REQUEST_KEY, as );
        request.setAttribute( Constants.ORDINAL_REQUEST_KEY, exerciseNumber );
        return mapping.findForward( Constants.LOGGED_STUD_FRWD );
    }
    
    
}