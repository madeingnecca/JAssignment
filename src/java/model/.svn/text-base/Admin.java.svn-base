package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;


public class Admin extends User {

    private static final int        MAX_PASS_CHARS = 6;
    private boolean                 superUser;
    private Set                     courses = new HashSet();


    public Admin() {
        super();
        superUser = false;
    }

    public Admin( String l, String p, boolean su ) {
        super( l, p );
        superUser = su;
    }

    void setSuperUser(boolean superUser) {
        this.superUser = superUser;
    }

    public boolean isSuperUser() {
        return superUser;
    }

    public List getOpenAssignments() {
        return null;
    }

    public Set getCourses() {
        return courses;
    }

    public List getSubmissions() {
        return null;
    }

    public boolean addPriviledge( Admin a, Course c ) {
        if ( this.superUser ) {
            a.addCourse( c );
            return true;
        }
        return false;
    }

    public boolean addAllPriviledges( Admin a ) {
        if ( this.superUser ) {
            a.setSuperUser( true );
            return true;
        }
        return false;
    }

    public boolean revokePriviledge( Admin a, Course c ) {
        if ( this.superUser) {
            a.removeCourse( c );
            //c.removeAdmin( a );
            return true;
        }
        return false;
    }

    public boolean revokeAllPriviledges( Admin a ) {
        if ( this.superUser ) {
            a.getCourses().removeAll( a.getCourses() );
            return true;
        }
        return false;
    }

    void addCourse( Course c ) {
        courses.add( c );
        //c.addAdmin( this );
    }

    void removeCourse( Course c ) {
        courses.remove( c );
        //c.removeAdmin( this );
    }

    public void setCourses(Set courses) {
        this.courses = courses;
    }

    public void submitForStudent( Student stu, Submission sub ) {
        stu.submit( sub );
    }

    public static String generatePassword() {
        String result = "";

        for ( int i = 0; i < MAX_PASS_CHARS; i++) {
            result += ( char ) ( (( int ) 26*Math.random()) + 'a' );
        }

        return result;
    }

    public static void main( String[] args ) {
        System.out.println( Admin.generatePassword() );
    }


}
