<%@ page contentType="text/html"%>
<%@ page pageEncoding="UTF-8"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="/WEB-INF/tlds/CodeBeautifier.tld" prefix="cb" %>
<%@ taglib uri="/WEB-INF/tlds/ShowResults.tld" prefix="sr" %>
<%@ taglib uri="/WEB-INF/tlds/HeaderAndHelp.tld" prefix="hh" %>
<%@ page  import="model.*"%>
<%@ page  import="java.util.*"%>
<%@ page  import="controller.*"%>
<%@ page  import="util.*"%>
<%

            int currentPage;

            try {
                Integer level = (Integer) request.getAttribute(Constants.LEVEL_REQUEST_KEY);
                currentPage = level.intValue();
            } catch (Exception e) {
                currentPage = Constants.LEVEL_HOME;
            }
%>


<%
            switch (currentPage) {

                case Constants.LEVEL_HOME: {
                    
                    String baselink = Constants.CHANGE_PAGE_STUD + "?" + Constants.LEVEL_REQUEST_KEY + "=";
                    
                    /* todo: fai vedere la home..*/
                    List todoAssignments = ( List ) request.getAttribute( Constants.TODO_ASSIGN_RK );
                    List openSubmitted = ( List ) request.getAttribute( Constants.OPEN_SUBMITTED_ASSIGN_RK );
                    List<Assignment> lastresults = ( List ) request.getAttribute( Constants.LAST_RESULT_ASSIGN_RK );
                    %>
                    <h1>Benvenuto!</h1>
                    <div class="homeZone">
                    <h2>Esercitazioni da consegnare</h2>
                    <%
                    int size = todoAssignments.size();
                    if ( size > 0  ) {
                    %>
                    <table class="assignments">
                        <tr>
                            <th>Corso</th><th>Titolo</th><th>Tempo rimanente</th>
                        </tr>
                    <%
                        for ( int i = 0; i < size; i++ ) {
                            Assignment current = ( Assignment ) todoAssignments.get( i );
                            String courseHref  = baselink + Constants.LEVEL_COURSES + "&" + Constants.COURSE_REQUEST_KEY + "=" + current.getCourse().getId();
                            String assHref = baselink + Constants.LEVEL_EXERCISES + "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + current.getId();
                            String remaining = Util.calculateDelay( 
                                    current.getDeadline().getTime() - new Date().getTime()
                            );
                            %>
                            <tr>
                                <td><a href="<%=courseHref%>"><%=current.getCourse().getNameWithAY()%></a></td>
                                <td><a href="<%=assHref%>"><%=current.getTitle()%></a></td>
                                <td><%=remaining%></td>
                            </tr>
                            <%
                        }
                        %>
                    </table>
                        <%
                    } else {
                    %>
                    <p>Non ci sono dati da visualizzare</p>
                    <% } %>
                    </div>
                    <div class="homeZone">
                    <h2>Ultime esercitazioni consegnate</h2>
<%
                    size = openSubmitted.size();
                    if ( size > 0  ) {
                    %>
                    <table class="assignments">
                        <tr>
                            <th>Corso</th><th>Titolo</th><th>Tempo rimanente</th>
                        </tr>
                    <%
                        for ( int i = 0; i < size; i++ ) {
                            Assignment current = ( Assignment ) openSubmitted.get( i );
                            String courseHref  = baselink + Constants.LEVEL_COURSES + "&" + Constants.COURSE_REQUEST_KEY + "=" + current.getCourse().getId();
                            String assHref = baselink + Constants.LEVEL_EXERCISES + "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + current.getId();
                            String remaining = Util.calculateDelay( 
                                    current.getDeadline().getTime() - new Date().getTime()
                            );
                            %>
                            <tr>
                                <td><a href="<%=courseHref%>"><%=current.getCourse().getNameWithAY()%></a></td>
                                <td><a href="<%=assHref%>"><%=current.getTitle()%></a></td>
                                <td><%=remaining%></td>
                            </tr>
                            <%
                        }
                        %>
                    </table>
                        <%
                    }
                    else {
                    %>
                    <p>Non ci sono dati da visualizzare</p>
                    <% } %>
                    </div>
                    <div class="homeZone">
                    <h2>Ultimi risultati</h2>
                    <%
                        size = lastresults.size();
                        if ( size > 0 ) {
                    %>
                    <table class="assignments">
                        <tr>
                            <th>Corso</th><th>Titolo</th><th>Sottoesercizi</th>
                        </tr>
                    <%
                            for ( Assignment current : lastresults ) {
                                String courseHref  = baselink + Constants.LEVEL_COURSES + "&" + Constants.COURSE_REQUEST_KEY + "=" + current.getCourse().getId();
                                String assHref = baselink + Constants.LEVEL_EXERCISES + "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + current.getId();
                                %>
                                <tr>
                                    <td><a href="<%=courseHref%>"><%=current.getCourse().getNameWithAY()%></a></td>
                                    <td><a href="<%=assHref%>"><%=current.getTitle()%></a></td>
                                    <td>
                                        <%
                                        List<Text> texts = current.getTexts();
                                        for ( Text t : texts ) {
                                            String textHref = baselink + Constants.LEVEL_SUB_EX + "&" 
                                                    + Constants.ASSIGNMENT_REQUEST_KEY + "=" + current.getId() + "&" +
                                                    Constants.ORDINAL_REQUEST_KEY + "=" + t.getOrdinal();
                                            %>
                                            <a href="<%=textHref%>">Es <%=t.getOrdinal()%></a>
                                            <%
                                        }
                                        %>
                                    </td>
                                </tr>
                                <%
                            }
                        %>
                    </table>
                        <%
                        } else {
                    %>
                    <p>Non ci sono dati da visualizzare</p>
                    <% } %>
                    </div>
                    <%
                    break;
                }
                case Constants.LEVEL_AA: {

                    AcademicYear currentAA = (AcademicYear) request.getAttribute(Constants.AA_REQUEST_KEY);
                    List<Course> currentAAcourses = currentAA.getCourses();

%>
<h1>AA <%=currentAA.getFirstYear() + "-" + currentAA.getSecondYear()%></h1>
<h2>Corsi</h2>
    <%
        if ( currentAAcourses.size() == 0 ) {
            %>
            <p>Nessun corso disponibile per questo anno accademico</p>
            <%
        }
     %>
<ul class="menulist">
<%
        String basehref = Constants.CHANGE_PAGE_STUD + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_COURSES + "&" + Constants.COURSE_REQUEST_KEY + "=";
        for ( Course c : currentAAcourses ) {
            String href = basehref + c.getId();
    %>
    <li><a href="<%=href%>"><%=c.getName()%></a></li>
    <%
        }
    %>
</ul>       
<%
        break;
    }
    case Constants.LEVEL_COURSES: {
        Course currentCourse = (Course) request.getAttribute(Constants.COURSE_REQUEST_KEY);
        List<Assignment> assignments = currentCourse.getAssignments();

        String basehref = Constants.CHANGE_PAGE_STUD + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_EXERCISES + "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=";
%>
<h1><%=currentCourse.getName()%></h1>
<br>
<h2>Esercitazioni</h2>
<%
    if ( assignments.isEmpty() ) {
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
            String aclass;

            if ( Assignment.isClosed( Assignment.getState( tempAss )) ) 
                aclass = "closed";
            else if ( Assignment.isOpen( Assignment.getState( tempAss )) ) 
                aclass = "open";

            else continue;

            String href = basehref + tempAss.getId();
            String trclass = count % 2 == 0 ? "even" : "odd";
            count++;
    %>
    <tr class="<%=trclass%>">
        <td><a href="<%=href%>"><%=tempAss.getTitle()%></a></td>
        <td><%=tempAss.getTexts().size()%></td>
        <td><%=Util.dateToString(tempAss.getStartTime())%></td>
        <td class="<%=aclass%>"><%=Util.dateToString(tempAss.getDeadline())%></td>
        <td><%=tempAss.isCorrected()%></td>
    </tr>
    <%
        }
    %>

</table>
<%
    }
        break;
    }
    case Constants.LEVEL_EXERCISES: {
        Student stud = ( Student ) session.getAttribute(Constants.USER_SESSION_KEY);
        Assignment currentAssign = (Assignment) request.getAttribute(Constants.ASSIGNMENT_REQUEST_KEY);
        List<Text> texts = currentAssign.getTexts();
        boolean open = true;
%>
<h1><%=currentAssign.getTitle()%></h1>
<br>
<h2>Testi esercitazione</h2>
<p>
    <%
    if ( Assignment.isClosed( Assignment.getState( currentAssign )) )  {
    %>
    <p class="ko">Il termine per la consegna dell'esercitazione e' stato raggiunto.</p>
    <%
        open = false;
    } else {
        long nowTime = new Date().getTime();
        long deadlineTime = currentAssign.getDeadline().getTime();
        long diff = deadlineTime - nowTime;
        String delay = Util.calculateDelay( diff );
    %>
    <p class="ok">La scadenza dell'esercitazione &egrave; tra <%=delay%></p>
    <%
    }
    %>
</p>
<sr:single assignment="<%=currentAssign%>" stud="<%=stud%>" />
<%
                    break;
                }
                case Constants.LEVEL_SUB_EX: {
                    Submission sub = ( Submission ) request.getAttribute( Constants.SUB_REQUEST_KEY );

                    Text subText = sub.getText();
                    int aid = subText.getAssignment().getId();
                    int o = subText.getOrdinal();
                    %>
                    <hh:h1>Es <%=subText.getOrdinal()%></hh:h1>
                    <html:errors />
                    <logic:messagesPresent message="true">
                    <ul class="messages">
                    <html:messages id="msg" message="true">
                        <li><bean:write name="msg" filter="false"/></li>
                    </html:messages>
                    </ul>
                    </logic:messagesPresent>
                    <html:form action="/SubmitExercise.do" styleId="formConsegna" method="post" enctype="multipart/form-data">
                    <table class="singleText">
                        <tr>
                            <td colspan="2">
                                <h2>Info esercitazione</h2>  
                            </td>
                        </tr>
                        <tr>
                            <th>Linguaggio</th>
                            <td><%=subText.getLanguage().getExt()%></td>
                        </tr>
                        <tr>
                            <th>Nome file consegna</th>
                            <td><%=subText.getSubmitFileName()%></td>
                        </tr>
                        <tr>
                            <th>Esempio file consegna</th>
                            <td>
                                <%
                                if ( subText.getExamplefile() != null && !subText.getExamplefile().equals("") ) {%>
                                <a href="javascript:viewExampleFileSrc(<%=aid%>,<%=o%>,true)">Vedi</a>, <a href="javascript:downloadExampleFileSrc(<%=aid%>,<%=o%>,true)">Scarica</a>
                                <% } else {%>Nessuno<% }%>
                            </td>
                        </tr>
                        <tr>
                            <th>File ausiliari</th>
                            <td>
                                <%
                                    Collection auxs = subText.getAuxfiles();
                                    if ( auxs != null && auxs.size() > 0 ) {
                                        Iterator i = auxs.iterator();
                                        String extension = subText.getLanguage().getExt();
                                        while ( i.hasNext() ) {
                                            AuxiliarySourceFile auxfile = ( AuxiliarySourceFile ) i.next();
                                            String fname = auxfile.getFilename();
                                        %>
                                        <%=fname%>&nbsp;[ <a href="javascript:viewAuxfileSrc(<%=auxfile.getId()%>,true)">Vedi</a>, <a href="javascript:downloadAuxfileSrc(<%=auxfile.getId()%>,true)">Scarica</a> ]<br />
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
                            <th>Necessario pseudocodice?</th>
                            <td><%=subText.isPseudocodeRequested()%></td>
                        </tr>
                        <tr>
                            <td colspan="2">
                                <br />
                    <h2>Testo</h2>
                    <p><%=subText.getText()%></p>
                    <%
                        String stud = (( Student ) session.getAttribute( Constants.USER_SESSION_KEY ) ).getLogin();
                    %>
                </td>
                </tr>
                <%
                if ( Assignment.isClosed( Assignment.getState( subText.getAssignment() )) ) { %>
                <tr>
                    <td colspan="2">
                        <br />
                        <h2>
                            Soluzione esercitazione
                        </h2>
                    <%
                        if ( subText.getSolution() != null && !subText.getSolution().equals("") ) {
                            String fname = subText.getSubmitFileName();                          
                            %>
                            <%=fname%>&nbsp;[ <a href="javascript:viewSolutionFileSrc(<%=aid%>,<%=o%>,true)">Vedi</a>, <a href="javascript:downloadSolutionFileSrc(<%=aid%>,<%=o%>,true)">Scarica</a>  ]
                            <%
                        } else { %>
                        <p>Non &egrave; stata inserita alcuna soluzione</p>
                        <% } %>
                        </td>
                    </tr>
                    <% } %>
                    <tr>
                    <td colspan="2">
                        <br />
                        <h2>
                            Codice esercitazione:
                        </h2>
                        <div style="width:100%;">
                            <div id="linecount">
                                <textarea id="lctxt" disabled="true"></textarea>
                            </div>
                            <div id="textareaDiv">
                                <html:textarea  onkeyup="updateTextarea()" styleId="exerciseText" property="exerciseText" value="<%=sub.getExerciseText()%>" />
                            </div>
                        </div>
                        <div style="border:2px solid black; padding:0.5em;margin-top:1em;clear:both;">
                            <input id="buttonCompile" type="button" onclick="compileTextarea('<%=stud%>',<%=aid%>,<%=o%>);" value="compila" />
                                <div id="ajaxlayer"></div>
                                <div id="sourcelayer">
                                    <div id="code"></div>
                                    <div style="text-align:center;margin:3px;">
                                        <a href="javascript:hideSourceLayer()">Chiudi finestra</a>
                                    </div>
                                </div>
                                <span id="compResLayer">
                                </span>
                            </div>
                            
                        
                            <script type="text/javascript">updateTextarea()</script>
                        <br /><br />
                        </td>
                    </tr>
                <%
                        if ( subText.isPseudocodeRequested() ) {
                        %>
                        <tr>
                            <td colspan="2">
                        <h2>Pseudocodice:</h2>
                        <html:textarea property="pseudoText" value="<%=sub.getPseudoText()%>" />
                        <br /><br />
                        
                    </td>
                        <% } %>
                    <tr>
                        
                        <td colspan="2">
                        <html:hidden property="assignmentID" value="<%=String.valueOf(aid)%>" />
                        <html:hidden property="ordinal" value="<%=String.valueOf(o)%>" />
                        <html:submit value="Consegna esercitazione"  />
                        </td>
                    </tr>

                    </table>
                    </html:form>
<%
                    break;
                }
                
                case Constants.LEVEL_RESULTS: {
                    
                    Integer risType = ( Integer ) request.getAttribute( Constants.SUB_LEVEL_REQUEST_KEY );
                    Submission sub = ( Submission ) request.getAttribute( Constants.SUB_REQUEST_KEY );
                    
                    if ( sub != null ) {
                    
                        %>
                        <h1>Risultati esercitazione</h1>
                        <h2>Ris. <%=Constants.RIS_TYPES[ risType ]%></h2>
                        <%

                        if (risType == Constants.LEVEL_RES_COMPILE) {

                            %>
                            <cb:showcode compile="true" sub="<%=sub%>" admin="false" onlykey="false"/>
                            <%
                        } else if (risType == Constants.LEVEL_RES_EXEC) {
                            %>
                            <cb:showcode test="true" sub="<%=sub%>" admin="false"  onlykey="false"/>
                            <%
                        } else if (risType == Constants.LEVEL_RES_PSEUDO) {
                            
                            boolean pseudook = sub.getResult().isPseudoOk();
                            
                            if ( pseudook ) {
                                %>
                                <img src="images/ok.png" title="corretto" />Pseudocodice corretto
                                <%
                            } else {
                                %>
                                <img src="images/ko.png" title="non corretto" />Pseudocodice non corretto
                                <%                                
                            }
                            
                        }
                    }
                    else {
                        %>
                        <p>Non hai consegnato questo esercizio!</p>
                        <%
                    }
                    
                    break;
                }
            }


%>    
