/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller.threads;

import controller.servlets.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.*;

public class TestThread extends Thread {

    private Integer                         slot = null;
    private int                             percentage = 0;
    private String                          appContext = null;
    private int                             mode;
    private Assignment                      assignment;
    private Submission                      currentSubmission;
    private Exception                       exception;

    private List<Submission>             submissions = new ArrayList();

    public void setSlot( int s ) {
        slot =  s;
    }

    public Integer getSlot() {
        return slot;
    }

    public TestThread( String ac, int m, Assignment a ) {
        appContext = ac;
        mode = TestServlet.MODE_ASSIGNMENT;
        assignment = a;
    }

    public TestThread( String ac, Submission s ) {
        appContext = ac;
        mode = TestServlet.MODE_SOURCE;
        assignment = s.getText().getAssignment();
        currentSubmission = s;
    }

    public String getApplicationContext() {
        return appContext;
    }


    public void run() {

        try
        {
            if ( mode == TestServlet.MODE_ASSIGNMENT ) {
                List<Text> texts = getAssignment().getTexts();
                List<Student> submitters = dao.AdminDAO.getInstance().getSubmitters(getAssignment());

                int textsSize = texts.size();
                int submSize = submitters.size();
                int totalSize  = textsSize * submSize;
                int z = 0;

                if ( totalSize == 0 ) this.setPercentage( 100 );

                for ( Student submitter : submitters ) {

                    for ( Text currentText : texts ) {

                        Submission submission = (Submission) submitter.getSubmissions().get( currentText );

                        if ( submission != null ) {
                            /* passo con la correzione */
                            Language textLanguage = currentText.getLanguage();
                            textLanguage.initDirs( false );
                            Result cr = textLanguage.compile(submission, false);
                            submission.setResult( cr );
                            cr = textLanguage.execute( submission );
                            textLanguage.removeBuild( false );
                            if ( cr != null ) addSubmission( submission );
                        }

                        /* avanzamento della percentuale */
                        z++;
                        double zdouble = ( double ) z;
                        double totalSizeDouble = ( double ) totalSize;
                        this.setPercentage( ( int ) ( ( zdouble / totalSizeDouble ) * 100 ) );
                    }
                }
            }
            else {
                Language lang = currentSubmission.getText().getLanguage();
                lang.initDirs( true );
                Result cr = lang.compile(currentSubmission, true);
                lang.removeBuild( true );
                currentSubmission.setResult(cr);
                addSubmission( currentSubmission );
            }
        }
        catch( Exception e ) {
            setException( e );
        }

    }


    public synchronized int getPercentage() {
        return this.percentage;
    }

    synchronized void setPercentage( int p ) {
        percentage = p;
    }

    public void addSubmission( Submission s) {
        submissions.add( s );
    }

    public Assignment getAssignment() {
        return assignment;
    }

    public List<Submission> getSubmissions() {
        return submissions;
    }

    public synchronized Exception getException() {
        return exception;
    }

    synchronized void setException(Exception exception) {
        this.exception = exception;
    }


}
