package model;

import java.io.Serializable;
import java.util.List;

public class User implements Serializable {
    
    protected String        login;
    protected String        password;
    protected String          email;

    public User() {
        login = null;
        password = null;
    }
    
    public User( String l, String p ) {
        login = l;
        password = p;
    }
    
    public String getLogin() {
        return login;
    }

    public String getPassword() {
        return password;
    }

    public void setLogin(String login) {
        this.login = login;
    }

    public void setPassword(String password) {
        this.password = password;
    }
    
    
    public boolean equals( Object o ) {
        if ( o == null ) return false;
        
        try {
            User u = ( User ) o;
            return this.getLogin().equals( u.getLogin() ) && u.getClass().equals( this.getClass() );
        }
        catch ( ClassCastException e ) {
            return false;
        }
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }
    
    /* todo: inserire anche campo email nella versione 2.0 */
}
