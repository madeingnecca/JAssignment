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
public class DoSearchStudAction extends org.apache.struts.action.Action {
        
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        
        HttpSession session = request.getSession();
        
        if ( session == null ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }

        DynaValidatorForm dvf = ( DynaValidatorForm ) form;
        String strMatricola = null;
        String name = null;
        String surname = null;
        String selectedCourseID = null;
        
        try {
            strMatricola = dvf.getString( "matricola");
            name = dvf.getString( "name" );
            surname = dvf.getString( "surname");
            selectedCourseID = dvf.getString( "selectedCourseID");
        }
        catch ( Exception e ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }
        
        ActionErrors errors = dvf.validate(mapping, request);
        
        request.setAttribute( Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_ACTIVITY );
        if ( !errors.isEmpty()) {
            this.saveErrors(request, errors);
            request.setAttribute( Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_SEARCH_STUD );
            return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        }
        
        Student tosearch = new Student();
        
        if ( !strMatricola.equals( "" ) ) {
            /* ho già informazioni a sufficienza per fare la ricerca */
            tosearch.setMatricola( Integer.parseInt( strMatricola));
               tosearch.setNome("");
               tosearch.setCognome("");
        }
        else {
            
            boolean nameOk = !name.equals( "" );
            boolean surnameOk = !surname.equals( "" );
            
            if ( !nameOk && !surnameOk ) {
                errors.add( ActionMessages.GLOBAL_MESSAGE, new ActionMessage( "errors.studInfo" ) );
            }
            else {
               tosearch.setNome(name);
               tosearch.setCognome(surname);
            }
        }

        if ( !errors.isEmpty()) {
            this.saveErrors(request, errors);
            request.setAttribute( Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_SEARCH_STUD );
            return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        }
        
        /* faccio la ricerca dello studente e la formwardo alla pagina di report */
        int cid = Integer.parseInt( selectedCourseID );
        Course c = (Course) CourseDAO.getInstance().getRecord(cid);
        List foundStudents = AdminDAO.getInstance().getStudentsOfCourse(tosearch,c );
        
        request.setAttribute( Constants.SUB_LEVEL_REQUEST_KEY, Constants.LEVEL_REPORT_SINGLE );
        request.setAttribute( Constants.STUDENTS_REQUEST_KEY, foundStudents );
        request.setAttribute( Constants.COURSE_REQUEST_KEY, c );
        return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
    }
}