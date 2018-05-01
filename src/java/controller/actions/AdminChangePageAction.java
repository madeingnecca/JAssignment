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
public class AdminChangePageAction extends org.apache.struts.action.Action {
    
    public ActionForward execute(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

        HttpSession session = request.getSession();

        if ( session == null || 
             session.getAttribute( Constants.USER_SESSION_KEY ) == null ||
             !(session.getAttribute( Constants.USER_SESSION_KEY ) instanceof Admin) ) {
            
            return mapping.findForward(Constants.LOGIN_FRWD);
        }

        int pageToGo;
        try {
            pageToGo = Integer.parseInt(request.getParameter(Constants.LEVEL_REQUEST_KEY));
        } catch (Exception e) {
            try {
                pageToGo = (Integer) request.getAttribute(Constants.LEVEL_REQUEST_KEY);
            } catch (Exception e1) {
                pageToGo = Constants.LEVEL_HOME;
            }
        }

        User userLogged = (User) session.getAttribute(Constants.USER_SESSION_KEY);

        if (userLogged == null || userLogged instanceof Student) {
            return mapping.findForward(Constants.LOGIN_FRWD);
        }

        AdminDAO adao = AdminDAO.getInstance();

        switch (pageToGo) {

            case Constants.LEVEL_COURSES: {

                int courseID = 0;
                try {
                    courseID = Integer.parseInt(request.getParameter(Constants.COURSE_REQUEST_KEY));
                } catch (Exception e) {
                    return mapping.findForward(Constants.LOGIN_FRWD);
                }

                CourseDAO cdao = CourseDAO.getInstance();
                Course current = (Course) cdao.getRecord(courseID);
                
                if ( current == null ) return mapping.findForward(Constants.LOGIN_FRWD);

                request.setAttribute(Constants.COURSE_REQUEST_KEY, current);
            }
            case Constants.LEVEL_HOME: {

                Admin admin = (Admin) userLogged;
                Collection coursesOfAdmin = null;
                if (admin.isSuperUser()) {
                    coursesOfAdmin = adao.getAllCourses();
                } else {
                    coursesOfAdmin = admin.getCourses();
                }

                request.setAttribute(Constants.COURSES_REQUEST_KEY, coursesOfAdmin);
                break;
            }
            case Constants.LEVEL_ACTIVITY: {

                Integer sublevel = Integer.parseInt(request.getParameter(Constants.SUB_LEVEL_REQUEST_KEY));

                switch (sublevel) {
                    case Constants.LEVEL_ADMINS: {
                        Admin admin = (Admin) userLogged;

                        if (!admin.isSuperUser()) {
                            /* todo: errore qui */
                        }

                        List admins = AdminDAO.getInstance().getAllAdmins();

                        request.setAttribute(Constants.ADMINS_REQUEST_KEY, admins);
                        break;

                    }
                    case Constants.LEVEL_EDIT_ADMIN: {
                        Admin selAdmin = null;

                        String param = request.getParameter(Constants.ADMIN_REQUEST_KEY);
                        try {
                            selAdmin = (Admin) AdminDAO.getInstance().getRecord(param);
                        } catch (Exception e) {
                            mapping.findForward(Constants.LOGIN_ADMIN_FRWD);
                        }

                        if ( selAdmin == null ) return mapping.findForward(Constants.LOGIN_FRWD);
                        
                        List admins = AdminDAO.getInstance().getAllAdmins();
                        List courses = AdminDAO.getInstance().getAllCourses();

                        request.setAttribute(Constants.ADMINS_REQUEST_KEY, admins);
                        request.setAttribute(Constants.ADMIN_REQUEST_KEY, selAdmin);

                        request.setAttribute(Constants.OPTIONS_EDIT_FLAG, true);
                        return mapping.findForward(Constants.EDIT_ADMIN_FW);

                    }
                    case Constants.LEVEL_NEW_ADMIN: {

                        request.setAttribute(Constants.OPTIONS_EDIT_FLAG, false);
                        return mapping.findForward(Constants.EDIT_ADMIN_FW);
                    }
                    case Constants.LEVEL_NEW_COURSE: {

                        request.setAttribute(Constants.OPTIONS_EDIT_FLAG, false);
                        return mapping.findForward(Constants.EDIT_COURSE_FW);
                    }
                    case Constants.LEVEL_COURSES: {

                        List courses = AdminDAO.getInstance().getAllCourses();
                        request.setAttribute(Constants.COURSES_REQUEST_KEY, courses);
                        break;
                    }
                    case Constants.LEVEL_EDIT_COURSES: {

                        Course selected = null;
                        String param = request.getParameter(Constants.COURSE_REQUEST_KEY);
                        try {
                            if (param != null) {
                                Integer cid = Integer.parseInt(param);
                                selected = (Course) CourseDAO.getInstance().getRecord(cid);
                            }
                        } catch (Exception e) {
                            /* errore!! */
                            return mapping.findForward(Constants.LOGIN_ADMIN_FRWD);
                        }

                        if ( selected == null ) return mapping.findForward(Constants.LOGIN_FRWD);
                        
                        request.setAttribute(Constants.OPTIONS_EDIT_FLAG, true);
                        request.setAttribute(Constants.COURSE_REQUEST_KEY, selected);
                        
                        return mapping.findForward(Constants.EDIT_COURSE_FW);
                    }
                    case Constants.LEVEL_LANGUAGES: {
                        List alllang = LanguageDAO.getInstance().getRecords();
                        
                        request.setAttribute( Constants.LANGUAGES_REQUEST_KEY, alllang );
                        break;
                    }
                    case Constants.LEVEL_EDIT_LANGUAGES: {
                        int langId = Integer.parseInt( request.getParameter( Constants.LANGUAGE_REQUEST_KEY ));                       
                        Language current = ( Language ) LanguageDAO.getInstance().getRecord( langId );
                        
                        request.setAttribute( Constants.LANGUAGE_REQUEST_KEY, current );
                        request.setAttribute(Constants.OPTIONS_EDIT_FLAG, true); 
                        return mapping.findForward(Constants.EDIT_LANGUAGE_FW);
                    }
                    case Constants.LEVEL_NEW_LANGUAGE: {
                        request.setAttribute(Constants.OPTIONS_EDIT_FLAG, false); 
                        return mapping.findForward(Constants.EDIT_LANGUAGE_FW);
                    }
                    case Constants.LEVEL_SEARCH_STUD: {
                        Admin connected = (Admin) userLogged;
                        Collection courses = null;
                        if (connected.isSuperUser()) {
                            courses = AdminDAO.getInstance().getAllCourses();
                        } else {
                            courses = connected.getCourses();
                        }
                        request.setAttribute(Constants.COURSES_REQUEST_KEY, courses);

                        return mapping.findForward(Constants.EDIT_SEARCH_FW);
                    }
                }

                request.setAttribute(Constants.SUB_LEVEL_REQUEST_KEY, sublevel);
                break;
            }
            case Constants.LEVEL_TEXT_SUBMITTED: {

                String studLogin = request.getParameter(Constants.STUDENT_REQUEST_KEY);
                if (studLogin == null) {
                    return mapping.findForward(Constants.LOGIN_FRWD);
                }
                Student stud = (Student) StudentDAO.getInstance().getRecord(studLogin);

                if ( stud == null ) return mapping.findForward(Constants.LOGIN_FRWD);
                
                int assignmentID = 0;
                try {
                    assignmentID = Integer.parseInt(request.getParameter(Constants.ASSIGNMENT_REQUEST_KEY));
                } catch (Exception e) {
                    return mapping.findForward(Constants.LOGIN_FRWD);
                }

                AssignmentDAO assdao = AssignmentDAO.getInstance();
                Assignment current = (Assignment) assdao.getRecord(assignmentID);

                if ( current == null ) return mapping.findForward(Constants.LOGIN_FRWD);
                
                int ordinal = 0;
                try {
                    ordinal = Integer.parseInt(request.getParameter(Constants.ORDINAL_REQUEST_KEY));
                } catch (Exception e) {
                    return mapping.findForward(Constants.LOGIN_FRWD);
                }

                Text text = new Text();
                text.setAssignment(current);
                text.setOrdinal(ordinal);
                text = (Text) TextDAO.getInstance().getRecord(text);

                if ( text == null ) return mapping.findForward(Constants.LOGIN_FRWD);
                
                Submission submission = (Submission) stud.getSubmissions().get(text);

                request.setAttribute(Constants.STUDENT_REQUEST_KEY, stud);
                request.setAttribute(Constants.SUB_REQUEST_KEY, submission);
                request.setAttribute(Constants.TEXT_REQUEST_KEY, text);

                break;
            }
            case Constants.LEVEL_SUBMISSIONS_2: {
                String studLogin = request.getParameter(Constants.STUDENT_REQUEST_KEY);
                if (studLogin == null) {
                    return mapping.findForward(Constants.LOGIN_FRWD);
                }
                Student stud = (Student) StudentDAO.getInstance().getRecord(studLogin);

                request.setAttribute(Constants.STUDENT_REQUEST_KEY, stud);
            }
            case Constants.LEVEL_SUBMISSIONS_1: {

                int assignmentID = 0;
                try {
                    assignmentID = Integer.parseInt(request.getParameter(Constants.ASSIGNMENT_REQUEST_KEY));
                } catch (Exception e) {
                    return mapping.findForward(Constants.LOGIN_FRWD);
                }
                
                AssignmentDAO assdao = AssignmentDAO.getInstance();
                Assignment current = (Assignment) assdao.getRecord(assignmentID);

                if ( current == null ) return mapping.findForward(Constants.LOGIN_FRWD);
                
                request.setAttribute(Constants.ASSIGNMENT_REQUEST_KEY, current);

                List submitters = AdminDAO.getInstance().getSubmitters(current);
                request.setAttribute(Constants.STUDENTS_REQUEST_KEY, submitters);
                break;
            }
            case Constants.LEVEL_EXERCISES: {
                int assignmentID = 0;
                try {
                    assignmentID = Integer.parseInt(request.getParameter(Constants.ASSIGNMENT_REQUEST_KEY));
                } catch (Exception e) {
                    return mapping.findForward(Constants.LOGIN_FRWD);
                }

                AssignmentDAO assdao = AssignmentDAO.getInstance();
                Assignment current = (Assignment) assdao.getRecord(assignmentID);
                
                if ( current == null ) return mapping.findForward(Constants.LOGIN_FRWD); 
                

                request.setAttribute(Constants.ASSIGNMENT_REQUEST_KEY, current);

                if ( Assignment.canEdit( Assignment.getState( current )) ) {
                    /* devo passare per l'edit assgnment */
                    request.setAttribute(Constants.LEVEL_REQUEST_KEY, pageToGo);
                    return mapping.findForward(Constants.EDIT_ASSIGNMENT_FW);
                }
                break;
            }
            case Constants.LEVEL_SUB_EX: {

                int assignmentID = 0;
                try {
                    assignmentID = Integer.parseInt(request.getParameter(Constants.ASSIGNMENT_REQUEST_KEY));
                } catch (Exception e) {
                    return mapping.findForward(Constants.LOGIN_FRWD);
                }

                AssignmentDAO assdao = AssignmentDAO.getInstance();
                Assignment current = (Assignment) assdao.getRecord(assignmentID);

                if ( current == null ) return mapping.findForward(Constants.LOGIN_FRWD);
                
                int ordinal = 0;
                try {
                    ordinal = Integer.parseInt(request.getParameter(Constants.ORDINAL_REQUEST_KEY));
                } catch (Exception e) {
                    return mapping.findForward(Constants.LOGIN_FRWD);
                }

                Text text = new Text();
                text.setAssignment(current);
                text.setOrdinal(ordinal);
                text = (Text) TextDAO.getInstance().getRecord(text);

                if ( text == null )  return mapping.findForward(Constants.LOGIN_FRWD);
                
                request.setAttribute(Constants.TEXT_REQUEST_KEY, text);

                if ( Assignment.canEdit( Assignment.getState( current ))) {
                    /* devo passare per l'edit assgnment */
                    request.setAttribute(Constants.LEVEL_REQUEST_KEY, pageToGo);
                    return mapping.findForward(Constants.EDIT_TEXT_FW);
                }

                break;
            }

        }
        request.setAttribute(Constants.LEVEL_REQUEST_KEY, pageToGo);
        return mapping.findForward(Constants.ADMIN_PAGE_FRWD);
    }
}