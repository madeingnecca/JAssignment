<%@ page import="java.util.*" %>
<%@ page import="controller.Constants" %>
<%@ page import="util.*" %>
<%@ page import="model.*" %><%
            List<Admin> admins = (List) request.getAttribute(Constants.ADMINS_REQUEST_KEY);
            Admin selected = (Admin) request.getAttribute(Constants.ADMIN_REQUEST_KEY);
%>
<h1>Vedi ADMIN</h1>
<html:errors />
<logic:messagesPresent message="true">
<ul class="messages">
<html:messages id="msg" message="true">
    <li><bean:write name="msg" filter="false"/></li>
</html:messages>
</ul>
</logic:messagesPresent>
<h2>Admins</h2>
<%
    if ( admins.isEmpty()) {
    %><ul class="errors"><li>Nessun amministratore presente in memoria</li></ul><%
    }
%>
<ul class="menulist">
    <%
            String basehref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" +
                +Constants.LEVEL_ACTIVITY + "&" + Constants.SUB_LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_EDIT_ADMIN + "&" + Constants.ADMIN_REQUEST_KEY + "=";
            for ( Admin iad : admins ) {
                String href = basehref + iad.getLogin();
    %>
    <li><a href="<%=href%>"><%=iad.getLogin()%></a></li>
    <%
            }
    %>
</ul>
