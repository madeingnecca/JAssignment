/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package dao;

import java.util.List;
import model.Assignment;
import model.Course;
import model.Student;
import model.Text;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Transaction;


public class AdminDAO extends UserDAO {
    
    private static AdminDAO instance = null;
    
    private AdminDAO() {
        super( model.Admin.class );
    }
    
    public static AdminDAO getInstance() {
        return instance == null ? instance = new AdminDAO() : instance;
    }
    
    public List getAllStudents() {
        List list = null;
        try {
            Query query = session.createQuery("from Student");
            list = query.list();
        } catch (HibernateException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List getAllCourses() {
        List list = null;
        try {
            Query query = session.createQuery("select corso from Course as corso, AcademicYear anno where anno.id = corso.academicYear order by corso.name, anno.secondYear desc");
            list = query.list();
        } catch (HibernateException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    public List getAllAdmins() {
        List list = null;
        try {
            Query query = session.createQuery("from Admin a where a.superUser = 'false'");
            list = query.list();
        } catch (HibernateException e) {
            e.printStackTrace();
        }
        return list;    
    }
    
    public List getSubmitters( Assignment a ) {
        Transaction tx = getSession().beginTransaction();
        List students = null;
        try {
            String hsql = "select distinct stud from Student as stud , Assignment a,Submission s, Text t where a = t.assignment and stud = s.login and a.id = " + a.getId() + " and s.text = t order by stud.cognome, stud.nome";
            Query query = getSession().createQuery( hsql );
            students = query.list();
            tx.commit();
        } catch (HibernateException e) {
            e.printStackTrace();
        }
        return students;
    }
 
    public List getSubmitters( Text t ) {
        List students = null;
        try {
            String hsql = "select distinct stud from Student as stud , Assignment a,Submission s, Text t " +
                            "where a = t.assignment and " +
                            "stud = s.login and a.id = " + t.getAssignment().getId() + " " +
                            "and s.text = t and t.ordinal = " + t.getOrdinal() +
                            " order by stud.cognome, stud.nome";
            Query query = getSession().createQuery( hsql );
            students = query.list();
        } catch (HibernateException e) {
            e.printStackTrace();
        }
        return students;
    }
    
    public List getStudentsOfCourse( Student tosearch, Course c ) {
        List students = null;
        try {
            String hsql = "select distinct stud from Student as stud, Submission as sub , Course c, Assignment a, Text t where a.course = c and a = t.assignment and stud = sub.login and c.id = " + c.getId() + " and sub.text = t";
            if ( tosearch.getMatricola() != null ) 
                hsql += " and stud.matricola = " + tosearch.getMatricola();
            if ( !tosearch.getCognome().equals( "" )) 
                hsql += " and upper(stud.cognome) = '" + tosearch.getCognome().toUpperCase()+"'";
            if ( !tosearch.getNome().equals( "" )) 
                hsql += " and upper(stud.nome) = '" + tosearch.getNome().toUpperCase()+"'";  
            Query query = getSession().createQuery(hsql);
            students = query.list();
        } catch (HibernateException e) {
            e.printStackTrace();
        }
        return students;
    }
    
    
    /* todo: scoprire le altre funzionalita' dell'admin!! */

}
