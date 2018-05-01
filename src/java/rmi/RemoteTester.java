/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package rmi;

import java.rmi.Remote;
import java.rmi.RemoteException;
import java.util.List;
import model.Text;
import model.Result;
import model.Submission;
import model.test.ExecutionError;
import model.test.TestError;

public interface RemoteTester extends Remote {
    
    public List<ExecutionError> execute()  throws RemoteException;
    
}
