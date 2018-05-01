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
public class DeleteCourseAction extends org.apache.struts.action.Action {
        
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        
        HttpSession session = request.getSession();
        
        if ( session == null ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }

        ArrayList aas = ( ArrayList ) AdminDAO.getInstance().getAcademicYears();
        AcademicYear lastAA = AdminDAO.getInstance().getLastAA();
        
        
        String selectedAYID = String.valueOf( lastAA.getId() );
        String[] allAYIDs  = new String[ aas.size() + 1 ];
        String[] allAYLabels = new String[ aas.size() + 1 ];
        
        for ( int i = 0; i < aas.size(); i++ ) {
            AcademicYear aa = ( AcademicYear ) aas.get(i);
            allAYIDs[ i ] = String.valueOf( aa.getId() );
            allAYLabels[ i ] = aa.getCompleteForm();
        }
        allAYIDs[ aas.size() ] = String.valueOf( Constants.INVALID_AA );
        allAYLabels[ aas.size() ] = lastAA.getNext().getCompleteForm();
        
        DynaValidatorForm dvf = ( DynaValidatorForm ) form;
        dvf.set( "selectedAYID", selectedAYID);
        dvf.set( "allAYIDs", allAYIDs);
        dvf.set( "allAYLabels", allAYLabels);
        
        boolean edit = (( Boolean ) request.getAttribute( Constants.OPTIONS_EDIT_FLAG ) ).booleanValue();
        
        if ( edit ) {
            Course selected = ( Course ) request.getAttribute( Constants.COURSE_REQUEST_KEY );
            dvf.set( "name", selected.getName() );
        }
        
        request.setAttribute(Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_ACTIVITY);
        request.setAttribute(Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_NEW_COURSE);
        return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        
    }
}