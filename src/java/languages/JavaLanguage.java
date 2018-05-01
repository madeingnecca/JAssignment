/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package languages;

import model.*;
import java.io.File;
import java.util.List;
import packagefixer.PackageFixer;
import java.io.IOException;
import java.lang.String;
import java.rmi.Naming;
import java.util.ArrayList;
import java.util.Arrays;

import java.util.Collection;
import java.util.Collections;
import java.util.Date;
import java.util.Iterator;
import java.util.StringTokenizer;
import javax.tools.Diagnostic;
import javax.tools.DiagnosticCollector;
import javax.tools.JavaCompiler;
import javax.tools.JavaFileObject;
import javax.tools.ToolProvider;
import javax.tools.JavaCompiler.CompilationTask;
import javax.tools.StandardJavaFileManager;
import model.test.ExecutionError;
import model.test.TestError;

/**
 *
 * @author Dax
 */
public class JavaLanguage extends Language {

    private static final int RMI_CONNECT_MAX_ATTEMPTS = 5;
    private static final int RMI_CONNECT_DELAY = 1000;

    public JavaLanguage() {
    }

    private boolean generateAppletStuff( Result cr, String appletname, String appletPath, String classname, String newPackage ) {
        String sep = System.getProperty( "file.separator");
        Runtime rt = Runtime.getRuntime();

        String jarname = String.valueOf( new Date().getTime() );

        String[] createJarCmd = new String[] {
            "jar",
            "cf",
            appletPath + sep + jarname + ".jar",
            dir
        };

        boolean jarcreated = true;

        Process p = null;

        try {
            p = rt.exec(createJarCmd , null, new File( getCompilePath() ) );
            p.waitFor();
        } catch (Exception ex) {
            jarcreated = false;
        }


        String appletHTMLCode = "";

        if ( !jarcreated ) return false;


        String alias = "jacouplealias";
        String keypass = jarname;
        String keystore = "key_"+jarname;

        String[] keytoolCMD = new String[] {
               "keytool",
               "-import",
               "-keypass",
               keypass,
               "-genkey",
               "-alias",
               alias,
               "-keystore",
               keystore,
               "-dname",
               "cn=jassignment",
               "-storepass",
               keypass
        };

        try {
            p = rt.exec(keytoolCMD , null, new File( appletPath + sep ) );
            p.waitFor();
        } catch (Exception ex) {
            jarcreated = false;
        }

       if ( !jarcreated ) return false;

        String signedjarname = "Signed_" + jarname + ".jar";

        String[] jarsignerCmd = new String[] {
                "jarsigner",
                "-keystore",
                keystore,
               "-storepass",
               keypass,
                "-keypass",
                keypass,
                "-signedjar",
                signedjarname,
                jarname + ".jar",
                alias
        };

        try {
            p = rt.exec(jarsignerCmd , null, new File( appletPath + sep ) );
            p.waitFor();
        } catch (Exception ex) {
            jarcreated = false;
        }

        /* todo: elimina jar non firmato */

        String jar = signedjarname;

        if ( !jarcreated ) {
            signedjarname = jarname + ".jar"; /* se non sono riuscito a creare l'applet firmato, utilizzo quello non firmato*/
        }
        else {
            /* cancello quello non firmato */
            new File( appletPath + sep + jarname + ".jar" ).delete();
        }
            /*  */
        appletHTMLCode =  "<applet " +
                        "code=\""+newPackage+ "." + classname + ".class\" " +
                        "archive=\"../applets/"+signedjarname+"\"" +
                        "width=\""+test.JAppletTestCase.APPLET_WIDTH+"\" height=\""+test.JAppletTestCase.APPLET_HEIGHT+"\" " +
                        "></applet>";

        String extrainfo = signedjarname + ";" + keystore;

        cr.setTestStdOut( appletHTMLCode );
        cr.setExtraInfo(extrainfo);

        return true;
    }

    @Override
    public Result compile(Submission s , boolean onthefly) {

        String sep = System.getProperty( "file.separator" );

        String classpath = getCompilePath();
        String contextPath = getCompilePath();
        String appletPath = this.getContextPath() + "applets";

        List errors = null;

        String src = s.getExerciseText();
        String login = s.getLogin().getLogin();
        String newPackage = this.getCompileDir(onthefly);

        Collection auxfiles = s.getText().getAuxfiles();
        Iterator auxs = auxfiles.iterator();

        int auxsSize = auxfiles.size();
        File[] filesNeeded = new File[ 2 + auxsSize ];
        int auxFileStartIndex = 2;

        contextPath += newPackage;
        newPackage = newPackage.replace( sep, "." );

        filesNeeded[ 0 ] = new File( contextPath + sep + s.getText().getLanguage().getTestcaseFilename() );
        filesNeeded[ 1 ] = new File( contextPath + sep + s.getText().getSubmitFileName() );

        String testcaseFixed;
        String srcFixed;

        try {
            
            srcFixed = PackageFixer.fix(src, newPackage);
            
            if ( !onthefly ) {
                srcFixed = s.getText().getLanguage().getFormatter().format( srcFixed );
                s.setExerciseText(srcFixed);
            }

            testcaseFixed = PackageFixer.fix( s.getText().getTestcase(), newPackage );
            filesNeeded[ 0 ].createNewFile();
            filesNeeded[ 1 ].createNewFile();
            util.Util.writeToFile(filesNeeded[ 0 ], testcaseFixed );
            util.Util.writeToFile(filesNeeded[ 1 ], srcFixed );
        }
        catch( IOException ioe ) {
            return this.newWrongResult( "impossibile copiare file sorgenti", TestError.COMPILER_ERROR );
        }
        catch( Throwable e ) {
            return this.newWrongResult( e.getMessage(), TestError.COMPILER_ERROR );
        }

        try {
            for ( int i = auxFileStartIndex; i < 2 + auxsSize; i++  ) {
                AuxiliarySourceFile aux = ( AuxiliarySourceFile ) auxs.next();
                String auxCodeFixed = aux.getCode();
                if ( aux.isSource() )
                    auxCodeFixed = PackageFixer.fix( aux.getCode(), newPackage );
                
                filesNeeded[ i ] = new File( contextPath + sep + aux.getFilename() );
                filesNeeded[ i ].createNewFile();
                util.Util.writeToFile(filesNeeded[ i ], auxCodeFixed );
            }
        }
        catch( IOException ioe ) {
            return this.newWrongResult( "impossibile copiare file sorgenti", TestError.COMPILER_ERROR );
        }
        catch( Throwable e ) {
            return this.newWrongResult( e.getMessage(), TestError.COMPILER_ERROR );
        }

        JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
        StandardJavaFileManager fileManager = compiler.getStandardFileManager(null, null,  null);
        DiagnosticCollector<JavaFileObject> diagnostics = new DiagnosticCollector<JavaFileObject>();

        List<File> sourceFileList = new ArrayList <File> ();
        sourceFileList.add( filesNeeded[ 0 ] );
        Iterable<? extends JavaFileObject> compilationUnits = fileManager.getJavaFileObjectsFromFiles (sourceFileList);

        final Iterable<String> options = Arrays.asList(
                new String[] {
                    "-classpath",
                    classpath,
                    "-nowarn",
                    "-d" , classpath
                }
        );

        CompilationTask task = compiler.getTask(null, fileManager, diagnostics, options, null, compilationUnits);

        boolean success = task.call();

        errors = new ArrayList();

        Result cr = new Result();

        for (Diagnostic diagnostic : diagnostics.getDiagnostics()) {

            String source = diagnostic.getSource().toString();
            int srcLen = source.length();
            String filename = source.substring( source.lastIndexOf( sep ) + 1, srcLen);
            String error = diagnostic.getMessage(null);
            int filenameIndex = error.lastIndexOf( filename );
            
            if ( filenameIndex != -1 ) {
                String lastpart = error.substring(filenameIndex );
                StringTokenizer tk = new StringTokenizer( lastpart, ":" );
                tk.nextToken(); // linenumber
                tk.nextToken(); // linenumber
                error = "";
                while ( tk.hasMoreTokens() ) error += tk.nextToken();    
            }
            
            if ( onthefly ) {
                TestError te = new TestError();
                te.setCode( diagnostic.getCode() );
                te.setLine( (int)diagnostic.getLineNumber() );
                te.setError( error );
                te.setFile(filename);
                cr.addCompilerError(te);

            } else {
                if ( filename.equals( s.getText().getSubmitFileName() )) {
                    TestError te = new TestError();
                    te.setCode( diagnostic.getCode() );
                    te.setLine( (int)diagnostic.getLineNumber() );
                    te.setError( error );
                    cr.addCompilerError(te);
                }
            }
        }

        cr.setReturnCode( success ? Result.COMPILES_OK : Result.COMPILES_KO );

        return cr;
    }

    @Override
    public Result execute( Submission s ) {

        Result cr = s.getResult();

        List<TestError> l = new ArrayList();
        List<ExecutionError> errors = new ArrayList();

        String sep = System.getProperty( "file.separator" );

            boolean okcompile = ( cr.getReturnCode() == Result.COMPILES_OK );

            if ( !okcompile ) return cr;

            String login = s.getLogin().getLogin();
            String newPackage = this.getCompileDir(false);
            newPackage = newPackage.replace( sep, ".");

            if ( s.getText().isHumanNeeded()) {
                /* creo applet e cancello dir */
                String appletPath = this.getContextPath() + "applets";
                String appletname = newPackage + ".jar";

                String testcasename = s.getText().getLanguage().getTestcaseFilename();
                String classname = testcasename.substring(0 ,  testcasename.lastIndexOf( ".java") );

                cr.setPseudoOk( null );

                boolean appletDone = this.generateAppletStuff( cr, appletname, appletPath, classname, newPackage);

                if ( appletDone ) {
                    return cr;
                }
                else {
                    /* che errore metto qui?? */
                    return this.newWrongResult( "impossibile creare l'applet", TestError.EXEC_ERROR );
                }
            }

            try {

                String testcasename = s.getText().getLanguage().getTestcaseFilename();
                String classname = testcasename.substring(0 ,  testcasename.lastIndexOf( ".java") );

                String execOptions = s.getText().getLanguage().getExecOptions();
                if ( execOptions == null ) execOptions = "";
                
                String newJvmCmd = new String(
                    "java"  + " " +
                    execOptions + " " +
                    "-classpath"  + " " + 
                    getCompilePath()  + " " +
                    "rmi.remote.ExecTestProcess"  + " " +
                    newPackage  + " " +
                    classname  + " " +
                    String.valueOf( s.getText().canExecuteIO() )  + " " +
                    String.valueOf( s.getText().canExecuteThread() )  + " " +
                    String.valueOf( s.getText().canExecuteSocket() )  + " " +
                    String.valueOf( s.getText().canExecuteSocketServer() )  + " " +
                    String.valueOf( s.getText().getTimeout() ) 
                );

                Runtime rt = Runtime.getRuntime();

                final Process testProcess;

                try {
                    testProcess = rt.exec(
                            newJvmCmd,
                            null,
                            new File( getCompilePath() + getCompileDir( false ) )
                    );
                } catch (Exception ex) {
                    return this.newWrongResult( "impossibile eseguire la seconda JVM", TestError.EXEC_ERROR );
                }

                try {

                    int attempts = 0;
                    boolean done = false;
                    rmi.RemoteTester tester = null;

                    while ( !done && attempts < RMI_CONNECT_MAX_ATTEMPTS  ) {
                        try {
                            Thread.sleep( RMI_CONNECT_DELAY );
                            tester =
                                    (rmi.RemoteTester) Naming.lookup(
                                    "rmi://localhost:"+rmi.remote.ExecTestProcess.REGISTRY_PORT+"/ExecTestProcess_" + newPackage
                            );
                            done = true;
                        }
                        catch( Exception e ) {
                            attempts++;
                        }
                    }

                    if ( attempts == RMI_CONNECT_MAX_ATTEMPTS ) {
                        /* errore connessione */
                        throw new Exception( "Impossibile stabilire la connessione con la seconda JVM" );
                    }

                    if ( tester != null )  {
                        /* eseguo il metodo remoto e sto in attesa*/
                        errors = tester.execute();
                    }
                    else {
                        throw new Exception( "Impossibile eseguire metodo remoto su seconda JVM" );
                    }

                }
                catch (Exception e ) {
                    /* gestire errore rmi */
                    TestError te = new TestError();
                    te.setCode( "-1" );
                    te.setError( "Test non effettuato: " + e.getMessage() );
                    l.add(te);
                }
                /* alla fine lo uccido */
                testProcess.destroy();


        } catch (Exception e) {
            TestError te = new TestError();
            te.setCode( "-1" );
            te.setLine( 0 );
            te.setError( "Generic Exception occured: " + e );
            l.add(te);
        }


        /* sistemo gli errori di esecuzione */
        s.getText().getLanguage().getCodeAnalizer().fixExecutionError(
                s.getExerciseText(),
                s.getText().getSubmitFileName(),
                errors
        );

        for ( ExecutionError ee : errors )
            cr.addExecError( ee.getTestError() );

        for ( TestError te : l )
            cr.addExecError( te );

        cr.setSeenByUser( false );

        if ( cr.getExecErrors().isEmpty() ) {
            cr.setReturnCode( Result.EXECUTES_OK );
        } else {
            cr.setReturnCode( Result.EXECUTES_KO );
        }

        return cr;
    }

    @Override
    public void voidResult( Submission s) {
        /* per il linguaggio java devo cancellare gli applet */
        Result cr = s.getResult();
        if ( !s.getText().isHumanNeeded() ) return;

        String sep = System.getProperty( "file.separator" );
        String extrainfo = cr.getExtraInfo();

        StringTokenizer tokenizer = new StringTokenizer( extrainfo, ";" );

        String appletname = tokenizer.nextToken();
        String keystore = tokenizer.nextToken();

        String appletPath = this.getContextPath() + "applets";

        /* cancello l'applet e keystore */
        try {
            new File( appletPath  + sep + appletname ).delete();
            new File( appletPath  + sep + keystore ).delete();
        } catch( Exception e ) {

        }
    }
}
