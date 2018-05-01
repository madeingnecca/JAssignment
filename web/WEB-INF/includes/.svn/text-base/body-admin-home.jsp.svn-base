<%@ page import="java.util.*" %>
<%@ page import="controller.Constants" %>
<%@ page import="util.*" %>
<%@ page import="model.*" %>
<h1>Homepage ADMIN</h1>
<h2>Attivit&agrave;</h2>
<ul class="menulist">
<%
            Admin admin = (Admin) session.getAttribute(Constants.USER_SESSION_KEY);
            String basehref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_ACTIVITY + "&" + Constants.SUB_LEVEL_REQUEST_KEY + "=";
            if (admin.isSuperUser()) {
                
                String vediAdminHref = basehref + Constants.LEVEL_ADMINS;
                String creaAdminHref = basehref + Constants.LEVEL_NEW_ADMIN;
                String creaCorsoHref = basehref + Constants.LEVEL_NEW_COURSE;
                String vediCorsiHref = basehref + Constants.LEVEL_COURSES;
                String vediLinguaggiHref = basehref + Constants.LEVEL_LANGUAGES;
                String creaLinguaggioHref = basehref + Constants.LEVEL_NEW_LANGUAGE;
%>

    <li><a href="<%=vediAdminHref%>">Vedi Admin</a></li>
    <li><a href="<%=creaAdminHref%>">Crea Admin</a></li>
    <li><a href="<%=vediCorsiHref%>">Vedi corsi</a></li>
    <li><a href="<%=creaCorsoHref%>">Crea Corso</a></li>
    <li><a href="<%=vediLinguaggiHref%>">Vedi linguaggi</a></li>
    <li><a href="<%=creaLinguaggioHref%>">Crea linguaggio</a></li>

<%}
String vediStud = basehref + Constants.LEVEL_STUDENTS;
String ricercaStud = basehref + Constants.LEVEL_SEARCH_STUD;           
%>
<li><a href="<%=ricercaStud%>">Ricerca studente</a></li>
</ul>