/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package model;

import controller.threads.TestThread;
import java.io.File;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.test.ExecutionError;
import model.test.TestError;

/**
 *
 * @author Dax
 */
public abstract class Language implements Serializable {

    protected Integer           id;
    protected String            ext;
    protected String            formatterClassString;
    protected String            codeanalizerClassString;
    protected String            testcaseFilename;
    protected Boolean             defaultlanguage;
    protected String            compileOptions;
    protected String            execOptions;
    protected String            dir;


    public Language() {

    }

    public String getCompileDir(  boolean fastCompilation ) {
        String sep = System.getProperty( "file.separator" );
        if ( fastCompilation )
            return dir + sep + "compilation" + getCurrentThreadID();

        return dir + sep + "test" + getCurrentThreadID();
    }
    
    public String initDirs( boolean fastCompilation ) {
        String path = getCompilePath() + getCompileDir( fastCompilation );
        try {        
            new File( path ).mkdirs();
        } catch ( Exception e ) {
            return null;    
        }
        return path;
    }
    
    public void removeBuild( boolean fastCompilation ) {
        String sep = System.getProperty( "file.separator" );
        try {
            util.Util.deleteDirectory( new File( getCompilePath() + getCompileDir( fastCompilation ) ) );
        } catch ( Exception e ) {
            
        }
    }
    
    protected Result newWrongResult( String message, int type ) {
        Result cr = new Result();
        
        if ( type == TestError.COMPILER_ERROR ) {
            cr.addCompilerError( new TestError( "no_test", TestError.NO_LINE, message  ) );
            cr.setReturnCode( Result.COMPILES_KO );
        }
        else {
            cr.addExecError( new TestError( "no_test", TestError.NO_LINE, message  ) );
            cr.setReturnCode( Result.EXECUTES_KO );
        }
        cr.setSeenByUser( false );

        return cr;
    }

    protected String getCompilePath() {
        Thread current = Thread.currentThread();
        Class currentClass = current.getClass();
        if (currentClass.equals(TestThread.class)) {
            TestThread tt = (TestThread) current;
            String sep = System.getProperty( "file.separator" );
            return tt.getApplicationContext() + "WEB-INF" + sep + "classes" + sep;
        }
        return "";
    }

    protected String getContextPath() {
        Thread current = Thread.currentThread();
        Class currentClass = current.getClass();
        if (currentClass.equals(TestThread.class)) {
            TestThread tt = (TestThread) current;
            return tt.getApplicationContext();
        }
        return "";
    }

    protected long getCurrentThreadID() {
        Thread current = Thread.currentThread();
        Class currentClass = current.getClass();
        if (currentClass.equals(TestThread.class)) {
            TestThread tt = (TestThread) current;
            if ( tt.getSlot() == null ) return tt.getId();
            return tt.getSlot();
        }
        return -1;
    }

    public CodeAnalizer getCodeAnalizer() {
        try {
            return (CodeAnalizer) Class.forName(getCodeanalizerClassString()).newInstance();
        } catch (Exception ex) {
        }
        return new CodeAnalizer() {
            public void fixExecutionError(String code, String fileName, List<ExecutionError> l) { } 
        };
    }

    public Formatter getFormatter() {
        try {
             return (Formatter) Class.forName(getFormatterClassString()).newInstance();
        } catch (Exception ex) {
        }
        return new Formatter() {
            public String format( String code ) { return code; }
        };
    }

    public abstract Result compile( Submission s, boolean destroyAfterCompilation );
    public abstract Result execute( Submission s );
    public abstract void voidResult( Submission s );

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getExt() {
        return ext;
    }

    public void setExt(String name) {
        this.ext = name;
    }

    public String getFormatterClassString() {
        return formatterClassString;
    }

    public void setFormatterClassString(String formatterClassString) {
        this.formatterClassString = formatterClassString;
    }

    public boolean equals( Object o ) {
        if ( o == null ) return false;

        try {
            Language ot = ( Language ) o;
            return ot.getId().equals( this.getId() );
        }
        catch ( ClassCastException e ) {
            return false;
        }

    }
    
    public String getTestcaseFilename() {
        return testcaseFilename;
    }

    public void setTestcaseFilename(String testcaseFilename) {
        this.testcaseFilename = testcaseFilename;
    }

    public String getCodeanalizerClassString() {
        return codeanalizerClassString;
    }

    public void setCodeanalizerClassString(String medialanguageClassString) {
        this.codeanalizerClassString = medialanguageClassString;
    }

    public Boolean isDefaultlanguage() {
        return defaultlanguage;
    }

    public void setDefaultlanguage(Boolean defaultlanguage) {
        this.defaultlanguage = defaultlanguage;
    }

    public String getCompileOptions() {
        return compileOptions;
    }

    public void setCompileOptions(String compileOptions) {
        this.compileOptions = compileOptions;
    }

    public String getExecOptions() {
        return execOptions;
    }

    public void setExecOptions(String execOptions) {
        this.execOptions = execOptions;
    }

    public String getDir() {
        return dir;
    }

    public void setDir(String dir) {
        this.dir = dir;
    }
}
