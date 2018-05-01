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

Student student = ( Student ) session.getAttribute( Constants.USER_SESSION_KEY );
String studentName = student.getCognome() + " " + student.getNome();
studentName = studentName.toUpperCase();

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

String baseHref = Constants.CHANGE_PAGE_STUD + "?" + Constants.LEVEL_REQUEST_KEY + "=";

switch ( currentPage ) {

    case Constants.LEVEL_RESULTS: {
        
        if ( request.getAttribute( Constants.SUB_REQUEST_KEY ) != null ) 
            sub = ( Submission ) request.getAttribute( Constants.SUB_REQUEST_KEY );
        
        int assId = sub.getText().getAssignment().getId();
        int ordinal = sub.getText().getOrdinal();
        
        Integer risType = ( Integer ) request.getAttribute( Constants.SUB_LEVEL_REQUEST_KEY );
       
        link = toLink( baseHref + Constants.LEVEL_RESULTS + "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + assId
                + "&" + Constants.ORDINAL_REQUEST_KEY + "=" + ordinal + "&" + 
                Constants.SUB_LEVEL_REQUEST_KEY + "=" + risType, 
                "Ris " +  Constants.RIS_TYPES[ risType ]
        ); 
        assign = sub.getText().getAssignment();
        path = enPath( link, path );        
    }
    case Constants.LEVEL_SUB_EX: {
        if ( request.getAttribute( Constants.SUB_REQUEST_KEY ) != null ) 
            sub = ( Submission ) request.getAttribute( Constants.SUB_REQUEST_KEY );
        
        int assId = sub.getText().getAssignment().getId();
        int ordinal = sub.getText().getOrdinal();
        
        link = toLink( baseHref + Constants.LEVEL_SUB_EX + "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + assId
                + "&" + Constants.ORDINAL_REQUEST_KEY + "=" + ordinal, 
                "Es " + ordinal 
        ); 
        assign = sub.getText().getAssignment();
        path = enPath( link, path );
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
                , c.getName()
        );
        path = enPath( link, path );
    }
    case Constants.LEVEL_AA: {
        if ( request.getAttribute( Constants.AA_REQUEST_KEY ) != null ) 
            aa = ( AcademicYear ) request.getAttribute( Constants.AA_REQUEST_KEY );
        
        link = toLink( baseHref + Constants.LEVEL_AA + "&" +  Constants.AA_REQUEST_KEY + "=" + aa.getId()
                ,"AA " + aa.getFirstYear() + "-" + aa.getSecondYear()
        );
        path = enPath( "Archivio &gt; " + link, path );
    }
    case Constants.LEVEL_HOME: {
        
        link = toLink( baseHref + Constants.LEVEL_HOME, "Homepage" );
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
<a href="Logout.do" target="_top"><img src="images/sess_img.gif" alt="collegamento per logout" /></a><%=studentName%>
</div>