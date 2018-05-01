/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package rmi;

import java.net.MalformedURLException;
import java.rmi.Naming;
import java.rmi.NotBoundException;
import java.rmi.RemoteException;
import java.util.List;
import model.test.ExecutionError;

public class RMIClient {
    public RMIClient() {}
    
    public static void main( String[] args ) throws NotBoundException, MalformedURLException, RemoteException, InterruptedException {
        
        RemoteTester tester = (RemoteTester) Naming.lookup( "rmi://localhost:7000/ciao" );
        RemoteTester tester2 = (RemoteTester) Naming.lookup( "rmi://localhost:7000/pappa" );
        
        Thread.sleep( 1000 );
        
        System.err.println( "from ciao: " );
        List<ExecutionError> l = tester.execute();
        for ( ExecutionError ee : l ) 
            System.err.println( ee.getTestError().getLine() ); 
        
        System.err.println( "from pappa: " );
        l = tester2.execute();
        for ( ExecutionError ee : l ) 
            System.err.println( ee.getTestError().getLine() ); 
        
        
        
    } 
}
