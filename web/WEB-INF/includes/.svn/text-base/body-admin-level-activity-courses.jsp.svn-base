<%@ page import="java.util.*" %>
<%@ page import="controller.Constants" %>
<%@ page import="model.*" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ page import="util.*" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%
            Collection courses = (Collection) request.getAttribute(Constants.COURSES_REQUEST_KEY);
            Iterator i = courses.iterator();
%>
<h1>Modifica corsi</h1>
<html:errors />
<logic:messagesPresent message="true">
<ul class="messages">
<html:messages id="msg" message="true">
    <li><bean:write name="msg" filter="false"/></li>
</html:messages>
</ul>
</logic:messagesPresent>
<%
    if ( courses.isEmpty() ) {
        %><ul class="errors"><li>Nessun corso presente in memoria</li></ul><%
    }
%>
<ul class="menulist">
    <%
            String basehref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" +
                    +Constants.LEVEL_ACTIVITY + "&" + Constants.SUB_LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_EDIT_COURSES + "&" + Constants.COURSE_REQUEST_KEY + "=";

            while (i.hasNext()) {
                Course c = (Course) i.next();
                String courseName = c.getName() + c.getAcademicYear().getAbbreviateForm();
                String href = basehref + c.getId();
    %>
    <li><a href="<%=href%>"><%=courseName%></a></li>
    <%
            }
    %>
</ul>