<h1>Crea Corso</h1>
<html:errors />
<logic:messagesPresent message="true">
<ul class="messages">
<html:messages id="msg" message="true">
    <li><bean:write name="msg" filter="false"/></li>
</html:messages>
</ul>
</logic:messagesPresent>
<html:form action="/admin/NewCourse" >
    <table>
        <tr>
            <td>Nome corso</td><td><html:text property="name" /></td>
        </tr>
        <tr>
            <td>Anno accademico</td>
            <td>
                <html:select property="selectedAYID" name="EditCourseForm">
                    <html:options property="allAYIDs" labelProperty="allAYLabels" />
                </html:select>
            </td>
        </tr>
    </table>
    <html:hidden property="id" />
    <html:hidden property="editmode" />
    <html:hidden property="delete" />
    <html:submit value="Aggiungi corso" />
</html:form> 