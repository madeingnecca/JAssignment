/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package dao;

/**
 *
 * @author Dax
 */
public class CourseDAO extends DAO {
    
    private static CourseDAO instance = null;
    
    private CourseDAO() {
        super( model.Course.class );
    }
    
    public static CourseDAO getInstance() {
        return instance == null ? instance = new CourseDAO() : instance; 
    }
}
