/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package dao;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import model.*;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.Transaction;

public class LanguageDAO extends UserDAO {

    private static LanguageDAO instance = null;

    private LanguageDAO() {
        super( model.Language.class );
    }

    public static LanguageDAO getInstance() {
        return instance == null ? instance = new LanguageDAO() : instance;
    }

    public Language getDefaultLanguage() {
        Language lang = null;
        try {
            Query q = getSession().createQuery( "select lang from Language as lang where defaultlanguage = 'true'" );
            lang = (Language) q.uniqueResult();
            
            if ( lang == null ) {
                List allLangs = this.getRecords();
                if ( allLangs.size() == 0 ) return null;
                return (Language) allLangs.get( 0 );
            }
        }
        catch( Exception e ) {

        }
        return lang;
    }

    public Language createLanguage( String ext,
                                   String formatter,
                                   String testcasefilename,
                                   String codeanalizer,
                                   boolean defaultlanguage,
                                   String compoptions,
                                   String execoptions,
                                   String dir ) {

        java.math.BigInteger langid = null;

        Transaction tx = getSession().beginTransaction();
        try {

            if ( this.getRecords().isEmpty() ) defaultlanguage = true;

            boolean ok = true;
            if ( defaultlanguage )
                ok = unsetDefaultLanguage( null );

            if ( !ok ) throw new Exception();

            String sql = "SELECT nextval('hibernate_sequence')";
            langid = ( java.math.BigInteger ) getSession().createSQLQuery( sql ).uniqueResult();

            sql = "INSERT INTO languages ( id," +
                                                "ext," +
                                                " formatter, " +
                                                "testcasefilename, " +
                                                "codeanalizer, " +
                                                "defaultlanguage, " +
                                                "compoptions, " +
                                                "execoptions, " +
                                                "dir " +
                                                ") VALUES ( " + langid.intValue() + "," +
                                                            "'" + ext + "',"+
                                                            "'" + formatter + "'," +
                                                            "'" + testcasefilename + "'," +
                                                            "'" + codeanalizer + "'," +
                                                            "'" + defaultlanguage + "'," +
                                                            "'" + compoptions + "'," +
                                                            "'" + execoptions + "'," +
                                                            "'" + dir + "'" +
                                              ")";
            Query q = session.createSQLQuery( sql );
            int rows = q.executeUpdate();
            tx.commit();
        }
        catch( Exception e ) {
            tx.rollback();
            e.printStackTrace();
            return null;
        }
        return (Language) this.getRecord( langid.intValue() );
    }

    private boolean unsetDefaultLanguage( Language lang ) {

        List<Language> languages = this.getRecords();
        boolean saved = true;

        for( Language l : languages ) {
            if ( lang == null || l != lang ) {
                l.setDefaultlanguage( false );
                saved = saved && super.saveRecord( l );
            }
        }
        return saved;
    }

    public boolean saveRecord( Language l ) {
        try {

            /* se e' il primo linguaggio che inserisco, deve essere di default */
            if ( this.getRecords().isEmpty() ) l.setDefaultlanguage( true );

            boolean ok = true;
            if ( l.isDefaultlanguage() )
                ok = unsetDefaultLanguage( l );

            if ( !ok ) throw new Exception();

            ok = super.saveRecord( l );
            if ( !ok ) throw new Exception();
        }
        catch ( Exception e ) {
            return false;
        }
        return true;
    }
}
