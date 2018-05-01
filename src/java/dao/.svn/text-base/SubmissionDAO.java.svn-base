/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package dao;

/**
 *
 * @author Dax
 */
public class SubmissionDAO extends DAO {
    
    private static SubmissionDAO instance = null;
    
    private SubmissionDAO() {
        super( model.Submission.class );
    }
    
    public static SubmissionDAO getInstance() {
        return instance == null ? instance = new SubmissionDAO() : instance;
    }

}
