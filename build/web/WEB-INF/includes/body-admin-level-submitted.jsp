<%@ page import="java.util.*" %>
<%@ page import="controller.Constants" %>
<%@ page import="util.*" %>
<%@ page import="model.*" %>
<%@ taglib uri="/WEB-INF/tlds/CodeBeautifier.tld" prefix="cb" %>
<%@ taglib uri="/WEB-INF/tlds/HeaderAndHelp.tld" prefix="hh" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<% 
    Text testo = ( Text ) request.getAttribute( Constants.TEXT_REQUEST_KEY );
    Submission sub = ( Submission ) request.getAttribute( Constants.SUB_REQUEST_KEY );
    Assignment currentAssignment = testo.getAssignment();
    Language currentLang = testo.getLanguage();
    
    boolean resultAvailable = sub != null && 
            sub.getResult() != null && 
            sub.getText().getAssignment().isCorrected();
    
    boolean okcompile = false;
    if ( sub != null ) {
        
            if ( resultAvailable ) {
                Result cr = sub.getResult();
                okcompile = cr.getReturnCode() == Result.COMPILES_OK || 
                        cr.getReturnCode() == Result.EXECUTES_KO || 
                        cr.getReturnCode() == Result.EXECUTES_OK;
           }
    }
    
%>
<h1>
    <%=currentAssignment.getTitle() + " - Es " + testo.getOrdinal()%>
</h1>
<html:errors />
<logic:messagesPresent message="true">
<ul class="messages">
<html:messages id="msg" message="true">
    <li><bean:write name="msg" filter="false"/></li>
</html:messages>
</ul>
</logic:messagesPresent>
<br />
<h2>Testo</h2>
<%=testo.getText()%>
<br />
<h2>Codice consegnato</h2>
    <%
    if ( sub != null ) {
        %>
        <cb:showcode compile="true" test="true" sub="<%=sub%>" admin="true" onlykey="false" />
        <%
    }else {
        %>
        <p><img src="../images/ko.png" alt="" />&nbsp;Lo studente non ha consegnato questo esercizio</p>
        <%
    }
    %>
<br />
<h2>Pseudo codice</h2>
<%
    if ( sub != null ) {
        if ( testo.isPseudocodeRequested() ) {
            String pseudotext = sub.getPseudoText();
            
            if ( pseudotext != null ) {
                %>
                <div class="code">
                    <pre><%=pseudotext%></pre>
                </div>
                <%
            }
            else {
                %>
                <p>Lo studente non ha consegnato lo pseudocodice</p>
                <%
            }
            %>
<%
            if ( resultAvailable ) {
                
                Boolean pseudoresult = sub.getResult().isPseudoOk();
                
                if ( pseudoresult == null ) {
                    /* devo ancora valutare l'esercizio */
                    %>
                    <html:form action="/admin/CorrectPseudo" >
                        <table style="text-align:right;">
                            <tr>
                                <td>Corretto<html:radio property="ok" value="true" /></td>
                                <td rowspan="2"><html:submit value="Salva risultato" /></td>
                            </tr>        
                            <tr>
                                <td>Non corretto<html:radio property="ok" value="false" /></td>
                            </tr>
                        </table>
                        <html:hidden property="assid" value="<%=String.valueOf(currentAssignment.getId())%>" />
                        <html:hidden property="ord" value="<%=String.valueOf(testo.getOrdinal())%>" />
                        <html:hidden property="stud" value="<%=sub.getLogin().getLogin()%>" />
                    </html:form>
                    <%
                }
                else {
                    if ( pseudoresult ) {
                        %>
                        <p><img src="../images/ok.png" alt="" />&nbsp;Pseudocodice corretto</p>
                        <%
                    }
                    else {
                        %>
                        <p><img src="../images/ko.png" alt="" />&nbsp;Pseudocodice NON corretto</p>
                        <%    
                    }
                }
            } else {
                    %>
                    <p>Non sono disponibili risultati per questo esercizio</p>
                    <%
            }
            
        }
        else {
                %>
                <p>Pseudocodice non richiesto</p>
                <%
        }
    }else {
        %>
        <p><img src="../images/ko.png" alt="" />&nbsp;Lo studente non ha consegnato questo esercizio</p>
        <%
    }
    %>
<br />
<%
    if ( sub != null ) {

        if ( resultAvailable && okcompile ) {
            String testOutput = sub.getResult().getTestStdOut();
            /* se e' richiesto l'intervento umano, getTestStdError contiene un valore intermedio, l'output dell'esecuzione ( o un applet )*/
            
            if ( sub.getResult().getReturnCode() == Result.COMPILES_OK && testo.isHumanNeeded()) {
                
            %>
            <h2>Test Manuale</h2>
            <p><img src="../images/human.gif" />&nbsp;Test manuale necessario, controllare l'output e compilare il form sottostante</p>
            <div><%=testOutput%><div>
                <html:form action="/admin/NewManualTestError">
                    <table class="manualTestForm">
                        <tr>
                            <th>Esito</th><th>Descrizione</th><th></th>
                        </tr>
                        <tr>
                            <td>Corretto<html:radio property="ok" value="true" /></td>
                            <td rowspan="2"><html:text property="cause" /></td>
                            <td rowspan="2"><html:submit value="Salva risultato" /></td>
                        </tr>        
                        <tr>
                            <td>Non corretto<html:radio property="ok" value="false" /></td>
                        </tr>
                    </table>
                    <html:hidden property="assid" value="<%=String.valueOf(currentAssignment.getId())%>" />
                    <html:hidden property="ord" value="<%=String.valueOf(testo.getOrdinal())%>" />
                    <html:hidden property="stud" value="<%=sub.getLogin().getLogin()%>" />
                </html:form>
            </div>
            <%
            }
        }
        else if ( resultAvailable && !okcompile ) {
            %>
            <p><img src="../images/ko.png" />&nbsp;Test esecuzione non effettuato, il file non compila</p>
            <%   
        }
    }
%>