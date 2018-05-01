/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package model;

import java.io.Serializable;
import java.util.HashSet;
import java.util.Set;


public class AuxiliarySourceFile implements Serializable {
    
    private int                 id;
    private boolean             source;
    private String              filename;
    private String              code;
    private Set                 texts = new HashSet();
    
    public AuxiliarySourceFile() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }


    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public Set getTexts() {
        return texts;
    }

    public void setTexts(Set texts) {
        this.texts = texts;
    }

    public boolean isSource() {
        return source;
    }

    public void setSource(boolean source) {
        this.source = source;
    }
    
    
}

