<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean" prefix="bean" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic" prefix="logic" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html:html locale="true" xhtml="true"><head>   
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <html:base />
        <style>
            @import url("css/main.css");
            @import url("css/layout.css");
            @import url("css/content.css");
            @import url("css/box.css");
            @import url("css/home.css");
            @import url("css/old_style.css");
            @import url("css/ja.css");
            @import url("css/custom/home.css");
            @import url("css/dip-informatica.css");
        </style>
        <link href="css/handheld.css" rel="stylesheet" type="text/css" media="handheld"/>
        <link href="css/print.css" rel="stylesheet" type="text/css" media="print"/>
        <title>Home Page del Dipartimento di Informatica - Ca' Foscari</title>
    </head><body>
        <div class="col_contenitore" id="header">
            <div id="header_sinistra"><a accesskey="0" href="http://www.unive.it/nqcontent.cfm?a_id=1"><img src="images/logo_head.gif" alt="Logo Università Ca' Foscari" /></a></div>
            <div id="header_centro">
                <a href="http://www.unive.it/nqcontent.cfm?a_id=3747"><img src="images/banner_informatica.jpg" alt="Immagine di Ca' Foscari"/></a>
            </div>
            <div id="header_destra">
                <div id="header_destra_data"></div>
            </div>
            <div class="col_finecolonna"></div>
        </div>
        <div class="col_contenitore" id="path">
            <div id="path_sinistra">
                <p>
                    <a target="_top" href="http://www.unive.it/nqcontent.cfm?a_id=1"><strong>Home</strong></a> &gt; 
                    <a target="_top" href="http://www.unive.it/nqcontent.cfm?a_id=10509">Dipartimenti Centri Biblioteche</a> &gt; 
                    <a target="_top" href="http://www.unive.it/nqcontent.cfm?a_id=10510">Dipartimenti</a> &gt; 
                    <a target="_top" href="http://www.unive.it/nqcontent.cfm?a_id=3747"><strong>Dipartimento Informatica</strong></a> &gt; 
                    <a target="_top" href="http://www.unive.it/nqcontent.cfm?a_id=4869">Servizi Informatici</a> &gt; 
                Consegna esercitazioni online </p>
            </div>		
            <div id="path_centro">
            <a href="http://www.unive.it/nqcontent.cfm?a_id=17099"></a>	</div>
            <div id="path_destra">
            <a accesskey="1" href="http://www.unive.it/nqcontent.cfm?a_id=29"></a>	</div>
            <div class="col_finecolonna"></div>
        </div>
        <div class="col_contenitore" id="content">
            <div id="content_sinistra">
                <div class="box chiaro">
                    <h1>&gt;&gt;&gt;</h1>
                    <ul class="menulist">
                        <li><a href="http://www.unive.it/nqcontent.cfm?a_id=5638">Orari dei Servizi Informatici</a></li> 
                        <li><a href="http://www.unive.it/nqcontent.cfm?a_id=10852">Regolamento per l'uso dei Laboratori</a></li> 
                        <li><a href="http://www.unive.it/nqcontent.cfm?a_id=5621">F.A.Q. generali</a></li> 
                        <li><a href="http://www.unive.it/nqcontent.cfm?a_id=5623">F.A.Q. sull'uso dei laboratori</a></li> 
                        <li><a href="http://www.unive.it/nqcontent.cfm?a_id=5636">Print Server</a></li> 
                        <li><a href="http://www.unive.it/nqcontent.cfm?a_id=5632">Licenze MSDN per studenti</a></li> 
                        <li class="current">Consegna esercitazioni online</li>
                        <li> 
                            <a href="http://www.unive.it/nqcontent.cfm?a_id=35536" target="_blank">
                                Materiale Informatico per la Didattica
                                <img src="images/ext.gif" alt="Link esterno a www.unive.it" border="0" height="9" width="9">
                            </a>
                        </li>
                        <li> 
                            <a href="http://www.unive.it/nqcontent.cfm?a_id=5635" target="_blank">
                                Mailing List
                                <img src="images/ext.gif" alt="Link esterno a www.unive.it" border="0" height="9" width="9">
                            </a>
                        </li>
                    </ul>
                    <ul class="menulist">
                        <li> 
                            <a href="http://www.unive.it/nqcontent.cfm?a_id=5633" target="_blank">
                                Web Mail Docenti e Personale
                                <img src="images/ext.gif" alt="Link esterno a www.unive.it" border="0" height="9" width="9">
                            </a>
                        </li>
                        <li> 
                            <a href="http://www.unive.it/nqcontent.cfm?a_id=5634" target="_blank">
                                Web Mail Studenti
                                <img src="images/ext.gif" alt="Link esterno a www.unive.it" border="0" height="9" width="9">
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
            <div id="content_centro">
                <div class="box chiaro allungato">
                    <h1>Consegna esercitazioni online </h1>
                    <p>Inserire Login o matricola e Password</p>
                    <html:errors />
                    <html:form action="/UserLogin.do" focus="username">
                        <table class="login">
                            <tr>
                                <td><bean:message key="StudentLoggingWithTemplateForm.username"/></td>
                            <td><html:text property="username"/></td>
                            </tr>
                            <tr>
                                <td><bean:message key="StudentLoggingWithTemplateForm.password"/></td>
                                <td><html:password property="password"/></td>
                            </tr>
                            <tr>
                                <td><html:submit value="Accedi applicazione" /></td>
                            </tr>
                       </table>
                       <html:hidden property="userType" value="s" />
                    </html:form>
                </div>
            </div>
            <div id="content_destra">
                <div class="box scuro">
                    <h1>Collegamenti</h1>
                    <ul class="menulist">
                        <li> <a href="http://www.dsi.unive.it/~prog1" target="_blank">Corso di Programmazione<img src="images/ext.gif" alt="Link esterno a www.unive.it"/></a></li>
                        <li><a href="http://www.dsi.unive.it/~labprog" target="_blank">Corso di Laboratorio di Programmazione <img src="images/ext.gif" alt="Link esterno a www.unive.it"/></a></li>
                        <li><a href="http://www.dsi.unive.it/~mp" target="_blank">Corso di Metodologie di Programmazione <img src="images/ext.gif" alt="Link esterno a www.unive.it" /></a></li>
                        <li><a href="http://www.dsi.unive.it/~lso" target="_blank">Corso di Laboratorio di Sistemi Operativi <img src="images/ext.gif" alt="Link esterno a www.unive.it"/></a></li>
                    </ul>
                </div>
            </div>
            <div class="col_finecolonna"></div>
        </div>
        <div id="foot_modifica">
        </div>
        <div id="foot">
            <div id="foot_testo"><p> 
                    <a href="http://www.unive.it/nqcontent.cfm?a_id=30">Aiuto</a>
                    <strong>|</strong>
                    <a href="http://www.unive.it/nqcontent.cfm?a_id=23">Mappa del Sito</a>
                    <strong>|</strong>
                    <a href="http://www.unive.it/nqcontent.cfm?a_id=10879">A...Z</a>
                    <strong>|</strong>
                    <a href="http://www.unive.it/nqcontent.cfm?a_id=31430">Novit&agrave;</a>
                    <strong>|</strong>
                    <a href="http://www.unive.it/nqcontent.cfm?a_id=29488">RSS</a>
                    <strong>|</strong>
                    <a href="http://www.unive.it/nqcontent.cfm?a_id=22">Accessibilit&agrave;</a>
                    <strong>|</strong>
                    <a href="http://www.unive.it/nqcontent.cfm?a_id=31">Copyright</a>
                    <strong>|</strong>
                    <a href="http://www.unive.it/nqcontent.cfm?a_id=34">Privacy</a>
                    <strong>|</strong>
                    <a href="http://www.unive.it/nqcontent.cfm?a_id=33">Credits</a>
                    <strong>|</strong>
            <a href="http://www.unive.it/nqcontent.cfm?a_id=42188&amp;CFNoCache=True">Feedback</a></p></div>
            <div id="foot_loghi"><a href="http://validator.w3.org/check?uri=referer"><img src="images/w3c_css.gif" alt="Sito con CSS conforme alle regole w3c"><img src="images/w3c_xhtml.gif" alt="Sito in XHTML 1.0 conforme alle regole w3c"/></a></div>
            <div class="col_finecolonna"></div>
        </div> 
        <img src="images/log.gif" />
    </body></html:html>
    