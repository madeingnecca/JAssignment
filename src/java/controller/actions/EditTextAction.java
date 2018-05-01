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
public class EditTextAction extends org.apache.struts.action.Action {
        
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        HttpSession session = request.getSession();
        
        if ( session == null ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }
        
        Text currentText = ( Text ) request.getAttribute( Constants.TEXT_REQUEST_KEY );
        Assignment currentAssign = currentText.getAssignment();
        int assId = currentAssign.getId();
        
        DynaValidatorForm dvf = ( DynaValidatorForm ) form;
        
        List allLanguages = LanguageDAO.getInstance().getRecords();
        String[] allLanguagesIDs = new String[ allLanguages.size() ];
        String[] allLanguagesLabels = new String[ allLanguages.size() ]; 
        for ( int i = 0; i < allLanguages.size(); i++ ) {
            allLanguagesIDs[ i ] = String.valueOf((( Language ) allLanguages.get(i)).getId());
            allLanguagesLabels[ i ] = (( Language ) allLanguages.get(i)).getExt();
        }
        
        List auxfiles = AuxiliarySourceFileDAO.getInstance().getAvailableAuxiliaryFiles(currentText);
        request.setAttribute( Constants.AUXFILES_REQUEST_KEY, auxfiles );
        
        dvf.set( "allLanguagesIDs", allLanguagesIDs );
        dvf.set("allLanguagesLabels", allLanguagesLabels);
        dvf.set( "selectedLangID", currentText.getLanguage().getId());
        dvf.set( "assid", assId );
        dvf.set( "ordinal", currentText.getOrdinal() );
        
        String testo = currentText.getText();
        
        dvf.set( "text", testo );
        /* TODO: aggiungere i set che mancano..*/
        dvf.set("human", currentText.isHumanNeeded() );
        dvf.set("pseudocode", currentText.isPseudocodeRequested() );
        dvf.set("timeout", currentText.getTimeout() );
        dvf.set( "submitname", currentText.getSubmitFileName() );
        dvf.set( "editmode", true );
        
        dvf.set( "io_perm", currentText.canExecuteIO() );
        dvf.set( "thread_perm", currentText.canExecuteThread() );
        dvf.set( "sock_srv_perm", currentText.canExecuteSocketServer());
        dvf.set( "sock_clnt_perm", currentText.canExecuteSocket() );
        
        request.setAttribute( Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_SUB_EX);
        return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        
    }
}