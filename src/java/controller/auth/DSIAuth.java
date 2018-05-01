/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller.auth;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.security.auth.login.LoginException;
import model.User;
import com.sun.jndi.ldap.LdapCtx;
import controller.auth.kerberos.LoginCallbackHandler;
import dao.StudentDAO;
import java.util.Properties;
import java.util.Scanner;
import java.util.StringTokenizer;
import javax.naming.Context;
import javax.naming.NamingEnumeration;
import javax.naming.NamingException;
import javax.naming.directory.Attribute;
import javax.naming.directory.Attributes;
import javax.naming.directory.DirContext;
import javax.naming.directory.InitialDirContext;
import javax.security.auth.login.LoginContext;
import javax.servlet.http.HttpServlet;
import model.Student;

public class DSIAuth implements Authenticator {


    private static final int            LDAP_PORT = 389;
    private static final String         LDAP_SERVER = "roar.dsi.unive.it";
    private static final String         LDAP_JAVA_CLASS = "com.sun.jndi.ldap.LdapCtxFactory";
    private static final String         AUTH_MODE = "";
    private static final String         BASE_DN = "cn=users,cn=accounts,dc=dsi,dc=unive,dc=it";

    private static final String         KERBEROS_REALM = "DSI.UNIVE.IT";
    private static final String         KERBEROS_KDC = "roar.dsi.unive.it";

    private static final String         JAAS_CONF_FILE_PATH = "jaas_conf_file";

    private HttpServlet requester;
    
    public DSIAuth() {
    }

    private User lookupLocally( String username ) {
        return ( User ) StudentDAO.getInstance().getRecord( username );
    }

    private User lookupViaLDAP( String username ) {

        Student user = new Student();

        Properties env = new Properties();
        env.put(Context.INITIAL_CONTEXT_FACTORY, LDAP_JAVA_CLASS);
        env.put(Context.PROVIDER_URL, "ldap://" + LDAP_SERVER + ":" + LDAP_PORT );
        env.put(Context.SECURITY_CREDENTIALS, AUTH_MODE );

        try {
            DirContext ctx = new InitialDirContext(env);

            String completeDN = "uid=" + username + "," + BASE_DN;

            String[] attrs = new String[] {
                "sn",
                "givenName",
                "mail",
                "gecos"
            };

            Attributes result = ctx.getAttributes( completeDN, attrs);

            if (result == null) {
                return null;
            } else {

                user.setLogin(username);

                Attribute attr = result.get( attrs[ 0 ] );
                if ( attr != null) user.setCognome( ( String ) attr.get(0) );

                attr = result.get( attrs[ 1 ] );
                if ( attr != null) user.setNome( ( String ) attr.get(0) );

                attr = result.get( attrs[ 2 ] );
                if ( attr != null) user.setEmail( ( String ) attr.get(0) );

                attr = result.get( attrs[ 3 ] );
                if ( attr != null) {
                    int matricola = -1;

                    StringTokenizer tk = new StringTokenizer( ( String ) attr.get(0), " " );

                    while ( tk.hasMoreTokens() ) {
                        try {
                            matricola = Integer.valueOf( ( String ) tk.nextElement() );
                        } catch( Exception e ) {}

                        if ( matricola != -1 ) {
                            user.setMatricola( matricola );
                            break;
                        }
                    }
                }
            }
        } catch (NamingException ne) {
            ne.printStackTrace();
            return null;
        }
        return user;
    }


    public User authViaKerberos( User user, String pass ) {

        System.setProperty( "java.security.krb5.realm", KERBEROS_REALM );
        System.setProperty( "java.security.krb5.kdc", KERBEROS_KDC );

        String configPath = requester.getServletContext().getRealPath( "/") +
                requester.getServletContext().getInitParameter( JAAS_CONF_FILE_PATH );

        System.out.println("authViaKerberos: " + configPath);
        System.setProperty( "java.security.auth.login.config", configPath );

        String username = user.getLogin();
        String password = pass;

        LoginContext loginCtx = null;

        try {
            loginCtx = new LoginContext( "Client",
                new LoginCallbackHandler( username, password));
            loginCtx.login();
            loginCtx.logout();
        } catch ( Exception e ) {
            e.printStackTrace();
            return null;
        }

        if ( loginCtx.getSubject() == null ) return null;

        user.setPassword( "" );
        return user;
    }

    private void updateLocalCopy( User usr ) {
        StudentDAO.getInstance().saveRecord( ( Student ) usr );
    }

    @Override
    public User authenticate(String usrname, String passwd, boolean isadmin, HttpServlet req ) {
        
        if ( isadmin ) return new LocalAuth().authenticate(usrname, passwd, isadmin, req);

        requester = req;
        
        User user = null;

        user = this.lookupLocally(usrname);

        if ( user == null ) {
            /* o lo studente non c'e' proprio, oppure deve ancora fare il primo login */

            user = this.lookupViaLDAP(usrname);
            /* se l'user e' ancora null, amen, vuol dire che non esiste */
            if ( user == null ) return null;
        }
        System.out.println(((Student)user).getEmail());
        /* comincio l'autenticazione */
        user = this.authViaKerberos(  user, passwd );

        if ( user == null ) return null;

        this.updateLocalCopy(user);

        return user;
    }

}
