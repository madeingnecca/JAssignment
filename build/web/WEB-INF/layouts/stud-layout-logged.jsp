<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>

<html:html locale="true" xhtml="true">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <style>
        @import url("css/main.css");
        @import url("css/layout.css");
        @import url("css/content.css");
        @import url("css/box.css");
        @import url("css/home.css");
        @import url("css/old_style.css");
        @import url("css/intra.css");
        @import url("css/custom/home.css");
        @import url("css/ja.css");
    </style>
    <link href="css/handheld.css" rel="stylesheet" type="text/css" media="handheld"/>
    <link href="css/print.css" rel="stylesheet" type="text/css" media="print"/>
    <script type="text/javascript" src="js/clientside.js"></script>
    <meta name="ROBOTS" content="NOARCHIVE" />
    <meta name="googleBOT" content="NOARCHIVE"/>
    <title>JAssignment - Consegna esercitazioni online</title>
    <body>
    <div class="col_contenitore" id="header">
        <div id="header_sinistra"><a accesskey="0" href="http://www.unive.it/nqcontent.cfm?a_id=1"><img src="images/logo_head_intra.gif" alt="Logo Università Ca' Foscari" /></a></div>
        <div id="header_centro">
            <img src="images/consegna.png" />
        </div>
        <div id="header_destra">
            <div id="header_destra_data"></div>
        </div>
        <div class="col_finecolonna"></div>
    </div>
    <div class="col_contenitore" id="path">
        
        <tiles:insert attribute="path-user" />
        <div class="col_finecolonna"></div>
    </div>
    <div class="col_contenitore" id="content">
        <div id="content_sinistra" class="neretto">
            <div class="box chiaro allungato">
                
                <tiles:insert attribute="left-nav" />
            </div>
        </div>         
        <div id="content_centro">
            <div class="box layer_fisso chiaro" id="home_content">
                <tiles:insert attribute="body" />
            </div>
        </div>
        <div id="content_destra"></div>
        <div class="col_finecolonna"></div>
    </div>
    <div id="foot_modifica">
    </div>
    <div id="foot">
        <div id="foot_testo"><p> 
                <a href="http://www.unive.it/nqcontent.cfm?a_id=1575">Aiuto</a>
                <strong>|</strong>
                <a href="http://www.unive.it/nqcontent.cfm?a_id=1584">Mappa del Sito</a>
                <strong>|</strong>
                <a href="http://www.unive.it/nqcontent.cfm?a_id=11294">A...Z</a>
                <strong>|</strong>
                <a href="http://www.unive.it/nqcontent.cfm?a_id=31432">Novit&agrave;</a>
                <strong>|</strong>
                <a href="http://www.unive.it/nqcontent.cfm?a_id=31021">RSS</a>
                <strong>|</strong>
                <a href="http://www.unive.it/nqcontent.cfm?a_id=1585">Accessibilit&agrave;</a>
                <strong>|</strong>
                <a href="http://www.unive.it/nqcontent.cfm?a_id=1586">Copyright</a>
                <strong>|</strong>
                <a href="http://www.unive.it/nqcontent.cfm?a_id=1587">Privacy</a>
                <strong>|</strong>
                <a href="javascript:showCredits()">Credits</a>
                <strong>|</strong>
        <a href="http://www.unive.it/nqcontent.cfm?a_id=42188&amp;CFNoCache=True">Feedback</a></p></div>
        <div id="foot_loghi"><a href="http://validator.w3.org/check?uri=referer"><img src="images/w3c_css.gif" alt="Sito con CSS conforme alle regole w3c"><img src="images/w3c_xhtml.gif" alt="Sito in XHTML 1.0 conforme alle regole w3c"/></a></div>
        <div class="col_finecolonna"></div>
    </div> 
    <img src="images/log.gif" alt=""/>
    </body>
</html:html>
