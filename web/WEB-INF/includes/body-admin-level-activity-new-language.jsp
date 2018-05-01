<%@ page import="java.util.*" %>
<%@ page import="controller.Constants" %>
<%@ page import="model.*" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ page import="util.*" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<h1>Crea linguaggio</h1>
<html:errors />
<logic:messagesPresent message="true">
<ul class="messages">
<html:messages id="msg" message="true">
    <li><bean:write name="msg" filter="false"/></li>
</html:messages>
</ul>
</logic:messagesPresent>
<html:form action="/admin/NewLang" >
    <table>
        <tr>
            <td>Nome</td><td><html:text property="ext" /></td>
        </tr>
        <tr>
            <td>Linguaggio di default</td>
            <td>Si<html:radio property="defaultlanguage" value="true" />&nbsp;No<html:radio property="defaultlanguage" value="false" /></td>
        </tr>        
        <tr>
            <td>Nome file testcase</td>
            <td>
                <html:text property="testcasename" />
            </td>
        </tr>
        <tr>
            <td>Classe Formatter</td>
            <td>
                <html:text property="formatterclass" />
            </td>
        </tr>
        <tr>
            <td>Classe CodeAnalizer</td>
            <td>
                <html:text property="codeanalizerclass" />
            </td>
        </tr>
        <tr>
            <td>Opzioni compilazione</td>
            <td>
                <html:text property="coptions" />
            </td>
        </tr>
        <tr>
            <td>Opzioni esecuzione</td>
            <td>
                <html:text property="eoptions" />
            </td>
        </tr>
        <tr>
            <td>Directory di build</td>
            <td>
                <html:text property="dir" />
            </td>
        </tr>
    </table>
    <html:hidden property="selectedLangID" />
    <html:hidden property="editmode" />
    <html:hidden property="delete" value="false" />
    <html:submit value="Crea" />
</html:form>