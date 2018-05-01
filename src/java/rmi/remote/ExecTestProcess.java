/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package rmi.remote;
import test.*;
import rmi.remote.ExecTestProcess;
import java.util.ArrayList;

import java.util.Timer;
import test.ClassicTestCase;
import rmi.remote.ExecThread;
import model.test.ExecutionError;
import test.TestCase;
import model.test.TestError;


import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.server.UnicastRemoteObject;
import java.util.List;
import java.util.TimerTask;
import java.util.logging.Level;
import java.util.logging.Logger;
import languages.JavaLanguage;
import model.Text;
import rmi.RemoteTester;
import rmi.remote.security.JAssignmentSecurityException;
import rmi.remote.security.JAssignmentSecurityManager;


public class ExecTestProcess extends UnicastRemoteObject implements RemoteTester  {
    
    public static final int    REGISTRY_PORT = 6789;
    
    private String                          newPackage;
    private String                          classname;
    private Integer                         timeout;
    
    private JAssignmentSecurityManager      smanager;
    
    public ExecTestProcess( String newPackage, String classname, boolean io, boolean thread, boolean socket, boolean socketServer, Integer timeout ) throws Exception {

        this.newPackage = newPackage;
        this.classname = classname;
        
        try {
            LocateRegistry.createRegistry( REGISTRY_PORT );
        }
        catch ( Exception e ) {
            /* probabilmente arrivo qui quando cerco di creare un registro gia' instanziato da un altro server rmi */
        }
        
        //String testClass = "test.test1307._aamato.Test";
        String testClass = newPackage + "." + classname;

        smanager = new JAssignmentSecurityManager( newPackage, io, thread, socket, socketServer );
        System.setSecurityManager(smanager);
        
        this.timeout = timeout;
        
        try {
            Naming.rebind("//localhost:"+REGISTRY_PORT+"/ExecTestProcess_" + newPackage, this);
        }
        catch ( Exception e ) {
            
        } 
        
    }
        
    public static void main( String[] args ) throws Exception {
        
       //args = new String[] { "caio", "bobi", "fmst", "20"};
        
        if ( args.length < 4 ) {
            System.err.println( "usage: ExecTestProcess ... " );
            return;
        }
        
        
        new ExecTestProcess( 
                args[ 0 ], 
                args[ 1 ], 
                args[ 2 ].equals( "true" ),
                args[ 3 ].equals( "true" ),
                args[ 4 ].equals( "true" ),
                args[ 5 ].equals( "true" ),
                Integer.parseInt( args[ 6 ] )
        );
        
    }

    @Override
    public List<ExecutionError> execute()  throws RemoteException{
        
        List<ExecutionError> errors = new ArrayList<ExecutionError>();

        ClassicTestCase ctc = null;
        
        try {
                       
            Class testClass = Class.forName(newPackage + "." + classname );
            Object testObject = testClass.newInstance();
            ctc = (ClassicTestCase) testObject;
            
            Thread executor = new ExecThread( ctc );

            Timer timer = new Timer(true); 
            timer.schedule(new TimeOutTask( executor ), timeout * 1000 );
            executor.start();
            try {
                executor.join();
            } catch (InterruptedException ex) {
            }

            errors = ctc.getErrors();
            
            SecurityException nestedSE = smanager.getExceptionToThrow();
            
            if ( nestedSE != null ) throw nestedSE;
                    

        }catch (ClassNotFoundException e) {
            errors = new ArrayList<ExecutionError>();
            ExecutionError ee = new ExecutionError( "", "no test", "Class non found " + e, false );
            errors.add(ee);
        } catch ( SecurityException e ) {
            /* controllare che metodo ha dato fastidio */
            int line = (( JAssignmentSecurityException ) e ).getLineNumber();
            errors = new ArrayList<ExecutionError>();
            ExecutionError ee = new ExecutionError( "sec_error", line, "Operazione non consentita");
            errors.add(ee);
        }
        catch (Exception e) {
            errors = new ArrayList<ExecutionError>();
            ExecutionError ee = new ExecutionError( "", "UNKNOWN ERROR", "Errore generico nell'esecuzione del test: " +e.getMessage(), false );
            errors.add(ee);
        }
        
        return errors;
    }

}
class TimeOutTask extends TimerTask {

    Thread t;

    TimeOutTask(Thread t) {
        this.t = t;
    }

    @Override
    public void run() {
        if (t != null && t.isAlive()) {
            t.stop();
        }
    }
}