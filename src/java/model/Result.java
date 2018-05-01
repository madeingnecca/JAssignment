/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import model.test.TestError;

public class Result implements Serializable {
    
    public static final int     NOT_TESTED = 1;
    public static final int     COMPILES_OK = 2;
    public static final int     COMPILES_KO = 3;
    public static final int     EXECUTES_OK = 4;
    public static final int     EXECUTES_KO = 5;

    private Integer         id;
    private Integer         returnCode;
    private String          testStdOut;
    private Boolean         pseudoOk;
    private Boolean         seenByUser;
    private String          extraInfo;
    
    private List<TestError>          errors = new ArrayList();
    
    public Result() {
        returnCode = NOT_TESTED;
        seenByUser = false;
    }


    public Integer getReturnCode() {
        return returnCode;
    }

    public void setReturnCode(Integer returnCode) {
        this.returnCode = returnCode;
    }

    public Boolean isPseudoOk() {
        return pseudoOk;
    }

    public void setPseudoOk(Boolean pseudoOk) {
        this.pseudoOk = pseudoOk;
    }


    public Boolean isSeenByUser() {
        return seenByUser;
    }

    public void setSeenByUser(Boolean seenByUser) {
        this.seenByUser = seenByUser;
    }

    public String getExtraInfo() {
        return extraInfo;
    }

    public void setExtraInfo(String extraInfo) {
        this.extraInfo = extraInfo;
    }
    
    public List<TestError> getCompilerErrors() {
        
        if ( errors == null ) return new ArrayList();
        
        List<TestError> compilerErrors = new ArrayList();
        
        for ( TestError te : getErrors() ) {
            if ( te.getType() == TestError.COMPILER_ERROR )
               compilerErrors.add(te); 
        }
        
        return compilerErrors;
    }
    
    
    public List<TestError> getExecErrors() {
        
        if ( errors == null ) return new ArrayList();
        
        List<TestError> execErrors = new ArrayList();
        
        for ( TestError te : getErrors() ) {
            if ( te.getType() == TestError.EXEC_ERROR )
               execErrors.add(te);
        }
        
        return execErrors;
    }

    public List<TestError> getErrors() {
        return errors;
    }

    public void setErrors(List<TestError> errors) {
        this.errors = errors;
    }

    public void addCompilerError( TestError te ) {
        te.setType( TestError.COMPILER_ERROR );
        errors.add(te);
    }
    
    public void addExecError( TestError te ) {
        te.setType( TestError.EXEC_ERROR );
        errors.add(te);
    }

    public String getTestStdOut() {
        return testStdOut;
    }

    public void setTestStdOut(String testStdOut) {
        this.testStdOut = testStdOut;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }
    
}
