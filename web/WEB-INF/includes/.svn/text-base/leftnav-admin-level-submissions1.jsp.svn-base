<%@ page import="java.util.*" %>
<%@ page import="controller.Constants" %>
<%@ page import="model.*" %>
<%
        Assignment currentAssign = ( Assignment ) request.getAttribute( Constants.ASSIGNMENT_REQUEST_KEY );
        Course parent = currentAssign.getCourse();
        List allAssignments = parent.getAssignments();
        Iterator assIterator = allAssignments.iterator();
        
        String basehref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_EXERCISES;
        
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
                            %>
                            <li><a href="<%=ahref%>" >Es. <%=ordinal%></a></li>
                            <%
                        }
                        
                        if ( Assignment.isClosed( Assignment.getState(a)) ) {
                            String consegneHref = Constants.CHANGE_PAGE_ADMIN + "?" + Constants.LEVEL_REQUEST_KEY + "=" + Constants.LEVEL_SUBMISSIONS_1;
                            consegneHref += "&" + Constants.ASSIGNMENT_REQUEST_KEY + "=" + currentAssign.getId();
                        %>
                        <li class="current"><a href="<%=consegneHref%>" >Consegne</a></li>
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