<%@page import="controller.Constants" %>
<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>

<html:html locale="true" xhtml="true">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript">
            function onSubmitForm() {
                if ( document.getElementById( "src" ).value != "" ) {
                    parent.showLoading();
                    return true;
                }
                return false;
            }
            
        </script>
        <%
        Integer assid = ( Integer ) request.getAttribute( Constants.ASSIGNMENT_REQUEST_KEY );
        Integer ord = ( Integer ) request.getAttribute( Constants.ORDINAL_REQUEST_KEY );
        Integer auxid = ( Integer ) request.getAttribute( "auxid" );
        String auxname = ( String ) request.getAttribute( "auxname" );
        Boolean source = ( Boolean ) request.getAttribute( "source" );
        
        Boolean error = ( Boolean ) request.getAttribute( "error" );
        if ( error == null ) error = false;
        
        Boolean done = ( Boolean ) request.getAttribute( "done" );
        if ( done == null ) done = false;
        
        String onload = "";
        
        if ( done ) {
            if ( !error ) {
                onload = "parent.stopLoadingAndAdd("+auxid+",'"+auxname+"',"+source+","+assid+","+ord+" )";
            }
            else onload = "parent.notifyError()";
        }
        %>
    </head>
    <body style="margin:0px;padding:0px;font-family:Arial;font-size:90%;" onload="<%=onload%>">
        <html:form  method="post" enctype="multipart/form-data" style="margin:0px;" action="/admin/UploadAuxFileAction" onsubmit="return onSubmitForm()" >
            <html:hidden property="assid" value='<%=request.getParameter("assid")%>' />
            <html:hidden property="ord" value='<%=request.getParameter("ord")%>' />
            <html:file property="src" styleId="src" />
            <html:submit value="Upload"/>
            <html:checkbox property="source" value="true" />&nbsp;Sorgente
        </html:form>
    </body>
</html:html>
