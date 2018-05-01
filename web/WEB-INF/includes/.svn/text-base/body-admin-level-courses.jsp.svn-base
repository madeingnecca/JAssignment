<%@ page import="java.util.*" %>
<%@ page import="controller.Constants" %>
<%@ page import="model.*" %>
<%@ page import="util.*" %>
<%
Course currentCourse = (Course) request.getAttribute(Constants.COURSE_REQUEST_KEY);
        List<Assignment> assignments = currentCourse.getAssignments();

        String basehref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_EXERCISES + "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=";
%>
<h1><%=currentCourse.getName() + currentCourse.getAcademicYear().getAbbreviateForm()%></h1>
<h2>Nuova esercitazione</h2>
<div>
    
</div>
<div class="layerNewEx">
    <html:errors />
    <logic:messagesPresent message="true">
    <ul class="messages">
    <html:messages id="msg" message="true">
        <li><bean:write name="msg" filter="false"/></li>
    </html:messages>
    </ul>
    </logic:messagesPresent>
    <html:form action="/admin/FastNewAssignment">
        <table class="newEx">
            <tr>
                <th>Titolo</th><th>N. esercizi</th><th colspan="2">Data inizio</th><th colspan="2">Scadenza</th><th></th>
            </tr>
            <tr>
                <td><html:text property="title" /></td>
                <td><html:text property="nes" /></td>
                <td><html:text property="start" value="" /></td><td><div class="buttonCalendar" onclick="displayCalendar(document.forms[0].start,'dd/mm/yyyy hh:ii',this,true)"></div></td>
                <td><html:text property="end" value="" /></td><td><div class="buttonCalendar"  onclick="displayCalendar(document.forms[0].end,'dd/mm/yyyy hh:ii',this,true)"></div></td>
                <td><html:submit value="Prosegui" /></td>
            </tr>
        </table>
        <html:hidden property="courseID" value="<%=String.valueOf(currentCourse.getId())%>"/>
        <html:hidden property="edit" value="false"/>
        <html:hidden property="delete" value="false"/>
        <html:hidden property="startNow" value="false"/>
    </html:form>
</div>
<h2>Esercitazioni presenti</h2>
<%
    if ( assignments.isEmpty()) {
    %><ul class="errors"><li>Nessuna esercitazione presente</li></ul><%
    } else {
%>
<table class="assignments">
    <tr>
        <th>Titolo</th><th>N. esercizi</th><th>Data inizio</th><th>Scadenza</th><th>Corretta</th>
    </tr>
    <%
    int count = 0;
    for ( Assignment tempAss : assignments ) {
        String href = basehref + tempAss.getId();
        
        int astate = Assignment.getState( tempAss );
        String startClass,deadlineClass;
        if ( Assignment.isClosed(astate) ) {
            startClass = "closed";
            deadlineClass = "closed";
        } else if ( Assignment.isOpen(astate) ) { 
            startClass = "closed";
            deadlineClass = "open";
        } else {
            startClass = "open";
            deadlineClass = "open";
        }
        
        String trclass = count % 2 == 0 ? "even" : "odd";
        String strStartTime = Util.dateToString( tempAss.getStartTime() );
        String strDeadLine = Util.dateToString( tempAss.getDeadline() );
        count++;
    %>
    <tr class="<%=trclass%>">
        <td><a href="<%=href%>"><%=tempAss.getTitle()%></a></td>
        <td><%=tempAss.getTexts().size()%></td>
        <td class="<%=startClass%>"><%=strStartTime%></td>
        <td class="<%=deadlineClass%>"><%=strDeadLine%></td>
        <td>
            <%
            boolean tested = tempAss.isCorrected();
            if ( Assignment.isClosed(astate) && !tested ) {
                %>
                <a href="javascript:testAssignment(<%=tempAss.getId()%>)">Test</a>
                <div id="testLayer">
                </div>
                 <div id="testContent">
                     <div id="fakeDiv">
                          <div id="progressDiv"</div>
                      </div>
                      <div id="progress">
                          Completato: <div id="percentage"></div>%
                      </div>
                 </div>
                <%
            } else if ( Assignment.isClosed(astate) && tested ) {
                %>
                S&igrave;
                <%
            }
            %>
        </td>
    </tr>
    <%
    }
    %>
</table>
<% } %>