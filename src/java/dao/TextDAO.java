/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package dao;

import model.Assignment;
import model.Text;
import org.hibernate.Query;
import org.hibernate.Transaction;

/**
 *
 * @author Dax
 */
public class TextDAO extends DAO {
    private static TextDAO instance = null;
    
    private TextDAO() {
        super( model.Text.class );
    }
    
    public static TextDAO getInstance() {
        return instance == null ? instance = new TextDAO() : instance;
    }
    
    /* cancella un Text, aggiornando la lista dei sottoesercizi */
    public boolean deleteText( Text t ) {
        boolean ok = true;
        
        int ordinal = t.getOrdinal();
        Assignment assignment = t.getAssignment();
        
        ok = this.removeRecord( t );
        
        if ( !ok ) return false;
        
        Transaction tx = getSession().beginTransaction();
        String hql = "update Text set ordinal = ordinal - 1 where assignment = :assign and ordinal > " + ordinal;
        Query query = getSession().createQuery( hql );
        query.setParameter( "assign", assignment );
        int updated = query.executeUpdate();
        tx.commit();
        if ( updated == -1 ) return false;

        return true;
    }
}
