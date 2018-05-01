<h1>Crea ADMIN</h1>
<html:errors />
<logic:messagesPresent message="true">
<ul class="messages">
<html:messages id="msg" message="true">
    <li><bean:write name="msg" filter="false"/></li>
</html:messages>
</ul>
</logic:messagesPresent>
<html:form action="/admin/NewAdmin">
    <table class="newAdmin">
        <tr>
            <th>Dati personali</th><th>Privilegi</th>
        </tr>
        <tr>
            <td>
                <table>
                    <tr>
                        <td>Login:</td><td><html:text property="login" /></td>
                    </tr>
                    <tr>
                        <td>Password:</td><td><html:password property="password" /></td>
                    </tr>  
                    <tr>
                        <td>Ripeti password:</td><td><html:password property="password2" /></td>
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
        </tr>
    </table>
    <html:hidden property="editmode" />
    <html:hidden property="delete" />
    <html:submit value="Aggiungi admin" />
</html:form>
