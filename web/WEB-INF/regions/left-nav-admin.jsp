<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ page import="controller.Constants" %>
<%@ page import="model.*" %>
<%@ page import="java.util.*" %>
<h1>&gt;&gt;&gt;</h1>

<%
            int currentPage;

            try {
                Integer level = (Integer) request.getAttribute(Constants.LEVEL_REQUEST_KEY);
                currentPage = level.intValue();
            } catch (Exception e) {
                currentPage = Constants.LEVEL_HOME;
            }


            switch (currentPage) {

                case Constants.LEVEL_HOME: {

                    String basehref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_COURSES + "&" + Constants.COURSE_REQUEST_KEY + "=";

                    Collection courses = (Collection) request.getAttribute(Constants.COURSES_REQUEST_KEY);
                    Iterator i = courses.iterator();
%>
<h2>I tuoi corsi</h2>
<%
    if ( courses.isEmpty() ) {
        %><p>Non sei amministratore di nessun corso</p><%
    }
%>
<ul class="menulist">
    <%
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
<%
        break;
    }
    case Constants.LEVEL_COURSES: {
        Course currentCourse = (Course) request.getAttribute(Constants.COURSE_REQUEST_KEY);
        Collection courses = (Collection) request.getAttribute(Constants.COURSES_REQUEST_KEY);
        Iterator i = courses.iterator();
%>
<h2>I tuoi corsi</h2>
<ul class="menulist">
    <%
    String basehref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_COURSES + "&" + Constants.COURSE_REQUEST_KEY + "=";

    while (i.hasNext()) {
        Course c = (Course) i.next();
        String courseName = c.getName() + c.getAcademicYear().getAbbreviateForm();
        String href = basehref + c.getId();
        String cclass = c.equals(currentCourse) ? "current" : "";
    %>
    <li class="<%=cclass%>" ><a href="<%=href%>"><%=courseName%></a></li>
    <%
    }
    %>
</ul>
<%
        break;
    }
    case Constants.LEVEL_ACTIVITY: {
%>
<%@ include file="../includes/leftnav-admin-level-activity.jsp" %>
<%
        break;
    }

                case Constants.LEVEL_EXERCISES: {
                    %>
                    <%@ include file="../includes/leftnav-admin-level-exercises.jsp" %>
                    <%
                    break;
                }
                case Constants.LEVEL_SUB_EX: {
                    %>
                    <%@ include file="../includes/leftnav-admin-level-subex.jsp" %>
                    <%
                    break;
                }
                case Constants.LEVEL_SUBMISSIONS_1: {
                    %>
                    <%@ include file="../includes/leftnav-admin-level-submissions1.jsp" %>
                    <%
                    break;
                }
                case Constants.LEVEL_SUBMISSIONS_2: {
                    %>
                    <%@ include file="../includes/leftnav-admin-level-submissions2.jsp" %>
                    <%
                    break;
                }
                case Constants.LEVEL_TEXT_SUBMITTED: {
                    %>
                    <%@ include file="../includes/leftnav-admin-level-submitted.jsp" %>
                    <%
                    break;
                }
            }


%>
