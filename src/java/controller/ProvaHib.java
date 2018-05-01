/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller;

import java.io.*;
import java.net.*;

import java.util.Iterator;
import java.util.List;
import java.util.Set;
import javax.servlet.*;
import javax.servlet.http.*;

import org.hibernate.*;
import org.hibernate.cfg.Configuration;

import model.*;
/**
 *
 * @author Dax
 */
public class ProvaHib extends HttpServlet {
   
    /** 
    * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
    * @param request servlet request
    * @param response servlet response
    */

        
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        try {
        
            Assignment a = (Assignment) dao.AssignmentDAO.getInstance().getRecord( 323 );
            Student stud = (Student) dao.StudentDAO.getInstance().getRecord( "aamato" );
            
            Text t = new Text();
            t.setAssignment( a );
            t.setOrdinal( 1 );
            
            t = (Text) dao.TextDAO.getInstance().getRecord( t );
            
            Submission s =         (Submission) stud.getSubmissions().get(t);
            
            out.println( s.getResult().getErrors().get(0).getError() );
            
        }
        catch ( Exception e ) {
            e.printStackTrace(out);
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
