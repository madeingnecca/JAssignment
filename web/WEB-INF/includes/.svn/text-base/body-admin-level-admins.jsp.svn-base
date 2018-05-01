<%@ page import="model.Admin,controller.Constants" %>
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
<html:form action="/admin/NewAdmin">
    <%

    %>
    <table class="newAdmin">
        <tr>
            <th>Dati personali</th><th>Privilegi</th><th>Opzioni</th>
        </tr>
        <tr>
            <td>
                <table>
                    <tr>
                        <td>Login:</td><td><html:text property="login" disabled="true" /></td>
                    </tr>
                    <tr>
                        <td>Password:</td><td><html:password property="password" disabled="true"/></td>
                    </tr>  
                    <tr>
                        <td>Ripeti password:</td><td><html:password property="password2" disabled="true"  /></td>
                    </tr>
                    <tr>
                        <td>Ripeti password:</td><td><html:text property="email" disabled="true"  /></td>
                    </tr>                        
                </table>
            </td>
            <td>
                <html:select size="5" property="selectedCoursesIDs" multiple="true" name="EditAdminForm">
                    <html:options property="allcoursesIDs" labelProperty="allcoursesLabels" />
                </html:select>  
            </td>
            <td>Elimina:<br/><html:checkbox property="delete" value="true" /></td>
        </tr>
    </table>
    <br/>
    <html:hidden property="editmode" />
    <html:submit value="Applica modifiche" />
    <html:reset value="Ripristina"/>
</html:form>
<% } %>