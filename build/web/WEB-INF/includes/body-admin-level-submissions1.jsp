<%@ taglib uri="/WEB-INF/tlds/ContentLoader.tld" prefix="cl" %>
<%@ taglib uri="/WEB-INF/tlds/ShowResults.tld" prefix="sr" %>
<%@ page  import="model.*"%>
<%@ page import="java.util.*" %>
<%@ page import="util.*" %>
<%@ page  import="controller.Constants"%>
<h1>Consegne</h1>
<%
Assignment current = ( Assignment ) request.getAttribute( Constants.ASSIGNMENT_REQUEST_KEY );
ArrayList submitters = ( ArrayList ) request.getAttribute( Constants.STUDENTS_REQUEST_KEY );
%>
<cl:load>
    <sr:per_student assignment="<%=current%>" submitters="<%=submitters%>" />
</cl:load>