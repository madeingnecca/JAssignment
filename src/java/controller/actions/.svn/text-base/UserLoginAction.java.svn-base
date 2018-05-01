/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller.actions;

import controller.*;
import controller.auth.Authenticator;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.validator.DynaValidatorForm;

import dao.*;
import model.*;
import org.apache.struts.action.ActionMessage;

/**
 *
 * @author Dax
 */
public class UserLoginAction extends Action {

    private static final String     AUTH_CLASS = "authenticator_class";

    @Override
    public ActionForward execute(   ActionMapping mapping,
                                    ActionForm form,
                                    HttpServletRequest request,
                                    HttpServletResponse response)
                                    throws IOException, ServletException {

        DynaValidatorForm dvf = ( DynaValidatorForm ) form;
        ActionErrors errors = dvf.validate(mapping, request);

        String typeQS = dvf.getString( "userType" );
        String errorFW;

        if ( typeQS.equals( "s" ) ) {
            errorFW = Constants.LOGIN_ERROR_FW_STUDENT;
        }
        else
            errorFW = Constants.LOGIN_ERROR_FW_ADMIN;

        if ( !errors.isEmpty() ) {
            this.saveErrors(request, errors );
            return mapping.findForward( errorFW );
        }


        String username = dvf.getString( "username" );
        String password = dvf.getString( "password" );

        DAO dao;
        User user = null;
        String loggedFW;
        boolean isadmin = false;

        if ( typeQS.equals( "s" ) ) {
            /* sono uno studente */
            loggedFW = Constants.LOGGED_STUD_FRWD;
        }
        else {
            /* sono un admin */
            isadmin = true;
            loggedFW = Constants.LOGGED_ADMIN_FRWD;
        }

        boolean authenticated = false;

        try {
            String authClass = this.getServlet().getServletContext().getInitParameter( AUTH_CLASS );
            Authenticator auth = ( Authenticator ) Class.forName( authClass ).newInstance();
            user = auth.authenticate(username, password, isadmin, this.getServlet() );
            authenticated = ( user != null );
        }
        catch( Exception e ){
            authenticated = false;
        }

        if ( !authenticated ) {
            errors.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage( "errors.invalidlogin" ));

            if ( !isadmin )
                errors.add(ActionMessages.GLOBAL_MESSAGE, new ActionMessage( "errors.loginsuggest" ));
        }

        if ( errors.isEmpty() ) {
            /* no errors committed */
            request.getSession( true ).setAttribute( Constants.USER_SESSION_KEY, user);
            return mapping.findForward( loggedFW );
        }

        /* todo: togliere metodo deprecato */
        this.saveErrors(request, errors );
        return mapping.findForward( errorFW );
    }

}
