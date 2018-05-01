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
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;
import org.apache.struts.validator.DynaValidatorForm;

/**
 *
 * @author Dax
 */
public class EditAssignmentAction extends org.apache.struts.action.Action {
        
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        HttpSession session = request.getSession();
        
        if ( session == null ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }
        
        Assignment currentAssign = ( Assignment ) request.getAttribute( Constants.ASSIGNMENT_REQUEST_KEY );

        DynaValidatorForm dvf = ( DynaValidatorForm ) form;
        
        dvf.set( "title", currentAssign.getTitle() );
        
        String strStartTime = Util.dateToString( currentAssign.getStartTime() );
        String strDeadLine = Util.dateToString( currentAssign.getDeadline() );
        
        dvf.set( "id", currentAssign.getId() );
        dvf.set( "start", strStartTime );
        dvf.set( "end", strDeadLine );
        dvf.set( "nes", currentAssign.getTexts().size() );
        dvf.set( "editmode", true );
        dvf.set( "delete", false );
        dvf.set( "startNow", false );

        return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        
    }
}