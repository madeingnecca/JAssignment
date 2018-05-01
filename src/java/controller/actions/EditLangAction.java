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
public class EditLangAction extends org.apache.struts.action.Action {
        
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        
        HttpSession session = request.getSession();
        
        if ( session == null ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }

        Boolean edit = ( Boolean ) request.getAttribute( Constants.OPTIONS_EDIT_FLAG );
        
        if ( edit == null ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }
        
        DynaValidatorForm dvf = ( DynaValidatorForm ) form;
        
        if ( edit ) {
            Language currentLanguage = ( Language ) request.getAttribute( Constants.LANGUAGE_REQUEST_KEY );
            dvf.set( "selectedLangID", currentLanguage.getId());
            dvf.set( "ext", currentLanguage.getExt() );
            dvf.set( "formatterclass", currentLanguage.getFormatterClassString() );
            dvf.set( "testcasename", currentLanguage.getTestcaseFilename() );
            dvf.set( "codeanalizerclass", currentLanguage.getCodeanalizerClassString());
            dvf.set( "defaultlanguage", currentLanguage.isDefaultlanguage() );
            dvf.set( "coptions", currentLanguage.getCompileOptions() );
            dvf.set( "eoptions", currentLanguage.getExecOptions() );
            dvf.set( "dir", currentLanguage.getDir() );
            request.setAttribute(Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_EDIT_LANGUAGES);
        }
        else {
            dvf.set( "selectedLangID",  null );
            dvf.set( "ext", "" );
            dvf.set( "formatterclass", "" );
            dvf.set( "testcasename", "" );
            dvf.set( "codeanalizerclass", "");
            dvf.set( "defaultlanguage", false );
            dvf.set( "coptions", "" );
            dvf.set( "eoptions", "" );
            dvf.set( "dir", "" );
            request.setAttribute(Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_NEW_LANGUAGE);
        }
        
        dvf.set( "editmode", edit );
        dvf.set( "delete", false );
        
        List allLang = LanguageDAO.getInstance().getRecords();
        
        request.setAttribute( Constants.LANGUAGES_REQUEST_KEY, allLang );
        request.setAttribute(Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_ACTIVITY);
        
        
        return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        
    }
}