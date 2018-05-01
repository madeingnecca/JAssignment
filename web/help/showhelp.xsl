<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" />
    <xsl:param name="type"></xsl:param>
    <xsl:param name="page"></xsl:param>
    <xsl:variable name="path">
        ../help/
    </xsl:variable>
    
    <xsl:template match="/help">        
    <html>
        <head>
            <style>
                body {
                    font-family:Arial, Helvetica, sans-serif;
                    font-size: 0.8em;
                    margin: 0px;
                    padding: 0px;
                    width: 99%;
                    height: 100%;
                }
                a:hover, a:active, a:visited, a:link {
                    text-decoration:none;
                    color:#9a0040;
                }
                
                #helpContent {
                    width:100%;
                    min-height:400px;
                    border:1px solid #cccccc;
                    text-align:left;
                }
                
                #close {
                    text-align:center;

                }
                
                #helpNav {
                    text-align:center;
                    font-weight:bold;
                    background-color:#cccccc;
                }
                #closebutton {
                    width:100%;
                }
                
                #helptitle h2 {
                    margin:0px;
                    padding:0px;
                    margin-bottom:2px;
                    border-bottom:1px solid black;
                    display:block;
                }
                
                #bottom {
                    position:absolute;
                    bottom:0px;
                    width:100%;
                }
                
            </style>
            <script type="text/javascript">

                function showHelp( index ) {
                    var divContent = document.getElementById( "helpContent" );
                    var divNav = document.getElementById( "helpNav" );

                    if ( !divContent || !divNav ) return;

                    divContent.innerHTML = contents[ index ];

                    var navHTML = "";

                    if ( index &gt; 0 ) {
                        navHTML += '<a href="javascript:showHelp('+(index-1)+')">Pagina precedente</a>';
                    }
                    if ( index &lt; isize - 1 ) {
                        navHTML += '<a href="javascript:showHelp('+(index+1)+')">Pagina successiva</a>';
                    }
                    divNav.innerHTML = navHTML;

                }
                var contents = new Array();
                var isize = 0;
                <xsl:for-each select="page[@type=$type and @id=$page]">
                    <xsl:for-each select="pagehelp">
                       <xsl:if test="@type='img'">
                            contents.push( "&lt;img src='<xsl:value-of select="normalize-space($path)" /><xsl:value-of select="normalize-space(text())" />'/&gt;"  );
                       </xsl:if>
                       <xsl:if test="@type='txt'">
                            var output = "";
                            output += "<xsl:value-of select="normalize-space(text())" />";
                            contents.push( output );
                       </xsl:if>
                       isize++;
                    </xsl:for-each>  
                </xsl:for-each>
                </script>
           </head>
           <body onload="showHelp(0)">
               <div id="helptitle">
                   <h2><xsl:value-of select="page[@type=$type and @id=$page]/@title"/></h2>
               </div>
               <div id="helpContent">
               </div>
               <div id="bottom">
                    <div id="helpNav">
                    </div>
                    <div id="close">
                        <button id="closebutton" onclick="parent.hideHelp();">Chiudi finestra</button>
                    </div>
               </div>
           </body>
     </html>
   </xsl:template>
</xsl:stylesheet>
