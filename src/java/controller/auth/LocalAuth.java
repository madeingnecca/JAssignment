/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package controller.auth;

import dao.AdminDAO;
import dao.DAO;
import dao.StudentDAO;
import fi.iki.santtu.md5.MD5;
import javax.servlet.http.HttpServlet;
import model.User;


public class LocalAuth implements Authenticator {

    public LocalAuth() {}

    @Override
    public User authenticate(String username, String password, boolean isadmin, HttpServlet req ) {

        DAO dao;
        User user;

        if ( isadmin ) {
            dao = AdminDAO.getInstance();
        } else {
            dao = StudentDAO.getInstance();
        }

        user = ( User ) dao.getRecord( username );

        // calcolo md5 della password che ho appena inserito nel form
        password = new MD5( password ).asHex();

        return ( user == null || !user.getPassword().equals( password ) ) ? null : user;
    }

}
