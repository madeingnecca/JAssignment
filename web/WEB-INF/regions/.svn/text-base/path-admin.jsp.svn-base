<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ page import="controller.Constants" %>
<%@ page import="model.*" %>
<%!
    String enPath( String content, String prevPath ) {
        if ( !prevPath.equals( "" ) ) prevPath = " &gt; " + prevPath;
        prevPath = content + prevPath;
        return prevPath;
    }

    String toLink( String href, String cdata ) {
        return "<a href=\"" + href + "\">" + cdata + "</a>";
    }

%>
<%

Admin admin = ( Admin ) session.getAttribute( Constants.USER_SESSION_KEY );
String adminName = admin.getLogin();

int currentPage;

try {
    Integer level = ( Integer ) request.getAttribute( Constants.LEVEL_REQUEST_KEY  );
    currentPage = level.intValue();
} catch (Exception e) {
    currentPage = Constants.LEVEL_HOME;
}

String path = "";
String link = "";

AcademicYear aa = null;
Course c = null;
Assignment assign = null;
Submission sub = null;
Student stud = null;
Text txt = null;

String baseHref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=";

switch ( currentPage ) {

    
    case Constants.LEVEL_TEXT_SUBMITTED: {
        
        if ( request.getAttribute( Constants.STUDENT_REQUEST_KEY ) != null ) 
            stud = ( Student ) request.getAttribute( Constants.STUDENT_REQUEST_KEY );
        
        if ( request.getAttribute( Constants.SUB_REQUEST_KEY ) != null ) 
            sub = ( Submission ) request.getAttribute( Constants.SUB_REQUEST_KEY );
        
        if (request.getAttribute(Constants.TEXT_REQUEST_KEY) != null) 
            txt = (Text) request.getAttribute(Constants.TEXT_REQUEST_KEY);
        
        int assId = txt.getAssignment().getId();
        int ordinal = txt.getOrdinal();
        
       
        link = toLink( baseHref + Constants.LEVEL_TEXT_SUBMITTED + "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + assId
                + "&" + Constants.ORDINAL_REQUEST_KEY + "=" + ordinal +
                "&" + Constants.STUDENT_REQUEST_KEY + "=" + stud.getLogin() , "Es " + ordinal 
        ); 
        assign = txt.getAssignment();
        path = enPath( link, path ); 
    }
    case Constants.LEVEL_SUBMISSIONS_2: {
        if ( request.getAttribute( Constants.STUDENT_REQUEST_KEY ) != null ) 
            stud = ( Student ) request.getAttribute( Constants.STUDENT_REQUEST_KEY );
        
        if ( request.getAttribute( Constants.ASSIGNMENT_REQUEST_KEY ) != null ) 
            assign = ( Assignment ) request.getAttribute( Constants.ASSIGNMENT_REQUEST_KEY ); 
        
        int assId = assign.getId();
        
        String labelStud = (stud.getCognome() + " " + stud.getNome()).toUpperCase();
        link = toLink( baseHref + Constants.LEVEL_SUBMISSIONS_2 + "&" + Constants.STUDENT_REQUEST_KEY + "=" + stud.getLogin()
               + "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + assId , labelStud
        ); 
        path = enPath( link, path );
        
    }
    case Constants.LEVEL_SUBMISSIONS_1: {
        if ( request.getAttribute( Constants.ASSIGNMENT_REQUEST_KEY ) != null ) 
            assign = ( Assignment ) request.getAttribute( Constants.ASSIGNMENT_REQUEST_KEY );       
        
        int assId = assign.getId();
        
        link = toLink( baseHref + Constants.LEVEL_SUBMISSIONS_1 + "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + assId
                , "Consegne"
        ); 
        path = enPath( link, path );
    }
    case Constants.LEVEL_SUB_EX: {
        
        if ( currentPage == Constants.LEVEL_SUB_EX ) {
        
            if ( request.getAttribute( Constants.TEXT_REQUEST_KEY ) != null ) 
                txt = ( Text ) request.getAttribute( Constants.TEXT_REQUEST_KEY );

            int assId = txt.getAssignment().getId();
            int ordinal = txt.getOrdinal();

            link = toLink( baseHref + Constants.LEVEL_SUB_EX + "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + assId
                    + "&" + Constants.ORDINAL_REQUEST_KEY + "=" + ordinal, 
                    "Es " + ordinal 
            ); 
            assign = txt.getAssignment();
            path = enPath( link, path );
        }
    }
    case Constants.LEVEL_EXERCISES: {
        if ( request.getAttribute( Constants.ASSIGNMENT_REQUEST_KEY ) != null ) 
            assign = ( Assignment ) request.getAttribute( Constants.ASSIGNMENT_REQUEST_KEY );
        
        c = assign.getCourse();
        
        link = toLink( baseHref + Constants.LEVEL_EXERCISES + "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + assign.getId(), 
                assign.getTitle() 
        );
        path = enPath( link, path );
    }
    case Constants.LEVEL_COURSES: {
        if ( request.getAttribute( Constants.COURSE_REQUEST_KEY ) != null ) 
            c = ( Course ) request.getAttribute( Constants.COURSE_REQUEST_KEY );
        
        aa = c.getAcademicYear();
        
        link = toLink( baseHref + Constants.LEVEL_COURSES + "&" +  Constants.COURSE_REQUEST_KEY + "=" + c.getId()
                , c.getName() + aa.getAbbreviateForm()
        );
        path = enPath( link, path );
        
        link = toLink( baseHref + Constants.LEVEL_HOME, "Homepage admin" );
        path = enPath( link, path );
        break;
    }
    case Constants.LEVEL_ACTIVITY: {
        
        Integer sublevel = (Integer) request.getAttribute(Constants.SUB_LEVEL_REQUEST_KEY);
        
        switch( sublevel ) {
            
            case Constants.LEVEL_REPORT_SINGLE: {
                path = enPath( "Risultato ricerca", path );
            }
            case Constants.LEVEL_SEARCH_STUD: {
                link = toLink( baseHref + Constants.LEVEL_ACTIVITY + "&" + Constants.SUB_LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_SEARCH_STUD
                        , "Ricerca studente" );
                path = enPath( link, path );
                break;
            }
            case Constants.LEVEL_EDIT_ADMIN: {
                Admin current = ( Admin ) request.getAttribute( Constants.ADMIN_REQUEST_KEY );
                path = enPath( current.getLogin(), path );
            }
            case Constants.LEVEL_ADMINS: {
                link = toLink( baseHref + Constants.LEVEL_ACTIVITY + "&" + Constants.SUB_LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_ADMINS
                        , "Vedi admin" );
                path = enPath( link, path );
                break;
            }
            case Constants.LEVEL_NEW_ADMIN: {
                link = toLink( baseHref + Constants.LEVEL_ACTIVITY + "&" + Constants.SUB_LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_NEW_ADMIN
                        , "Crea admin" );
                path = enPath( link, path );
                break;
            }
            case Constants.LEVEL_EDIT_COURSES: {
                Course current = ( Course ) request.getAttribute( Constants.COURSE_REQUEST_KEY);
                path = enPath( current.getNameWithAY(), path );
            }
            case Constants.LEVEL_COURSES: {
                link = toLink( baseHref + Constants.LEVEL_ACTIVITY + "&" + Constants.SUB_LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_COURSES
                        , "Modifica corsi" );
                path = enPath( link, path );
                break;
            }
            case Constants.LEVEL_NEW_COURSE: {
                break;
            }
            case Constants.LEVEL_EDIT_LANGUAGES: {
                Language current = ( Language ) request.getAttribute( Constants.LANGUAGE_REQUEST_KEY);
                path = enPath( current.getExt(), path );  
            }
            case Constants.LEVEL_LANGUAGES: {
                link = toLink( baseHref + Constants.LEVEL_ACTIVITY + "&" + Constants.SUB_LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_LANGUAGES
                        , "Modifica linguaggi" );
                path = enPath( link, path );
                break;
            }
            case Constants.LEVEL_NEW_LANGUAGE: {
                path = enPath( "Crea linguaggio", path );  
                break;
            }
        }
    }
    case Constants.LEVEL_HOME: {
        
        link = toLink( baseHref + Constants.LEVEL_HOME, "Homepage admin" );
        path = enPath( link, path );
        break;
    }

}


%>
<div id="path_sinistra">
    <p>
         <%=path%>
    </p>
</div>		
<div id="path_centro">
</div>
<div id="path_destra">
<a href="Logout.do" target="_top"><img src="../images/sess_img.gif" alt="collegamento per logout" /></a><%=adminName%>
</div>