package dao;

import java.io.Serializable;
import java.util.List;
import org.hibernate.HibernateException;
import org.hibernate.MappingException;
import org.hibernate.ObjectNotFoundException;
import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;

public class DAO {

    protected   static  SessionFactory      sessionFactory = null;
    protected   static  Configuration       cfg = null;
    protected   static  Session             session = null;
    protected   static  final String        HIBERNATE_CFG = "hibernate.cfg.xml";

    private Class persistentClass = null;

    protected Session getSession() {
        
        synchronized( this ) {
            if ( sessionFactory == null ) return null;
            return session;
        }        
    }

    protected DAO(Class pc) {
        persistentClass = pc;

        try {

            if ( sessionFactory != null ) return;

            cfg = new Configuration();
            cfg.configure(HIBERNATE_CFG);
            sessionFactory = cfg.buildSessionFactory();
            session = sessionFactory.openSession();

        } catch (HibernateException e) {
            e.printStackTrace();
        }
    }

    protected Class getPersistentClass() {
        return persistentClass;
    }


    public Object getRecord(Serializable id) {
        Object record = null;
        try {
            record = getSession().get(persistentClass, id);
        }
        catch (HibernateException e) {
            e.printStackTrace();
        }
        return record;
    }

    public boolean recordExists(Serializable id) {
        return ( getRecord( id ) != null );
    }

    public List getRecords() {
        List list = null;
        try {
            Query query = getSession().createQuery("from " + persistentClass.getName());
            list = query.list();
        } catch (HibernateException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean saveRecord(Object record) {
        Transaction tx = getSession().beginTransaction();
        try {
            getSession().saveOrUpdate(record);
            //getSession().flush();
            tx.commit();
        }catch (HibernateException e) {
            getSession().clear();
            tx.rollback();
            e.printStackTrace();
            return false;
        }
        return true;
    }

    public boolean removeRecord(Serializable id) {
        Transaction tx = getSession().beginTransaction();
        try {
            Object record = getSession().get(persistentClass, id);
            getSession().delete(record);
            //getSession().flush();
            tx.commit();
        } catch (HibernateException e) {
            tx.rollback();
            e.printStackTrace();
            return false;
        }
        return true;
    }

}
