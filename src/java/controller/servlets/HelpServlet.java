/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller.servlets;

import java.io.*;
import java.net.*;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;

/**
 *
 * @author tec
 */
public class HelpServlet extends HttpServlet {
   
    
    public static final String     HELP_CONF_XML = "help_conf_xml";
    public static final String     HELP_CONF_XSL = "help_conf_xsl";
    
    private static final String     PAGE_KEY = "page";
    private static final String     TYPE_KEY = "type";
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            
            String strType = request.getParameter( TYPE_KEY );
            String strPage = request.getParameter( PAGE_KEY );
            
            int type = Integer.parseInt( strType );
            int page = Integer.parseInt(strPage);
            
            String pathXML = getServletContext().getRealPath("/") + this.getServletContext().getInitParameter( HELP_CONF_XML );
            String pathXSL = getServletContext().getRealPath("/") + this.getServletContext().getInitParameter( HELP_CONF_XSL );
            
            File xmlFile = new File( pathXML );
            File xsltFile = new File( pathXSL );

            javax.xml.transform.Source xmlSource =
                    new javax.xml.transform.stream.StreamSource(xmlFile);
            javax.xml.transform.Source xsltSource =
                    new javax.xml.transform.stream.StreamSource(xsltFile);
            
            StringWriter xslOutput = new StringWriter();
            
            javax.xml.transform.Result result =
                    new javax.xml.transform.stream.StreamResult( xslOutput );

            // create an instance of TransformerFactory
            javax.xml.transform.TransformerFactory transFact =
                    javax.xml.transform.TransformerFactory.newInstance(  );

            javax.xml.transform.Transformer trans =
                    transFact.newTransformer(xsltSource);

            trans.setParameter(TYPE_KEY, type);
            trans.setParameter(PAGE_KEY, page);
            trans.transform(xmlSource, result);
            
            String outputStr = xslOutput.toString();
            out.println( outputStr );
            
        } catch( Exception e ) {
            out.println( "err" );
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
