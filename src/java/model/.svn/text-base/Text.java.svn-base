package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Level;
import java.util.logging.Logger;

public class Text implements Serializable {

    public static final String      DEFAULT_TEXT = "<p></p>";
    public static final int         DEFAULT_TIMEOUT = 20;

    private Assignment          assignment;
    private Integer             ordinal;
    private String              text;
    private String              testcase;
    private String              submitFileName;
    private Boolean             pseudocodeRequested;
    private Boolean             humanNeeded;
    private Language            language;
    private Integer             timeout;
    private String              examplefile;
    private String              solution;

    private List                submissions = new ArrayList();
    private Set                 auxfiles = new HashSet();
    private Map                 permissions = new HashMap();

    public Text() {
        text = DEFAULT_TEXT;
        humanNeeded = false;
        pseudocodeRequested = false;
        timeout = DEFAULT_TIMEOUT;
        submitFileName = "";
        testcase = "";
        solution = "";
        examplefile = "";
    }

    public Assignment getAssignment() {
        return assignment;
    }

    public void setAssignment(Assignment assignment) {
        this.assignment = assignment;
    }

    public Integer getOrdinal() {
        return ordinal;
    }

    public void setOrdinal(Integer ordinal) {
        this.ordinal = ordinal;
    }

    public String getText() {
        return text;
    }

    public void setText(String text) {
        if ( text == null || text.equals( "" ) )
            this.text = this.DEFAULT_TEXT;
        else
            this.text = text;
    }


    public Boolean isPseudocodeRequested() {
        return pseudocodeRequested;
    }

    public void setPseudocodeRequested(Boolean pseudocodeRequested) {
        this.pseudocodeRequested = pseudocodeRequested;
    }

    public List getSubmissions() {
        return submissions;
    }

    public void setSubmissions( List subs ) {
        submissions = subs;

    }

    public void addAuxFile( AuxiliarySourceFile a ) {
        this.getAuxfiles().add(a);
        a.getTexts().add( this );
    }


    public void removeAuxFile( AuxiliarySourceFile a ) {
        this.getAuxfiles().remove( a );
        a.getTexts().remove( this );
    }


    public boolean equals( Object o ) {
        if ( o == null ) return false;

        try {
            Text ot = ( Text ) o;
            return ot.getAssignment().getId() == this.getAssignment().getId() && ot.getOrdinal() == this.getOrdinal();
        }
        catch ( ClassCastException e ) {
            return false;
        }

    }

    public String getTestcase() {
        return testcase;
    }

    public void setTestcase(String testcase) {
        this.testcase = testcase;
    }
    
    public void setTestcase(String testcase, boolean docheck) {
        if ( docheck ) {
            if ( testcase != null && !testcase.equals( "" ) )
                setTestcase( testcase );
        }
        else setTestcase( testcase );
    }

    public Language getLanguage() {
        return language;
    }

    public void setLanguage(Language language) {
        this.language = language;
    }

    public String getSubmitFileName() {
        return submitFileName;
    }

    public void setSubmitFileName(String submitFileName) {
        this.submitFileName = submitFileName;
    }

    public Set getAuxfiles() {
        return auxfiles;
    }

    public void setAuxfiles(Set auxfiles) {
        this.auxfiles = auxfiles;
    }

    public Boolean isHumanNeeded() {
        return humanNeeded;
    }

    public void setHumanNeeded(Boolean humanNeeded) {
        this.humanNeeded = humanNeeded;
    }

    public Integer getTimeout() {
        return timeout;
    }

    public void setTimeout(Integer timeout) {
        this.timeout = timeout;
    }

    public String getExamplefile() {
        return examplefile;
    }

    public void setExamplefile(String examplefile) {
         this.examplefile = examplefile;
    }
    
    public void setExamplefile(String examplefile, boolean docheck ) {
        if ( docheck ) {
            if ( examplefile != null && !examplefile.equals( "" ) )
               setExamplefile( examplefile );
        }
        else setExamplefile( examplefile );
    }
    
    

    public String getSolution() {
        return solution;
    }

    public void setSolution(String solution) {
        if ( solution != null && !solution.equals( "" ))
            this.solution = solution;
    }

    public boolean canExecuteIO() {
        Permission p = (Permission) this.getPermissions().get( Permission.IO );
        if ( p == null ) return false;
        return p.isEnabled();
    }

    public boolean canExecuteSocketServer() {
        Permission p = (Permission) this.getPermissions().get( Permission.SOCK_SRV );
        if ( p == null ) return false;
        return p.isEnabled();
    }

    public boolean canExecuteSocket() {
        Permission p = (Permission) this.getPermissions().get( Permission.SOCK_CLNT );
        if ( p == null ) return false;
        return p.isEnabled();
    }

    public boolean canExecuteThread() {

        if ( true ) return true;
        Permission p = (Permission) this.getPermissions().get( Permission.THREAD );
        if ( p == null ) return false;
        return p.isEnabled();
    }

    public void setExecuteIO( boolean flag ) {
        Permission p = (Permission) this.getPermissions().get( Permission.IO );
        if ( p == null ) {
            p = new Permission();
            p.setEnabled(flag);
            p.setType( Permission.IO );
            this.getPermissions().put( Permission.IO, p );
        }
        else p.setEnabled(flag);
    }

    public void setExecuteSocket( boolean flag ) {
        Permission p = (Permission) this.getPermissions().get( Permission.SOCK_CLNT );
        if ( p == null ) {
            p = new Permission();
            p.setEnabled(flag);
            p.setType( Permission.IO );
            this.getPermissions().put( Permission.SOCK_CLNT, p );
        }
        else p.setEnabled(flag);
    }

    public void setExecuteSocketServer( boolean flag ) {
        Permission p = (Permission) this.getPermissions().get( Permission.SOCK_SRV );
        if ( p == null ) {
            p = new Permission();
            p.setEnabled(flag);
            p.setType( Permission.IO );
            this.getPermissions().put( Permission.SOCK_SRV, p );
        }
        else p.setEnabled(flag);
    }

    public void setExecuteThread( boolean flag ) {
        Permission p = (Permission) this.getPermissions().get( Permission.THREAD );
        if ( p == null ) {
            p = new Permission();
            p.setEnabled(flag);
            p.setType( Permission.IO );
            this.getPermissions().put( Permission.THREAD, p );
        }
        else p.setEnabled(flag);
    }

    public Map getPermissions() {
        return permissions;
    }

    public void setPermissions(Map permissions2) {
        this.permissions = permissions2;
    }


}
