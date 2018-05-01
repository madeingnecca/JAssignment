/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Dax
 */
public class AcademicYear implements Serializable {
    
    private int id;
    private int firstYear;
    private int secondYear;
    
    private List courses = new ArrayList();
    
    public AcademicYear() {}

    public int getFirstYear() {
        return firstYear;
    }

    public void setFirstYear(int firstYear) {
        this.firstYear = firstYear;
    }

    public int getSecondYear() {
        return secondYear;
    }

    public void setSecondYear(int secondYear) {
        this.secondYear = secondYear;
    }

    public List getCourses() {
        return courses;
    }

    public void setCourses(List courses) {
        this.courses = courses;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
    
    public void addCourse( Course c ) {
        courses.add( c );
        c.setAcademicYear( this );
    }
    
    public void removeCourse( Course c ) {
        courses.remove( c );
    }
    
    public String getAbbreviateForm() {
        String strFirstYear = String.valueOf( getFirstYear() );
        String strSecondYear = String.valueOf( getSecondYear() );
        strFirstYear = strFirstYear.substring( strFirstYear.length() - 2);
        strSecondYear = strSecondYear.substring( strSecondYear.length() - 2);
        return strFirstYear + strSecondYear;
    }
   
    public String getCompleteForm() {
        String strFirstYear = String.valueOf( getFirstYear() );
        String strSecondYear = String.valueOf( getSecondYear() );    
        return strFirstYear + "/" + strSecondYear;
    }
    
    public AcademicYear getNext() {
        AcademicYear next = new AcademicYear();
        next.setFirstYear( this.firstYear + 1 );
        next.setSecondYear( this.secondYear + 1 );
        return next;
    }
    
    public boolean equals( Object o ) {
        
        if ( o == null ) return false;
        
        if ( this == o ) return true;
        
        try {
            AcademicYear ay = ( AcademicYear ) o;
            return ay.getId() == this.getId();
        }
        catch ( ClassCastException e ) {
            return false;
        }
   
    }
}
