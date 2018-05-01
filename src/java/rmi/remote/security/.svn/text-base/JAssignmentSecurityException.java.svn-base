/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package rmi.remote.security;

import model.test.TestError;

/**
 *
 * @author dax
 */
public class JAssignmentSecurityException extends SecurityException {

    private int lineno = TestError.NO_LINE;
    
    public JAssignmentSecurityException( int lineno ) {
        this.lineno = lineno;
    }
    
    public int getLineNumber() {
        return lineno;
    }
    
}
