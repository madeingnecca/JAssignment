/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller.servlets;

import controller.*;
import dao.AssignmentDAO;
import java.io.*;
import java.net.*;

import java.util.List;
import javax.servlet.*;
import javax.servlet.http.*;
import model.Admin;
import model.Text;
import model.Assignment;
import model.Result;
import model.Student;
import model.Submission;

/**
 *
 * @author dax
 */
public class VoidResultServlet extends HttpServlet {
   

    private static final String ASSIGNMENT_ID_KEY = "aid";
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/xml");
        PrintWriter out = response.getWriter();
        
        
        HttpSession session = request.getSession();
        if ( session == null || 
                session.getAttribute( Constants.USER_SESSION_KEY ) == null ||
                !(session.getAttribute( Constants.USER_SESSION_KEY ) instanceof Admin) ) {
            
            /* informarsi su come fare il redirect*/
            response.sendRedirect( "/" ); /* questo va bene??? */
        }        
        
        Assignment tovoid;
        try {
            int assId = Integer.parseInt( request.getParameter( ASSIGNMENT_ID_KEY ) );
            tovoid = ( Assignment ) AssignmentDAO.getInstance().getRecord( assId );
        }
        catch( Exception e ) {
            out.println( "<err/>" );
            return;
        }
        
        List<Student> submitters = dao.AdminDAO.getInstance().getSubmitters(tovoid);
        
        List<Text> texts = tovoid.getTexts();
        
        for ( Student s : submitters ) {
            for ( Text t : texts ) {
                
                Submission sub = (Submission) s.getSubmissions().get( t );
                
                if ( sub == null ) continue; 
                
                
                Result cr = sub.getResult();
                /* rimuovi il cr solo se c'e' effettivamente */
                if ( cr != null ) {
                
                    t.getLanguage().voidResult( sub );
                    sub.setResult( null );
                    
                    boolean deleted = dao.SubmissionDAO.getInstance().saveRecord( sub );
                    deleted = deleted && dao.ResultDAO.getInstance().removeRecord( cr.getId() );
                    if ( !deleted ) {
                        /* todo: pensa ad un errore */
                    }
                }
            }
        }
        
        tovoid.setCorrected( false );
        dao.AssignmentDAO.getInstance().saveRecord(tovoid);
        out.println( "<ok/>" );
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
