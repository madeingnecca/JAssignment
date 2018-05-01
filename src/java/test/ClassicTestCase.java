/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package test;

import model.test.ExecutionError;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Dax
 */
public abstract class ClassicTestCase implements TestCase {

    public ClassicTestCase() {

    }

    private final List<ExecutionError> errors = new ArrayList<ExecutionError>();

    public final void raiseMethodError(String methodname, String code, String cause, String... params) {
        errors.add( new ExecutionError( methodname, code,cause, false, params ) );
    }
    
    public final void raiseConstructorError(String methodname, String code, String cause, String... params) {
        errors.add( new ExecutionError( methodname, code,cause, true, params ) );
    }    

    public final void raiseError( String code, int line, String cause ) {
        errors.add( new ExecutionError( code, line, cause ) );
    }

    public List<ExecutionError> getErrors() {
        return errors;
    }

}
