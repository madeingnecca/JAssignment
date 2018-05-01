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
import java.util.Set;
import controller.mail.EmailSender;

public class NewAdminAction extends org.apache.struts.action.Action {
        
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        
        HttpSession session = request.getSession();
        
        if ( session == null ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }
        
        Admin root = ( Admin ) session.getAttribute( Constants.USER_SESSION_KEY );
        if ( root == null || !root.isSuperUser())
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );      
        
        DynaValidatorForm dvf = ( DynaValidatorForm ) form;
        ActionErrors errors = dvf.validate(mapping, request);
        
        Boolean editMode = (Boolean) dvf.get( "editmode" );
        String login = null;
        Admin tosave = null;
       
        request.setAttribute( Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_ACTIVITY );
        
        if ( !editMode ) {
            request.setAttribute( Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_NEW_ADMIN );
        } else {
            request.setAttribute( Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_EDIT_ADMIN );
        }
        
        
        List alladmins = AdminDAO.getInstance().getAllAdmins();
        request.setAttribute( Constants.ADMINS_REQUEST_KEY, alladmins );
        
        if ( !errors.isEmpty() ) {
            
            if ( editMode ) {
                 login = dvf.getString( "login" );
                 tosave = (Admin) AdminDAO.getInstance().getRecord( login );
                 request.setAttribute( Constants.ADMIN_REQUEST_KEY, tosave );
                 
            }
            this.saveErrors(request, errors);
            request.setAttribute( Constants.OPTIONS_EDIT_FLAG, false);
            return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        }
        
        String password;
        String password2;
        String email;
        String[] courses;
        Boolean toDelete;
        Boolean newPass;
        
        try {
            login = dvf.getString( "login" );
            password = dvf.getString( "password" );
            password2 = dvf.getString( "password2" );
            courses = dvf.getStrings( "selectedCoursesIDs" );
            toDelete = (Boolean) dvf.get( "delete" );
            email = dvf.getString( "email" );
            newPass = ( Boolean ) dvf.get( "newpass" );
            newPass = ( newPass != null ) && newPass;
        }
        catch ( Exception e ) {
            return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        }

        if ( !password.equals( password2 ) ) {
            errors.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage( "errors.differentPassword" ));
            this.saveErrors(request, errors);
            return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        }

        ActionMessages msgs = new ActionMessages();
        boolean saved = true;
        String error = "errore generico jdbc";
        
        if ( editMode ) {
            if ( toDelete ) {
                
                request.setAttribute( Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_ADMINS );
                    
                saved = AdminDAO.getInstance().removeRecord( login );

            }
            else {
                tosave = (Admin) AdminDAO.getInstance().getRecord( login );
            }
        }
        else {
            tosave = new Admin();
            tosave.setLogin(login);
            tosave.setPassword(new MD5(password).asHex());
            
            if ( AdminDAO.getInstance().recordExists( login ) ) {
                saved = false;
                error = "login gia presente";
            }
        }
        
        boolean sendemail = false;

        if ( !toDelete ) {
            
            tosave.setEmail(email);
            
            if ( newPass ) {
                
                password = Admin.generatePassword();

                sendemail = true;
            }
            
            /* se devo salvare un admin che prima era in edit mode, salvo i suoi corsi e l'email*/
            root.revokeAllPriviledges( tosave );
            
            for (int i = 0; i < courses.length; i++) {
                int id = Integer.parseInt(courses[i]);
                Course c = (Course) CourseDAO.getInstance().getRecord(id);
                root.addPriviledge(tosave, c);
            }
            
            saved = saved && AdminDAO.getInstance().saveRecord(tosave);
        }
        
        if (!saved) {
            
            if ( !editMode ) {
                /* se non riesce a salvare l'oggetto probabilmente e' perche' c'e' gia' un admin con quel login*/
                if ( !toDelete )
                    errors.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("errors.savenotok", error));
                else 
                    errors.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("errors.deletenotok", "errore generico jdbc" ));
            } else {
                errors.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage("errors.savenotok", "errore generico jdbc" ));
            }
            this.saveErrors(request, errors);
            return mapping.findForward(Constants.ADMIN_PAGE_FRWD);
        }
        else {
            
            if ( sendemail ) {
                tosave.setPassword( new MD5( password ).asHex() );
                
                EmailSender mailer;
                mailer = EmailSender.getInstance( 
                        this.getServlet().getServletContext().getRealPath("/") +
                        this.getServlet().getServletContext().getInitParameter( EmailSender.MAIL_CONF_XML ) 
                );
                boolean sentmail = mailer.sendNewPassAdmin( root, tosave, password );
                if ( sentmail )
                    msgs.add( ActionMessages.GLOBAL_MESSAGE,  new ActionMessage( "messages.admin_mail" ) );
                else 
                    msgs.add( ActionMessages.GLOBAL_MESSAGE,  new ActionMessage( "messages.admin_mail_failed" ) );
            }
            
            msgs.add( ActionMessages.GLOBAL_MESSAGE, new ActionMessage( "messages.saveok" ) );
            this.saveMessages(request, msgs);
            request.setAttribute( Constants.ADMIN_REQUEST_KEY, tosave );

            alladmins = AdminDAO.getInstance().getAllAdmins();
            request.setAttribute( Constants.ADMINS_REQUEST_KEY, alladmins );
        }
        
        /* resetto il form.. */
        dvf.reset(mapping, request);        
        return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        
    }
}