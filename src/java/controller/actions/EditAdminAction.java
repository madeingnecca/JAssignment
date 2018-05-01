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
public class EditAdminAction extends org.apache.struts.action.Action {
        
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        
        HttpSession session = request.getSession();
        
        if ( session == null ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }

        ArrayList courses = ( ArrayList ) AdminDAO.getInstance().getAllCourses();
        
        String[] allcoursesIDs = new String[ courses.size() ];
        String[] allcoursesLabels  = new String[ courses.size() ];
        String[] selectedCoursesIDs = new String[]{};
        
        for ( int i = 0; i < courses.size(); i++ ) {
            Course c = ( Course ) courses.get(i);
            allcoursesIDs[ i ] = String.valueOf( c.getId() );
            allcoursesLabels[ i ] = c.getName() + c.getAcademicYear().getAbbreviateForm();
        }
        
        boolean edit = ( Boolean ) request.getAttribute( Constants.OPTIONS_EDIT_FLAG );
        
        DynaValidatorForm dvf = ( DynaValidatorForm ) form;
        dvf.set( "allcoursesIDs", allcoursesIDs);
        dvf.set( "allcoursesLabels", allcoursesLabels);
        dvf.set("login", "");
        dvf.set("password", "" );
        dvf.set("password2", "" );
        dvf.set("email", "" );
        dvf.set( "editmode", false );
        dvf.set( "delete", false );
        
        request.setAttribute(Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_ACTIVITY);
        request.setAttribute(Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_NEW_ADMIN);        
        
        if ( edit ) {
            /* sono in edit mode, devo precaricare il form con dati da db */
            Admin selected = ( Admin ) request.getAttribute( Constants.ADMIN_REQUEST_KEY );
            dvf.set("login", selected.getLogin());
            dvf.set("password", selected.getPassword() );
            dvf.set("password2", selected.getPassword() );
            dvf.set("email", selected.getEmail() );
            dvf.set( "editmode", true );
            
            Set coursesOfAdmin = ( Set ) selected.getCourses();
            Object[] coa = coursesOfAdmin.toArray();
            
            selectedCoursesIDs = new String[ coa.length ];
            for ( int i = 0; i < coa.length; i++ ) {
                Course c = ( Course ) coa[ i ];
                selectedCoursesIDs[ i ] = String.valueOf( c.getId() );
            }
            request.setAttribute(Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_ACTIVITY);
            request.setAttribute(Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_EDIT_ADMIN);
        }
        
        dvf.set( "selectedCoursesIDs", selectedCoursesIDs);
        
        return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        
    }
}