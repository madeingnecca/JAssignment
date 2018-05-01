var HTTP_COMPLETED = 4;
var HTTP_OK = 200;
var INTERNAL_ERROR = 500;
var REFRESH = 1000;
var intervalID = 0;
var PROGRESS_DIV_MAX_SIZE = 220;
var MAX_TIMEOUT = 60;
var MAX_ATTEMPTS = MAX_TIMEOUT * 1000 / REFRESH;
var MAX_TEST_REACHED = -1;
var TEST_NOT_ALLOWED = -2;
var GENERIC_ERROR = -3;


function deleteText( href, ord ) {
    if ( confirm( "Vuoi veramente cancellare il sottoesercizio n. "+ord+" ?" ) )
      document.location = href;
}

function createXMLHttpRequest() {
    var xmlhttp = null;
    try {
        xmlhttp = new XMLHttpRequest();
    } catch ( e ) {
        try {
            xmlhttp = new ActiveXObject( "Msxml2.XMLHTTP" );
        }
        catch ( e1 ) {
            xmlhttp = new ActiveXObject( "Microsoft.XMLHTTP" );
        }
    }
    return xmlhttp;
}

function showError( message, exitExpression ) {
    window.alert( message );
    eval( exitExpression );
}

function voidTest( aid ) {
    var request = createXMLHttpRequest();
    var url = "VoidResultServlet?aid="+aid;

    request.onreadystatechange = function() {
        if ( request.readyState == HTTP_COMPLETED && request.status == HTTP_OK ) {
            stopLoading();
	    closeTestDiv();
        } else if ( request.readyState == HTTP_COMPLETED && request.status == INTERNAL_ERROR ) {
            showError( "Errore interno del server", "stopLoading();closeTestDiv();" );
        }
    };
    showLoading();
    request.open( "GET", url );
    request.send( null );	
}

var attempts = 0;
var lastPercentage = -1;

function testAssignment( aid ) {
    /* let's use ajax power!!! */
    var testDiv = document.getElementById( "testLayer" );
    testDiv.style.display = "block";
    var contentDiv = document.getElementById( "testContent" );
    contentDiv.style.display = "block";
    var request = createXMLHttpRequest();
    var url = "TestServlet?ft=1&mode=1&aid="+aid;

    request.onreadystatechange = function() {
        if ( request.readyState == HTTP_COMPLETED && request.status == HTTP_OK ) {
            var tid = getTID( request.responseXML.documentElement );
            if ( tid == TEST_NOT_ALLOWED ) {
                showError( "Esecuzione concorrente da parte di un altro amministratore", "stopLoading();closeTestDiv();" );
            }
            else if ( tid == MAX_TEST_REACHED ) {
                showError( "Il sistema ha raggiunto il numero massimo di test eseguibili.\n Riprovare piu' tardi.", "stopLoading();closeTestDiv();" );
            }
            else if ( tid == GENERIC_ERROR ) {
                showError( "Esecuzione concorrente da parte di un altro amministratore", "stopLoading();closeTestDiv();" );
            }
            else {
                intervalID = window.setInterval( "layerRefresher(" + tid + ")", REFRESH );
            }
        }
        
    };

    request.open( "GET", url );
    request.send( null );
}


function layerRefresher( tid ) {
    var request = createXMLHttpRequest();
    var url = "TestServlet?ft=0&mode=1&tid="+tid;
    request.onreadystatechange = function() {
        if ( request.readyState == HTTP_COMPLETED && request.status == HTTP_OK ) {
            var xml = request.responseXML.documentElement;
            parseTestResponse( xml );
        }
    };
    
    request.open( "GET", url );
    request.send( null );
    
}

function getTID( xml ) {
    if ( xml.tagName == "err" ) {
        /* TODO: metti errore qui */
        var code = parseInt(xml.getAttribute("code"));
        return (-1) * code;
    }
    else {
        var tid;
        try {
            var threadTag = xml.getElementsByTagName("thread-id")[0].firstChild.nodeValue;
            tid = parseInt( threadTag );
        }
        catch( e ) {
            /* TODO: metti errore qui */
            return GENERIC_ERROR;
        }
        return tid;
    }    
}

function parseTestResponse( xml ) {
    if ( xml.tagName != "test" ) {
        /* TODO: metti errore qui */
        var exceptionerror = xml.firstChild.nodeValue;
        showError( exceptionerror, "window.clearInterval( "+intervalID+" );closeTestDiv();" );
    }
    else {
        try {
            var threadTag = xml.getElementsByTagName("thread-id")[0].firstChild.nodeValue;
            var percTag = xml.getElementsByTagName("percentage")[0].firstChild.nodeValue;
            
        }
        catch( e ) {
            /* TODO: metti errore qui */
            showError( "Errore interno del server", "window.clearInterval( "+intervalID+" );closeTestDiv();" );
        }
        var p = parseInt( percTag );
        
        if ( p == lastPercentage ) {
            if ( attempts > MAX_ATTEMPTS ) {
                attempts = 0;
                showError( "Errore interno del server", "window.clearInterval( "+intervalID+" );closeTestDiv();" );
            } else  {
                attempts++;
            }  
        } else {
            attempts = 0;
        }
        
        var perDiv = document.getElementById( "percentage" );
        perDiv.innerHTML = p;
        var progressDiv = document.getElementById( "progressDiv" );
        progressDiv.style.width = parseInt(( p / 100 ) * PROGRESS_DIV_MAX_SIZE ) + "px";
        if ( p == 100 ) {
            window.clearInterval( intervalID );
            closeTestDiv();
        }
    }
}

function closeTestDiv() {
    document.location = document.location.href;
}

var displaying = false;
function showCurrentTestCode() {
    var tr = document.getElementById( "currentTestCodeTR" );
    if ( !displaying ) {
        tr.style.display = "table-row";
    }
    else tr.style.display = "none";
    displaying = !displaying;
}

function addFile( id ) {
    var auxobj = auxfiles[ id ];
    var request = createXMLHttpRequest();
    var url = "UploadServlet?" + "assid="+auxobj.assid+"&ord="+auxobj.ord+"&mode=1&aux="+id;
    request.onreadystatechange = function() {
        if ( request.readyState == HTTP_COMPLETED && request.status == HTTP_OK ) {
            var response = request.responseXML.documentElement 
            if ( response.tagName == "err") {
                /* TODO: metti errore qui*/
                notifyError();
            }
            else   updateAuxDiv( response, true );
        } else if ( request.readyState == HTTP_COMPLETED && request.status == INTERNAL_ERROR ) {
            notifyError();
        }
    };
    showLoading();
    request.open( "GET", url );
    request.send(null);
}

function removeFile( id ) {
    var auxobj = auxfiles[ id ];
    var request = createXMLHttpRequest();
    var url = "UploadServlet?" + "assid="+auxobj.assid+"&ord="+auxobj.ord+"&mode=2&aux="+id;
    request.onreadystatechange = function() {
        if ( request.readyState == HTTP_COMPLETED && request.status == HTTP_OK ) {
            var response = request.responseXML.documentElement; 
            if ( response.tagName == "err") {
                /* TODO: metti errore qui*/
                notifyError();
            }
            else   updateAuxDiv( response, false );
        }
    };
    showLoading();
    request.open( "GET", url );
    request.send(null);
}
    
var allFiles = new Object(); // tutti i file
var auxfiles = new Object(); // miei file

function AuxFile_ClientSide( i, fn, src, a, o ) {
   this.id = i;
   this.filename = fn;
   this.src = src;
   this.assid = a;
   this.ord = o;
}


function displayAuxFile( auxid ) {
    var str = "";
    str += "<div class=\"singleAuxFileDiv\">";
    
    var buttonValue, jsAction;
    if ( auxfiles[ auxid ] == undefined ) {
        buttonValue = "Aggiungi";
        var auxobj = allFiles[ auxid ];
        jsAction="addFile("+auxobj.id+","+auxobj.assid+","+auxobj.ord+")";
    } else {
        buttonValue = "Elimina";
        var auxobj = allFiles[ auxid ];
        jsAction="removeFile("+auxobj.id+","+auxobj.assid+","+auxobj.ord+")";
    }
    
    str += "<input type=\"button\" value=\""+buttonValue+"\"";
    str += " onclick=\""+jsAction+"\" />";
    str += allFiles[ auxid ].filename;
    str += "</div>";
    return str;
}

function addAuxFile( auxobj, mine ) {
    allFiles[ auxobj.id ] = auxobj;
    if ( mine ) 
    	auxfiles[ auxobj.id ] = auxobj;
}

function addMyAuxFile( auxid ) {
   if ( allFiles[ auxid ] != undefined ) auxfiles[ auxid ] = allFiles[ auxid ];
}

function removeAuxFile( auxid, total ) {
    auxfiles[ auxid ] = undefined;
    if ( total )
        allFiles[ auxid ] = undefined;
}


function updateAuxDiv( response, create ) {
    var auxid, name;
    if ( create ) {
        auxid = parseInt( response.getAttribute("id") );
        name = response.getAttribute("name");
      
        addMyAuxFile( auxid );
    }
    else {
        auxid = parseInt( response.getAttribute("id") );
        var total = parseInt( response.getAttribute("total") );
        total = total == 1;
        removeAuxFile( auxid, total );
    }
    stopLoading();
    refreshAuxDiv();
}

function refreshAuxDiv() {
    var auxtr = document.getElementById( "auxfilesTR" );
    var auxdiv = document.getElementById( "auxfilesDiv" );
    if ( allFilesCount() == 0 ) {
        auxtr.style.display = "none";
        return;
    }
    auxtr.style.display = "table-row";
    var str = "";
    for ( var id in allFiles ) {
        if ( allFiles[ id ] != undefined )
            str += displayAuxFile( id );
    }
    
    auxdiv.innerHTML = str;
}

function showLoading() {
    
    var hiddenDiv = document.getElementById( "ajaxlayer" );
    hiddenDiv.style.display = "block";
    
}

function stopLoading() {
    var hiddenDiv = document.getElementById( "ajaxlayer" );
    hiddenDiv.style.display = "none";
}

function stopLoadingAndAdd( auxid, name, src, assid, ord ) {
    stopLoading();
    var auxobj = new AuxFile_ClientSide( auxid, name, src, assid, ord );
    addAuxFile( auxobj, true );
    refreshAuxDiv();
}

function notifyError() {
    parent.stopLoading();
    parent.alert("Non si e' potuto portare a termine l'operazione");
}

function allFilesCount() {
    var count = 0;
    for ( var id in allFiles ) {
        if ( allFiles[ id ] != undefined )
            count++;
    }
    return count;
}

function initFiles() {
    allFiles = new Object();
    auxfiles = new Object();    
}

function compileTextarea( stud,assid, ord) {
    var compLayer = document.getElementById( "compResLayer" );
    compLayer.style.display = "none";
    var textarea = document.getElementById( "exerciseText" );
    var src = encodeURIComponent( textarea.value );
    var request = createXMLHttpRequest();
    var url = "admin/TestServlet";
    request.onreadystatechange = function() {
        if ( request.readyState == HTTP_COMPLETED && request.status == HTTP_OK ) {
            showCompileResult( request );
        } 
    };
    showLoading();
    request.open( "POST", url, true );
    var params = "stud="+stud+"&aid="+assid+"&ord="+ord+"&mode=2&src="+src;
    request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    request.setRequestHeader("Content-length", params.length);
    request.setRequestHeader("Connection", "close");
    
    request.send( params );    
}

function showCompileResult( response ) {
    stopLoading();
    var compLayer = document.getElementById( "compResLayer" );
    compLayer.style.display = "inline";
    var okcompile = true;
    var error = "";
                  
    try {
        okcompile = response.responseXML.documentElement.tagName == "ok";
        if ( !okcompile )  {
        
          var xml = response.responseXML.documentElement;
          var errorContent = xml.getElementsByTagName("err")[0].firstChild.nodeValue;

          if ( errorContent == undefined )  {
            error = response.responseText;    
          } else {
            showError( errorContent, "stopLoading();" ); 
          }
      }
        
    } catch ( e ) {
        okcompile = false;
        error = response.responseText;
    }
     	    
    if ( okcompile ) {
        compLayer.innerHTML = "<img src=\"images/ok.png\" alt=\"ok\" /><span style=\"color:green;\">Il tuo file compila</span>";  
    }else {
        compLayer.innerHTML = "<img src=\"images/ko.png\" alt=\"ok\" />" +
                            "<span style=\"color:red;\">Il tuo file NON compila</span>" +
                            "&nbsp;-<a href=\"javascript:showAllCompileResults()\">" +
                            "Clicca qui per maggiori dettagli</a>-";
                        
        var resultsDiv = document.getElementById( "code" ); 
        
        resultsDiv.innerHTML = error;
    }
}

function showAllCompileResults() {
    var resultsDiv = document.getElementById( "sourcelayer" );
    resultsDiv.style.display = "block";
}

function showAllCompileResults2() {
    var resultsDiv = document.getElementById( "sourcelayer2" );
    resultsDiv.style.display = "block";
}


function showSourceLayer( source ) {
    var srclayer = document.getElementById( "sourcelayer" );
    srclayer.style.display = "block";
    srclayer.style.height = (getViewportSize().h * 0.9) + 'px';
    
    var codelayer = document.getElementById( "code" );
    codelayer.innerHTML = "<pre>" + source + "</pre>";
}

function hideSourceLayer() {
    var srclayer = document.getElementById( "sourcelayer" );
    srclayer.style.display = "none";
    stopLoading();
}

function hideSourceLayer2() {
    var srclayer = document.getElementById( "sourcelayer2" );
    srclayer.style.display = "none";
    stopLoading();
}

function viewAuxfileSrc( auxid, studentmode ) {
  var request = createXMLHttpRequest();
    var url = "";
    if ( studentmode )
        url = "admin/";
    url += "ViewSourceServlet?mode=1&sub=1&auxid=" + auxid;
    request.onreadystatechange = function() {
        if ( request.readyState == HTTP_COMPLETED && request.status == HTTP_OK ) {
            var response = request.responseText;
            showSourceLayer( response );
        } else if ( request.readyState == HTTP_COMPLETED && request.status == INTERNAL_ERROR ) {
            showError( "Errore interno del server", "stopLoading();" );
        }
    };
    showLoading();
    request.open( "GET", url );
    request.send(null);    
}

function viewFile( assid, ord, mode, studentmode ) {
    var url = "";
    if ( studentmode )
        url = "admin/";
    url += "ViewSourceServlet?mode="+mode+"&sub=1&assid=" + assid + "&ord=" + ord;
    var request = createXMLHttpRequest();
    request.onreadystatechange = function() {
        if ( request.readyState == HTTP_COMPLETED && request.status == HTTP_OK ) {
            var response = request.responseText;
            showSourceLayer( response );
        } else if ( request.readyState == HTTP_COMPLETED && request.status == INTERNAL_ERROR ) {
            showError( "Errore interno del server", "stopLoading();" );
        }
    };
    showLoading();
    request.open( "GET", url );
    request.send(null); 
}

function viewTestCaseSrc( assid, ord, admin ) {
  viewFile( assid, ord, 2, admin );
}

function viewExampleFileSrc( assid, ord, admin ) {
  viewFile( assid, ord, 3, admin );  
}

function viewSolutionFileSrc( assid, ord, admin ) {
    viewFile( assid, ord, 4, admin );
}

function downloadSolutionFileSrc( assid, ord, studentmode ) {
    var url = "";
    if ( studentmode )
        url = "admin/";
    url += "ViewSourceServlet?mode=4&sub=2&assid=" + assid + "&ord=" + ord;
    document.location = url;
}

function downloadAuxfileSrc( auxid, studentmode ) {
    var url = "";
    if ( studentmode )
        url = "admin/";
    url += "ViewSourceServlet?mode=1&sub=2&auxid=" + auxid;
    document.location = url;
}

function downloadTestCaseSrc( assid, ord, studentmode ) {
    var url = "";
    if ( studentmode )
        url = "admin/";
    url += "ViewSourceServlet?mode=2&sub=2&assid=" + assid + "&ord=" + ord;
    document.location = url;    
}

function downloadExampleFileSrc( assid, ord, studentmode ) {
    var url = "";
    if ( studentmode )
        url = "admin/";
    url += "ViewSourceServlet?mode=3&sub=2&assid=" + assid + "&ord=" + ord;
    document.location = url;    
}


function showHelpLoading() {
    var hiddenDiv = document.getElementById( "helpAjaxLayer" );
    hiddenDiv.style.display = "block";
}

function hideHelp() {
    var hiddenDiv = document.getElementById( "helpAjaxLayer" );
    hiddenDiv.style.display = "none";  

    hiddenDiv = document.getElementById( "helpDiv" );
    hiddenDiv.style.display = "none";
}

function showHelp( type, page ) {
    showHelpLoading();
    var url = "";
    if ( type == 0 ) url += "admin/";
    
    url += "HelpServlet?type=" + type + "&page=" + page;
    
    var theFrame = document.getElementById( "helpFrame" );
    theFrame.src = url;
    
    showHelpLayer();
}

function showHelpLayer() {
    
    var hiddenDiv = document.getElementById( "helpDiv" );
    hiddenDiv.style.display = "block";
    hiddenDiv.style.height = ( getViewportSize().h * 0.9 ) + 'px';
}

var MIN_HEIGHT = 20;
var FONT_SIZE_EM = 1.5;
var ERROR_EM = 0;
var prevSize = 0;

function updateTextarea() {
    var textarea = document.getElementById( "exerciseText" );
    var code = textarea.value;
    
    var lines = code.split( "\n" );
    var linesCount = lines.length;

    if ( prevSize == linesCount ) return;
    
    var height = MIN_HEIGHT;
    if ( linesCount > MIN_HEIGHT ) {
        height = linesCount;
    }
    
    var lcTxt = document.getElementById( "lctxt" );
    
    if ( linesCount < prevSize ) {
        var lcTxtContent = "";
	for ( var i = 1; i <= height; i++ ) {
		lcTxtContent += i + "\n";
	}
	lcTxt.value = lcTxtContent;
    }
    else {

        var diff = linesCount - prevSize;
        if ( prevSize == 0 ) diff = MIN_HEIGHT;

	var lcTxtContent = "";
        for ( var i = 1; i <= diff; i++ ) lcTxtContent += (prevSize + i) + "\n";

	lcTxt.value += lcTxtContent;
    }
    
    lcTxt.style.height = (height * FONT_SIZE_EM) + "em";
    textarea.style.height = (height * FONT_SIZE_EM) + "em";

    prevSize = height;
}


function showCredits() {
    window.alert( "             ----> Coded by Dax86 <----")
}

function moveToAnchor( anchorname ) {
   var anchorObj = getAnchorPosition( anchorname );
   window.scrollBy( 0, anchorObj.y );
}

/* ************************************* ANCHOR POSITION  ************************************ */
// ===================================================================
// Author: Matt Kruse <matt@mattkruse.com>
// WWW: http://www.mattkruse.com/
//
// NOTICE: You may use this code for any purpose, commercial or
// private, without any further permission from the author. You may
// remove this notice from your final code if you wish, however it is
// appreciated by the author if at least my web site address is kept.
//
// You may *NOT* re-distribute this code in any way except through its
// use. That means, you can include it in your product, or your web
// site, or any other form where the code is actually being used. You
// may not put the plain javascript up on your site for download or
// include it in your javascript libraries for download. 
// If you wish to share this code with others, please just point them
// to the URL instead.
// Please DO NOT link directly to my .js files from your site. Copy
// the files to your server and use them there. Thank you.
// ===================================================================

/* 
AnchorPosition.js
Author: Matt Kruse
Last modified: 10/11/02

DESCRIPTION: These functions find the position of an <A> tag in a document,
so other elements can be positioned relative to it.

COMPATABILITY: Netscape 4.x,6.x,Mozilla, IE 5.x,6.x on Windows. Some small
positioning errors - usually with Window positioning - occur on the 
Macintosh platform.

FUNCTIONS:
getAnchorPosition(anchorname)
  Returns an Object() having .x and .y properties of the pixel coordinates
  of the upper-left corner of the anchor. Position is relative to the PAGE.

getAnchorWindowPosition(anchorname)
  Returns an Object() having .x and .y properties of the pixel coordinates
  of the upper-left corner of the anchor, relative to the WHOLE SCREEN.

NOTES:

1) For popping up separate browser windows, use getAnchorWindowPosition. 
   Otherwise, use getAnchorPosition

2) Your anchor tag MUST contain both NAME and ID attributes which are the 
   same. For example:
   <A NAME="test" ID="test"> </A>

3) There must be at least a space between <A> </A> for IE5.5 to see the 
   anchor tag correctly. Do not do <A></A> with no space.
*/ 

// getAnchorPosition(anchorname)
//   This function returns an object having .x and .y properties which are the coordinates
//   of the named anchor, relative to the page.
function getAnchorPosition(anchorname) {
	// This function will return an Object with x and y properties
	var useWindow=false;
	var coordinates=new Object();
	var x=0,y=0;
	// Browser capability sniffing
	var use_gebi=false, use_css=false, use_layers=false;
	if (document.getElementById) { use_gebi=true; }
	else if (document.all) { use_css=true; }
	else if (document.layers) { use_layers=true; }
	// Logic to find position
 	if (use_gebi && document.all) {
		x=AnchorPosition_getPageOffsetLeft(document.all[anchorname]);
		y=AnchorPosition_getPageOffsetTop(document.all[anchorname]);
		}
	else if (use_gebi) {
		var o=document.getElementById(anchorname);
		x=AnchorPosition_getPageOffsetLeft(o);
		y=AnchorPosition_getPageOffsetTop(o);
		}
 	else if (use_css) {
		x=AnchorPosition_getPageOffsetLeft(document.all[anchorname]);
		y=AnchorPosition_getPageOffsetTop(document.all[anchorname]);
		}
	else if (use_layers) {
		var found=0;
		for (var i=0; i<document.anchors.length; i++) {
			if (document.anchors[i].name==anchorname) { found=1; break; }
			}
		if (found==0) {
			coordinates.x=0; coordinates.y=0; return coordinates;
			}
		x=document.anchors[i].x;
		y=document.anchors[i].y;
		}
	else {
		coordinates.x=0; coordinates.y=0; return coordinates;
		}
	coordinates.x=x;
	coordinates.y=y;
	return coordinates;
	}

// getAnchorWindowPosition(anchorname)
//   This function returns an object having .x and .y properties which are the coordinates
//   of the named anchor, relative to the window
function getAnchorWindowPosition(anchorname) {
	var coordinates=getAnchorPosition(anchorname);
	var x=0;
	var y=0;
	if (document.getElementById) {
		if (isNaN(window.screenX)) {
			x=coordinates.x-document.body.scrollLeft+window.screenLeft;
			y=coordinates.y-document.body.scrollTop+window.screenTop;
			}
		else {
			x=coordinates.x+window.screenX+(window.outerWidth-window.innerWidth)-window.pageXOffset;
			y=coordinates.y+window.screenY+(window.outerHeight-24-window.innerHeight)-window.pageYOffset;
			}
		}
	else if (document.all) {
		x=coordinates.x-document.body.scrollLeft+window.screenLeft;
		y=coordinates.y-document.body.scrollTop+window.screenTop;
		}
	else if (document.layers) {
		x=coordinates.x+window.screenX+(window.outerWidth-window.innerWidth)-window.pageXOffset;
		y=coordinates.y+window.screenY+(window.outerHeight-24-window.innerHeight)-window.pageYOffset;
		}
	coordinates.x=x;
	coordinates.y=y;
	return coordinates;
	}

// Functions for IE to get position of an object
function AnchorPosition_getPageOffsetLeft (el) {
	var ol=el.offsetLeft;
	while ((el=el.offsetParent) != null) { ol += el.offsetLeft; }
	return ol;
	}
function AnchorPosition_getWindowOffsetLeft (el) {
	return AnchorPosition_getPageOffsetLeft(el)-document.body.scrollLeft;
	}	
function AnchorPosition_getPageOffsetTop (el) {
	var ot=el.offsetTop;
	while((el=el.offsetParent) != null) { ot += el.offsetTop; }
	return ot;
	}
function AnchorPosition_getWindowOffsetTop (el) {
	return AnchorPosition_getPageOffsetTop(el)-document.body.scrollTop;
	}


// damiano 23 ott 09: aggiunta funzione per il calcolo della grandezza dello schermo
// da utilizzare per impostare l'altezza dei vari layer in overlay (e.g. testo del file di test)
function getViewportSize() {
    var viewportwidth;
     var viewportheight;

     // the more standards compliant browsers (mozilla/netscape/opera/IE7) use window.innerWidth and window.innerHeight

     if (typeof window.innerWidth != 'undefined')
     {
          viewportwidth = window.innerWidth,
          viewportheight = window.innerHeight
     }

    // IE6 in standards compliant mode (i.e. with a valid doctype as the first line in the document)

     else if (typeof document.documentElement != 'undefined'
         && typeof document.documentElement.clientWidth !=
         'undefined' && document.documentElement.clientWidth != 0)
     {
           viewportwidth = document.documentElement.clientWidth,
           viewportheight = document.documentElement.clientHeight
     }

     // older versions of IE

     else
     {
           viewportwidth = document.getElementsByTagName('body')[0].clientWidth,
           viewportheight = document.getElementsByTagName('body')[0].clientHeight
     }
     return { w: viewportwidth, h: viewportheight };
}
