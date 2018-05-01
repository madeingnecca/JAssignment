/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package dao;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import model.AcademicYear;
import org.hibernate.FlushMode;
import org.hibernate.HibernateException;
import org.hibernate.Query;


public class UserDAO extends DAO {
    
    protected UserDAO( Class c ) {
        super( c );
    }
    
    public List getAcademicYears() {
        synchronized( this ) {
            List list = new ArrayList();
            try {
                Query query = getSession().createQuery("from AcademicYear aa order by aa.secondYear");
                query.setFlushMode( FlushMode.MANUAL );
                list = query.list();
            } catch (HibernateException e) {
                e.printStackTrace();
            }
            return list;
        }
    }
    
    public AcademicYear getLastAA() {
        synchronized( this ) {
            AcademicYear aa = null;
            List aas = getAcademicYears();
            
            if ( aas.size() == 0 ) {
                aa = new AcademicYear();
                Calendar today = Calendar.getInstance();
                int currentMonth = today.get(Calendar.MONTH);
                int currentYear = today.get( Calendar.YEAR );

                if ( currentMonth >= Calendar.SEPTEMBER ) {
                    aa.setFirstYear( currentYear );
                    aa.setSecondYear( currentYear + 1 );
                } else {
                    aa.setFirstYear( currentYear - 1 );
                    aa.setSecondYear( currentYear );  
                }
                
                AcademicYearDAO.getInstance().saveRecord( aa );
                return aa;
            }
            
            ArrayList al = ( ArrayList ) aas;
            aa = (AcademicYear) al.get( al.size() - 1 );
            return aa;
        }
    }
}
