package model.test;

import java.io.Serializable;

public class TestError implements Comparable, Serializable {
    
    
    public final static int COMPILER_ERROR = 1;
    public final static int EXEC_ERROR = 2;
    
    public final static int NO_LINE = -1;
    
    private int     id;
    private String  code;
    private String  error;
    private int     type = COMPILER_ERROR;
    private String  file;
    
    private int    line = NO_LINE;

    public TestError() {}

    public TestError(String c, int l, String e) {
        code  = c;
        line  = l;
        error = e;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public int getLine() {
        return line;
    }

    public void setLine(int line) {
        this.line = line;
    }

    public String getError() {
        return error;
    }

    public void setError(String error) {
        this.error = error;
    }

    @Override
    public int compareTo(Object o) {
        if ( o == null ) return 1;
        
        try {
            TestError other = ( TestError ) o;
            
            if ( other.getLine() == this.getLine() ) return 0;
            
            return other.getLine() < this.getLine() ? 1 : -1;
        }
        catch ( ClassCastException e ) {
            return 1;
        }
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public String getFile() {
        return file;
    }

    public void setFile(String file) {
        this.file = file;
    }
}


//~ Formatted by Jindent --- http://www.jindent.com
