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
public class EditSearchStudAction extends org.apache.struts.action.Action {
        
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        
        HttpSession session = request.getSession();
        
        if ( session == null ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }
        
        Collection courses = ( Collection ) request.getAttribute( Constants.COURSES_REQUEST_KEY );
        if ( courses == null ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }
        
        Object[] coursesArray = courses.toArray();
        int size = coursesArray.length;
        String[] ids = new String[ size ];
        String[] labels = new String[ size ];
        for ( int i = 0; i < size; i++ ) {
            Course c = ( Course ) coursesArray[ i ];
            ids[ i ] = String.valueOf( c.getId() );
            labels[ i ] = c.getName() + c.getAcademicYear().getAbbreviateForm();
        }
        
        DynaValidatorForm dvf = ( DynaValidatorForm ) form;
        dvf.set( "allcoursesIDs", ids);
        dvf.set( "allcoursesLabels", labels);
        dvf.set("matricola", "");
        dvf.set("name", "" );
        dvf.set("surname", "" );
        
        request.setAttribute(Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_ACTIVITY);
        request.setAttribute(Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_SEARCH_STUD);        
        return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        
    }
}