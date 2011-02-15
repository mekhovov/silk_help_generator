/* These are the parameters to define the appearance of the ToC. */
var
	showNumbers = false, 		// display the ordering strings: yes=true | no=false
	backColor = "#F2F2F2",		// background color of the ToC 
	normalColor = "#333",	// text color of the ToC headlines
	currentColor = "#000",	// text color of the actual line just clicked on
	currentBGColor = "#c0d2ec",	// baground text color of the actual line just clicked on
	titleColor = "#FFF",		// text color of the title "Table of Contents"
	mLevel = 1,					// number of levels minus 1 the headlines of which are presentet with large and bold fonts   
	textSizes = new Array(0.9, 0.7, 0.6, 0.8, 0.7),			// font-size factors for: [0] the title "Table of Contents", [1] larger and bold fonts [2] smaller fonts if MS Internet Explorer [3] larger and bold fonts [4] smaller fonts if Netscape Navigator.
	fontTitle = "Verdana, Geneva, Arial, Helvetica, sans-serif", // font-family of the title "Table of Contents"
	fontLines = "Verdana, Geneva, Arial, Helvetica, sans-serif" // font-family of the headlines
