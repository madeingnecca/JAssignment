package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class Assignment implements Serializable {
    
    /* stati assignment:
     VV: verde - verde: posso ancora modificare l'assignment
     RV: rosso - verde: posso solamente vedere l'assignment
     RR: rosso - rosso: posso vedere l'assignment, le consegne e i risultati
     */
    public static final int             STATE_VV = 1;
    public static final int             STATE_RV = 2;
    public static final int             STATE_RR = 3;
    
    private int         id;
    private Course      course;
    private String      title;
    private Date        startTime;
    private Date        deadline;
    private List        submissions = new ArrayList();
    private List        texts  = new ArrayList();
    private Boolean     corrected;
    
    public Assignment( 
                        Course c,
                        int n,
                        String t,
                        Date s,
                        Date d,
                        int e ) {
        
        course = c;
        title = t;
        startTime = s;
        deadline = d;
    }

    public Assignment() {
        
    }
    
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Course getCourse() {
        return course;
    }

    public void setCourse(Course course) {
        this.course = course;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public Date getStartTime() {
        return startTime;
    }

    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    public Date getDeadline() {
        return deadline;
    }

    public void setDeadline(Date deadline) {
        this.deadline = deadline;
    }

    public List getTexts() {
        return texts;
    }

    public void setTexts(List texts) {
        this.texts = texts;
    }

    public List getSubmissions() {
        return submissions;
    }

    public void setSubmissions(List submissions) {
        this.submissions = submissions;
    }

    public Boolean isCorrected() {
        return corrected;
    }

    public void setCorrected(Boolean corrected) {
        this.corrected = corrected;
    }
    
    public boolean equals(Object o) {
        if (o == null) {
            return false;
        }
        try {
            Assignment oa = (Assignment) o;
            return oa.getId() == this.getId();
        } catch (ClassCastException e) {
            return false;
        }
    }  
    
    public void addText( Text t ) {
        t.setAssignment(this);
        this.getTexts().add(t);
    }
    
    public void removeText( Text text ) {
        int ordinal = text.getOrdinal();
        List allTexts = this.getTexts();
        allTexts.remove( ordinal - 1 );
        int size = allTexts.size();
        
        for ( int i = 0; i < size; i++ ) {
            Text t = ( Text ) allTexts.get(i);
            if ( t.getOrdinal() > ordinal ) {
                t.setOrdinal( t.getOrdinal() - 1 );
            }
        }
    }
    
    public static int getState( Date start, Date end ) {
        int astate = STATE_RR;
        Date today = new Date();
        
        if ( start == null ) {
            if (today.compareTo( end ) > 0) return STATE_RR;
            else return STATE_VV;
        }
        
        if (today.compareTo( start ) < 0) {
            astate = STATE_VV;
        } else if (today.compareTo( end ) < 0) {
            astate = STATE_RV;
        }
        return astate;   
    }
    
    public static int getState( Assignment a ) {
       return getState( a.getStartTime(), a.getDeadline() );
    }
    
    public static boolean canEdit( int state ) {
        return state == STATE_VV || state == STATE_RV;
    }
    
    public static boolean canDeleteOrAdd( int state) {
        return state == STATE_VV;
    }
    
    public static boolean isOpen( int state) {
        return state == STATE_RV;
    }
    
    public static boolean isClosed( int state) {
        return state == STATE_RR;
    }      
}
