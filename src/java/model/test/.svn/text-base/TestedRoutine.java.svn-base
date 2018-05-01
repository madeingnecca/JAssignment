/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package model.test;

import java.io.Serializable;

public class TestedRoutine implements Serializable {
    
    public final static String NO_NAME = "NONAME";
    private String      name;
    private int         line;
    private String[]    args;
    private boolean     constructor = false;
    
    public TestedRoutine( String n, int l, String ... a ) {
        name = n;
        line = l;
        args = a;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getLine() {
        return line;
    }

    public void setLine(int line) {
        this.line = line;
    }

    public String[] getArgs() {
        return args;
    }

    public void setArgs(String[] args) {
        this.args = args;
    }
    
    
    public boolean samePrototype( TestedRoutine tm  ) {
        if ( tm == null ) return false;
        
        boolean sameName = this.getName().equals( tm.getName() );
        boolean samePTypes = false;
        boolean sameType = this.isConstructor() == tm.isConstructor();
           
        if (this.getArgs() == null && tm.getArgs() == null ||
                this.getArgs().length == 0 && tm.getArgs().length == 0) {
            samePTypes = true;
        } else {

            if (this.getArgs().length != tm.getArgs().length) {
                samePTypes =  false;
            }
            else {
                int size = tm.getArgs().length;
                samePTypes =  true;
                for (int i = 0; i < size; i++) {
                    if (!tm.getArgs()[i].equals(this.getArgs()[i])) {
                        samePTypes = false;
                        break;
                    }
                }
            }
        }

        return sameName && samePTypes && sameType;
        
    }

    public boolean isConstructor() {
        return constructor;
    }

    public void setConstructor(boolean constructor) {
        this.constructor = constructor;
    }
}
