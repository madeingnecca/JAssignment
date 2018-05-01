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
public class FastNewAssignmentAction extends org.apache.struts.action.Action {
        
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
        Integer cid;
        Course course = null;
        
        
        try {
            title = dvf.getString( "title" );
            exerciseNumber = ( Integer ) dvf.get( "nes" );
            start = dvf.getString( "start" );
            end = dvf.getString( "end" );
            cid = ( Integer ) dvf.get( "courseID" );
        }
        catch ( Exception e ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }
        
        Date startTime = Util.stringToDate( start );
        Date deadline = Util.stringToDate( end );
        
        if ( deadline != null ) {
            Date today = new Date();
            
            if ( ( startTime != null && startTime.compareTo(today) <= 0 ) || 
                    ( startTime != null && startTime.compareTo(deadline) >= 0 ) || 
                    deadline.compareTo(today) <= 0) {
                errors.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("EditAssignmentForm.dateError"));
            }
            
        }
        
        List langs = LanguageDAO.getInstance().getRecords();
        if ( langs == null || langs.size() == 0 ) {
            errors.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("errors.nolanguages"));
        }
        
        course = (Course) CourseDAO.getInstance().getRecord(cid);
        
        if ( !errors.isEmpty() ) {
            this.saveErrors(request, errors);
            Collection allcourses = connected.isSuperUser() ? AdminDAO.getInstance().getAllCourses() : connected.getCourses();
            request.setAttribute(Constants.COURSES_REQUEST_KEY, allcourses );
            request.setAttribute(Constants.COURSE_REQUEST_KEY, course);
            request.setAttribute(Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_COURSES);
            return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        }

        Assignment newAss = null;
        Language defaultLanguage = LanguageDAO.getInstance().getDefaultLanguage();

        boolean saved = true;
        
        if ( defaultLanguage != null ) {
        
            newAss = new Assignment();
            newAss.setTitle(title);
            newAss.setCourse(course);
            newAss.setStartTime(startTime);
            newAss.setDeadline(deadline);
            newAss.setCorrected( false );

            for (int i = 0; i < exerciseNumber; i++) {
                Text tempText = new Text();
                tempText.setAssignment(newAss);
                tempText.setOrdinal(i + 1);
                tempText.setLanguage( defaultLanguage );
                newAss.addText(tempText);
            }

            course.addAssignment(newAss);
        }
        else {
            saved = false;
        }
        /* XXX: qui salvo gia' su db, pero' la cosa non e' molto efficiente.. */
        
        saved = AssignmentDAO.getInstance().saveRecord( newAss );
        
        if ( !saved ) {
            
            if ( defaultLanguage == null ) 
                errors.add( ActionMessages.GLOBAL_MESSAGE, new ActionMessage("errors.savenotok", "nessun linguaggio di default impostato")  );
            else {
                course.getAssignments().remove( 0 );
                errors.add( ActionMessages.GLOBAL_MESSAGE, new ActionMessage("errors.savenotok", "probabile errore -> titolo gia' presente")  );
            }
            this.saveErrors(request, errors);
            
            Collection allcourses = connected.isSuperUser() ? AdminDAO.getInstance().getAllCourses() : connected.getCourses();
            request.setAttribute(Constants.COURSES_REQUEST_KEY, allcourses );
            request.setAttribute(Constants.COURSE_REQUEST_KEY, course);
            request.setAttribute(Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_COURSES);
            return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        }
        
        dvf.set( "id", newAss.getId() );
        dvf.set( "editmode", true );
        
        request.setAttribute(Constants.COURSE_REQUEST_KEY, course);
        request.setAttribute(Constants.ASSIGNMENT_REQUEST_KEY, newAss);
        
        request.setAttribute(Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_EXERCISES);
        
        return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        
    }
}