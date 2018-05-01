/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller.servlets;

import java.io.*;
import java.net.*;

import javax.servlet.*;
import javax.servlet.http.*;

import model.*;
import dao.*;

/**
 *
 * @author Dax
 */
public class ViewSourceServlet extends HttpServlet {
   
    public static final String MODE_KEY = "mode";
    public static final String SUBMODE_KEY = "sub";
    public static final String ORDINAL_KEY = "ord";
    public static final String ASSIGNMENT_KEY = "assid";
    public static final String AUX_KEY = "auxid";
    
    public static final int MODE_AUX =              1;
    public static final int MODE_TESTCASE =         2;
    public static final int MODE_EXAMPLEFILE =      3;
    public static final int MODE_SOLUTIONFILE =     4;
    
    public static final int SUBMODE_HTML =          1;
    public static final int SUBMODE_DOWNLOAD =      2;
    
    /** 
    * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
    * @param request servlet request
    * @param response servlet response
    */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        int mode, submode;
        try {
            mode = Integer.parseInt( request.getParameter( MODE_KEY ) );
            submode = Integer.parseInt( request.getParameter( SUBMODE_KEY ) );
        }
        catch( NumberFormatException e ) {
            return;
        }
        
        switch ( mode ) {
            
            case MODE_AUX: {
                
                int auxID;
                
                try {
                    auxID = Integer.parseInt( request.getParameter( AUX_KEY ) );
                }
                catch( NumberFormatException e ) {
                    return;
                }
                
                AuxiliarySourceFile aux = (AuxiliarySourceFile) dao.AuxiliarySourceFileDAO.getInstance().getRecord( auxID );
                String source = aux.getCode();
                
                                
                String html;
                
                if ( submode == SUBMODE_HTML ) {
                    response.setContentType("text/html;charset=UTF-8");
                    html = source;
                }
                else {
                    response.setContentType("application/octet-stream");
                    response.setHeader("Content-Disposition", "attachment; filename=" + aux.getFilename() );
                    html = source;
                }
                
                out.println( html );
                
                break;
            }
            case MODE_SOLUTIONFILE: {
                
            }
            case MODE_EXAMPLEFILE: {
                
            }
            case MODE_TESTCASE: {
                
                int assID;
                int ordinal;
                
                try {
                    ordinal = Integer.parseInt( request.getParameter( ORDINAL_KEY ) );
                    assID = Integer.parseInt( request.getParameter( ASSIGNMENT_KEY ) );
                }
                catch( NumberFormatException e ) {
                    return;
                }
                
                Assignment assign = ( Assignment ) AssignmentDAO.getInstance().getRecord( assID );
                Text text = new Text();
                text.setAssignment(assign);
                text.setOrdinal( ordinal );
                text = ( Text ) TextDAO.getInstance().getRecord( text );
                
                String source = null;
                String filename = "";
                if ( mode == MODE_TESTCASE ) {
                    source = text.getTestcase();
                    filename = text.getLanguage().getTestcaseFilename();
                }
                else  {
                    if ( mode == MODE_EXAMPLEFILE )
                        source = text.getExamplefile();
                    else
                        source = text.getSolution();
                    filename = text.getSubmitFileName();
                }
                
                if ( source == null ) source = "";
                
                String html;
                
                if ( submode == SUBMODE_HTML ) {
                    response.setContentType("text/html;charset=UTF-8");
                    html = text.getLanguage().getFormatter().formatWithoutErrors(source);
                }
                else {
                    response.setContentType("application/octet-stream");
                    response.setHeader("Content-Disposition", "attachment; filename=" + filename );
                    html = source;
                }
                
                out.println( html );
                
                break;
            }
            default: break;
            
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
