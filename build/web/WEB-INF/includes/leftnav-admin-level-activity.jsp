<%@ page import="java.util.*" %>
<%@ page import="controller.Constants" %>
<%@ page import="util.*" %>
<%@ page import="model.*" %>
<%
        User connected = ( User ) session.getAttribute( Constants.USER_SESSION_KEY );
        
        if ( connected == null || ! (connected instanceof Admin ) ) return;
        
        Admin admin = ( Admin ) connected;
        
        if ( !admin.isSuperUser() ) return;

        Integer sublevel = (Integer) request.getAttribute(Constants.SUB_LEVEL_REQUEST_KEY);

        String basehref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_ACTIVITY + "&" + Constants.SUB_LEVEL_REQUEST_KEY + "=";
        String creaAdminHref = basehref + Constants.LEVEL_NEW_ADMIN;
        String vediAdminHref = basehref + Constants.LEVEL_ADMINS;
        String creaCorsoHref = basehref + Constants.LEVEL_NEW_COURSE;
        String vediCorsiHref = basehref + Constants.LEVEL_COURSES;
        String vediStud = basehref + Constants.LEVEL_STUDENTS;
        String ricercaStud = basehref + Constants.LEVEL_SEARCH_STUD; 
        String vediLinguaggiHref = basehref + Constants.LEVEL_LANGUAGES;
        String creaLinguaggioHref = basehref + Constants.LEVEL_NEW_LANGUAGE;
%>
<ul class="menulist">
    <%
    switch (sublevel) {
        case Constants.LEVEL_SEARCH_STUD: {
        %>
        <li><a href="<%=vediAdminHref%>">Vedi Admin</a></li>
        <li><a href="<%=creaAdminHref%>">Crea Admin</a></li>
        <li><a href="<%=vediCorsiHref%>">Modifica corsi</a></li>
        <li><a href="<%=creaCorsoHref%>">Crea Corso</a></li>
        <li><a href="<%=vediLinguaggiHref%>">Vedi linguaggi</a></li>
        <li><a href="<%=creaLinguaggioHref%>">Crea linguaggio</a></li>
        <li class="current"><a href="<%=ricercaStud%>">Ricerca studente</a></li>

        <%
            break;
        }
        case Constants.LEVEL_LANGUAGES: {               
        %>
        <li><a href="<%=vediAdminHref%>">Vedi Admin</a></li>
        <li><a href="<%=creaAdminHref%>">Crea Admin</a></li>
        <li><a href="<%=vediCorsiHref%>">Modifica corsi</a></li>
        <li><a href="<%=creaCorsoHref%>">Crea Corso</a></li>
        <li class="current"><a href="<%=vediLinguaggiHref%>">Vedi linguaggi</a></li>
        <li><a href="<%=creaLinguaggioHref%>">Crea linguaggio</a></li>
        <li ><a href="<%=ricercaStud%>">Ricerca studente</a></li>

        <%
            break;    
        }
        case Constants.LEVEL_NEW_LANGUAGE: {               
        %>
        <li><a href="<%=vediAdminHref%>">Vedi Admin</a></li>
        <li><a href="<%=creaAdminHref%>">Crea Admin</a></li>
        <li><a href="<%=vediCorsiHref%>">Modifica corsi</a></li>
        <li><a href="<%=creaCorsoHref%>">Crea Corso</a></li>
        <li><a href="<%=vediLinguaggiHref%>">Vedi linguaggi</a></li>
        <li class="current"><a href="<%=creaLinguaggioHref%>">Crea linguaggio</a></li>
        <li><a href="<%=ricercaStud%>">Ricerca studente</a></li>

        <%
            break;    
        }
        case Constants.LEVEL_EDIT_LANGUAGES: {
            List allLanguages = ( List ) request.getAttribute( Constants.LANGUAGES_REQUEST_KEY );
            Language selected = ( Language ) request.getAttribute( Constants.LANGUAGE_REQUEST_KEY );
            Iterator ite = allLanguages.iterator();
            
            String basehrefEdit = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" +
                +Constants.LEVEL_ACTIVITY + "&" + Constants.SUB_LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_EDIT_LANGUAGES + "&" + Constants.LANGUAGE_REQUEST_KEY + "=";
            
            while ( ite.hasNext() ) {
                Language current = ( Language ) ite.next();
                String aclass = current.equals( selected ) ? "current" : "";
                
                String href = basehrefEdit + current.getId();
                %>
                <li class="<%=aclass%>" ><a href="<%=href%>"><%=current.getExt()%></a></li>
                <%
            }
    %>    
    <%
            break;
        }
        case Constants.LEVEL_NEW_ADMIN: {
    %>
    <li><a href="<%=vediAdminHref%>">Vedi Admin</a></li>
    <li class="current"><a href="<%=creaAdminHref%>">Crea Admin</a></li>
    <li><a href="<%=vediCorsiHref%>">Modifica corsi</a></li>
    <li><a href="<%=creaCorsoHref%>">Crea Corso</a></li>
    <li><a href="<%=vediLinguaggiHref%>">Vedi linguaggi</a></li>
    <li><a href="<%=creaLinguaggioHref%>">Crea linguaggio</a></li>
    <li><a href="<%=ricercaStud%>">Ricerca studente</a></li>
    <%
            break;
        }
        case Constants.LEVEL_ADMINS: {
    %>
    <li  class="current"><a href="<%=vediAdminHref%>">Vedi Admin</a></li>
    <li><a href="<%=creaAdminHref%>">Crea Admin</a></li>
    <li><a href="<%=vediCorsiHref%>">Modifica corsi</a></li>
    <li><a href="<%=creaCorsoHref%>">Crea Corso</a></li>
    <li><a href="<%=vediLinguaggiHref%>">Vedi linguaggi</a></li>
    <li><a href="<%=creaLinguaggioHref%>">Crea linguaggio</a></li>
    <li><a href="<%=ricercaStud%>">Ricerca studente</a></li>
    <%
            break;    
        }
        case Constants.LEVEL_EDIT_ADMIN: {
	List admins = (List) request.getAttribute(Constants.ADMINS_REQUEST_KEY);
		Admin selected = (Admin) request.getAttribute(Constants.ADMIN_REQUEST_KEY);
	%>
	    <%
	    Iterator adIterator = admins.iterator();
	    while (adIterator.hasNext()) {
	    	String basehrefEdit = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" +
                +Constants.LEVEL_ACTIVITY + "&" + Constants.SUB_LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_EDIT_ADMIN + "&" + Constants.ADMIN_REQUEST_KEY + "=";
		Admin iad = (Admin) adIterator.next();
		String aclass = iad.equals(selected) ? "current" : "";
		String href = basehrefEdit + iad.getLogin();
	    %>
	    <li class="<%=aclass%>" ><a href="<%=href%>"><%=iad.getLogin()%></a></li>
	    <%
	    }
            break;
        }
        case Constants.LEVEL_NEW_COURSE: {
    %>
    <li><a href="<%=vediAdminHref%>">Vedi Admin</a></li>
    <li><a href="<%=creaAdminHref%>">Crea Admin</a></li>
    <li><a href="<%=vediCorsiHref%>">Modifica corsi</a></li>
    <li class="current"><a href="<%=creaCorsoHref%>">Crea Corso</a></li>
    <li><a href="<%=vediLinguaggiHref%>">Vedi linguaggi</a></li>
    <li><a href="<%=creaLinguaggioHref%>">Crea linguaggio</a></li>
    <li><a href="<%=ricercaStud%>">Ricerca studente</a></li>
    <%
            break;
        }
        case Constants.LEVEL_COURSES: {
    %>
    <li><a href="<%=vediAdminHref%>">Vedi Admin</a></li>
    <li><a href="<%=creaAdminHref%>">Crea Admin</a></li>
    <li class="current"><a href="<%=vediCorsiHref%>">Modifica corsi</a></li>
    <li><a href="<%=creaCorsoHref%>">Crea Corso</a></li>
    <li><a href="<%=vediLinguaggiHref%>">Vedi linguaggi</a></li>
    <li><a href="<%=creaLinguaggioHref%>">Crea linguaggio</a></li>
    <li><a href="<%=ricercaStud%>">Ricerca studente</a></li>
    <%
            break;
        }
        case Constants.LEVEL_EDIT_COURSES: {
            Course currentCourse = (Course) request.getAttribute(Constants.COURSE_REQUEST_KEY);
            Collection courses = (Collection) request.getAttribute(Constants.COURSES_REQUEST_KEY);
            Iterator i = courses.iterator();
    %>
        <%
                String basehrefEdit = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" +
                +Constants.LEVEL_ACTIVITY + "&" + Constants.SUB_LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_EDIT_COURSES + "&" + Constants.COURSE_REQUEST_KEY + "=";

                while (i.hasNext()) {
                    Course c = (Course) i.next();
                    String courseName = c.getName() + c.getAcademicYear().getAbbreviateForm();
                    String href = basehrefEdit + c.getId();
                    String cclass = c.equals(currentCourse) ? "current" : "";
                    %>
                    <li class="<%=cclass%>" ><a href="<%=href%>"><%=courseName%></a></li>
                    <%
                }
        %>
    <%
            break;
        }
        case Constants.LEVEL_REPORT_SINGLE: {
            /* todo: trovare cosa mettere qui.. */
            break;
        }
    }
    %>
</ul>