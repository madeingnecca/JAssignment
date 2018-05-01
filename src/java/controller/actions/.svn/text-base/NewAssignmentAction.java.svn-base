/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller.actions;

import controller.*;
import dao.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.*;

import javax.servlet.http.HttpSession;
import controller.mail.EmailSender;
import model.*;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.validator.DynaValidatorForm;

/**
 *
 * @author Dax
 */
public class NewAssignmentAction extends org.apache.struts.action.Action {
        
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        HttpSession session = request.getSession();
            
        if ( session == null ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }
        
        User user = ( User ) session.getAttribute( Constants.USER_SESSION_KEY );
        Admin connected = null;
        if ( user instanceof Student ) {
            return mapping.findForward( Constants.LOGIN_FRWD );
        }
        else {
            connected = ( Admin ) user;
        }
        
        DynaValidatorForm dvf = ( DynaValidatorForm ) form;
        
        ActionErrors errors = dvf.validate(mapping, request);
        
        String title;
        Integer exerciseNumber;
        String start, end;
        Integer aid;
        Boolean delete;
        Boolean startNow;
        
        if ( !errors.isEmpty() ) {
            Assignment assignment = null;
            try {
                aid = ( Integer ) dvf.get( "id" );
                assignment = ( Assignment ) AssignmentDAO.getInstance().getRecord( aid );
            } catch( Exception e ) {
                return mapping.findForward( Constants.LOGIN_FRWD );
            }
            this.saveErrors(request, errors);
            request.setAttribute( Constants.LEVEL_REQUEST_KEY,  Constants.LEVEL_EXERCISES );
            request.setAttribute( Constants.ASSIGNMENT_REQUEST_KEY,  assignment );
            return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        }
        
        try {
            title = dvf.getString( "title" );
            exerciseNumber = ( Integer ) dvf.get( "nes" );
            start = ( String ) dvf.get( "start" );
            end = ( String ) dvf.get( "end" );
            
            delete = ( Boolean ) dvf.get( "delete" );
            aid = ( Integer ) dvf.get( "id" );
            startNow = ( Boolean ) dvf.get( "startNow" );
         }
        catch ( Exception e ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }

        Assignment assignment = ( Assignment ) AssignmentDAO.getInstance().getRecord( aid ); 
        
        if ( assignment == null ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }
        
        Course c = assignment.getCourse();
        
        if ( delete ) {
            c.removeAssignment(assignment);
            CourseDAO.getInstance().saveRecord( c );
            boolean removed = AssignmentDAO.getInstance().removeRecord( aid );
        }
        else {
            
            boolean tosave = true;
            
            Date startTime;
            
            if ( startNow ) {
                startTime = new Date();
            }
            else 
                startTime = Util.stringToDate( start );
            
            /* in che stato sono prima della modifica? */
            int prevState = Assignment.getState( assignment );
            
            assignment.setTitle(title);
            Date deadline = Util.stringToDate( end );
            
            int currentState = Assignment.getState( startTime, deadline );
            
            if ( Assignment.isClosed( currentState )) {
                /* ho impostato valori che fanno chiudere l'esercitazione - situazione che non puo' avvenire*/
                errors.add( ActionMessages.GLOBAL_MESSAGE,  new ActionMessage( "EditAssignmentForm.dateError" ) );
                tosave = false;
            } else {
                assignment.setStartTime(startTime);
                assignment.setDeadline(deadline);  
            }
            
            assignment.setCorrected( false );
            
            boolean saved = false;
            
            if ( tosave ) saved = AssignmentDAO.getInstance().saveRecord( assignment );
            
            ActionMessages msgs = new ActionMessages();
            
            if ( saved ) {
                msgs.add( ActionMessages.GLOBAL_MESSAGE,  new ActionMessage( "messages.saveok" ) );
            }
            else {
                errors.add( ActionMessages.GLOBAL_MESSAGE,  new ActionMessage( "errors.savenotok", "probabile errore -> titolo gia' presente" ) );
            }
            
            if ( !errors.isEmpty() ) this.saveErrors(request, errors);
            
            /* se ho salvato tutto e prima l'esercitazione era aperta */
            if ( saved && Assignment.isOpen( prevState ) ) {
                List receivers = AdminDAO.getInstance().getSubmitters( assignment );
                EmailSender emailsender = EmailSender.getInstance( 
                        this.getServlet().getServletContext().getRealPath("/") +
                        this.getServlet().getServletContext().getInitParameter( EmailSender.MAIL_CONF_XML )
                );
                boolean sentmail = emailsender.sendUpdatedAssignment( connected, receivers, assignment);
                if ( sentmail )
                    msgs.add( ActionMessages.GLOBAL_MESSAGE,  new ActionMessage( "messages.sentmail" ) );
                else 
                    msgs.add( ActionMessages.GLOBAL_MESSAGE,  new ActionMessage( "messages.sentmailnotok" ) );
            }
            this.saveMessages(request, msgs);
        }
        
        Collection mycourses = null;
        if ( connected.isSuperUser() )
            mycourses = AdminDAO.getInstance().getAllCourses();
        else
            mycourses = connected.getCourses();
        
        request.setAttribute( Constants.LEVEL_REQUEST_KEY,  Constants.LEVEL_COURSES );
        request.setAttribute( Constants.COURSE_REQUEST_KEY,  c );
        request.setAttribute( Constants.COURSES_REQUEST_KEY,  mycourses );
        /* resetto il form.. */
        dvf.reset(mapping, request);
        return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        
    }
}