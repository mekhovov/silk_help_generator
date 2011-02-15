if (navigator.appName.toLowerCase().indexOf("explorer") > -1) {
	var mdi=textSizes[1], sml=textSizes[2];
}
else {
	var mdi=textSizes[3], sml=textSizes[4];
}

function reDisplay (currentNumber,currentIsExpanded) {
	toc.document.open();
	toc.document.write("<html>\n<head>\n<title>ToC</title>\n");
		
	// find field
	toc.document.writeln("<script language=\"JavaScript\" src=\"tocTab" + variant + ".js\"></script>");
	toc.document.writeln("<script language=\"JavaScript\" src=\"tocParas.js\"></script>");
	toc.document.writeln("<script language=\"JavaScript\" src=\"displayToc.js\"></script>");
	toc.document.writeln("<script src=\"js/prototype.js\" type=\"text/javascript\"></script>");
	toc.document.writeln("<script src=\"js/scriptaculous.js?load=effects,controls\" type=\"text/javascript\"></script>");
	toc.document.writeln("<script src=\"js/unittest.js\" type=\"text/javascript\"></script>");
	toc.document.writeln("<link rel=\"stylesheet\" href=\"js/test.css\" type=\"text/css\" />");
	toc.document.writeln("<Script type=\"text/javascript\">");
	toc.document.writeln("var s = [];");
	toc.document.writeln("for (i=0; i<tocTab.length; i++) {");
	toc.document.writeln("s[i] = tocTab[i][1];");
	toc.document.writeln("}");
	toc.document.writeln("function link () {");
	toc.document.writeln("var s1 = [];");
	toc.document.writeln("var sLink = DLData.ac5.value;");
	toc.document.writeln("var loverStr;");
	toc.document.writeln("var ilinks = [];");
	toc.document.writeln("for (i=0; i<s.length; i++) {");
	toc.document.writeln("loverStr = s[i].toLowerCase();");
	toc.document.writeln("if (s[i] == sLink) {");
	toc.document.writeln("ilinks.push(i);");
	toc.document.writeln("}");
	toc.document.writeln("if (loverStr.search(sLink.toLowerCase()) >= 0) {");
	toc.document.writeln("s1.push(i);");
	toc.document.writeln("}");
	toc.document.writeln("}");
	toc.document.writeln("if ((ilinks.length == 1) && (s1.length > 0))");
	toc.document.writeln("parent.reDisplay(tocTab[ilinks[0]][0],true);");
	toc.document.writeln("else if (s1.length == 0) ");
	toc.document.writeln("alert (\"nothing found\");");
	toc.document.writeln("else {");
	toc.document.writeln("parent.DisplayLinks(s1,tocTab[s1[0]][0],tocTab[s1[0]][2]);");
	toc.document.writeln("}");
	toc.document.writeln("}");
	toc.document.writeln("function go2 () {");
	toc.document.writeln("var ivent = null;");
	toc.document.writeln("var pressed = false;");
	toc.document.writeln("if (window.event) ");
	toc.document.writeln("ivent=window.event;");
	toc.document.writeln("else if (parent && parent.event) ");
	toc.document.writeln("ivent=parent.event;");
	toc.document.writeln("if (ivent) {");
	toc.document.writeln("pressed= (ivent.keyCode==13);");
	toc.document.writeln("}");
	toc.document.writeln("if (pressed) { ");
	toc.document.writeln("DLData.go.click();");
	toc.document.writeln("window.event.returnValue = false; ");
	toc.document.writeln("}");
	toc.document.writeln("return false;");
	toc.document.writeln("}");
	toc.document.writeln("</script>");
		
	toc.document.write("</head>\n<body bgcolor=\"" + backColor + "\">\n<STYLE> \n body \n {scrollbar-face-color: #FFF; \n scrollbar-3dlight-color: #FFF; \n scrollbar-track-color: #FFF; \n scrollbar-shadow-color: #527194; \n scrollbar-darkshadow-color: #FFF; \n scrollbar-arrow-color: #527194; \n scrollbar-highlight-color: #527194;}\n  .submit {font-weight: bold; \n font-size: 9pt;\n font-family: verdana, helvetica, sans-serif; \n background-color: #5A82AD; \n color: #ffffff; \n border: 1px outset #739ECC; \n margin: 1;}\n .navlink \n { \n background: transparent; \n color: " + normalColor + "; \n text-decoration: none; \n font-family: " + fontTitle + "; \n font-size:" + mdi + "em; \n} \n a:hover.navlink \n { \n background: " + currentBGColor + "; \n color: " + normalColor + "; \n text-decoration: none; \n }\n </STYLE>\n");
	
	// find field
	toc.document.writeln("<FORM name=\"DLData\" id=\"DLData\" method=\"post\">");

	toc.document.write("<table width=100% border=0 cellspacing=0 cellpadding=0>\n<tr>");
	
	var currentNumArray = currentNumber.split(".");
	var currentLevel = currentNumArray.length-1;
	var scrollY=0, addScroll=true, theHref="";
	var bLast;
	
	for (i=0; i<tocTab.length; i++) {
		thisNumber = tocTab[i][0];
		var isCurrentNumber = (thisNumber == currentNumber);
		if (isCurrentNumber) theHref=tocTab[i][2];
		var thisNumArray = thisNumber.split(".");
		var thisLevel = thisNumArray.length-1;
		var toDisplay = true;
		if (thisLevel > 0) {
			for (j=0; j<thisLevel; j++) {
				toDisplay = (j>currentLevel)?false:toDisplay && (thisNumArray[j] == currentNumArray[j]);
			}
		}
		thisIsExpanded = toDisplay && (thisNumArray[thisLevel] == currentNumArray[thisLevel])
		if (currentIsExpanded) {
			toDisplay = toDisplay && (thisLevel<=currentLevel);
			if (isCurrentNumber) thisIsExpanded = false;
		}
		
		if (toDisplay) {
			if (i==0) {
				// find field
				toc.document.writeln("<TR>");
				toc.document.writeln("<TD colspan=" + (nCols+1) + ">");
				toc.document.writeln("<INPUT id=\"ac5\" name=\"ac5\" type=\"text\" size=\"17\" maxlength=\"50\" style=\"width:210;\" onkeypress=\"go2 ();\"   value=\"search...\"  onblur=\"if(this.value=='') this.value='search...';\" onfocus=\"if(this.value=='search...') this.value='';\" />");
				toc.document.writeln("<DIV id=\"ac5update\" class=\"autocomplete\"></DIV>");
				toc.document.writeln("<SCRIPT type=\"text/javascript\" language=\"javascript\" charset=\"utf-8\">");
				toc.document.writeln("new Autocompleter.Local('ac5','ac5update', s, { tokens: new Array(',','\\n'), fullSearch: true, partialSearch: true, choices: \"20\", ignoreCase: true});");
				toc.document.writeln("</SCRIPT>");
				toc.document.writeln("<INPUT class=\"submit\" id=\"go\" name=\"go\" type=\"button\" onclick=\"link ();\" value=\"Go\">");
				//toc.document.writeln("</DIV>");
				toc.document.writeln("</TD>");
				toc.document.writeln("</TR>");
				
				toc.document.write("<tr>\n");
				for (k=0; k<nCols; k++) {
					toc.document.write("<td>&nbsp</td>");
				}
				
				toc.document.write("<td width=1024>");
				for (k=1; k<54; k++) {
					toc.document.write("&nbsp;");
				}
				toc.document.write("</td></tr>");
				
				toc.document.writeln("<tr>\n<td width=10 colspan=" + (nCols+1) + "><a class=\"navlink\" id=\"home\" href=\"javaScript:\parent.reDisplay('" + thisNumber + "'," + thisIsExpanded + ")\"><img src=\"images/home.png\" width=16 height=16 border=0>&nbsp;Home</a></td></tr>");
				
				}
			else {
				if (addScroll) scrollY+=((thisLevel<2)?mdi:sml)*27;
				if (isCurrentNumber) addScroll=false;
				var isLeaf = (i==tocTab.length-1) || (thisLevel >= tocTab[i+1][0].split(".").length-1);
				
				bLast = (i==tocTab.length-1) || thisLevel > tocTab[i+1][0].split(".").length-1;
				
				if (bLast == false) {
					
					for (k=i+1; k<tocTab.length-1; k++) {
						if (thisLevel == tocTab[k][0].split(".").length-1) {
							bLast = false;
							break;
						} else
							bLast = true;
						
						if (thisLevel > tocTab[k][0].split(".").length-1) {
							bLast = true;
							break;
						}
							
						
					}
					
				}
				
				if (bLast) {
					imgTree = (isLeaf)?"joinbottom":(thisIsExpanded)?"minusbottom":"plusbottom";
				}
				else
					imgTree = (isLeaf)?"join":(thisIsExpanded)?"minus_tree":"plus_tree";
				
				imgIco = (isLeaf)?"page":(thisIsExpanded)?"folderopen":"folder";
				
				imgIco = ((thisLevel+1) == nCols) ? "page" : imgIco;
												
				var imgTagIco = "<img src=\"images/" + imgIco + ".gif\"  border=0>";
				var imgTagTree = "<img src=\"images/" + imgTree + ".gif\"  border=0>";

				var bLast2 = true;
				toc.document.writeln("<tr>");
				for (k=1; k<=thisLevel; k++) {
					toc.document.writeln("<td width=10><img src=\"images/line.gif\"  border=0></td>");
				}
					
				toc.document.writeln("<td width=10 valign=top><a href=\"javaScript:parent.reDisplay('" + thisNumber + "'," + thisIsExpanded + ");\">" + imgTagTree + "</a></td> <td width=10 colspan=" + (nCols-thisLevel) + "><a class=\"navlink\" href=\"javaScript:parent.reDisplay('" + thisNumber + "'," + thisIsExpanded + ")\" style=\"font-family: " + fontLines + ";" + ((thisLevel<=mLevel)?"font-weight:bold":"") +  "; font-size:" + ((thisLevel<=mLevel)?mdi:sml) + "em; white-space: nowrap; " + ((isCurrentNumber)?"background-color: " + currentBGColor + "":"") + ";\">" + imgTagIco + ((showNumbers)?(thisNumber+" "):"") + tocTab[i][1] + "</a></td></tr>");
			}
		}
	}
	
	toc.document.writeln("</table>\n");
	// find field
	toc.document.writeln("</FORM>");
	toc.document.writeln("</body>");
	toc.document.close();
	toc.scroll(0,scrollY);

	if (theHref != "") content.location.href = theHref;
	
}

function DisplayLinks (s1, currentNumber,link) {
		
	if (s1 != 0) {

		toc.document.open();
		toc.document.write("<html>\n<head>\n<title>ToC</title>\n");

		// find field
		toc.document.writeln("<script language=\"JavaScript\" src=\"tocTab" + variant + ".js\"></script>");
		toc.document.writeln("<script language=\"JavaScript\" src=\"tocParas.js\"></script>");
		toc.document.writeln("<script language=\"JavaScript\" src=\"displayToc.js\"></script>");
		toc.document.writeln("<script src=\"js/prototype.js\" type=\"text/javascript\"></script>");
		toc.document.writeln("<script src=\"js/scriptaculous.js?load=effects,controls\" type=\"text/javascript\"></script>");
		toc.document.writeln("<script src=\"js/unittest.js\" type=\"text/javascript\"></script>");
		toc.document.writeln("<link rel=\"stylesheet\" href=\"js/test.css\" type=\"text/css\" />");

		toc.document.writeln("<Script type=\"text/javascript\">");
		toc.document.writeln("var s = [];");
		toc.document.writeln("var oldCurrNum;");
		toc.document.writeln("for (i=0; i<tocTab.length; i++) {");
		toc.document.writeln("s[i] = tocTab[i][1];");
		toc.document.writeln("}");
		toc.document.writeln("function link () {");
		toc.document.writeln("var s1 = [];");
		toc.document.writeln("var sLink = DLData.ac5.value;");
		toc.document.writeln("var loverStr;");
		toc.document.writeln("var ilinks = [];");
		toc.document.writeln("for (i=0; i<s.length; i++) {");
		toc.document.writeln("loverStr = s[i].toLowerCase();");
		toc.document.writeln("if (s[i] == sLink) {");
		toc.document.writeln("ilinks.push(i);");
		toc.document.writeln("}");
		toc.document.writeln("if (loverStr.search(sLink.toLowerCase()) >= 0) {");
		toc.document.writeln("s1.push(i);");
		toc.document.writeln("}");
		toc.document.writeln("}");
		toc.document.writeln("if ((ilinks.length == 1) && (s1.length > 0))");
		toc.document.writeln("parent.reDisplay(tocTab[ilinks[0]][0],true);");
		toc.document.writeln("else if (s1.length == 0) ");
		toc.document.writeln("alert (\"nothing found\");");
		toc.document.writeln("else {");
		toc.document.writeln("parent.DisplayLinks(s1,tocTab[s1[0]][0],tocTab[s1[0]][2]);");
		toc.document.writeln("}");
		toc.document.writeln("}");
		toc.document.writeln("function go2 () {");
		toc.document.writeln("var ivent = null;");
		toc.document.writeln("var pressed = false;");
		toc.document.writeln("if (window.event) ");
		toc.document.writeln("ivent=window.event;");
		toc.document.writeln("else if (parent && parent.event) ");
		toc.document.writeln("ivent=parent.event;");
		toc.document.writeln("if (ivent) {");
		toc.document.writeln("pressed= (ivent.keyCode==13);");
		toc.document.writeln("}");
		toc.document.writeln("if (pressed) { ");
		toc.document.writeln("DLData.go.click();");
		toc.document.writeln("window.event.returnValue = false; ");
		toc.document.writeln("}");
		toc.document.writeln("return false;");
		toc.document.writeln("}");
		toc.document.writeln("function current (currNum, oldCurr) { var curr = document.getElementById(oldCurr);curr.style.backgroundColor = \"transparent\"; curr = document.getElementById(currNum);curr.style.backgroundColor = \"" + currentBGColor + "\";}");
		
		toc.document.writeln("</script>");
			
		toc.document.write("</head>\n<body bgcolor=\"" + backColor + "\">\n<STYLE> \n body \n {scrollbar-face-color: #FFF; \n scrollbar-3dlight-color: #FFF; \n scrollbar-track-color: #FFF; \n scrollbar-shadow-color: #527194; \n scrollbar-darkshadow-color: #FFF; \n scrollbar-arrow-color: #527194; \n scrollbar-highlight-color: #527194;}\n  .submit {font-weight: bold; \n font-size: 9pt;\n font-family: verdana, helvetica, sans-serif; \n background-color: #5A82AD; \n color: #ffffff; \n border: 1px outset #739ECC; \n margin: 1;}\n .navlink \n { \n background: transparent; \n color: " + normalColor + "; \n text-decoration: none; \n font-family: " + fontTitle + "; \n font-size:" + mdi + "em; \n} \n a:hover.navlink \n { \n background: " + currentBGColor + "; \n color: " + normalColor + "; \n text-decoration: none; \n }\n </STYLE>\n");
		
		// find field
		toc.document.writeln("<FORM name=\"DLData\" id=\"DLData\" method=\"post\">");

		toc.document.write("<table width=100% border=0 cellspacing=0 cellpadding=0>\n<tr>");
			
		var nCols2 = 1;
		
		// find field
		toc.document.writeln("<TR>");
		toc.document.writeln("<TD colspan=" + (nCols+1) + ">");
		//toc.document.writeln("<DIV align='center'><FONT face=\"Arial, Helvetica, sans-serif\" size=\"2\">Quick Search</FONT>");
		toc.document.writeln("<INPUT id=\"ac5\" name=\"ac5\" type=\"text\" size=\"17\" maxlength=\"50\" style=\"width:210;\" onkeypress=\"go2 ();\"   value=\"search...\"  onblur=\"if(this.value=='') this.value='search...';\" onfocus=\"if(this.value=='search...') this.value='';\" />");
		toc.document.writeln("<DIV id=\"ac5update\" class=\"autocomplete\"></DIV>");
		toc.document.writeln("<SCRIPT type=\"text/javascript\" language=\"javascript\" charset=\"utf-8\">");
		toc.document.writeln("new Autocompleter.Local('ac5','ac5update', s, { tokens: new Array(',','\\n'), fullSearch: true, partialSearch: true, choices: \"20\", ignoreCase: true});");
		toc.document.writeln("</SCRIPT>");
		toc.document.writeln("<INPUT class=\"submit\" id=\"go\" name=\"go\" type=\"button\" onclick=\"link ();\" value=\"Go\">");
		//toc.document.writeln("</DIV>");
		toc.document.writeln("</TD>");
		toc.document.writeln("</TR>");
		
		toc.document.write("<tr>\n");
		
		for (k=0; k<nCols2; k++) {
			toc.document.write("<td>&nbsp;</td>");
		}
		
		toc.document.write("<td width=1024>");
		for (k=1; k<54; k++) {
			toc.document.write("&nbsp;");
		}
		toc.document.write("</td></tr>");
		
		toc.document.writeln("<tr>\n<td colspan=" + (nCols2+1) + "><a class=\"navlink\" id=\"home\" href=\"javaScript:\parent.reDisplay(toc.oldCurrNum," + true + ")\"><img src=\"images/home.png\" width=16 height=16 border=0>&nbsp;Home</a></td></tr>");
		
		var showNumbers = false;
		var currentNumArray = currentNumber.split(".");
		var currentLevel = currentNumArray.length-1;
		var scrollY=0, addScroll=true, theHref="";
		
		for (kk=0; kk<s1.length; kk++) {
			var i = s1[kk]-0;
			
			thisNumber = tocTab[i][0];
			var isCurrentNumber = false;
			
			var thisNumArray = thisNumber.split(".");
			var thisLevel = thisNumArray.length-1;
			var toDisplay = true;
			
			thisIsExpanded = false;
			
			if (toDisplay) {
				
				if (i!=0){
					if (addScroll) scrollY+=((thisLevel<2)?mdi:sml)*25;
					if (isCurrentNumber) addScroll=false;
					var isLeaf = (i==tocTab.length-1) || (thisLevel >= tocTab[i+1][0].split(".").length-1);
		
					imgTree = (isLeaf)?"join":(thisIsExpanded)?"minus_tree":"plus_tree";
					
					imgIco = (isLeaf)?"page":(thisIsExpanded)?"folderopen":"folder";
					
					var imgTagIco = "<img src=\"images/" + imgIco + ".gif\"  border=0>";
					var imgTagTree = "<img src=\"images/" + imgTree + ".gif\" border=0>";
					
					toc.document.writeln("<tr>");
					if ((thisLevel+1) == nCols) {
						if (!isCurrentNumber) {
							isCurrentNumber = true;
							theHref=tocTab[i][2];
							toc.oldCurrNum = tocTab[i][0];;
						}
						toc.document.writeln("<td width=10 valign=top><a id=\"blank\" href=\"javaScript:parent.DisplayLinks(" +0+ ",'" + thisNumber + "','" + tocTab[s1[kk]][2] + "');\">" + imgTagTree + "</a></td> <td width=10 colspan=" + (nCols-thisLevel) + "><a class=\"navlink\"  id=\"" + thisNumber + "\" onclick=\"current('"+ thisNumber +"', oldCurrNum)\" href=\"javaScript:\parent.DisplayLinks(" +0+ ",'" + thisNumber + "','" + tocTab[s1[kk]][2] + "')\" style=\"white-space: nowrap;\">" + imgTagIco + ((showNumbers)?(thisNumber+" "):"") + tocTab[i][1] + "</a></td></tr>");
					
					}
				}
			}
		}
		
		toc.document.writeln("</table>\n");
		
		// find field
		toc.document.writeln("</FORM>");

		toc.current(thisNumber, toc.oldCurrNum);
	
  	toc.document.writeln("</body>");
	  toc.document.close();	
		
	  parent.DisplayLinks(0,thisNumber,tocTab[i][2]);
		
	  toc.scroll(0,scrollY);
		
		if (theHref != "") content.location.href = theHref;
	}
	else {
		toc.oldCurrNum = currentNumber;
		toc.home.href = "javaScript:\parent.reDisplay('" + currentNumber + "'," + true + ")";
		content.location.href = link;
	}
}

function DisplaySilkDirLocations (sLocation) {
	var sLink = "";
	sLink += "</pre>";
	sLink += "<p>File: " + sLocation + "&nbsp;&nbsp;";
		
	sLink +=  "<object id=\"clippy\" class=\"clippy\" height=\"14\" width=\"110\" classid=\"clsid:d27cdb6e-ae6d-11cf-96b8-444553540000\">";
    sLink +=  "<param value=\"../../images/clippy.swf\" name=\"movie\"/>";
    sLink +=  "<param value=\"always\" name=\"allowScriptAccess\"/>";
    sLink +=  "<param value=\"high\" name=\"quality\"/>";
    sLink +=  "<param value=\"noscale\" name=\"scale\"/>";
    sLink +=  "<param value=\"text=" + sLocation + "\" name=\"FlashVars\"/>";
    sLink +=  "<param value=\"#FFFFFF\" name=\"#FFFFFF\"/>";
    sLink +=  "<param value=\"opaque\" name=\"wmode\"/>";
    sLink +=  "<embed height=\"14\" width=\"110\" wmode=\"opaque\" bgcolor=\"#FFFFFF\" flashvars=\"text=" + sLocation + " pluginspage=\"http://www.macromedia.com/go/getflashplayer\" type=\"application/x-shockwave-flash\" allowscriptaccess=\"always\" quality=\"high\" name=\"clippy\" src=\"../../images/clippy.swf\"/>";
    sLink +=  "</object>";
	sLink +=  "</p>";
	sLink +=  "<pre class=\"prettyprint lang-java\"  id=\"java_lang\" style=\"border-style: none\">";
	
	return sLink;
}


function DisplayAuthor (sAuthor) {
	
	var sLink = "";
	sLink += "<a class=\"navlink\" href=\"#\" onclick=\"dijit.byId('" + sAuthor + "').show()\"><img src=\"../../images/user.gif\"> " + sAuthor + "</a>";
	sLink += "<div id=\"" + sAuthor + "\" dojoType=\"dijit.Dialog\"";
	sLink += "title=\"" + sAuthor + "\" style=\"display:none;\"";
	sLink += "href=\"../Stat/" + sAuthor.replace (" ", "_") + ".htm\"></div>";
	sLink += "<br>";

	return sLink;
}

function DisplayCode (sFile) {
	var sLink = "";
	sLink += "<a class=\"navlink\" href=\"../" + sFile + "\" title=\"Open source code\">see code <img src=\"../../images/forward.gif\"></a>";

	return sLink;
}


var toggle = function() {
    var currentDiv = null;

    function open(divElement) {
	    divElement.style.display = "block";
        currentDiv = divElement;
    }

    function close(divElement) {
        divElement.style.display = "none";
		currentDiv = null;
    }

    return function(divID) {
	var divElement = document.getElementById(divID);
	
	if (divElement) {
	    if (divElement === currentDiv) {
	        close(currentDiv);
	    } else if(currentDiv != null) {
	        open(divElement);
	    } else open(divElement);
	}
    }
  }();


var toggleCode = function() {
    var currentDiv = null;

    function open(divElement, divID) {
		
    divElement.style.display = "block";
		document.images[divID].src = "../../../images/minus_silk.jpg";
		
        currentDiv = divElement;
    }

    function close(divElement, divID) {
        divElement.style.display = "none";
		document.images[divID].src = "../../../images/plus_silk.jpg";
		currentDiv = null;
    }

    return function(divID) {
	var divElement = document.getElementById(divID);
	
	if (divElement) {
	    if (divElement === currentDiv) {
	        close(currentDiv, divID);
	    } else if(currentDiv != null) {
	        open(divElement, divID);
	    } else open(divElement, divID);
	}
    }
  }();

