/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller.servlets;

import dao.*;
import java.io.*;
import java.net.*;

import javax.servlet.*;
import javax.servlet.http.*;
import model.Assignment;
import model.AuxiliarySourceFile;
import model.Text;

/**
 *
 * @author Dax
 */
public class AuxfileManagerServlet extends HttpServlet {
   
    private static final String     ASSIGNMENT_KEY      = "assid";
    private static final String     ORDINAL_KEY         = "ord";
    private static final String     MODE_KEY            = "mode";
    private static final String     AUX_SRC_KEY         = "aux";
    
    private static final int        MODE_ADD    = 1;
    private static final int        MODE_REMOVE = 2;
    
    private static final String     OK_RESPONSE         = "<ok/>";
    private static final String     KO_RESPONSE         = "<err/>";
    
    /** 
    * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
    * @param request servlet request
    * @param response servlet response
    */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/xml");
        PrintWriter out = response.getWriter();
        
        int assid;
        int ordinal;
        int mode;
        int srcId;
        
        try {
            assid = Integer.parseInt( request.getParameter( ASSIGNMENT_KEY ) );
            ordinal = Integer.parseInt( request.getParameter( ORDINAL_KEY ) );
            mode = Integer.parseInt( request.getParameter( MODE_KEY ) );
            srcId = Integer.parseInt( request.getParameter( AUX_SRC_KEY ) );
        }
        catch ( Exception e ) {
            out.println( KO_RESPONSE );
            return;
        }
        
        Assignment assignment = ( Assignment ) AssignmentDAO.getInstance().getRecord( assid );
        Text txt = new Text();
        txt.setAssignment(assignment);
        txt.setOrdinal(ordinal);
        txt = ( Text ) TextDAO.getInstance().getRecord(txt);
        
        AuxiliarySourceFile aux = ( AuxiliarySourceFile ) AuxiliarySourceFileDAO.getInstance().getRecord( srcId );
        
        if ( txt == null ) {
            out.println( KO_RESPONSE );
            return;    
        }
        
        switch( mode ) {
            
            case MODE_ADD: {
                
                txt.addAuxFile(aux);
                boolean saved = TextDAO.getInstance().saveRecord( txt );
                if ( saved  ) {
                    out.println( "<created id=\""+srcId+"\"/>" );
                }
                else out.println( KO_RESPONSE );
                break;
            }
            case MODE_REMOVE: {
                txt.removeAuxFile(aux);
                boolean savedTxt = TextDAO.getInstance().saveRecord( txt );
                boolean savedAux = AuxiliarySourceFileDAO.getInstance().saveRecord( aux );
                if ( savedTxt && savedAux  ) {
                    if ( aux.getTexts().size() == 0 ) {
                        /* è un file sorgente che non ha riferimenti in alcun testo, lo elimino */
                        boolean deleted = AuxiliarySourceFileDAO.getInstance().removeRecord( srcId );
                        if ( deleted ) {
                            
                            String output = "<deleted id=\""+srcId+"\" total=\"1\"/>";
                            out.println( output );
                            
                        } else out.println( KO_RESPONSE );
                    }
                    else out.println( "<deleted id=\""+srcId+"\" total=\"0\"/>" );
                }
                else out.println( KO_RESPONSE );
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
