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
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

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
import fi.iki.santtu.md5.MD5;

/**
 *
 * @author Dax
 */
public class NewCourseAction extends org.apache.struts.action.Action {
        
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        
        HttpSession session = request.getSession();        
        
        Admin root = ( Admin ) session.getAttribute( Constants.USER_SESSION_KEY );
        if ( root == null || !root.isSuperUser())
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        
        if ( session == null ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }
       
        request.setAttribute( Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_ACTIVITY );


        List aas = AdminDAO.getInstance().getAcademicYears();
        AcademicYear lastAA = AdminDAO.getInstance().getLastAA();
        request.setAttribute(Constants.AAS_REQUEST_KEY, aas);
        request.setAttribute(Constants.AA_REQUEST_KEY, lastAA);
        
        String name;
        Integer aaID;
        Boolean toDelete;
        Boolean editMode;
        
        DynaValidatorForm dvf = ( DynaValidatorForm ) form;
        ActionErrors errors = dvf.validate(mapping, request);
        
        editMode = (Boolean) dvf.get( "editmode" );
        
        if ( editMode ) {
            request.setAttribute( Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_EDIT_COURSES );
        } else {
            request.setAttribute( Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_NEW_COURSE ); 
        }
        
        if ( !errors.isEmpty() ) {
            this.saveErrors(request, errors);
            request.setAttribute( Constants.OPTIONS_EDIT_FLAG, false);
            return mapping.findForward( Constants.EDIT_COURSE_FW );
        }
        
        try {
            name = dvf.getString( "name" );
            aaID = Integer.parseInt(dvf.getString( "selectedAYID" ));
            toDelete = (Boolean) dvf.get( "delete" );
        }
        catch ( Exception e ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }
        
        ActionMessages msgs = new ActionMessages();
        boolean saved = true;
        Course tosave = null;
        
        if ( editMode ) {
            
            Integer cid = ( Integer ) dvf.get( "id" );
            tosave = (Course) CourseDAO.getInstance().getRecord( cid  );
            
             if ( toDelete ) {
                 /* se il corso voglio cancellarlo */
                tosave.getAcademicYear().removeCourse(tosave); 
                saved = CourseDAO.getInstance().removeRecord( cid );
                request.setAttribute( Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_COURSES );
             }
             else {
                 /* voglio aggiornare il corso e basta */
                    AcademicYear aa;

                    if ( aaID == Constants.INVALID_AA ) {
                        /* ho scelto di creare un nuovo anno accademico */
                        AcademicYear last = AdminDAO.getInstance().getLastAA();
                        AcademicYear newLast = last.getNext();
                        aa = newLast;
                        AcademicYearDAO.getInstance().saveRecord( newLast );
                    }
                    else {
                        /* altrimenti dall'id mi prelevo l'oggetto */
                        aa = (AcademicYear) AcademicYearDAO.getInstance().getRecord( aaID );
                    }
                    tosave.setName(name);
                    tosave.setAcademicYear(aa);
                    saved = CourseDAO.getInstance().saveRecord( tosave );
                    saved = saved && AcademicYearDAO.getInstance().saveRecord( tosave.getAcademicYear() );
             }
        }
        else {
            /* devo creare un nuovo corso */
            AcademicYear aa;

            if ( aaID == Constants.INVALID_AA ) {
                /* ho scelto di creare un nuovo anno accademico */
                AcademicYear last = AdminDAO.getInstance().getLastAA();
                AcademicYear newLast = last.getNext();
                aa = newLast;
                AcademicYearDAO.getInstance().saveRecord( newLast );
            }
            else {
                /* altrimenti dall'id mi prelevo l'oggetto */
                aa = (AcademicYear) AcademicYearDAO.getInstance().getRecord( aaID );
            }

            /* creo corso e lo salvo */
            tosave = new Course();
            tosave.setName(name);
            aa.addCourse( tosave );
            saved = saved && AcademicYearDAO.getInstance().saveRecord( tosave.getAcademicYear() );
            saved = CourseDAO.getInstance().saveRecord( tosave );
        }
        
        if (!saved) {
            
            if ( !toDelete ) {
                errors.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("errors.savenotok"));
            }
            else {
                errors.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("errors.deletenotok", "errore sconosciuto"));
            }
            this.saveErrors(request, errors);
        }
        else {
            msgs.add( ActionMessages.GLOBAL_MESSAGE, new ActionMessage( "messages.saveok" ) );
            this.saveMessages(request, msgs);
            request.setAttribute( Constants.COURSE_REQUEST_KEY, tosave );
        }
        
        Collection allCourses = AdminDAO.getInstance().getAllCourses();
        request.setAttribute( Constants.COURSES_REQUEST_KEY, allCourses );
        
        /* resetto il form.. */
        dvf.reset(mapping, request);
        return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
    }
}