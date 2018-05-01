<%@ page import="java.util.*" %>
<%@ page import="controller.Constants" %>
<%@ page import="model.*" %>
<%@ page import="util.*" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="/WEB-INF/tlds/ShowResults.tld" prefix="sr" %>
<%@ taglib uri="/WEB-INF/tlds/ContentLoader.tld" prefix="cl" %>

<%
    List<Student> foundStudents = ( List<Student> ) request.getAttribute( Constants.STUDENTS_REQUEST_KEY );
    Course c = ( Course ) request.getAttribute( Constants.COURSE_REQUEST_KEY );
    List<Assignment> courseAssignments = ( List<Assignment> ) c.getAssignments();
%>
<h1>Risultati ricerca per <%=c.getNameWithAY()%></h1>
<%
    if ( foundStudents == null || foundStudents.size() == 0 ) {
        String backHref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_ACTIVITY + "&" + Constants.SUB_LEVEL_REQUEST_KEY + "=";
        backHref += Constants.LEVEL_SEARCH_STUD;
        %>
        <ul class="errors">
            <li>La ricerca non ha prodotto risultati<br /><a href="<%=backHref%>">Torna al form di ricerca</a></li>
        </ul>
        <%
    } else {
        %>
        <h2>Studenti trovati</h2>
        <table class="students">
            <tr>
                <th>Nome</th><th>Cognome</th><th>Matricola</th><th>Login</th><th></th>
            </tr>
            <%
            for ( Student s : foundStudents ) {
                %>
                <tr>
                    <td><%=s.getNome().toUpperCase()%></td>
                    <td><%=s.getCognome().toUpperCase()%></td>
                    <td><%=s.getMatricola()%></td>
                    <td><%=s.getLogin()%></td>
                    <td><a href="javascript:moveToAnchor('<%=s.getLogin()%>')">Vai</a></td>
                </tr>
                <%
            }
            %>
        </table>
        <cl:load>
            <sr:per_assignment assignments="<%=c.getAssignments()%>" submitters="<%=foundStudents%>" />
        </cl:load>
        <% }  %>