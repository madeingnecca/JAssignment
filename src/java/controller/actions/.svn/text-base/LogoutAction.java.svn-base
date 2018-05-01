/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller.actions;

import controller.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.servlet.http.HttpSession;
import model.Admin;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;


public class LogoutAction extends org.apache.struts.action.Action {
       
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        String fw = Constants.LOGIN_FRWD;        
        
        HttpSession session = request.getSession();
        if ( session == null || session.getAttribute( Constants.USER_SESSION_KEY ) == null ) {
            /* fare solo il forward */
            return mapping.findForward( fw );
        }
        
        /* se l'utente esiste veramente, cancella la session */
        if ( session.getAttribute( Constants.USER_SESSION_KEY) instanceof Admin )
            fw = Constants.LOGIN_ADMIN_FRWD;
        
        session.invalidate();
        return mapping.findForward( fw );
        
    }
}