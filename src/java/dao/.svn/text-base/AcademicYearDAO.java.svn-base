/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package dao;

/**
 *
 * @author Dax
 */
public class AcademicYearDAO extends DAO {
    
    private static AcademicYearDAO instance = null;
    
    private AcademicYearDAO() {
        super( model.AcademicYear.class );
    }
    
    public static AcademicYearDAO getInstance() {
        return instance == null ? instance = new AcademicYearDAO() : instance;
    }
}
