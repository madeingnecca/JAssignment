package test;

import java.awt.BorderLayout;
import java.awt.Container;
import java.awt.Frame;
import java.awt.GraphicsEnvironment;
import java.awt.Point;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.io.ByteArrayOutputStream;
import java.io.FilterOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.PrintStream;
import java.util.Date;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JApplet;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;

public abstract class JAppletTestCase extends JApplet implements TestCase {

    public static final int APPLET_WIDTH = 300;
    public static final int APPLET_HEIGHT = 50;
    
    private JFrame console;
    private JTextArea jta;
    private JButton startTest;
    
    public void writeOnConsole( String src ) {
        jta.append( src );
        jta.setCaretPosition(jta.getDocument().getLength());
    }
    
    @Override
    public void init() {
        
        this.setSize(APPLET_WIDTH, APPLET_HEIGHT);
        JPanel jp = new JPanel();
        Container c = this.getContentPane();
        c.setLayout( new BorderLayout() );
        c.add( jp );
        startTest = new JButton( "Inizia test manuale" );
        
        console = new JFrame( "console output" );
        JPanel consolePanel = new JPanel();
        console.add( consolePanel );
        
        jta = new JTextArea();
        jta.setRows( 20 );
        jta.setColumns( 20 );
        jta.setEditable( false );
        JScrollPane scrollPane = new JScrollPane(jta);
        
        PrintStream aPrintStream  =
               new PrintStream(
                 new FilteredStream(
                   new ByteArrayOutputStream()));
        
        System.setOut(aPrintStream);
        System.setErr(aPrintStream);
        consolePanel.add( scrollPane );
        console.setVisible( true );
        console.pack();
        center( console );
                    
        ActionListener al = new ActionListener() {

            @Override
            public void actionPerformed(ActionEvent e) {
                if ( e.getSource() == startTest ) {
                    initJappletTest();
                    test();
                }
            }
            
        };
        startTest.addActionListener(al);
        jp.setLayout( new BorderLayout() );
        jp.setSize( this.getSize() );
        startTest.setSize( this.getSize() );
        jp.add( startTest );
        
        System.setSecurityManager( new test.security.JAppletTestCaseSecurityManager( this ));
    }
    
    @Override
    public abstract void test();
    
    private static void center(JFrame frame) {
            GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
            Point center = ge.getCenterPoint();
            Rectangle bounds = ge.getMaximumWindowBounds();
            int w = frame.getWidth();
            int h = frame.getHeight();
            int x = center.x - w/2, y = center.y - h/2;
            frame.setBounds(x, y, w, h);
            if (w == bounds.width && h == bounds.height)
                frame.setExtendedState(Frame.MAXIMIZED_BOTH);
            frame.validate();
        }

    
    class FilteredStream extends FilterOutputStream {
        public FilteredStream(OutputStream aStream) {
            super(aStream);
        }

        public void write(byte b[]) throws IOException {
            String aString = new String(b);
            writeOnConsole( aString );
        }

        public void write(byte b[], int off, int len) throws IOException {
            String aString = new String(b , off , len);
            writeOnConsole( aString );
        }
        
    }
    
    private void initJappletTest() {
        startTest.setEnabled( false );
        jta.setText("");
        System.out.println( "TEST MANUALE INIZIATO" );
        console.setDefaultCloseOperation( JFrame.DO_NOTHING_ON_CLOSE );
    }
    
    protected void notifyTerminatedTest() {
        startTest.setEnabled( true );
        System.out.println( "TEST MANUALE TERMINATO");
    }
    
    protected void setCloseWindowListener( final JFrame target ) {
        target.setDefaultCloseOperation( JFrame.DO_NOTHING_ON_CLOSE );
        target.addWindowListener( 
                new WindowAdapter() {
                    public void windowClosing( WindowEvent e ) {
                        target.dispose();
                        notifyTerminatedTest();
                    }
                }
        );
    }

    public void destroy() {
        console.dispose();
    }
}



