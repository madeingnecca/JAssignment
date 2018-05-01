/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package model;

import java.io.Serializable;

public class Permission implements Serializable {

    public final static int            IO = 0;
    public final static int            SOCK_SRV = 1;
    public final static int            SOCK_CLNT = 2;
    public final static int            THREAD = 3;

    private int         type;
    private boolean     enabled;
    private int         id;


    public Permission() {

    }

    public int getType() {
        return type;
    }

    public void setType(int type) {
        this.type = type;
    }

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }



}
