/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package model.test;

import test.*;
import java.io.Serializable;

public class ExecutionError implements Serializable {
    private TestError   te;
    private TestedRoutine  tm;
    
    
    public ExecutionError() {
        te = null;
        tm = null;
    }
    
    public ExecutionError( String methodname, String code, String cause, boolean constructor, String... ptypes) {
        te = new TestError( code, TestError.NO_LINE, cause );
        tm = new TestedRoutine( methodname, TestError.NO_LINE, ptypes );
        tm.setConstructor(constructor);
    }
    
    public ExecutionError( String code, int line, String cause ) {
        te = new TestError( code, line, cause );
        tm = new TestedRoutine( TestedRoutine.NO_NAME, line );
    }    

    public void setLineNumber( int line ) {
        te.setLine(line);
        this.getTestedRoutine().setLine(line);
    }
    
    public TestError getTestError() {
        return te;
    }

    public void setTestError(TestError te) {
        this.te = te;
    }

    public TestedRoutine getTestedRoutine() {
        return tm;
    }

    public void setTestedRoutine(TestedRoutine tm) {
        this.tm = tm;
    }
}
