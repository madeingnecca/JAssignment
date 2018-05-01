<%@ page import="java.util.*" %>
<%@ page import="controller.Constants" %>
<%@ page import="model.*" %>
<%@ page import="util.*" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%
    Assignment currentAssign = ( Assignment ) request.getAttribute( Constants.ASSIGNMENT_REQUEST_KEY );
    String assTitle = currentAssign.getTitle();
    
    boolean tested = currentAssign.isCorrected();
%>
<h1><%=assTitle%></h1>
<%
int astate = Assignment.getState( currentAssign);
    switch (astate) {
        case Assignment.STATE_RV: {
            
        }
        case Assignment.STATE_VV: {
            
%>
    <html:errors />
    <html:form action="admin/NewAssignment">
        <table class="singleAssignment">
            <tr> 
                <th>Titolo</th>
                <td><html:text property="title" /></td>
            </tr>
            <tr>
                <th>Data inizio</th>
                <td><html:text property="start"/><input type="button" value="Cal" onclick="displayCalendar(document.forms[0].start,'dd/mm/yyyy hh:ii',this,true)" /></td>
            </tr>
            <tr>
                <th>Scadenza esercitazione</th>
                <td><html:text property="end"/><input type="button" value="Cal"  onclick="displayCalendar(document.forms[0].end,'dd/mm/yyyy hh:ii',this,true)"/></td>
            </tr>
            <tr>
                <td>Rendila disponibile dopo il submit</td><td><html:checkbox property="startNow" /></td>
            </tr>
            <tr>
                <td>Elimina?</td><td><html:checkbox property="delete" /></td>
            </tr>
            <tr>
                <td colspan="2"><html:submit value="Salva modifiche" /></td>
            </tr>
        </table>
        <html:hidden property="editmode" />
        <html:hidden property="id" />

    </html:form>

<%
        break;
    }
    case Assignment.STATE_RR: {
        
        String strStartTime = Util.dateToString( currentAssign.getStartTime() );
        String strDeadLine = Util.dateToString( currentAssign.getDeadline() );
        
        %>
        <h2>Info esercitazione</h2>
        <table class="singleAssignment">
            <tr>
                <th>Titolo</th>
                <td><%=currentAssign.getTitle()%></td>
            </tr>
            <tr>
                <th>Data inizio</th>
                <td class="closed"><%=strStartTime%></td>
            </tr>
            <tr>
                <th>Scadenza esercitazione</th>
                <td class="closed"><%=strDeadLine%></td>
            </tr>
        </table>
        <h2>Test automatico</h2>
        <%
            if ( tested ) {
        %>
        <p>
                <ul class="menulist">
                    <li><a href="javascript:voidTest(<%=currentAssign.getId()%>)">Annulla i risultati del test</a></li>
                    </ul>
            </p>
        </p>
        <%
        } else {
            %>
            <p>
                <ul>
                    <li><a href="javascript:testAssignment(<%=currentAssign.getId()%>)">Avvia il test automatico</a></li>
                </ul>
            </p>
            <%
        }
        %>
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
         <div id="ajaxlayer"></div>
        <%
        break;
    }
}
%>