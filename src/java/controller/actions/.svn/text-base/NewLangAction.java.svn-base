/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller.actions;

import controller.*;
import dao.*;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.servlet.http.HttpSession;
import model.*;
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
public class NewLangAction extends org.apache.struts.action.Action {
        
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
        
        DynaValidatorForm dvf = ( DynaValidatorForm ) form;
        ActionErrors errors = dvf.validate(mapping, request);
        
        Boolean editMode = (Boolean) dvf.get( "editmode" );
        Integer langId = null;
        Language tosave = null;
        
        List allLangs = LanguageDAO.getInstance().getRecords();
        request.setAttribute( Constants.LANGUAGES_REQUEST_KEY, allLangs );
        
        if ( editMode ) {
            request.setAttribute( Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_ACTIVITY );
            request.setAttribute( Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_EDIT_LANGUAGES );
        }
        else {
            request.setAttribute( Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_ACTIVITY );
            request.setAttribute( Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_NEW_LANGUAGE );
        }
        
        if ( !errors.isEmpty() ) {
            
            if ( editMode ) {
                 langId = (Integer) dvf.get( "selectedLangID" );
                 tosave = (Language) LanguageDAO.getInstance().getRecord( langId );
                 request.setAttribute( Constants.LANGUAGE_REQUEST_KEY, tosave );
            }
            this.saveErrors(request, errors);
            request.setAttribute( Constants.OPTIONS_EDIT_FLAG, false);
            return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        }
        
        String name = "";
        String formatterclass = "";
        String codeanalizerclass = "";
        String testcasename = "";
        Boolean toDelete = null;
        String compOptions = "";
        String execOptions = "";
        Boolean defaultlang = null;
        String dir = null;
        
        try {
            name = dvf.getString( "ext" );
            formatterclass = dvf.getString( "formatterclass" );
            codeanalizerclass = dvf.getString( "codeanalizerclass" );
            toDelete = ( Boolean ) dvf.get( "delete" );
            testcasename = dvf.getString( "testcasename" );
            langId = (Integer) dvf.get( "selectedLangID" );
            compOptions = dvf.getString( "coptions" );
            execOptions = dvf.getString( "eoptions" );
            defaultlang = ( Boolean ) dvf.get( "defaultlanguage" );
            dir = dvf.getString( "dir" );
            
        }
        catch ( Exception e ) {
            return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        }
       
        ActionMessages msgs = new ActionMessages();
        
        boolean saved = true;
        
        
        if ( editMode ) {

            if ( toDelete ) {
                saved = LanguageDAO.getInstance().removeRecord(langId);
                
                /* forward verso pagina linguaggi */
                request.setAttribute( Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_LANGUAGES );
            }
            else {
                
                langId = (Integer) dvf.get( "selectedLangID" );
                tosave = (Language) LanguageDAO.getInstance().getRecord( langId );
                
                tosave.setTestcaseFilename(testcasename);
                tosave.setCompileOptions(compOptions);
                tosave.setExecOptions(execOptions);
                tosave.setDefaultlanguage(defaultlang);
                tosave.setFormatterClassString(formatterclass);
                tosave.setCodeanalizerClassString(codeanalizerclass);
                tosave.setDir(dir);
                
                /* faccio l'update del linguaggio */
                saved = saved && LanguageDAO.getInstance().saveRecord(tosave);
                request.setAttribute( Constants.LANGUAGE_REQUEST_KEY, tosave );
            }
        }
        else {
            tosave = LanguageDAO.getInstance().createLanguage(
                    name, 
                    formatterclass, 
                    testcasename, 
                    codeanalizerclass,
                    defaultlang, 
                    compOptions, 
                    execOptions, 
            dir ); 
            saved = saved && ( tosave != null );
        }

 
        if (!saved) {
            
            if ( !toDelete ) {
                if ( tosave != null )
                    tosave.setDefaultlanguage( false );
                errors.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("errors.savenotok"));
            }
            else 
                errors.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("errors.deletenotok", "necessario almeno un linguaggio di default"));
            this.saveErrors(request, errors);
        }
        else {
            msgs.add( ActionMessages.GLOBAL_MESSAGE, new ActionMessage( "messages.saveok" ) );
            this.saveMessages(request, msgs);
            request.setAttribute( Constants.LANGUAGE_REQUEST_KEY, tosave );
        }
        
        /* resetto il form.. */
        dvf.reset(mapping, request);
        return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        
    }
}