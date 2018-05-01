/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package dao;

import java.util.List;
import model.*;
import org.hibernate.HibernateException;
import org.hibernate.Query;

/**
 *
 * @author Dax
 */
public class StudentDAO extends UserDAO {

    private static StudentDAO instance = null;

    private StudentDAO() {
        super( model.Student.class );
    }

    public static StudentDAO getInstance() {
        return instance == null ? instance = new StudentDAO() : instance;
    }


    public List getTODOAssignments( Student stud ) {
        AcademicYear currentAA = getLastAA();
        List list = null;
        try {
            /* todo: trova che query ( in hsql ) mettere */
            Query query = getSession().createQuery("select ass from Assignment as ass" +
                                                " where exists( from Assignment a, Text t, Submission s " +
                                                                "where a.course = ass.course and " +
                                                                "t.assignment = a  and " +
                                                                "a <> ass and " +
                                                                " s.text = t and s.login = :stud ) and "+
                                                " ass.startTime < now() and " +
                                                 " ass.deadline > now() and " +
                                                 " ass.course.academicYear = :aa and " +
                                                 " ( select count(*) from Text t where t.assignment = ass ) > ( select count(*) from Text t, Submission s " +
                                                                " where s.text = t and " +
                                                                " s.login = :stud and " +
                                                                "t.assignment = ass " +
                                                   ") "
                                                 );

            query.setParameter( "stud", stud );
            query.setParameter( "aa", currentAA );
            list = query.list();
        } catch (HibernateException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List getLastSubmitted( Student stud ) {
        AcademicYear currentAA = getLastAA();
        List list = null;
        try {
            Query query = getSession().createQuery("select distinct ass from Course c, Assignment as ass, Text t, Submission s " +
                                                "where c = ass.course and t.assignment = ass and" +
                                                 " t = s.text and ass.startTime < now() and " +
                                                 " ass.deadline > now() and " +
                                                 " c.academicYear = :aa and " +
                                                 "s.login = :stud"
                                                 );
            query.setParameter( "stud", stud );
            query.setParameter( "aa", currentAA );
            list = query.list();
        } catch (HibernateException e) {
            e.printStackTrace();
        }
        return list;
    }


    public List getLastResults( Student stud ) {
        List list = null;
        try {
            Query query = getSession().createQuery("select distinct ass from Submission as sub, Text t, Assignment as ass, Result c " +
                                                "where sub.login = :stud and " +
                                                " sub.text = t and " +
                                                " ass = t.assignment and " +
                                                "sub.result = c and " +
                                                " c.seenByUser = 'false' "
                                                 );
            query.setParameter( "stud", stud );
            list = query.list();
        } catch (HibernateException e) {
            e.printStackTrace();
        }
        return list;
    }
}
