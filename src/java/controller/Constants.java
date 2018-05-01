/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

/**
 *
 * @author Dax
 */
public class Constants {

    public static final String          USER_SESSION_KEY = "user";
    public static final String          LOGGED_ADMIN_FRWD = "logged-admin";
    public static final String          LOGGED_STUD_FRWD = "logged-stud";
    public static final String          LOGIN_FRWD = "login";
    public static final String          LOGIN_ADMIN_FRWD = "loginAdmin";
    public static final String          STUD_PAGE_FRWD = "stud-page";
    public static final String          ADMIN_PAGE_FRWD = "admin-page";
    public static final String          EDIT_ADMIN_FW = "editAdmin";
    public static final String          EDIT_COURSE_FW = "editCourse";
    public static final String          EDIT_TEXT_FW = "editText";
    public static final String          EDIT_ASSIGNMENT_FW = "editAssignment";
    public static final String          EDIT_SEARCH_FW = "editSearch";
    public static final String          EDIT_LANGUAGE_FW = "editlang";

    public static final String          CHANGE_PAGE_STUD = "ChangePageAction.do";
    public static final String          CHANGE_PAGE_ADMIN = "AdminChangePageAction.do";
    public static final String          DELETE_TEXT_ACTION = "DeleteTextAction.do";
    public static final String          NEW_TEXT_ACTION = "NewTextAction.do";

    public static final String          LOGIN_ERROR_FW_STUDENT = "errorloginStudent";
    public static final String          LOGIN_ERROR_FW_ADMIN = "errorloginAdmin";

    public static final String          LEVEL_REQUEST_KEY = "l";
    public static final String          SUB_LEVEL_REQUEST_KEY = "sl";

    public static final int             LEVEL_HOME = 0;
    public static final int             LEVEL_AA = 1;
    public static final int             LEVEL_COURSES = 2;
    public static final int             LEVEL_EXERCISES = 3;
    public static final int             LEVEL_SUB_EX = 4;
    public static final int             LEVEL_RESULTS = 5;
    public static final int             LEVEL_NEW_ASSIGNMENT = 6;
    public static final int             LEVEL_ADMINS = 7;
    public static final int             LEVEL_NEW_ADMIN = 8;
    public static final int             LEVEL_EDIT_ADMIN = 30;
    public static final int             LEVEL_NEW_COURSE = 9;
    public static final int             LEVEL_NEW_LANGUAGE = 10;
    public static final int             LEVEL_LANGUAGES = 11;
    public static final int             LEVEL_EDIT_LANGUAGES = 20;
    public static final int             LEVEL_EDIT_COURSES = 12;
    public static final int             LEVEL_STUDENTS = 21;
    public static final int             LEVEL_SEARCH_STUD = 22;
    public static final int             LEVEL_REPORT_ALL = 23;
    public static final int             LEVEL_REPORT_SINGLE = 24;
    public static final int             LEVEL_ACTIVITY = 15;
    public static final int             LEVEL_SUBMISSIONS_1 = 16;
    public static final int             LEVEL_SUBMISSIONS_2 = 17;
    public static final int             LEVEL_TEXT_SUBMITTED = 18;

    public static final String          AAS_REQUEST_KEY = "aas";
    public static final String          AA_REQUEST_KEY = "aa";
    public static final String          COURSE_REQUEST_KEY = "course";
    public static final String          ASSIGNMENT_REQUEST_KEY = "assignment";
    public static final String          TEXT_REQUEST_KEY = "txt";
    public static final String          ORDINAL_REQUEST_KEY = "ord";
    public static final String          SUB_REQUEST_KEY = "sub";
    public static final String          ADMIN_REQUEST_KEY = "ad";
    public static final String          ADMINS_REQUEST_KEY = "ads";
    public static final String          ASSIGNMENT_STATE_RK = "astate";
    public static final String          LANGUAGE_REQUEST_KEY = "lang";
    public static final String          LANGUAGES_REQUEST_KEY = "langs";
    public static final String          AUXFILES_REQUEST_KEY = "aux";

    public static final String          TODO_ASSIGN_RK = "todo";
    public static final String          OPEN_SUBMITTED_ASSIGN_RK = "opensub";
    public static final String          LAST_RESULT_ASSIGN_RK = "lastres";

    public static final String          STUDENT_REQUEST_KEY = "stud";
    public static final String          STUDENTS_REQUEST_KEY = "studs";

    public static final String          COURSES_REQUEST_KEY = "cc";

    public static final int             LEVEL_RES_COMPILE = 0;
    public static final int             LEVEL_RES_EXEC = 1;
    public static final int             LEVEL_RES_PSEUDO = 2;
    public static final String[]        RIS_TYPES = new String[] { "Compilazione", "Esecuzione", "Pseudocodice"};


    public static final int             INVALID_AA = -1;

    public static final String          OPTIONS_EDIT_FLAG = "eflag";


    /* let's avoid instantiating.. */
    private Constants() {

    }

}

