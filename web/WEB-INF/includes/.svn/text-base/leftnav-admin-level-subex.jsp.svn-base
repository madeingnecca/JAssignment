<%@ page import="java.util.*" %>
<%@ page import="controller.Constants" %>
<%@ page import="util.*" %>
<%@ page import="model.*" %>
<%
        Text currentText = ( Text ) request.getAttribute( Constants.TEXT_REQUEST_KEY );
        Assignment currentAssign = currentText.getAssignment();
        Course parent = currentAssign.getCourse();
        List allAssignments = parent.getAssignments();
        Iterator assIterator = allAssignments.iterator();
        int currentOrdinal = currentText.getOrdinal();
        
        String basehref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_EXERCISES;
        int assignmentState = ( Integer ) request.getAttribute( Constants.ASSIGNMENT_STATE_RK );
        
        %>
        <h2>Esercitazioni</h2> 
        <ul class="menulist">
            <%
            while ( assIterator.hasNext() ) {
                Assignment a = ( Assignment ) assIterator.next();
                String aclass = a.equals( currentAssign ) ? "current" : "";
                String href = basehref + "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + a.getId();
                
                if ( a.equals( currentAssign ) ) {
                %>
                <li>
                    <a href="<%=href%>" ><%=a.getTitle()%></a>
                    <ul class="menulist">
                        <%
                        String textHref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_SUB_EX;
                        textHref += "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + currentAssign.getId();
                        textHref += "&" + Constants.ORDINAL_REQUEST_KEY + "=";
                        
                        List asstexts = currentAssign.getTexts();
                        Iterator titerator = asstexts.iterator();
                        while ( titerator.hasNext() ) {
                            Text text = ( Text ) titerator.next();
                            int ordinal = text.getOrdinal();
                            String ahref = textHref + ordinal;
                            String delete = "";
                            String tclass = currentOrdinal == ordinal ? "current" : "";
                            
                            if ( Assignment.canDeleteOrAdd( Assignment.getState( a ) )  ) {
                                String deleteHref = Constants.DELETE_TEXT_ACTION + "?" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + currentAssign.getId() + "&" + Constants.ORDINAL_REQUEST_KEY + "=" + text.getOrdinal();
                                delete = " [ <a href=\"javascript:deleteText('"+deleteHref+"\',"+text.getOrdinal()+")\">Elimina</a> ]";
                            }
                            
                            %>
                            <li class="<%=tclass%>"><a href="<%=ahref%>" >Es. <%=ordinal%></a><%=delete%></li>
                            <%
                        }
                        if ( Assignment.canDeleteOrAdd( Assignment.getState( a ) ) ) {
                            String newHref = Constants.NEW_TEXT_ACTION + "?" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + currentAssign.getId();
                            String newEx = " [ <a href=\""+newHref+"\">Nuovo esercizio</a> ]";
                            %>
                            <li><%=newEx%></li>
                            <%
                        }                        
                        
                        if ( Assignment.isClosed( Assignment.getState( a ) ) ) {
                            String consegneHref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_SUBMISSIONS_1;
                            consegneHref += "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + currentAssign.getId();
                        %>
                        <li><a href="<%=consegneHref%>" >Consegne</a></li>
                        <% } %>
                    </ul>
                </li>
                <%
                }
                else {
                %>
                <li><a href="<%=href%>" ><%=a.getTitle()%></a></li>
                <% 
                }
            }
            %>
        </ul>
