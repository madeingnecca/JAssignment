/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller.actions;
import controller.*;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.upload.FormFile;
import org.apache.struts.validator.DynaValidatorForm;
import model.*;
import dao.*;
/**
 *
 * @author Dax
 */
public class UploadAuxFileAction extends Action {

    @Override
    public ActionForward execute(ActionMapping mapping,
            ActionForm form,
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException, ServletException {

        DynaValidatorForm dvf = (DynaValidatorForm) form;
        
        Integer assid = ( Integer )  dvf.get("assid");
        Integer ordinal = ( Integer ) dvf.get("ord");
        Boolean source = ( Boolean ) dvf.get("source"); 
        boolean source2 = (source == null) ? false : source.booleanValue();
        
        FormFile src = (FormFile) dvf.get("src");
        String content = new String( src.getFileData() );
        String filename = src.getFileName();

        Assignment assignment = ( Assignment ) AssignmentDAO.getInstance().getRecord(assid);
        Text txt = new Text();
        txt.setAssignment(assignment);
        txt.setOrdinal(ordinal);
        txt = ( Text ) TextDAO.getInstance().getRecord(txt);
             
        if ( txt == null ) {
            /* errore */
            request.setAttribute( "error", true );
        }
        else {
            
            AuxiliarySourceFile aux = new AuxiliarySourceFile();
            aux.setCode(content);
            aux.setFilename(filename);
            aux.setSource(source2);

            txt.addAuxFile( aux );

            //boolean created = AuxiliarySourceFileDAO.getInstance().saveRecord( aux );
            boolean saved = TextDAO.getInstance().saveRecord( txt );
            
            if ( saved ) {
                
                int auxid = aux.getId();
                String name = aux.getFilename();
                request.setAttribute( "auxid", auxid );
                request.setAttribute( "auxname", name );
                request.setAttribute( "source", source );
                request.setAttribute( "error", false );
                request.setAttribute( "done", true );
            }
            else {
                request.setAttribute( "done", true );
                request.setAttribute( "error", true );
            }
        }
        request.setAttribute( Constants.ASSIGNMENT_REQUEST_KEY,  assid );
        request.setAttribute( Constants.ORDINAL_REQUEST_KEY,  ordinal );
        return mapping.findForward("uploadAuxFileResult");
    }
}
