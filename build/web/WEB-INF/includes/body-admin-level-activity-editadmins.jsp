<%@ page import="java.util.*" %>
<%@ page import="controller.Constants" %>
<%@ page import="model.*" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ page import="util.*" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%
Admin selected = (Admin) request.getAttribute(Constants.ADMIN_REQUEST_KEY);
%>
<h1><%=selected.getLogin()%></h1>
<%
    if (selected.isSuperUser()) {
%>
Questo utente &egrave; superuser.
<%} else {
%>
<html:errors />
<logic:messagesPresent message="true">
<ul class="messages">
<html:messages id="msg" message="true">
    <li><bean:write name="msg" filter="false"/></li>
</html:messages>
</ul>
</logic:messagesPresent>
<html:form action="/admin/NewAdmin">
    <%

    %>
    <table class="newAdmin">
        <tr>
            <th>Dati personali</th><th>Privilegi</th><th colspan="2">Opzioni</th>
        </tr>
        <tr>
            <td>
                <table>
                    <tr>
                        <td>Login:</td><td><html:text property="login" disabled="true" /></td>
                    </tr>
                    <tr>
                        <td>Email:</td><td><html:text property="email"  /></td>
                    </tr>                        
                </table>
            </td>
            <td>
                <html:select size="5" property="selectedCoursesIDs" multiple="true" name="EditAdminForm">
                    <html:options property="allcoursesIDs" labelProperty="allcoursesLabels" />
                </html:select>  
            </td>
            <td>Elimina:<br/><html:checkbox property="delete" value="true" /></td>
            <td>Nuova pass:<br/><html:checkbox property="newpass" value="true" /></td>
        </tr>
    </table>
    <br/>
    <html:hidden property="editmode" />
    <html:submit value="Applica modifiche" />
    <html:reset value="Ripristina"/>
</html:form>
<% } %>