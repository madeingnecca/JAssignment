<%@ page import="java.util.*" %>
<%@ page import="controller.Constants" %>
<%@ page import="model.*" %>
<%@ page import="util.*" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<h1>Ricerca studente</h1>
<html:errors />
<html:form action="/admin/DoSearchStud">
    <table class="search">
        <tr>
            <td colspan="2">
                <h2>Scegli un corso</h2>
            </td>
        </tr>
        <tr>
            <td>
                <html:select property="selectedCourseID" size="1">
                <html:options  labelProperty="allcoursesLabels" property="allcoursesIDs" name="SearchStudForm"/>
            </html:select>    
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <h2>Informazioni studente</h2>
            </td>
        </tr>
        <tr>
            <th>Matricola</th>
            <td>
                <html:text property="matricola" />
            </td>
        </tr>
        <tr>
            <th>Nome</th>
            <td>
                <html:text property="name" />
            </td>
        </tr>
        <tr>
            <th>Cognome</th>
            <td>
                <html:text property="surname" />
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <html:submit  value="Vedi report"/>
            </td>
        </tr>
    </table>
</html:form>
