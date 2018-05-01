<%@ page import="java.util.*" %>
<%@ page import="controller.Constants" %>
<%@ page import="model.*" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ page import="util.*" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<h1>Modifica corso</h1>
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
        <tr>
            <td>Elimina</td><td><html:checkbox property="delete"  value="true"/></td>
        </tr>
    </table>
    <html:hidden property="id" />
    <html:hidden property="editmode" />
    <html:submit value="Aggiorna" />
</html:form>