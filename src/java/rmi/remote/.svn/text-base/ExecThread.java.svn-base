/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package rmi.remote;

import test.*;
import java.util.Timer;
import java.util.TimerTask;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.test.TestError;



public class ExecThread extends Thread {
    
    
    public static StackTraceElement getStackTrace( StackTraceElement[] stack, String classname ) {

        if ( classname == null ) return null;
        
        try {
            for ( int i = 0; i < stack.length; i++ )
                if ( stack[ i ].getClassName().contains( classname ) )
                    return stack[ i ];
        }
        catch ( Exception e ) {
            return null;
        }

        return null;
    }
    
    private StackTraceElement getStackTraceWithTest( StackTraceElement[] stack ) { 
        return getStackTrace( stack,ctc.getClass().getPackage().getName() );       
    }
    
    private ClassicTestCase ctc;
    
    public ExecThread( ClassicTestCase parent ) {
        ctc = parent;
    }
    
    @Override
    public void run() {
        try {
            ctc.test();
        } catch (ThreadDeath e) {
            /* controllare che metodo ha dato fastidio */
            StackTraceElement[] stack = e.getStackTrace();
            StackTraceElement last = getStackTraceWithTest( stack );
            int line = last == null ? TestError.NO_LINE : last.getLineNumber();
            ctc.raiseError("ciclo_inf", line, "Tempo massimo di esecuzione raggiunto, probabile ciclo infinito" );
        } 
        catch ( SecurityException e ) {
            /* HACK: per consentire il catch delle eccezioni nei sottothread guardo le eccezioni memorizzate sul security manager*/
        } catch ( RuntimeException e ) {
            /* controllare che metodo ha dato fastidio */
            StackTraceElement[] stack = e.getStackTrace();
            StackTraceElement last = getStackTraceWithTest( stack );
            int line = last == null ? TestError.NO_LINE : last.getLineNumber();
            ctc.raiseError("runtime_error", line, "Errore runtime" );
        }
        catch ( Exception e ) {
            /* controllare che metodo ha dato fastidio */
            StackTraceElement[] stack = e.getStackTrace();
            StackTraceElement last = getStackTraceWithTest( stack );
            int line = last == null ? TestError.NO_LINE : last.getLineNumber();
            ctc.raiseError( "unknown_error", line, "Errore sconosciuto" );
        }
    }
}
