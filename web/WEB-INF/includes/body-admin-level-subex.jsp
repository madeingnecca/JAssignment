<%@ page import="java.util.*" %>
<%@ page import="controller.Constants" %>
<%@ page import="model.*" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ page import="util.*" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://java.fckeditor.net" prefix="FCK" %>
<%@ taglib uri="/WEB-INF/tlds/HeaderAndHelp.tld" prefix="hh" %>
<%
    Text currentText = ( Text ) request.getAttribute( Constants.TEXT_REQUEST_KEY );
    int o = currentText.getOrdinal();
    int aid = currentText.getAssignment().getId();
%>
<%
    int astate = Assignment.getState( currentText.getAssignment());
    switch (astate) {
        case Assignment.STATE_RV: {
        }
        case Assignment.STATE_VV: {
            
%>
    <hh:h1>Es <%=o%></hh:h1>
    <html:errors />
    <logic:messagesPresent message="true">
    <ul class="messages">
    <html:messages id="msg" message="true">
        <li><bean:write name="msg" filter="false"/></li>
    </html:messages>
    </ul>
    </logic:messagesPresent>
    <html:form action="admin/NewTextAction" enctype="multipart/form-data">
        <table class="singleText">
            <tr>
                <td colspan="2">
                    <h2>Compilazione ed Esecuzione</h2>
                </td>
            </tr>
            <tr>
                <th>Linguaggio</th>
                <td>
                    <html:select property="selectedLangID" name="EditTextForm">
                        <html:options property="allLanguagesIDs" labelProperty="allLanguagesLabels" />
                    </html:select>
                </td>
            </tr>
            <tr>
                <th>Nome file consegna</th>
                <td>
                    <html:text property="submitname" />
                </td>
            </tr>
            
            <tr>
                <th>File di test</th>
                <td>
                    <html:file property="testclass" />&nbsp;[ <a href="javascript:viewTestCaseSrc(<%=aid%>,<%=o%>)">Vedi Corrente</a> ]
                </td>
            </tr>
            <tr>
                <th>File esempio di consegna</th>
                <td>
                    <html:file property="examplesubmit" />&nbsp;[ <a href="javascript:viewExampleFileSrc(<%=aid%>,<%=o%>)">Vedi Corrente</a> ]
                </td>
            </tr>
            <tr>
                <th>File soluzione</th>
                <td>
                    <html:file property="solutionfile" />&nbsp;[ <a href="javascript:viewSolutionFileSrc(<%=aid%>,<%=o%>)">Vedi Corrente</a> ]
                </td>
            </tr>
            <tr>
                <th>File ausiliari</th>
                <td>
                    <div id="ajaxlayer"></div>
                    <div id="sourcelayer">
                        <div id="code"></div>
                        <div style="text-align:center;margin:3px;">
                            <a href="javascript:hideSourceLayer()">Chiudi finestra</a>
                        </div>
                    </div>
                    <iframe id="uploadFrame" src="auxFileUploadPage.jsp?assid=<%=aid%>&ord=<%=o%>" ></iframe>
                </td>
            </tr>
            <tr id="auxfilesTR">
                <td colspan="2">
                    <div id="auxfilesDiv">
                    </div>
                    <script type="text/javascript">
                        initFiles();
                        <%
                        List auxfiles = ( List ) request.getAttribute( Constants.AUXFILES_REQUEST_KEY );
                        
                        for ( int i = 0; i < auxfiles.size(); i++ ) {
                            AuxiliarySourceFile aux = ( AuxiliarySourceFile ) auxfiles.get(i);
                            int auxid = aux.getId();
                            String filename = aux.getFilename();
                            boolean source = aux.isSource();
                            if ( aux.getTexts().contains( currentText )) {
                                /* e' uno dei miei */
                            %>
                            var auxObj = new AuxFile_ClientSide( 
                                <%=auxid%>,
                                '<%=filename%>',
                                <%=source%>,
                                <%=aid%>,
                                <%=o%>    
                            );    
                                
                            addAuxFile( auxObj ,true );
                            <%
                            }
                            else {
                            %>
                            addAuxFile( auxObj ,false );
                            <%    
                            }
                        }
                        %>
                        refreshAuxDiv();
                    </script>       
                </td>
            </tr>
            <tr>
                <th>Necessario test manuale</th>
                <td>
                    Si<html:radio property="human" value="true" />&nbsp;No<html:radio property="human" value="false" />
                </td>
            </tr>
            <tr>
                <th>Necessario pseudocodice</th>
                <td>
                    Si<html:radio property="pseudocode" value="true" />&nbsp;No<html:radio property="pseudocode" value="false" />
                </td>
            </tr>
            <tr>
                <th>Timeout esecuzione</th>
                <td>
                    <html:text property="timeout" />
                </td>
            </tr>            
            <tr>
                <th>Permessi esecuzione</th>
                <td>
                    <table  class="permissions">
                        <tr>
                            <th>Thread</th><th>I/O</th><th>Socket client</th><th>Socket server</th>
                        </tr>
                        <tr>
                            <td><html:checkbox property="thread_perm" value="true" /></td>
                            <td><html:checkbox property="io_perm" value="true" /></td>
                            <td><html:checkbox property="sock_clnt_perm" value="true" /></td>
                            <td><html:checkbox property="sock_srv_perm" value="true" /></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                  <h2>Testo esercitazione</h2>  
                  <FCK:editor instanceName="text" toolbarSet="ToolbarFissa">
                    <jsp:attribute name="value">
                        <bean:write name="EditTextForm" property="text" scope="session" filter="false"/>
                    </jsp:attribute>
                  </FCK:editor>
                </td>
            </tr>
            <tr>
                <td colspan="2"><html:submit value="Salva modifiche" /></td>
            </tr>
        </table>
        <html:hidden property="editmode" />
        <html:hidden property="ordinal" />
    </html:form>

<%
        break;
    }
    case Assignment.STATE_RR: {        
        %>
        <h1>Es <%=o%></h1>
        <div id="ajaxlayer"></div>
        <div id="sourcelayer">
            <div id="code"></div>
            <div style="text-align:center;margin:3px;">
                <button onclick="hideSourceLayer()">Chiudi finestra</button>
            </div>
        </div>
        <table class="singleText">
            <tr>
                <td colspan="2">
                    <h2>Info sottoesercizio</h2>  
                </td>
            </tr>
            <tr>
                <th>Linguaggio</th>
                <td><%=currentText.getLanguage().getExt()%></td>
            </tr>
            <tr>
                <th>Nome file consegna</th>
                <td><%=currentText.getSubmitFileName()%></td>
            </tr>
            <tr>
                <th>File di test</th>
                <td>
                    <%
                        if ( currentText.getTestcase() != null ) {

                            String fname = currentText.getLanguage().getTestcaseFilename() ;                          
                            %>
                            <%=fname%>&nbsp;[ <a href="javascript:viewTestCaseSrc(<%=aid%>,<%=o%>)">Vedi</a>, <a href="javascript:downloadTestCaseSrc(<%=aid%>,<%=o%>)">Scarica</a>  ]
                            <%
                        }
                    %>
                </td>
            </tr>
            <tr>
                <th>File di esempio</th>
                <td>
                    <%
                        if ( currentText.getExamplefile() != null ) {
                            String fname = currentText.getSubmitFileName();                          
                            %>
                            <%=fname%>&nbsp;[ <a href="javascript:viewExampleFileSrc(<%=aid%>,<%=o%>)">Vedi</a>, <a href="javascript:downloadExampleFileSrc(<%=aid%>,<%=o%>)">Scarica</a>  ]
                            <%
                        }
                    %>
                </td>    
            </tr>
            <tr>
                <th>File soluzione</th>
                <td>
                    <%
                        if ( currentText.getSolution() != null && !currentText.getSolution().equals("") ) {
                            String fname = currentText.getSubmitFileName();                          
                            %>
                            <%=fname%>&nbsp;[ <a href="javascript:viewSolutionFileSrc(<%=aid%>,<%=o%>)">Vedi</a>, <a href="javascript:downloadSolutionFileSrc(<%=aid%>,<%=o%>)">Scarica</a>  ]
                            <%
                        } else {
                            %>
                            <p>Non &egrave; stata inserita alcuna soluzione</p>
                            <%
                        }
                    %>
                </td>    
            </tr>
            <tr>
                <th>File ausiliari</th>
                <td>
                    <%
                        Collection auxs = currentText.getAuxfiles();
                        if ( auxs != null && auxs.size() > 0 ) {
                            Iterator i = auxs.iterator();
                            String extension = currentText.getLanguage().getExt();
                            while ( i.hasNext() ) {
                                AuxiliarySourceFile auxfile = ( AuxiliarySourceFile ) i.next();
                                String fname = auxfile.getFilename();
                            %>
                            <%=fname%>&nbsp;[ <a href="javascript:viewAuxfileSrc(<%=auxfile.getId()%>)">Vedi</a>, <a href="javascript:downloadAuxfileSrc(<%=auxfile.getId()%>)">Scarica</a> ]<br />
                            <%
                            }
                        }
                        else {
                    %>
                    Nessuno
                    <% } %>
                </td>
            </tr>            
            <tr>
                <th>Necessario test manuale?</th>
                <td><%=currentText.isHumanNeeded()%></td>
            </tr>
            <tr>
                <th>Necessario pseudocodice?</th>
                <td><%=currentText.isPseudocodeRequested()%></td>
            </tr>
            <tr>
                <th>Timeout esecuzione</th>
                <td><%=currentText.getTimeout()%></td>
            </tr>            
        <tr>
                <th>Permessi esecuzione</th>
                <td>
                    <table class="permissions">
                        <tr>
                            <th>Thread</th><th>I/O</th><th>Socket client</th><th>Socket server</th>
                        </tr>
                        <tr>
                            <% 
                                String[] imgs = new String[] { "<img src=\"../images/ok.png\" />", "<img src=\"../images/ko.png\" />" };
                            %>
                            <td><%=imgs[ currentText.canExecuteThread() ? 0 : 1]%></td>
                            <td><%=imgs[ currentText.canExecuteIO()? 0 : 1] %></td>
                            <td><%=imgs[ currentText.canExecuteSocket()? 0 : 1] %></td>
                            <td><%=imgs[ currentText.canExecuteSocketServer()? 0 : 1] %></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <h2>Testo</h2>
                    <div class="text" >
                        <%=currentText.getText()%>
                    </div>
                </td>
            </tr>
        </table>
        <%
        break;
    }
}
%>