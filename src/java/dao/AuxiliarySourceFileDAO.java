/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package dao;

import java.util.ArrayList;
import java.util.List;
import model.*;
import org.hibernate.HibernateException;
import org.hibernate.Query;

/**
 *
 * @author Dax
 */
public class AuxiliarySourceFileDAO extends UserDAO {

    private static AuxiliarySourceFileDAO instance = null;

    private AuxiliarySourceFileDAO() {
        super( model.AuxiliarySourceFile.class );
    }

    public static AuxiliarySourceFileDAO getInstance() {
        return instance == null ? instance = new AuxiliarySourceFileDAO() : instance;
    }

    public List getAvailableAuxiliaryFiles(Text t) {
        List list = null;
        Assignment a = t.getAssignment();
        Language l = t.getLanguage();
        Query q = getSession().createQuery(
                "select distinct aux " +
                "from Assignment a, Text t join t.auxfiles as aux" +
                " where a = :assign and t.language = :lang and t.assignment = a" );
        q.setParameter( "assign", a);
        q.setParameter( "lang", l);
        list = q.list();
        if ( list == null ) list = new ArrayList();
        return list;
    }
}
