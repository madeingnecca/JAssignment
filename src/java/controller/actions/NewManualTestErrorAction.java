/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller.actions;

import controller.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Admin;
import model.User;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import model.*;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.validator.DynaValidatorForm;
import model.test.ExecutionError;
import model.test.TestError;


public class NewManualTestErrorAction extends Action{
    
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        
        HttpSession session = request.getSession();

        if ( session == null ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }
        
        User userlogged = ( User ) session.getAttribute( Constants.USER_SESSION_KEY );
        if ( !(userlogged instanceof Admin ))
            return mapping.findForward( Constants.LOGIN_FRWD );
        
        Assignment subAssign = null;
        Text subText = null;
        Student subStud = null;
        Submission sub = null;
        Boolean ok = null;
        
        String cause = null;
        
        DynaValidatorForm dvf = ( DynaValidatorForm ) form;
        ActionErrors errors = dvf.validate(mapping, request);
        if ( !errors.isEmpty() ) {
            this.saveErrors(request, errors);
            int assid = ( Integer ) dvf.get( "assid");
            int ordinal = ( Integer ) dvf.get( "ord");
            String login = dvf.getString( "stud");

            subStud = (Student) dao.StudentDAO.getInstance().getRecord( login );

            subAssign = ( Assignment ) dao.AssignmentDAO.getInstance().getRecord(assid);
            subText = new Text();
            subText.setAssignment(subAssign);
            subText.setOrdinal(ordinal);
            subText = ( Text ) dao.TextDAO.getInstance().getRecord(subText);

            sub = new Submission();
            sub.setLogin(subStud);
            sub.setText(subText);
            sub = (Submission) dao.SubmissionDAO.getInstance().getRecord( sub );
        }
        else {
            try {

                cause = dvf.getString( "cause");

                int assid = ( Integer ) dvf.get( "assid");
                int ordinal = ( Integer ) dvf.get( "ord");
                String login = dvf.getString( "stud");
                ok = ( Boolean ) dvf.get( "ok");

                subStud = (Student) dao.StudentDAO.getInstance().getRecord( login );

                subAssign = ( Assignment ) dao.AssignmentDAO.getInstance().getRecord(assid);
                subText = new Text();
                subText.setAssignment(subAssign);
                subText.setOrdinal(ordinal);
                subText = ( Text ) dao.TextDAO.getInstance().getRecord(subText);

                sub = (Submission) subStud.getSubmissions().get( subText );
                sub.setText(subText);
                sub.setLogin(subStud);
                
                if ( sub == null ) throw new Exception( "sub is null" );

            }
            catch ( Exception e ) {
                return mapping.findForward( Constants.LOGIN_FRWD );
            }

            /* se sono arrivato qui tutto ok!! */

            Result cr = sub.getResult();

            if (!ok) {
                TestError newError = new TestError();
                newError.setCode("MANUAL_EXEC_ERROR");
                newError.setError(cause);
                cr.addExecError(newError);
                cr.setReturnCode( Result.EXECUTES_KO);
            } else {
                cr.setReturnCode( Result.EXECUTES_OK );
            }

            ActionMessages msgs = new ActionMessages();

            ActionMessage msg = null;
            boolean saved = dao.ResultDAO.getInstance().saveRecord( cr );
            saved = saved && dao.SubmissionDAO.getInstance().saveRecord( sub );
            if ( saved ) {
                msg = new ActionMessage( "messages.saveok" );
                msgs.add( ActionMessages.GLOBAL_MESSAGE, msg );
                this.saveMessages(request, msgs);
            }
            else {
                
                cr.setReturnCode( Result.COMPILES_OK );
                
                msg = new ActionMessage( "errors.savenotok" );
                errors.add( ActionMessages.GLOBAL_MESSAGE, msg );
                this.saveErrors(request, errors);
            }
        }
        
        
        request.setAttribute( Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_TEXT_SUBMITTED );
        request.setAttribute(Constants.STUDENT_REQUEST_KEY, subStud);
        request.setAttribute(Constants.SUB_REQUEST_KEY, sub);
        request.setAttribute(Constants.TEXT_REQUEST_KEY, subText);
        
        /* resetto il form.. */
        dvf.reset(mapping, request);
        return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
    }
}
