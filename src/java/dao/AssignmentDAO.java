/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package dao;

/**
 *
 * @author Dax
 */
public class AssignmentDAO extends DAO {
    private static AssignmentDAO instance = null;

    private AssignmentDAO() {
        super(model.Assignment.class);
    }

    public static AssignmentDAO getInstance() {
        return instance == null ? instance = new AssignmentDAO() : instance;
    }
}
