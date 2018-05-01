<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ page import="controller.Constants" %>
<%@ page import="model.*" %>
<%@ page import="java.util.*" %>
<%@ page import="util.*" %>
<h1>&gt;&gt;&gt;</h1>

<%
int currentPage;

try {
    Integer level = ( Integer ) request.getAttribute( Constants.LEVEL_REQUEST_KEY  );
    currentPage = level.intValue();
} catch (Exception e) {
    currentPage = Constants.LEVEL_HOME;
}



switch ( currentPage ) {

    case Constants.LEVEL_HOME: {
        /* faccio vedere gli anni accademici */
        AcademicYear lastAA = ( AcademicYear ) request.getAttribute( Constants.AA_REQUEST_KEY );
        List<Course> coursesOfAA = lastAA.getCourses();

        
        %>
        <h2><%= "AA" + lastAA.getFirstYear() + "-" + lastAA.getSecondYear()%></h2>        
        <%
        
        if ( coursesOfAA.size() == 0 ) {
            %>
            <p><%= "Nessun corso disponibile"%></p>
            <%            
        }else {
            %>
            <ul class="menulist">
            <%
        }
        String qs = Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_COURSES ;
        String cid = Constants.COURSE_REQUEST_KEY;
        
        for ( Course c : coursesOfAA ) {
             %>
             <li><a href="ChangePageAction.do?<%=qs%>&<%=cid%>=<%=c.getId()%>"><%=c.getName()%></a></li>
             <%
        }
        
        qs = Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_AA ;
        String aaid = Constants.AA_REQUEST_KEY;
        %>
    </ul>
    <h2>Archivio</h2> 
    <ul class="menulist">
        <li><a href="ChangePageAction.do?<%=qs%>&<%=aaid%>=<%=lastAA.getId()%>">Sfoglia per anno accademico</a></li>
    </ul> 
<%
        break;
    }
    case Constants.LEVEL_AA: {
        
        AcademicYear currentAA = ( AcademicYear ) request.getAttribute( Constants.AA_REQUEST_KEY );
        List<AcademicYear> allAAs = ( List ) request.getAttribute( Constants.AAS_REQUEST_KEY );
        
        String basehref = Constants.CHANGE_PAGE_STUD + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_AA;
        %>
        <h2>Archivio</h2> 
        <ul class="menulist">
        <%
        for ( AcademicYear tempAA : allAAs ) {
            String aclass = "";
            String href = basehref + "&" + Constants.AA_REQUEST_KEY + "=" + tempAA.getId();
            if ( tempAA.getId() == currentAA.getId() ) aclass = "current";
            %>
            <li class="<%=aclass%>"><a href="<%=href%>" ><%=tempAA.getFirstYear() + "-" + tempAA.getSecondYear()%></a></li>
            <%
        }
        %>
        </ul>
        <%
        
        break;
    }
    case Constants.LEVEL_COURSES: {
        Course currentCourse = ( Course ) request.getAttribute( Constants.COURSE_REQUEST_KEY );
        AcademicYear courseAA = currentCourse.getAcademicYear();
        List<Course> allCourses = courseAA.getCourses();
        
        String basehref = Constants.CHANGE_PAGE_STUD + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_COURSES;
        %>
        <h2>Corsi</h2>
        <%
        if ( allCourses.size() == 0 ) {
        %><p>Nessun corso disponibile per questo anno accademico</p><%
        }
        %>
        <ul class="menulist">
        <%
        for ( Course c : allCourses ) {
            String href = basehref + "&" + Constants.COURSE_REQUEST_KEY + "=" + c.getId();
            String aclass = "";
            if ( c.getId() == currentCourse.getId() ) aclass = "current";
            %>
            <li class="<%=aclass%>"><a href="<%=href%>" ><%=c.getName()%></a></li>
            <%
        }
        %>
        </ul>
        <%
        break;
    }
    case Constants.LEVEL_EXERCISES: {
        Assignment currentAssign = ( Assignment ) request.getAttribute( Constants.ASSIGNMENT_REQUEST_KEY );
        Course parent = currentAssign.getCourse();
        List<Assignment> allAssignments = parent.getAssignments();
        
        String basehref = Constants.CHANGE_PAGE_STUD + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_EXERCISES;
        
        %>
        <h2>Esercitazioni</h2> 
        <ul class="menulist">
            <%
            for ( Assignment a : allAssignments ) {
                int astate = Assignment.getState(a);
                
                if ( !Assignment.isClosed(astate) && !Assignment.isOpen(astate)) continue;
                
                String aclass = a.equals( currentAssign ) ? "current" : "";
                String href = basehref + "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + a.getId();
                %>
                <li class="<%=aclass%>"><a href="<%=href%>" ><%=a.getTitle()%></a></li>
                <%
                }
            %>
        </ul>
        <%
        break;
    }
    case Constants.LEVEL_RESULTS: {
        
    }
    case Constants.LEVEL_SUB_EX: {
        Submission sub = ( Submission ) request.getAttribute( Constants.SUB_REQUEST_KEY );
        
        Text subText = sub.getText();
        Assignment subAssignment = subText.getAssignment();
        List texts = subAssignment.getTexts();
        Iterator textsIterator = texts.iterator();
        
        String basehref = Constants.CHANGE_PAGE_STUD + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_SUB_EX;
        
        Integer risType = ( Integer ) request.getAttribute( Constants.SUB_LEVEL_REQUEST_KEY );
        String compileClass = "";
        String execClass = "";
        String pseudoClass = "";
        if ( risType != null ) {
            compileClass = risType == Constants.LEVEL_RES_COMPILE ? "current" : "";
            execClass = risType == Constants.LEVEL_RES_EXEC ? "current" : "";
            pseudoClass = risType == Constants.LEVEL_RES_PSEUDO ? "current" : "";
        }
        
        %>
        <h2>Sotto esercizi</h2> 
        <ul class="menulist">
            <%
        while ( textsIterator.hasNext() ) {
            Text itext = ( Text ) textsIterator.next();
            String href = basehref;
            href += "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + subAssignment.getId();
            href += "&" + Constants.ORDINAL_REQUEST_KEY + "=" + itext.getOrdinal();
            
            String basehrefRis = Constants.CHANGE_PAGE_STUD + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_RESULTS;
            basehrefRis += "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + subAssignment.getId();
            basehrefRis += "&" + Constants.ORDINAL_REQUEST_KEY + "=" + itext.getOrdinal();            
            String rishref = basehrefRis + "&" + Constants.SUB_LEVEL_REQUEST_KEY + "="; 
            
            String liclass = currentPage == Constants.LEVEL_RESULTS ? "" : "current";
            
            if ( itext.equals( subText ) ) {
                %>
                <li class="<%=liclass%>"><a href="<%=href%>" >Es <%=itext.getOrdinal()%></a>
                    <% 
                    /* se l'assignment è stato corretto dall'admin e io ho consegnato, allora da la possibilita' 
                    far vedere i risultati */
                    if ( itext.getAssignment().isCorrected() && sub.getResult() != null ) { %>
                    <ul class="menulist">
                        <li class="<%=compileClass%>"><a href="<%=rishref + Constants.LEVEL_RES_COMPILE%>">Ris. compilazione</a></li>
                        <li class="<%=execClass%>"><a href="<%=rishref + Constants.LEVEL_RES_EXEC%>">Ris. esecuzione</a></li>
                        <% if ( itext.isPseudocodeRequested() ) { %> 
                            <li class="<%=pseudoClass%>"><a  href="<%=rishref + Constants.LEVEL_RES_PSEUDO%>">Ris. pseudocodice</a></li>
                        <% } %>
                    </ul>
                    <% } %>
                </li>
                <%
            }
            else {
                %>
                <li><a href="<%=href%>" >Es <%=itext.getOrdinal()%></a>
                <%
            }
        }
        %>
    </ul>
            <%
        break;
    }

}


%>
