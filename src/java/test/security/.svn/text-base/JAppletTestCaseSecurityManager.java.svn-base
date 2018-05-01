/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package test.security;

import java.io.FileDescriptor;
import java.net.InetAddress;
import java.security.Permission;
import java.util.PropertyPermission;
import javax.swing.JOptionPane;
import test.JAppletTestCase;

/**
 *
 * @author dax
 */
public class JAppletTestCaseSecurityManager extends SecurityManager {
    
    private JAppletTestCase jatc;
    
    public JAppletTestCaseSecurityManager( JAppletTestCase jatc ) {
        this.jatc = jatc;
    }
    
    private void askForPermission( String message ) {
        
        /* se sto caricando una classe, lascia perdere, troppi file da controllare.. diamo i permessi */
        if ( classPresent( this.getClassContext(), "java.lang.ClassLoader" ) != null ) return;
        
        Object[] options = {"Consenti",
                            "Blocca",
        };

        int n = JOptionPane.showOptionDialog(jatc,
            message,
            "Richiesta permessi esecuzione",
            JOptionPane.YES_NO_OPTION,
            JOptionPane.QUESTION_MESSAGE,
            null,
            options,
            options[0]
        );
        
        if ( n == JOptionPane.NO_OPTION ) {
            throw new SecurityException();
        }
        
    }
    
@Override
    public void  checkAccept( String host, int port ) { 
        askForPermission( "L'applet sta tentando di mettersi in ascolto in: " + host + ":" + port );
    }
    
    @Override
    public void checkAccess(Thread t) {
    }
    
    @Override
    public void checkAccess(ThreadGroup t) {
    }    
    
    public void checkCreateClassLoader() {
        
    }
    
    public void checkMemberAccess(Class clazz,
                              int which) {
                             
        
    }
    
    public void checkPackageAccess(String pkg) {
        
    }
    
    public void checkPackageDefinition(String pkg) {
        
    }

    public void checkLink(String lib) {
        
    }
    
    public void checkPrintJobAccess() {
        askForPermission( "L'applet sta tentando di stampare!");
    }
    
    @Override
    public void checkExec(String cmd) {
        askForPermission( "L'applet sta tentando di eseguire il comando: " + cmd );
    }
    
    public void checkRead(FileDescriptor fd) {
        askForPermission( "L'applet sta tentando di leggere il file descriptor: " + fd.toString() );
    }
    
    @Override
    public void checkRead(String file) {
    }
    
    private Class classPresent( Class[] stack, String target ){
        
        for ( int i = stack.length -1; i > 0; i-- )
            if ( stack[ i ].getName().contains( target ))
                return stack[ i ];
        
        return null;        
    }
    
    @Override
    public void checkRead(String file, Object context) {
        askForPermission( "L'applet sta tentando di leggere il file " + file );
    }
    
    public void checkWrite(FileDescriptor fd) {
        askForPermission( "L'applet sta tentando di scrivere sul file descriptor " + fd );
    }
    
    public void checkWrite(String path) {
        askForPermission( "L'applet sta tentando di scrivere il file " + path );
    }    
    
    public void checkDelete(String file) {
        askForPermission( "L'applet sta tentando di cancellae il file " + file );
    }    
    
    public void checkListen( int p ) {
        askForPermission( "L'applet sta tentando di mettersi in ascolto sulla porta: " + p );
    }
    
    public void checkMulticast(InetAddress maddr) {
        
    }
    
    public void checkConnect(String host, int port) {
        askForPermission( "L'applet sta tentando di mettersi in ascolto verso: " + host + ":" + port );
    }
    
    public void checkConnect(String host, int port, Object o ) {
        askForPermission( "L'applet sta tentando di mettersi in ascolto verso: " + host + ":" + port );
    }
    
    @Override
    public void checkExit( int a) {
        this.askForPermission( "Exiting with exit status = " + String.valueOf( a ) );
    }
    
    public void checkPermission(Permission perm) {

    }
    
    public void checkPermission(Permission perm,
                            Object context) {
                
    }
}
