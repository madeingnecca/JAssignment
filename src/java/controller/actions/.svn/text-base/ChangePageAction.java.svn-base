/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller.actions;

import controller.*;
import dao.*;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.servlet.http.HttpSession;
import model.*;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;

/**
 *
 * @author Dax
 */
public class ChangePageAction extends org.apache.struts.action.Action {
        
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        HttpSession session = request.getSession();
        
        if ( session == null || 
             session.getAttribute( Constants.USER_SESSION_KEY ) == null ||
             !(session.getAttribute( Constants.USER_SESSION_KEY ) instanceof Student) ) {
            
            return mapping.findForward(Constants.LOGIN_FRWD);
        }
        
        int pageToGo;
        try {
            pageToGo = Integer.parseInt( request.getParameter( Constants.LEVEL_REQUEST_KEY ) );
        } catch ( Exception e ) {
            try {
                pageToGo = ( Integer ) request.getAttribute( Constants.LEVEL_REQUEST_KEY );
            }
            catch( Exception e1 ) {
                pageToGo = Constants.LEVEL_HOME;
            }
        }
        
        User userLogged = ( User ) session.getAttribute( Constants.USER_SESSION_KEY );
        
        if ( userLogged == null ) {
            return mapping.findForward( Constants.LOGIN_FRWD );
        }
        
        if ( userLogged instanceof Admin ) return mapping.findForward( Constants.LOGIN_FRWD );
        
        StudentDAO sdao = StudentDAO.getInstance();
        

        
        switch ( pageToGo ) {
            
            case Constants.LEVEL_HOME: {
                AcademicYear lastAA = sdao.getLastAA();
                if ( lastAA == null ) {
                    lastAA = null;
                }
                
                List todoAssignments = sdao.getTODOAssignments( ( Student ) userLogged );
                List lastSubmitted = sdao.getLastSubmitted( ( Student ) userLogged );
                List lastResults = sdao.getLastResults( ( Student ) userLogged );
                
                request.setAttribute( Constants.AA_REQUEST_KEY, lastAA );
                request.setAttribute( Constants.TODO_ASSIGN_RK, todoAssignments );
                request.setAttribute( Constants.OPEN_SUBMITTED_ASSIGN_RK, lastSubmitted );
                request.setAttribute( Constants.LAST_RESULT_ASSIGN_RK, lastResults );
                break;
            }
            case Constants.LEVEL_AA: {
                List aas = sdao.getAcademicYears();
                AcademicYear theAA = null;
                
                int aaID = 0;
                try {
                    aaID = Integer.parseInt( request.getParameter( Constants.AA_REQUEST_KEY ) );
                    theAA = ( AcademicYear ) AcademicYearDAO.getInstance().getRecord(aaID);
                } catch ( Exception e ) {
                    theAA = sdao.getLastAA();
                }
                
                if ( theAA == null ) return mapping.findForward( Constants.LOGIN_FRWD );
                
                request.setAttribute( Constants.AAS_REQUEST_KEY, aas );
                request.setAttribute( Constants.AA_REQUEST_KEY, theAA );
                break;
            }
            case Constants.LEVEL_COURSES: {
                
                int courseID = 0;
                try {
                    courseID = Integer.parseInt( request.getParameter( Constants.COURSE_REQUEST_KEY ) );
                } catch ( Exception e ) {
                    return mapping.findForward( Constants.LOGIN_FRWD );
                }
                
                CourseDAO cdao = CourseDAO.getInstance();
                Course current = ( Course ) cdao.getRecord( courseID );
                               
                if ( current == null ) return mapping.findForward( Constants.LOGIN_FRWD );
                
                request.setAttribute( Constants.COURSE_REQUEST_KEY, current);
                break;
            }
            case Constants.LEVEL_EXERCISES: {
                
                int assignmentID = 0;
                try {
                    assignmentID = Integer.parseInt( request.getParameter( Constants.ASSIGNMENT_REQUEST_KEY ) );
                } catch ( Exception e ) {
                    return mapping.findForward( Constants.LOGIN_FRWD );
                }
                
                AssignmentDAO adao = AssignmentDAO.getInstance();
                Assignment current = ( Assignment ) adao.getRecord( assignmentID );
                               
                if ( current == null ) return mapping.findForward( Constants.LOGIN_FRWD );
                
                request.setAttribute( Constants.ASSIGNMENT_REQUEST_KEY, current);
                break;
            }
            case Constants.LEVEL_RESULTS: {
                
            }
            case Constants.LEVEL_SUB_EX: {
                
                int exercisenumber = 0;
                try {
                    exercisenumber = Integer.parseInt(request.getParameter(Constants.ORDINAL_REQUEST_KEY));
                } catch (Exception e) {
                    try {
                        exercisenumber = ( Integer ) request.getAttribute(Constants.ORDINAL_REQUEST_KEY);
                    } catch ( Exception e1 ) {
                        return mapping.findForward(Constants.LOGIN_FRWD);
                    }
                }
                
                int assignmentID = 0;
                Assignment current = null;
                
                try {
                    assignmentID = Integer.parseInt(request.getParameter(Constants.ASSIGNMENT_REQUEST_KEY));
                    AssignmentDAO adao = AssignmentDAO.getInstance();
                    current = ( Assignment ) adao.getRecord( assignmentID );
                    
                } catch (Exception e) {
                    try {
                        current = ( Assignment ) request.getAttribute(Constants.ASSIGNMENT_REQUEST_KEY);
                    } catch ( Exception e1 ) {
                        return mapping.findForward(Constants.LOGIN_FRWD);
                    }
                }
               
                if ( current == null ) return mapping.findForward( Constants.LOGIN_FRWD );
                
                Text txt = new Text();
                txt.setAssignment(current);
                txt.setOrdinal(exercisenumber);
                txt =       (Text) TextDAO.getInstance().getRecord(txt);
                
                if ( txt == null ) return mapping.findForward( Constants.LOGIN_FRWD );
                
                Student stud = (Student) session.getAttribute(Constants.USER_SESSION_KEY);
                Submission submissionOfStudent = (Submission) stud.getSubmissions().get(txt);
                
                
                if ( submissionOfStudent == null  ) {
                    /* se non ho consegnato il sotto esercizio, e' come se ne avessi consegnato uno vuoto*/
                    submissionOfStudent = new Submission();
                    submissionOfStudent.setLogin(stud);
                    submissionOfStudent.setExerciseText("");
                    submissionOfStudent.setPseudoText("");
                    submissionOfStudent.setText(txt);
                } else {
                    submissionOfStudent.setText(txt);
                    submissionOfStudent.setLogin(stud);
                    if ( submissionOfStudent.getResult() != null && !submissionOfStudent.getResult().isSeenByUser() ) {
                        submissionOfStudent.getResult().setSeenByUser( true );

                        dao.ResultDAO.getInstance().saveRecord( submissionOfStudent.getResult() );
                    }
                    
                }
                
                
                
                request.setAttribute( Constants.SUB_REQUEST_KEY, submissionOfStudent);
                
                int risType = 0;
                try {
                    risType = Integer.parseInt( request.getParameter( Constants.SUB_LEVEL_REQUEST_KEY ) );
                } catch ( Exception e ) {
                    break;
                }
                
                if ( risType == Constants.LEVEL_RES_COMPILE ) {
                    
                }
                else if ( risType == Constants.LEVEL_RES_EXEC ) {
                    
                }
                else if ( risType == Constants.LEVEL_RES_PSEUDO ) {
                    
                }
                else {
                    return mapping.findForward( Constants.LOGIN_FRWD );
                }
                
                request.setAttribute( Constants.SUB_LEVEL_REQUEST_KEY, risType );
                break;
                
            }  
            
        }
        request.setAttribute( Constants.LEVEL_REQUEST_KEY, pageToGo );
        return mapping.findForward( Constants.STUD_PAGE_FRWD );
        
    }
}