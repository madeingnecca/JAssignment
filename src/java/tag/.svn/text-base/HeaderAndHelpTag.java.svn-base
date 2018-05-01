/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package tag;

import controller.Constants;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.BodyContent;
import javax.servlet.jsp.tagext.BodyTag;
import javax.servlet.jsp.tagext.Tag;
import javax.servlet.jsp.tagext.TagSupport;
import model.*;

/**
 *
 * @author tec
 */
public class HeaderAndHelpTag implements BodyTag {
    
    private Tag parent;
    private BodyContent bodyContent;
    private PageContext pageContext;
    
    private String title;

    public HeaderAndHelpTag() {
        super();
    }
    
    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }


    @Override
    public void setBodyContent(BodyContent arg0) {
        bodyContent = arg0;
    }

    @Override
    public void doInitBody() throws JspException {
        
    }

    @Override
    public int doAfterBody() throws JspException {
        return SKIP_BODY;
    }

    @Override
    public void setPageContext(PageContext arg0) {
        pageContext = arg0;
    }

    @Override
    public void setParent(Tag arg0) {
        parent = arg0;
    }

    @Override
    public Tag getParent() {
        return parent;
    }

    @Override
    public int doStartTag() throws JspException {
        return EVAL_BODY_TAG;
    }

    @Override
    public int doEndTag() throws JspException {
        
        String body = bodyContent.getString();
        String page = "";
        
        boolean admin;
        
        int ipage = 0;
        ipage = ( Integer ) pageContext.getRequest().getAttribute( Constants.LEVEL_REQUEST_KEY );
        
        User current = ( User ) pageContext.getSession().getAttribute( Constants.USER_SESSION_KEY );
        admin = current instanceof Admin;
        
        page = String.valueOf( ipage );
        
        int type = admin ? 1 : 0;
        String js = "showHelp("+type+",'"+page+"');";
        
        String output = "<h1>" + body + "</h1>";
        output += "<div onclick=\""+js+"\" class=\"help\">&nbsp;</div>";
        output += "<div id=\"helpAjaxLayer\"></div>";
        output += "<div id=\"helpDiv\"><iframe src=\"\" id=\"helpFrame\"></iframe></div>";
        
        try {
            pageContext.getOut().write(output);
        } catch (IOException ex) {
            Logger.getLogger(HeaderAndHelpTag.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return SKIP_BODY;
    }

    @Override
    public void release() {

    }

}
