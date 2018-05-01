package rmi.remote.security;

import java.io.File;
import java.io.FileDescriptor;
import java.net.InetAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.security.Permission;
import java.util.PropertyPermission;
import model.Text;
import model.test.TestError;
import rmi.remote.ExecThread;

public class JAssignmentSecurityManager extends SecurityManager {

    private SecurityException tothrow = null;
    private boolean ioPermission = false;
    private boolean threadPermission = false;
    private boolean socketSrvPermission = false;
    private boolean socketClntPermission = false;
    /* directory in cui lo studente ha gli eventuali permessi di scrittura : <classpath>/test/testTTID/_STUD
     * e' ottenibile tramite System.getProperty("user.dir") in quanto è la working directory in cui viene lanciata la jvm di test 
     */
    private final String userDir = System.getProperty( "user.dir" );

    public SecurityException getExceptionToThrow() {
        return this.tothrow;
    }


    private void throwSecurityError() {

        int line = TestError.NO_LINE;
        try {
            throw new Exception();
        }
        catch( Exception e ) {
            line = ExecThread.getStackTrace( e.getStackTrace(), dangerousClass).getLineNumber();
        }
        JAssignmentSecurityException error = new JAssignmentSecurityException( line );
        this.tothrow = error;
        throw error;
    }

    private String      dangerousClass;

    private Class classPresent( Class[] stack, String target ){

        for ( int i = stack.length -1; i > 0; i-- )
            if ( stack[ i ].getName().contains( target ))
                return stack[ i ];

        return null;
    }


    public synchronized boolean isDangerousCode() {

        try {
            Class[] stack = this.getClassContext();

            boolean loadingclass = ( classPresent( stack, "sun.misc.Launcher" ) != null );
            //boolean testclassThread = classPresent( stack, dangerousClass );
            boolean isRmiOperation = ( classPresent( stack, "sun.rmi") != null ) ;

            if ( loadingclass ) return false;

            if ( isRmiOperation ) return false;
        }
        catch ( Exception e ) {
            return false;
        }

        return true;
    }

    public JAssignmentSecurityManager( String dc, boolean io, boolean thread, boolean socketClient, boolean socketServ ) {

        ioPermission = io;
        threadPermission = thread;
        socketClntPermission = socketClient;
        socketSrvPermission = socketServ;

        dangerousClass = dc;
    }

    @Override
    public void  checkAccept( String host, int port ) {
        if ( !socketSrvPermission && isDangerousCode())
            throwSecurityError();
    }

    @Override
    public void checkAccess(Thread t) {

        if ( !threadPermission && isDangerousCode() )
            throwSecurityError();
    }

    @Override
    public void checkAccess(ThreadGroup t) {

        if ( !threadPermission && isDangerousCode() )
            throwSecurityError();


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
        /* do la possibilita' di caricare SOLO la libreria rmi (utile al codice del server rmi) */
        if ( !lib.equals( "rmi" ) ) throwSecurityError();
    }

    public void checkPrintJobAccess() {
        throwSecurityError();
    }

    @Override
    public void checkExec(String cmd) {
        /* sotto processi, ma ti xe fora?? */
        throwSecurityError();
    }

    public void checkRead(FileDescriptor fd) {
        if ( !ioPermission && isDangerousCode() )
            throwSecurityError();

    }

    @Override
    public void checkRead(String file) {
        if ( !ioPermission &&  isDangerousCode() )
            throwSecurityError();


    }

    @Override
    public void checkRead(String file, Object context) {
        if ( !ioPermission && isDangerousCode())
            throwSecurityError();


    }

    public void checkWrite(FileDescriptor fd) {
        if ( !ioPermission ) {
            if ( isDangerousCode() ) throwSecurityError();
        }
    }

    public void checkWrite(String path) {
        if ( !ioPermission )
            if ( isDangerousCode() ) throwSecurityError();
        else if ( !path.contains( userDir ))
            throwSecurityError();
    }

    public void checkDelete(String file) {
        if ( !ioPermission )
            if ( isDangerousCode() ) throw new SecurityException( );
        else if ( !file.contains( userDir ))
            throwSecurityError();

    }

    public void checkExit( int code ) {
        if ( isDangerousCode() ) throwSecurityError();


    }

    public void checkListen( int p ) {
        if ( isDangerousCode() &&  !socketSrvPermission )
            throwSecurityError();


    }

    public void checkMulticast(InetAddress maddr) {

    }

    public void checkConnect(String host, int port) {
        if ( isDangerousCode() &&  !socketClntPermission )
            throwSecurityError();
    }

    public void checkConnect(String host, int port, Object o ) {
        if ( isDangerousCode() && !socketClntPermission  )
            throwSecurityError();
    }

    public void checkPermission(Permission perm) {

        boolean dangerous = (  ( perm.getActions().contains("setIO")  ||
               ( perm instanceof PropertyPermission  && perm.getActions().contains( "write") ) ) );

        dangerous = dangerous || ( perm instanceof RuntimePermission && perm.getActions().contains("setSecurityManager") );
        
        if (  dangerous ) {
            throwSecurityError();
        }
    }

    public void checkPermission(Permission perm,
                            Object context) {
        boolean dangerous = (  ( perm.getActions().contains("setIO")  ||
               ( perm instanceof PropertyPermission  && perm.getActions().contains( "write") ) ) );
        
        dangerous = dangerous || ( perm instanceof RuntimePermission && perm.getActions().contains("setSecurityManager") );
        
        if (  dangerous ) {
            throwSecurityError();
        }

    }
}
