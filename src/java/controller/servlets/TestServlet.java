/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller.servlets;

import controller.threads.TestThread;
import java.io.*;
import java.net.*;

import java.util.HashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.*;
import javax.servlet.http.*;
import model.*;
import dao.*;
import java.util.Collection;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import model.test.TestError;
import util.*;
/**
 *
 * @author Dax
 */
public class TestServlet extends HttpServlet {

    
    public static final String FIRST_TIME_KEY = "ft";
    public static final String ASSIGNMENT_ID_KEY = "aid";
    public static final String MODE_KEY = "mode";
    public static final String SOURCE_KEY = "src";
    public static final String STUDENT_KEY = "stud";
    public static final String ORDINAL_KEY = "ord";
    
    public static final int MODE_ASSIGNMENT = 1;
    public static final int MODE_SOURCE = 2;

    public static final String SLOT_INDEX = "test_slot_count";

    private boolean[] testSlots = null;

    public void init() {
        try {
            int slotCount = Integer.parseInt(this.getServletContext().getInitParameter(SLOT_INDEX));
            synchronized (this) {
                testSlots = new boolean[slotCount];
                for (int i = 0; i < slotCount; i++) {
                    testSlots[i] = true;
                }
            }
        } catch (Exception e) {
            synchronized (this) {
                testSlots = new boolean[]{true};
            }
        }
    }
    
    private static final int MAX_TEST_REACHED = 1;
    private static final int TEST_NOT_ALLOWED = 2;

    private int getNextSlot() {
        synchronized ( this ) {
            for ( int i = 0; i < testSlots.length; i++ ) {
                if ( testSlots[ i ] ) {
                    testSlots[ i ] = false;
                    return i;
                }
            }
            return -1;
        }
    }

    private void realeaseSlot( int index ) {
        synchronized ( this ) {
            testSlots[ index ] = true;
        }
    }

    private static HashMap testThreads = new HashMap();
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        response.setContentType("text/xml");
        PrintWriter out = response.getWriter();
        
        HttpSession session = request.getSession();
        if ( session == null ) {
            out.println( "<err/>" ); 
            return;    
        }
        
        try {
        
            int ft;
            int mode;

            mode = Integer.parseInt( request.getParameter( MODE_KEY ) );

            if ( mode == TestServlet.MODE_ASSIGNMENT ) {

                try {
                    ft = Integer.parseInt( request.getParameter( FIRST_TIME_KEY ) );
                }
                catch ( NumberFormatException e ) {
                    out.println( "<err/>" ); 
                    return;
                }

                if (ft == 1) {
                    int assId = Integer.parseInt( request.getParameter( ASSIGNMENT_ID_KEY ) );
                    Assignment assign = ( Assignment ) AssignmentDAO.getInstance().getRecord( assId );

                    if ( assign == null ) {
                        out.println( "<err/>" ); 
                        return;    
                    }

                    // cerco un testthread che sta testando la mia esercitazione
                    Collection ttCollection = testThreads.values();
                    Iterator tts = ttCollection.iterator();
                    
                    boolean assignmentFound = false;
                    
                    while ( tts.hasNext() && !assignmentFound ) {
                        TestThread tti = (TestThread) tts.next();
                        if ( tti.getAssignment().equals( assign )) assignmentFound = true;
                    }
                    
                    if ( assignmentFound ) {
                        String output = "<err code=\""+TEST_NOT_ALLOWED+"\"/>";
                        out.println(output);
                        return;
                    }

                    int ttid = this.getNextSlot();
                    if ( ttid == -1 ) {
                        String output = "<err code=\""+MAX_TEST_REACHED+"\"/>";
                        out.println(output);
                        return;
                    }
                    
                    TestThread tt = new TestThread(this.getServletContext().getRealPath("/"), TestServlet.MODE_ASSIGNMENT, assign );
                    tt.setSlot( ttid );
                    testThreads.put( new Integer(ttid) , tt);
                    tt.start();
                    String output = "<test><thread-id>" + ttid + "</thread-id></test>";
                    out.println(output);
                } else {
                    long tid = Integer.parseInt(request.getParameter("tid"));
                    TestThread mytt = (TestThread) testThreads.get( new Integer( (int) tid) );

                    if ( mytt == null ) {
                        out.println( "<err/>" ); 
                        return;    
                    }

                    if ( mytt.getException() != null ) throw mytt.getException();
                    
                    int percentage = mytt.getPercentage();

                    if (percentage == 100) {
                        testThreads.remove( new Integer( (int) tid) );
                        this.realeaseSlot( (int) tid );

                        /* salvo risultati */
                        List<Submission> subs = mytt.getSubmissions();
                        for ( Submission s : subs ) {
                            dao.SubmissionDAO.getInstance().saveRecord(s);
                        }

                        /* salvo assignment */
                        Assignment assign = mytt.getAssignment();
                        assign.setCorrected( true );
                        AssignmentDAO.getInstance().saveRecord( assign );
                    }

                    String output = "<test><thread-id>" + tid + "</thread-id><percentage>" + percentage + "</percentage></test>";
                    out.println(output);
                }
            }
            else if ( mode == TestServlet.MODE_SOURCE) {

                int assId, ordinal; 

                assId = Integer.parseInt( request.getParameter( ASSIGNMENT_ID_KEY ) );
                ordinal = Integer.parseInt( request.getParameter( ORDINAL_KEY ) );

                Assignment assign = ( Assignment ) AssignmentDAO.getInstance().getRecord( assId );

                String src = request.getParameter( TestServlet.SOURCE_KEY );
                //src = URLDecoder.decode(src, "UTF-8");

                String student = request.getParameter( TestServlet.STUDENT_KEY );

                Student stud = (Student) StudentDAO.getInstance().getRecord( student );
                if ( stud == null ) return;

                Text text = new Text();
                text.setAssignment(assign);
                text.setOrdinal( ordinal );
                text = ( Text ) TextDAO.getInstance().getRecord( text );

                Submission fake = new Submission();
                fake.setText( text );
                fake.setExerciseText( src );
                fake.setLogin(stud);

                TestThread tt = new TestThread(this.getServletContext().getRealPath("/"), fake);
                tt.start();

                // aspetto che finisca
                tt.join();
                
                if ( tt.getException() != null ) throw tt.getException();

                Submission s = tt.getSubmissions().get( 0 );
                Result cr = s.getResult();
                if ( cr != null && cr.getReturnCode() == Result.COMPILES_OK ) {
                    out.println( "<ok/>" );
                } else {
                    String errors = "";

                    List<TestError> compErrors = cr.getCompilerErrors();
                    for ( TestError te : compErrors ) {
                        String singleError = te.getFile() + ":" + te.getLine() + ":" + te.getError();
                        errors += singleError + "\n";
                    }

                    response.setContentType("text/html");
                    out.println( Util.stringToHTMLString(errors) );
                }

            }
            else {
                return;
            }
        }
        catch( Exception e ) {
            response.setContentType("text/xml");
            out.println( "<err>" );
            e.printStackTrace( out );
            out.println( "</err>" );
        }
        
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
    * Handles the HTTP <code>GET</code> method.
    * @param request servlet request
    * @param response servlet response
    */
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

    /** 
    * Handles the HTTP <code>POST</code> method.
    * @param request servlet request
    * @param response servlet response
    */
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    /** 
    * Returns a short description of the servlet.
    */
    public String getServletInfo() {
        return "Short description";
    }
    // </editor-fold>
}
