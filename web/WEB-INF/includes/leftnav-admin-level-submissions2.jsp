<%@ page import="java.util.*" %> 
<%@ page import="controller.Constants" %>
<%@ page import="model.*" %>
<%

    Assignment currentAssign = ( Assignment ) request.getAttribute( Constants.ASSIGNMENT_REQUEST_KEY );
    List texts = currentAssign.getTexts();
    
    Student stud = ( Student ) request.getAttribute( Constants.STUDENT_REQUEST_KEY );
    
    String assTitle = currentAssign.getTitle();
%>
<h2><%=assTitle%> - consegne:</h2>
<ul class="menulist">
<%
String baseHref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_SUBMISSIONS_2;
baseHref += "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + currentAssign.getId();

String baseHrefSubmitted = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_TEXT_SUBMITTED;
baseHrefSubmitted += "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + currentAssign.getId();


String hrefStudente = "#";
String cognomeNome = (stud.getCognome() + " " + stud.getNome()).toUpperCase();
Iterator textsIterator = texts.iterator();
%>
    <li class="current">
        <%=cognomeNome%>
        <ul class="menulist">
        <%
        while ( textsIterator.hasNext() ) {
            Text text = ( Text ) textsIterator.next();
            String link = baseHrefSubmitted + "&" + Constants.ORDINAL_REQUEST_KEY + "=" + text.getOrdinal();
            link += "&" + Constants.STUDENT_REQUEST_KEY + "=" + stud.getLogin();
            %>
            <li><a href="<%=link%>">Es. <%=text.getOrdinal()%></a></li>
            <%
        }
        %>
        </ul>
    </li>
    <%
    String gobackHref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_SUBMISSIONS_1;
    gobackHref += "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + currentAssign.getId();
%>
<li><a href="<%=gobackHref%>">Torna alla lista delle consegne</a></li>
</ul>