<%@ page import="java.util.*" %>
<%@ page import="controller.Constants" %>
<%@ page import="model.*" %>
<%@ taglib uri="/WEB-INF/tlds/CodeBeautifier.tld" prefix="cb" %>
<%
Assignment current = ( Assignment ) request.getAttribute( Constants.ASSIGNMENT_REQUEST_KEY );
Student stud = ( Student ) request.getAttribute( Constants.STUDENT_REQUEST_KEY );
%>
<h1>Consegna di <%=(stud.getCognome() + " " + stud.getNome()).toUpperCase()%></h1>
<br />
<%
    List<Text> texts = current.getTexts();
    for ( Text itext : texts ) {
        Submission consegna = ( Submission ) stud.getSubmissions().get( itext );
        if ( consegna != null ) {
            consegna.setText( itext );
            consegna.setLogin( stud );
        }
        %>
        <h1>Es <%=itext.getOrdinal()%></h1>
        <cb:showcode compile="true" test="true" sub="<%=consegna%>" admin="true" onlykey="true" />
        <br />
        <%
        }  
%>