/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import dao.*;
import model.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Submission;

/**
 *
 * @author Dax
 */
public class ProvaDAO extends HttpServlet {
   
    private List<Text> cancelSubmission( Student[] fakeSubmitters , int assid, PrintWriter out ) {
                
        
        List<Student> students = StudentDAO.getInstance().getRecords();

        int i = 0;
        for ( Student s : students ) {
            if ( i >= fakeSubmitters.length ) break;
            fakeSubmitters[ i++ ] = s;
        }
        
        Assignment assignment = (Assignment) AssignmentDAO.getInstance().getRecord( assid );

        int nonDeleted = 0;

        List<Student> submitters = dao.AdminDAO.getInstance().getSubmitters(assignment);

        List<Text> texts = assignment.getTexts();

        for ( Student s : submitters ) {
            for ( Text testo : texts ) {
                Submission sub = ( Submission ) s.getSubmissions().get( testo );
                if ( sub == null ) continue;
                sub.setText( testo );
                sub.setLogin(s);
                boolean deleted = SubmissionDAO.getInstance().removeRecord( sub );
                s.getSubmissions().remove( testo );
                if ( !deleted )
                    nonDeleted++;
            }
        }
        
        out.println( "Tot non cancellati: " + nonDeleted + "<br />" );
        
        return texts;
    }
    
    private void submitAssignment( int nstud, int assid, String[][] codes, String[] codiceConsegnato, PrintWriter out ) {

        Student[] fakeSubmitters = new Student[ nstud ];
       
        int nonSaved = 0;

        
        List<Text> texts = cancelSubmission( fakeSubmitters, assid, out );
        
        String[] pseudos = new String[] {
            "corretto",
            "non corretto"
        };
        
        
        int[] indexes = new int[] { 0,0 };
        for ( Student s : fakeSubmitters ) {

            int i = 0;
            for ( Text t : texts ) {
            
                Submission sub = new Submission();
                sub.setText(t);
                sub.setLogin(s);

                String codeToReplace = codes[i][ indexes[i] ];

                String code = codiceConsegnato[i].replaceAll( "\\{0\\}", codeToReplace );
                sub.setExerciseText(code);
                
                if ( t.isPseudocodeRequested() ) {
                    int random = ( int ) (Math.random() * (pseudos.length));
                    sub.setPseudoText( pseudos[ random ] );
                }
                
                s.doSubmit( sub );

                boolean saved = SubmissionDAO.getInstance().saveRecord( sub );
                if ( !saved ) 
                    nonSaved++;
                
                indexes[i] = (indexes[i] + 1) % codes[ i ].length;
                i++;
            }
            
        }
        
        out.println( "Tot non salvati: " + nonSaved + "<br />" );
        
    }    
    
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            
            String[] codiceConsegnato = new String[] {
                "#include <stdio.h>\r\n int sum( int* a, int len ) {\r\n\t{0} \r\n} ",
                "import java.util.List; import java.io.File;import java.io.IOException;public class Consegna{public Consegna() {} public int sum( List<Integer> l ) { {0} }}"
                
            };
            
            String[][] codes = new String[][] {
                {
                    "return 1;", /* risultato errato*/
                    "return 10", /* errore compilazione */
                    "int i, s =0; for (i=0;i<len;i++){s+=a[i];} return s;", /* risultato corretto */
                    "int i = 0; while ( i < 10 ); return 120;", /* ciclo infinito*/       
                    "int *aa = NULL; *aa = 10; return 10;", /*segmentation fault  */
                    "return 2 / 0;", /* errore runtime */
                    "FILE *fp; fp = fopen(\"/home/dax/attack_c.txt\", \"w+\"); fputs(\"moira cucciola\", fp); return 999;" /* attacco! */
                }
                ,
                {
                    "int s = 0; for (int i=0;i<l.size();i++){s+=l.get(i);};", /* risultato corretto*/
                    "return 1;", /* risultato sbagliato*/
                    "adwadwadwadwa", /* non compila */
                    "return 2 / 0;", /* errore runtime */
                    "int i = 0; while ( i < 10 );return 1;",
                    "try {new File(\"/home/dax/ciao.txt\").createNewFile();return -1;} catch (IOException ex) {return 9;}" /* errore sicurezza*/
                }
            };
            
            submitAssignment( 30, 753, codes, codiceConsegnato, out );
            
        } 
        catch( Exception e ) {
            out.println( e.getMessage() );
            e.printStackTrace( out );
            return;
        } 
        out.println("<br/>sono arrivato fino a qui senza eccezioni!");
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
    }// </editor-fold>
 
}
