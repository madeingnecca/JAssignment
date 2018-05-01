package model;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class Student extends User {
    
    private String              nome;
    private String              cognome;
    
    private Integer                 matricola;
    private Map                submissions = new HashMap();
   
    
    public Student() {
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCognome() {
        return cognome;
    }

    public void setCognome(String cognome) {
        this.cognome = cognome;
    }


    public Integer getMatricola() {
        return matricola;
    }

    public void setMatricola(Integer matricola) {
        this.matricola = matricola;
    }
    
    
    public Map getSubmissions() {
        return submissions;
    }
    
    void submit( Submission s ) {
        submissions.put( s.getText(), s );
    }
    
    public void doSubmit( Submission s ) {
        submit( s );
    }
    
    public void unsubmit( Submission s ) {
        submissions.remove( s.getText() );
    }

    public void setSubmissions(Map submissions) {
        this.submissions = submissions;
    }
}
