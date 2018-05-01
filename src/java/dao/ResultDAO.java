/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package dao;

/**
 *
 * @author Dax
 */
public class ResultDAO extends DAO {
    private static ResultDAO instance = null;
    
    private ResultDAO() {
        super( model.Result.class );
    }
    
    public static ResultDAO getInstance() {
        return instance == null ? instance = new ResultDAO() : instance;
    }
}
