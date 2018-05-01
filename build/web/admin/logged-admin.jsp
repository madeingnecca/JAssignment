<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>

<tiles:insert page="/WEB-INF/layouts/admin-layout-logged.jsp" flush="true">
  <tiles:put name="path-user" value="/WEB-INF/regions/path-admin.jsp" />
  <tiles:put name="left-nav" value="/WEB-INF/regions/left-nav-admin.jsp" />
  <tiles:put name="body" value="/WEB-INF/regions/logged-body-admin.jsp" /> 
</tiles:insert>
