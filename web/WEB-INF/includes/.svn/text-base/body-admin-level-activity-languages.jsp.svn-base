<%@ page import="java.util.*" %>
<%@ page import="controller.Constants" %>
<%@ page import="model.*" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ page import="util.*" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%
    List<Language> allLanguages = ( List ) request.getAttribute( Constants.LANGUAGES_REQUEST_KEY );
%>
<h1>Modifica linguaggi</h1>
<html:errors />
<logic:messagesPresent message="true">
<ul class="messages">
<html:messages id="msg" message="true">
    <li><bean:write name="msg" filter="false"/></li>
</html:messages>
</ul>
</logic:messagesPresent>
<%
    if ( allLanguages.isEmpty()) {
    %><ul class="errors"><li>L'applicazione al momento non supporta alcun linguaggio di programmazione</li></ul><%
    }
%>
<ul class="menulist">
    <%
            String basehref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" +
                    +Constants.LEVEL_ACTIVITY + "&" + Constants.SUB_LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_EDIT_LANGUAGES + "&" + Constants.LANGUAGE_REQUEST_KEY + "=";

            for ( Language c : allLanguages ) {
                String href = basehref + c.getId();
    %>
    <li><a href="<%=href%>"><%=c.getExt()%></a></li>
    <%
            }
    %>
</ul>