package tag;

import java.io.IOException;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.BodyContent;
import javax.servlet.jsp.tagext.BodyTag;
import javax.servlet.jsp.tagext.Tag;

public class ContentLoader implements BodyTag {

    private Tag parent;
    private BodyContent bodyContent;
    private PageContext pageContext;
    
    private String title;

    public ContentLoader() {
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
        
        String divHTML = "<div id=\"ajaxlayer\"></div>";
        String showLoadingHTML = "<script type=\"text/javascript\">" +
                                     "showLoading();" +
                                    "</script>";
        
        divHTML += showLoadingHTML;
        
        try {
            pageContext.getOut().write( divHTML );
            pageContext.getOut().flush();
        } catch (IOException ex) {}
        
        return EVAL_BODY_TAG;
    }

    @Override
    public int doEndTag() throws JspException {
        
        String body = bodyContent.getString();

        
        String stopLoadingHTML = "<script type=\"text/javascript\">" +
                                     "stopLoading();" +
                                    "</script>";
        
        body += stopLoadingHTML;
        
        try {
            pageContext.getOut().write( body );
        } catch (IOException ex) {}
        
        return SKIP_BODY;
    }

    @Override
    public void release() {
        
    }

}
