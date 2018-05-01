/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package languages;

import model.*;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.Serializable;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;
import java.util.StringTokenizer;
import java.util.Timer;
import java.util.TimerTask;
import model.test.ExecutionError;
import model.test.TestError;
import util.Util;

/**
 *
 * @author Dax
 */
public class CeeLanguage extends Language implements Serializable {

    private static final String BIN_FILE_NAME = "test.o";

    private static final int    MAX_SIG = 128; /* max valore ritornabile da programma */
    private static final int    PROCESS_NOT_EXITED = -1; /* codice ritorno se viene fatto il destroy del processo */
    private static final int    SIGSEGV = 11; /* codice ritorno seg. fault */
    private static final int    SIGFPE = 8; /* codice ritorno errore runtime */
    private static final int    PERMISSION_DENIED = 126;
    private static final int    EXIT_SUCCESS = 0;

    public CeeLanguage() {
    }

    @Override
    public Result compile(Submission s , boolean onTheFly) {

        Result cr = new Result();

        String sep = System.getProperty( "file.separator" );

        String classpath = getCompilePath();
        String contextPath = getCompilePath();

        List errors = null;

        String src = s.getExerciseText();
        String login = s.getLogin().getLogin();
        String newPackage = this.getCompileDir( onTheFly );

        Collection auxfiles = s.getText().getAuxfiles();
        Iterator auxs = auxfiles.iterator();

        int auxsSize = auxfiles.size();
        File[] filesNeeded = new File[ 2 + auxsSize ];
        int auxFileStartIndex = 2;

        contextPath += newPackage;
        File dirs = new File( contextPath );
        dirs.mkdirs();

        filesNeeded[ 0 ] = new File( contextPath + sep + s.getText().getLanguage().getTestcaseFilename() );
        filesNeeded[ 1 ] = new File( contextPath + sep + s.getText().getSubmitFileName() );

        try {
            if ( !s.getText().isHumanNeeded() ) {
                filesNeeded[ 0 ].createNewFile();
                util.Util.writeToFile(filesNeeded[ 0 ], s.getText().getTestcase() );
            }
            filesNeeded[ 1 ].createNewFile();
            util.Util.writeToFile(filesNeeded[ 1 ], src );
        }
        catch( IOException ioe ) {
            StringWriter sw = new StringWriter();
            ioe.printStackTrace( new PrintWriter( sw ) );
            return newWrongResult( sw.toString() , TestError.COMPILER_ERROR );
        }

        try {
            for ( int i = auxFileStartIndex; i < 2 + auxsSize; i++  ) {
                AuxiliarySourceFile aux = ( AuxiliarySourceFile ) auxs.next();
                filesNeeded[ i ] = new File( contextPath + sep + aux.getFilename() );
                filesNeeded[ i ].createNewFile();
                util.Util.writeToFile(filesNeeded[ i ], aux.getCode() );
            }
        }
        catch( IOException ioe ) {
            StringWriter sw = new StringWriter();
            ioe.printStackTrace( new PrintWriter( sw ) );
            return newWrongResult( sw.toString() , TestError.COMPILER_ERROR );
        }

        /* compilazione file */

        String gccCommand;


        String fileToCompile = s.getText().getLanguage().getTestcaseFilename();

        if ( s.getText().isHumanNeeded() ) {
            /* e' un programma completo, significa che devo compilare la consegna invece del file di test*/
            fileToCompile = s.getText().getSubmitFileName();
        }

        String compOptions = s.getText().getLanguage().getCompileOptions();
        if ( compOptions == null )
            compOptions = "";

        gccCommand = new String (
            "gcc" + " " +
            "-w" + " " + /* opzione obbligatoria, no warning */
            compOptions + " " +
            fileToCompile + " " +
            "-o" + " " + /* opzione obbligatoria, settaggio nome file output*/
            BIN_FILE_NAME
        );

        Process gccProcess;

        try {
            gccProcess = Runtime.getRuntime().exec(
                    gccCommand,
                    null,
                    new File( contextPath ));

            gccProcess.waitFor();

        } catch (Exception ex) {

            /* todo: sarebbe da far salire gli errori e farli vedere all'amministratore.. */
            StringWriter sw = new StringWriter();
            ex.printStackTrace( new PrintWriter( sw ) );
            return newWrongResult( sw.toString() , TestError.COMPILER_ERROR );
        }

        InputStream is = gccProcess.getErrorStream();
        BufferedReader br = new BufferedReader( new InputStreamReader( is ) );

        List<TestError> l = new ArrayList<TestError>();

        boolean success = false;
        String line = "";

        try {
            success = getCompileErrors(l, br, s.getText().getSubmitFileName(), onTheFly );
            line = br.readLine();

        } catch (Exception ex) {
            /* todo: sarebbe da far salire gli errori e farli vedere all'amministratore.. */
            StringWriter sw = new StringWriter();
            ex.printStackTrace( new PrintWriter( sw ) );
            return newWrongResult( sw.toString() , TestError.COMPILER_ERROR );
        }

        for ( TestError te : l ) {
            cr.addCompilerError(te);
        }

        cr.setReturnCode( success ? Result.COMPILES_OK : Result.COMPILES_KO );

        return cr;

    }

    private static boolean getCompileErrors( List<TestError> l, BufferedReader errorStream, String filename, boolean onthefly ) throws Exception {

        String line = null;
        String output = "";
        line = errorStream.readLine();
        boolean compiles = ( line == null );
        while ( line != null ) {
            TestError te = getCompileError( filename, line, onthefly );

            if ( te != null ) l.add(te);
            line = errorStream.readLine();
        }
        return compiles;
    }

    /* parsa una stringa del tipo filename:linea:tipo:errore*/

    private static model.test.TestError getCompileError( String textFilename, String errorline, boolean onthefly ) {
        model.test.TestError te = null;

        StringTokenizer tokenizer = new StringTokenizer( errorline, ":" );

        String error = "";
        String filename = null;
        int lineno = -1;

        try {
            filename = tokenizer.nextToken();
            String strLineno = tokenizer.nextToken();
            lineno = Integer.parseInt(strLineno);
        }
        catch ( NumberFormatException nfe ) {}
        catch ( Exception e ) {
            return te;
        }

        /* se arrivo qui, filename e lineno sono 'validi'*/

        if ( onthefly ) {
                if ( !tokenizer.hasMoreElements() ) return te;
                
                /* hack: salto il token successivo, indica solamente se si tratta di error o di warning */
                tokenizer.nextToken();
                
                while ( tokenizer.hasMoreElements() ) {
                    error += tokenizer.nextToken().trim();
                }
                te = new TestError();
                te.setCode( "");
                te.setLine(lineno);
                te.setError(error);
                te.setFile(filename);
        }
        else {
            if ( textFilename.equals( filename ) ) {

                /* hack: salto il token successivo, indica solamente se si tratta di error o di warning */
                tokenizer.nextToken();

                while ( tokenizer.hasMoreElements() ) {
                    error += tokenizer.nextToken().trim();
                }
                te = new TestError();
                te.setCode( "");
                te.setLine(lineno);
                te.setError(error);
            }
        }

        return te;
    }


    @Override
    public Result execute( Submission s ) {

        Result cr = s.getResult();
        boolean okcompile = cr.getReturnCode() == Result.COMPILES_OK;

        if ( !okcompile ) return cr;

        List<TestError> l = new ArrayList();
        List<ExecutionError> errors = new ArrayList();

        String contextPath = getCompilePath();
        String sep = System.getProperty( "file.separator" );

        String login = s.getLogin().getLogin();
        String newPackage = this.getCompileDir( false );
        
        String execOutput = "";

        final Process testProcess;

        String execOptions = s.getText().getLanguage().getExecOptions();
        if ( execOptions == null )
            execOptions = "";

        String testCommand = new String (
                    "./" + BIN_FILE_NAME + " " +
                    execOptions
        );

        int testExitValue;
        contextPath += newPackage;
        try {
            testProcess = Runtime.getRuntime().exec(
                    testCommand,
                    null,
                    new File( contextPath ));

            Timer timer = new Timer(true);

            final List<ExecutionError> exceptionErrors = new ArrayList<ExecutionError>();

            Thread t = new Thread() {

                public void run() {
                    try {
                        testProcess.waitFor();
                    }
                    catch (ThreadDeath e) {
                        exceptionErrors.add( new ExecutionError(
                                        "",
                                        "ciclo_inf",
                                        "Tempo massimo di esecuzione raggiunto, probabile ciclo infinito",
                                        false
                                    )
                        );
                        testProcess.destroy();
                    }
                    catch( Exception e ) {
                        /* altre eccezioni */

                    }

                }
            };

            timer.schedule( new TimeOutTask( t ), s.getText().getTimeout() * 1000 );
            t.start();
            t.join();
            
            try {
                testExitValue = testProcess.exitValue();
            } catch ( Exception e ) {
                /* nel caso in cui io faccia il destroy, il processo non ritorna alcun valore */
                testExitValue = PROCESS_NOT_EXITED;
            }

            if ( testExitValue != PROCESS_NOT_EXITED ) {

                if (testExitValue == MAX_SIG + SIGSEGV) {
                    exceptionErrors.add(new ExecutionError(
                            "",
                            "seg_fault",
                            "Segmentation fault",
                            false 
                    ));
                } else if (testExitValue == MAX_SIG + SIGFPE) {
                    exceptionErrors.add(new ExecutionError(
                            "",
                            "runtime_error",
                            "Errore runtime (probabile divisione per zero)",
                            false
                   ));

                } else if (testExitValue == PERMISSION_DENIED) {
                    exceptionErrors.add(new ExecutionError(
                            "",
                            "sec_error",
                            "Processo bloccato per ragioni di sicurezza",
                            false
                    ));
                }

            }

            boolean humanNeeded = s.getText().isHumanNeeded();

            if ( exceptionErrors.size() != 0 ) {
                /* sistemo gli errori di esecuzione */
                s.getText().getLanguage().getCodeAnalizer().fixExecutionError(
                        s.getExerciseText(),
                        s.getText().getSubmitFileName(),
                        errors
                );

                for ( ExecutionError ee : exceptionErrors ) {
                    cr.addExecError( ee.getTestError() );
                }

                cr.setReturnCode( Result.EXECUTES_KO );
                return cr;
            }
            else {

                boolean noErrors =  ( testExitValue == EXIT_SUCCESS );
                
                if ( humanNeeded ) {
                    String output = "";
                    // voglio vedere l'output del programma ( dato da printf( "..." ) )
                    try {
                        output = getOutputFromReader(
                                    new BufferedReader(
                                    new InputStreamReader(
                                    testProcess.getInputStream() ) ) );
                    }
                    catch ( Exception e ) {}
                    output = output.replace( "\\n", "\n");
                    
                    cr.setTestStdOut( "<div class=\"code\">" + Util.stringToHTMLString( output ) + "</div>");
                }
                else {
                    if ( !noErrors ) {
                    // voglio vedere gli errori del programma ( dati da fprintf( stderr, "..." ) )
                        errors = this.getExecutionErrors(
                                        new BufferedReader(
                                        new InputStreamReader(
                                        testProcess.getErrorStream() ) ) );

                        /* sistemo gli errori di esecuzione */
                        s.getText().getLanguage().getCodeAnalizer().fixExecutionError(
                                s.getExerciseText(),
                                s.getText().getSubmitFileName(),
                                errors
                        );

                        for ( ExecutionError ee : errors ) {
                            cr.addExecError( ee.getTestError() );
                        }

                        cr.setReturnCode( Result.EXECUTES_KO );
                    }
                    else {
                        cr.setReturnCode( Result.EXECUTES_OK );
                    }
                }
            }

        } catch (Exception ex) {
            StringWriter sw = new StringWriter();
            ex.printStackTrace( new PrintWriter( sw ) );
            return newWrongResult( sw.toString() , TestError.EXEC_ERROR );
        }

        // finalmente posso cancellare il processo
        testProcess.destroy();


        cr.setSeenByUser( false );
        return cr;

    }


    private List<ExecutionError> getExecutionErrors( BufferedReader errorStream ) throws IOException {
        List<ExecutionError> l = new ArrayList<ExecutionError>();

        String line = null;
        String output = "";
        line = errorStream.readLine();

        while ( line != null ) {
            ExecutionError ee = getExecutionError( line );
            line = errorStream.readLine();
            l.add(ee);
        }

        return l;
    }

    private ExecutionError getExecutionError( String toparse ) {

        ExecutionError ee = null;

        StringTokenizer tokenparser = new StringTokenizer( toparse, ":" );

        String methodname = "";
        String code = "";
        String cause = "";

        try {
            methodname = tokenparser.nextToken();
            code = tokenparser.nextToken();
            while ( tokenparser.hasMoreElements() )
                cause += tokenparser.nextToken();

            ee = new ExecutionError( methodname,code,cause,false );
        }
        catch ( Exception e ) {
            return null;
        }

        return ee;
    }

    private String getOutputFromReader( BufferedReader errorStream ) throws Exception {

        String output = "";
        String line = null;
        line = errorStream.readLine();

        while ( line != null )  {
            output += line + '\n';
            line = errorStream.readLine();
        }
        return output;

    }

    class TimeOutTask extends TimerTask {

    Thread t;

    TimeOutTask(Thread t) {
        this.t = t;
    }

    public void run() {
        if (t != null && t.isAlive()) {
            t.stop();
        }
    }
}

    @Override
    public void voidResult(Submission s) {
        /* per il c non devo fare nulla.. */
    }
}
