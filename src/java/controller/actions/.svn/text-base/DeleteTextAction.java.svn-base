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
public class DeleteTextAction extends org.apache.struts.action.Action {

    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        HttpSession session = request.getSession();

        if (session == null) {
            return mapping.findForward(Constants.LOGIN_ADMIN_FRWD);
        }

        int assignmentID = 0;
        try {
            assignmentID = Integer.parseInt(request.getParameter(Constants.ASSIGNMENT_REQUEST_KEY));
        } catch (Exception e) {
            return mapping.findForward(Constants.LOGIN_FRWD);
        }

        AssignmentDAO assdao = AssignmentDAO.getInstance();
        Assignment current = (Assignment) assdao.getRecord(assignmentID);

        int ordinal = 0;
        try {
            ordinal = Integer.parseInt(request.getParameter(Constants.ORDINAL_REQUEST_KEY));
        } catch (Exception e) {
            return mapping.findForward(Constants.LOGIN_FRWD);
        }

        Text text = new Text();
        text.setAssignment(current);
        text.setOrdinal(ordinal);
        
        Assignment currentAssign = text.getAssignment();
        currentAssign.removeText(text);
        
        boolean saved = AssignmentDAO.getInstance().saveRecord( currentAssign );

        boolean updated = TextDAO.getInstance().deleteText(text);
        
        if ( !saved || !updated ) {
            /* todo: aggiungi errore appropriato!! */
        }

        request.setAttribute( Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_EXERCISES );
        request.setAttribute( Constants.ASSIGNMENT_REQUEST_KEY, current );
        return mapping.findForward(Constants.ADMIN_PAGE_FRWD);
    }
}