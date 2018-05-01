package controller.actions;

import controller.servlets.TestServlet;
import controller.threads.TestThread;
import controller.*;
import dao.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import util.*;

import javax.servlet.http.HttpSession;
import controller.mail.EmailSender;
import model.*;
import model.test.TestError;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.action.ActionMessages;
import org.apache.struts.upload.FormFile;
import org.apache.struts.validator.DynaValidatorForm;


public class NewTextAction extends org.apache.struts.action.Action {
        
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        HttpSession session = request.getSession();
        
        if ( session == null ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }
        
        User user = ( User ) session.getAttribute( Constants.USER_SESSION_KEY );
        Admin connected = null;
        if ( user instanceof Student ) {
            return mapping.findForward( Constants.LOGIN_FRWD );
        }
        else {
            connected = ( Admin ) user;
        }
        
        boolean fastCreate = true;
        
        int assignmentID = 0;
        try {
            assignmentID = Integer.parseInt(request.getParameter(Constants.ASSIGNMENT_REQUEST_KEY));
        } catch (Exception e) {
            fastCreate = false;
        }
        
        ActionErrors errors = new ActionErrors();
        
        if ( fastCreate ) {
            
            ActionMessages msgs = new ActionMessages();
            AssignmentDAO assdao = AssignmentDAO.getInstance();
            Assignment current = (Assignment) assdao.getRecord(assignmentID);
            
            Language defLanguage = LanguageDAO.getInstance().getDefaultLanguage();
            
            if ( defLanguage == null ) {
                errors.add( ActionMessages.GLOBAL_MESSAGE,  new ActionMessage( "errors.savenotok", "nessun linguaggio di programmazione impostato" ) );
                this.saveErrors(request, errors);
                
                request.setAttribute( Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_EXERCISES );
                request.setAttribute( Constants.ASSIGNMENT_REQUEST_KEY, current );
                return mapping.findForward( Constants.ADMIN_PAGE_FRWD );    
            }
            
            if ( !Assignment.canDeleteOrAdd( Assignment.getState( current )) ) {
                /* non posso piu' creare sottoesercizi, ERRORE! */
                return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
            }
            
            int nextOrdinal = current.getTexts().size() + 1;
            Text text = new Text();
            text.setAssignment(current);
            text.setOrdinal( nextOrdinal );
            text.setLanguage( defLanguage );
            
            current.addText(text);
            boolean saved = TextDAO.getInstance().saveRecord( text );
            saved = saved && AssignmentDAO.getInstance().saveRecord( current );
            
            if ( !saved ) {
                /* se il salvataggio non e' riuscito */
                current.getTexts().remove( text );
                
                errors.add( ActionMessages.GLOBAL_MESSAGE,  new ActionMessage( "errors.savenotok", "" ) );
                this.saveErrors(request, errors);
                
                request.setAttribute( Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_EXERCISES );
                request.setAttribute( Constants.ASSIGNMENT_REQUEST_KEY, current );
                return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
            }
            
            /* se il salvataggio e' riuiscito: devo passar per l'edit assignment che carica tutto da db */
            
            request.setAttribute( Constants.TEXT_REQUEST_KEY, text );
            return mapping.findForward( Constants.EDIT_TEXT_FW );
        }
        
        DynaValidatorForm dvf = ( DynaValidatorForm ) form;
        errors = dvf.validate(mapping, request);
        
        String text;
        String submitname = null;
        FormFile testClass = null;
        FormFile exampleFile = null;
        Boolean pseudocode = null;
        Boolean human = null;
        Integer aid = null;
        Boolean edit = null;
        Integer textOrdinal = null;
        Integer langId = null;
        String strPerm = null;
        Integer timeout = null;
        FormFile solution = null;
        Boolean ioPerm = null;
        Boolean threadPerm = null;
        Boolean socketServPerm = null;
        Boolean socketClientPerm = null;
        
        
        try {
            textOrdinal = ( Integer ) dvf.get( "ordinal" );
            aid = ( Integer ) dvf.get( "assid" );
        }
        catch ( Exception e ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }
        
        AssignmentDAO assdao = AssignmentDAO.getInstance();
        Assignment current = (Assignment) assdao.getRecord(aid);
        Text theText = new Text();
        theText.setAssignment(current);
        theText.setOrdinal(textOrdinal);
        theText = ( Text ) TextDAO.getInstance().getRecord( theText );
        
        if ( !errors.isEmpty() ) {
            this.saveErrors(request, errors);
            List auxfiles = AuxiliarySourceFileDAO.getInstance().getAvailableAuxiliaryFiles(theText);
            request.setAttribute( Constants.AUXFILES_REQUEST_KEY, auxfiles );
            request.setAttribute( Constants.TEXT_REQUEST_KEY, theText );

            request.setAttribute( Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_SUB_EX );

            /* resetto il form.. */
            dvf.reset(mapping, request);
            return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        }
        
        try {
            text = dvf.getString( "text" );
            pseudocode = ( Boolean ) dvf.get( "pseudocode" );

            edit = ( Boolean ) dvf.get( "editmode" );
            textOrdinal = ( Integer ) dvf.get( "ordinal" );
            pseudocode = ( Boolean ) dvf.get( "pseudocode" );
            human = ( Boolean ) dvf.get( "human" );
            langId = ( Integer ) dvf.get( "selectedLangID" );
            testClass = ( FormFile ) dvf.get( "testclass");
            exampleFile = ( FormFile ) dvf.get( "examplesubmit");
            solution = ( FormFile ) dvf.get( "solutionfile");

            timeout = ( Integer ) dvf.get( "timeout" );
            submitname = ( String ) dvf.get("submitname");
            
            boolean[] permissions = new boolean[ 4 ];
            
            ioPerm = ( Boolean ) dvf.get( "io_perm");
            threadPerm = ( Boolean ) dvf.get( "thread_perm");
            socketServPerm = ( Boolean ) dvf.get( "sock_srv_perm");
            socketClientPerm = ( Boolean ) dvf.get( "sock_clnt_perm");
            
        }
        catch ( Exception e ) {
            return mapping.findForward( Constants.LOGIN_ADMIN_FRWD );
        }
       
        theText.setText(text);
        theText.setSubmitFileName(submitname);
        
        Language currentLang = ( Language ) LanguageDAO.getInstance().getRecord( langId );
        
        theText.setLanguage( currentLang );
        theText.setPseudocodeRequested(pseudocode);
        theText.setHumanNeeded(human);
        theText.setTimeout(timeout);
        
        theText.setExecuteIO( ioPerm );
        theText.setExecuteSocket( socketClientPerm );
        theText.setExecuteSocketServer( socketServPerm );
        theText.setExecuteThread( threadPerm );
        
        String testcaseCode = new String( testClass.getFileData() );
        String solutionCode = new String( solution.getFileData() );
        String exampleSrc = new String( exampleFile.getFileData() );
        
        /* formatta codice testcase prima della memorizzazione */
        testcaseCode = theText.getLanguage().getFormatter().format( testcaseCode );
        
        String oldExampleFileSrc = theText.getExamplefile();
        String oldTestCase = theText.getTestcase();
        
        theText.setSolution( solutionCode );
        theText.setTestcase( testcaseCode, true );
        theText.setExamplefile(exampleSrc, true );
        
        boolean compiles = true;
        String allErrors = "";
        
        boolean doCompilation = false;
        
        doCompilation = ( !testcaseCode.equals("") && !exampleSrc.equals("") ) ||
                ( !testcaseCode.equals("") && !oldExampleFileSrc.equals("") ) ||
                ( !oldTestCase.equals("") && !exampleSrc.equals("") );
        
        /* tento di fare la compilazione del file consegna */
        if (  doCompilation )  {
            
            Submission fake = new Submission();
            fake.setText( theText );
            fake.setExerciseText( theText.getExamplefile() );
            
            Student fakeStud = new Student();
            fakeStud.setLogin( "temp" );
            fake.setLogin( fakeStud );
            
            TestThread tt = new TestThread( 
                    this.getServlet().getServletContext().getRealPath("/"), 
                    fake
            );
            
            tt.start();
            
            try {
                // aspetto che finisca
                tt.join();
                
                Result cr = tt.getSubmissions().get( 0 ).getResult();
                if ( cr != null && cr.getReturnCode() == Result.COMPILES_OK ) {
                    compiles = true;
                }
                else {
                    compiles = false;

                    List<TestError> compErrors = cr.getCompilerErrors();
                    for ( TestError te : compErrors ) {
                        String singleError = te.getFile() + ":" + te.getLine() + ":" + te.getError();
                        allErrors += singleError + "</br>";
                    }
                }
                
            } catch (InterruptedException ex) {
                Logger.getLogger(TestServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            
        }
        
        ActionMessages msgs = new ActionMessages();
        
        boolean saved = false;
        
        if ( compiles )
            saved = TextDAO.getInstance().saveRecord( theText );
        else {
            theText.setExamplefile(oldExampleFileSrc, false );
            theText.setTestcase( oldTestCase, false );
            errors.add( ActionMessages.GLOBAL_MESSAGE,  new ActionMessage( "messages.notcompile", allErrors ) );
        }
        
        if ( saved ) {
            msgs.add( ActionMessages.GLOBAL_MESSAGE,  new ActionMessage( "messages.saveok" ) );
        }
        else {
            errors.add( ActionMessages.GLOBAL_MESSAGE,  new ActionMessage( "errors.savenotok", "" ) );
            this.saveErrors(request, errors);
        }
        
        if ( saved && Assignment.isOpen( Assignment.getState( current )) ) {
            List receivers = AdminDAO.getInstance().getSubmitters( theText );
            EmailSender emailsender = EmailSender.getInstance( 
                    this.getServlet().getServletContext().getRealPath("/") +
                    this.getServlet().getInitParameter( EmailSender.MAIL_CONF_XML ) 
            );
            boolean sentmail = emailsender.sendUpdatedText(connected, receivers, theText);
            if ( sentmail )
                msgs.add( ActionMessages.GLOBAL_MESSAGE,  new ActionMessage( "messages.sentmail" ) );
            else 
                msgs.add( ActionMessages.GLOBAL_MESSAGE,  new ActionMessage( "messages.sentmailnotok" ) );
        }
        
        this.saveMessages(request, msgs);
        
        List auxfiles = AuxiliarySourceFileDAO.getInstance().getAvailableAuxiliaryFiles(theText);
        request.setAttribute( Constants.AUXFILES_REQUEST_KEY, auxfiles );
        request.setAttribute( Constants.TEXT_REQUEST_KEY, theText );
        
        request.setAttribute( Constants.LEVEL_REQUEST_KEY, Constants.LEVEL_SUB_EX );
        
        /* resetto il form.. */
        dvf.reset(mapping, request);
        return mapping.findForward( Constants.ADMIN_PAGE_FRWD );
        
    }
}