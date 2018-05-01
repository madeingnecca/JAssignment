/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package rmi.remote;

import java.rmi.Naming;
import java.rmi.RemoteException;
import java.rmi.registry.LocateRegistry;
import java.rmi.server.UnicastRemoteObject;
import java.util.ArrayList;
import java.util.List;
import model.test.ExecutionError;
import model.test.TestError;
import rmi.RemoteTester;


public class FakeServer extends UnicastRemoteObject implements RemoteTester {

    private int param;
    
    public static void main( String[] args ) {
        try {
            LocateRegistry.createRegistry( 7000 );
        }
        catch ( Exception e ) {
            /* probabilmente arrivo qui quando cerco di creare un registro gia' instanziato da un altro server rmi */
            if ( true ) {int a = 3;}
        }
        
        int random = (int) (Math.random() * 1000);
        
        try {
            Naming.rebind("//localhost:7000/ciao" , new FakeServer( random ));
        }
        catch ( Exception e ) {
            if ( true ) return;
        } 
        
    }

    public FakeServer( int a ) throws Exception {
        param = a;
    }
    
    public List<ExecutionError> execute() throws RemoteException {
        ArrayList al = new ArrayList<ExecutionError>();
        TestError te = new TestError();
        te.setLine(param);
        ExecutionError ee = new ExecutionError();
        ee.setTestError( te );
        al.add( ee );
        return al;
    }
    
}
