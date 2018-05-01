package controller.mail;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.StringReader;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.mail.*;
import javax.mail.internet.*;
import java.util.*;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import model.*;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import util.*;

public class EmailSender {
    
    public static final String  MAIL_CONF_XML = "mail_conf_xml";
    
    private static EmailSender instance = null;
    private static boolean      debug = true;
    
    private String      subjectEditText = "";
    private String      bodyEditText = "";
    
    private String      subjectEditAssignment = "";
    private String      bodyEditAssignment = "";
    
    private String      subjectNewPass = "";
    private String      bodyNewPass = "";
    
    private String      username = "";
    private String      password = "";
    private boolean     useSSL = false;
    private String      smtpServer = "";
    private String      sender = "";
    
    private EmailSender( String mail_conf_xml ){
        
        String sep = System.getProperty( "file.separator" );
        File mailconf = new File( mail_conf_xml );
        XPath xpath = XPathFactory.newInstance().newXPath();
        String expSmtphost = "normalize-space(smtp-host/text())";
        String expSender = "normalize-space(sender/text())";
        String expUsername = "normalize-space(smtp-username/text())";
        String expPassword = "normalize-space(smtp-password/text())";
        String expSSL = "normalize-space(smtp-ssl/text())";
        
        String expSubjectEditText = "normalize-space(updated-text/subject/text())";
        String expBodyEditText = "normalize-space(updated-text/content/text())";
        String expSubjectEditAssignment = "normalize-space(updated-assignment/subject/text())";
        String expBodyEditAssignment = "normalize-space(updated-assignment/content/text())";
        String expSubjectNewPass = "normalize-space(new-pass-admin/subject/text())";
        String expBodyNewPass = "normalize-space(new-pass-admin/content/text())";        
        
        String[] expressions = new String[] {
            expSmtphost,
            expUsername,
            expPassword,
            expSSL,
            expSubjectEditText,
            expBodyEditText,
            expSubjectEditAssignment,
            expBodyEditAssignment,
            expSubjectNewPass,
            expBodyNewPass,
            expSender
        };
        
        String[] results = new String[ expressions.length ];
        
        try {
            InputSource inputSource = new InputSource( new FileInputStream( mailconf ) );
            Node root = (Node) xpath.evaluate("/mailconf", inputSource, XPathConstants.NODE);
          
            for ( int i = 0; i < expressions.length; i++ ) {
                results[ i ] = (String) xpath.evaluate(expressions[i], root, XPathConstants.STRING);
 
            }
            
            
            if ( debug ) {
                System.out.print( "mailconf.fields = " );
                for ( int i = 0; i < results.length; i++ ) {
                    System.out.print( results[ i ] );
                    String space = (i < results.length - 1)? " ," : " ";
                    System.out.println( space );
                }
            }
            
            smtpServer = results[ 0 ];
            username = results[ 1 ];
            password = results[ 2 ];
            useSSL = results[ 3 ].equals( "true" );
            subjectEditText = results[ 4 ];
            bodyEditText = results[ 5 ];
            subjectEditAssignment = results[ 6 ];
            bodyEditAssignment = results[ 7 ];
            subjectNewPass = results[ 8 ];
            bodyNewPass = results[ 9 ];
            sender = results[ 10 ];
            
        } catch (Exception ex) {
             if ( debug ) 
                 ex.printStackTrace();
        }
        
    }
    
    public static synchronized EmailSender getInstance( String appc) {
        
        if ( instance == null ) instance = new EmailSender( appc );
        
        return instance;
    }
    
    private static String replaceWithValues( String source, String ... replacements ) {
        
        int i = 0;
        for ( String replacement : replacements ) {
            source = source.replaceAll( "\\{"+i+"\\}", replacement);
            i++;
        }
        
        return source;
    }
    
    public boolean sendUpdatedAssignment( Admin adminSender, List<Student> submitters, Assignment a ) {
        
        String body = bodyEditAssignment;
        String subject = subjectEditAssignment;
        
        body = replaceWithValues(   body, 
                                    a.getTitle(), 
                                    a.getCourse().getNameWithAY(),
                                    String.valueOf( a.getTexts().size() ),
                                    Util.dateToString( a.getDeadline() )
        );
        
        subject = replaceWithValues( subject, "" );
        
        String[] recipients = new String[ submitters.size() ];
        int i = 0;
        for ( Student s : submitters ) {
            recipients[ i ] = s.getEmail();
        }
        
        String from = adminSender.getEmail();
        try {
            postMail( recipients, subject, body, from  );
        }
        catch ( Exception e) {
             if ( debug )
                e.printStackTrace();
            return false;
        }
        return true;
    }

    public boolean sendUpdatedText( Admin adminSender, List<Student> submitters,Text t ) {
        String body = bodyEditAssignment;
        String subject = subjectEditAssignment;
        
        body = replaceWithValues( body,
                                  t.getAssignment().getCourse().getNameWithAY(),
                                  t.getAssignment().getTitle(),
                                  String.valueOf( t.getOrdinal()));
        
        subject = replaceWithValues( subject, "" );
        
        String[] recipients = new String[ submitters.size() ];
        int i = 0;
        for ( Student s : submitters ) {
            recipients[ i ] = s.getEmail();
        }
        
        String from = sender;
        try {
            postMail( recipients, subject, body, from  );
        }
        catch ( Exception e) {
             if ( debug )
                e.printStackTrace();
            return false;
        }
        return true;
    }

    public boolean sendNewPassAdmin( Admin adminSender, Admin admin, String newpass ) {
        String body = bodyNewPass;
        String subject = subjectNewPass;
        
        body = this.replaceWithValues( body, newpass );
        
        String[] recipients = new String[] { admin.getEmail() };
        
        try {
            postMail( recipients, subject, body, adminSender.getEmail()  );
        }
        catch ( Exception e) {
             if ( debug )
                e.printStackTrace();
            return false;
        }
        return true;
    }
    
    private void postMail(String recipients[], String subject, String message, String from) throws MessagingException {
        boolean debug = false;

        //Set the host smtp address
        Properties props = new Properties();
        props.put("mail.smtp.host",smtpServer );
        
        // create some properties and get the default Session
        
        Authenticator auth = new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(username, password);
            }
        };
        Session session = Session.getInstance(props, auth);
        session.setDebug(debug);

        // create a message
        Message msg = new MimeMessage(session);

        // set the from and to address
        InternetAddress addressFrom = new InternetAddress(from);
        msg.setFrom(addressFrom);

        InternetAddress[] addressTo = new InternetAddress[recipients.length];
        for (int i = 0; i < recipients.length; i++) {
            addressTo[i] = new InternetAddress(recipients[i]);
        }
        msg.setRecipients(Message.RecipientType.TO, addressTo);

        // Setting the Subject and Content Type
        msg.setSubject(subject);
        msg.setContent(message, "text/html");
        Transport.send(msg);
    }
    
    public static void main( String[] args ) {
        
        String appc = "/home/dax/JAssignmentStruts/build/web/";
        EmailSender s = EmailSender.getInstance( appc );
        
        Admin admin = new Admin();
        admin.setLogin("beo");
        admin.setEmail( "dseno@dsi.unive.it" );
        
        Assignment a = new Assignment();
        a.setDeadline( new Date() );
        a.setTitle( "es prova" );
        //a.setExercises( 4 );
        Course c = new Course();
        c.setName( "labasd" );
        AcademicYear ay = new AcademicYear();
        ay.setFirstYear(2008);
        ay.setSecondYear(2009);
        c.setAcademicYear(ay);
        a.setCourse( c );
        
        Student stud = new Student();
        stud.setLogin("dseno");
        stud.setEmail("damy_belthazor86@yahoo.it");
        
        List l = new ArrayList();
        l.add( stud );
        
        s.sendUpdatedAssignment( admin, l, a );
        
    }
        
}
