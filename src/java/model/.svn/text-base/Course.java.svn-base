package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;


public class Course implements Serializable {
    
    private int                 id;
    private String              name;
    private AcademicYear        academicYear;
    
    private List                assignments = new ArrayList();
    //private Set                 admins = new HashSet();
    
    
    public Course() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public AcademicYear getAcademicYear() {
        return academicYear;
    }

    public void setAcademicYear(AcademicYear academicYear) {
        this.academicYear = academicYear;
    }

    public List getAssignments() {
        return assignments;
    }

    public void setAssignments(List assignments) {
        this.assignments = assignments;
    }

    public void addAssignment( Assignment a ) {
        /* la inserisco come prima esercitazione disponibile */
        this.getAssignments().add( 0, a );
        a.setCourse( this );
    }

    public void removeAssignment( Assignment a ) {
        this.getAssignments().remove(a);
    }
    
    public boolean equals( Object o ) {
        if ( o == null ) return false;
        
        try {
            Course c = ( Course ) o;
            return c.getId() == this.getId();
        }
        catch ( ClassCastException e ) {
            return false;
        }
    }
    
    public String getNameWithAY() {
        return this.getName() + this.getAcademicYear().getAbbreviateForm();
    }
}
