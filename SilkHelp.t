[ ] // ***************************************************************************
[ ] // *                                                                         *
[ ] // *                        Silk Help Generator                              *
[ ] // *                                                                         *
[ ] // *                                                                         *
[ ] // * Created by: David Genrich                                    Oct, 2001  *
[ ] // *                                                                         *
[ ] // * Forked  by: Alex Mekhovov                                    Dec, 2009  *
[ ] // *                                                                         *
[ ] // ***************************************************************************
[ ] 
[ ] // ---------------------------------------------------------------------------
[+] // ------------------------------- COMMON CODE -------------------------------
	[ ] 
	[ ] // ------- TYPE MAP ------
	[+] type PAIR is record	// Supplementary type {sKey, aValue} for type MAP
		[ ] STRING sKey
		[ ] ANYTYPE aValue
	[ ] 
	[+] // Type MAP
		[ ] // Description: 
		[ ] // Associative array, that stores list of pairs {sKey, aValue}. 
		[ ] // Key is of type STRING, while Value can be of any type.
		[ ] // Any key in associative array must be unique:
		[ ] // MAP mPatient = {...}
		[ ] // {"sLastName", "Smith"}
		[ ] // {"sFirstName", "John"}
		[ ] // {"sSex", "M - male"}
		[ ] // {"sAge", 100}
		[ ] // 
		[ ] // Values of map can be accessed via MapGet/MapSet function:
		[ ] // s = MapGet (mPatient, "sLastName");
		[ ] // MapSet (mPatient, "sSp", "cat")
		[ ] // 
		[ ] // You can also add values to the map without key. The unique key will be 
		[ ] // assigned automatically (this is done by MapGetNextHash function):
		[ ] // MapAdd (mPatient, "cat")  // + {"1", "cat"}
		[ ] // MapAdd (mPatient, "tail") // + {"2", "tail"}
		[ ] // 
		[ ] // To delete a value by key, use MapDelete:
		[ ] // MapDelete (mPatient, "sAge") 
		[ ] // 
		[ ] // The function MapValueKeys returns list of keys, that have given value in a map:
		[ ] // Print (MapValueKeys (mPatient, "cat")) -> {"sSp", "1"}
		[ ] // 
		[ ] // To erase a value from map (that can be keyed by one or more keys), use
		[ ] // MapErase function. 
		[ ] // MapErase (mPatient, "cat") // will erase both {"sSp","cat"} and {"1","cat"}
		[ ] // 
		[ ] //*************************************************************************************** 
		[ ] type MAP is LIST OF PAIR
		[ ] 
		[+] //******************************************************************************
    //**Function: BOOLEAN MapHasKey (mMap, f_sKey)
			[ ] //Description: Returns true or false depending on whether mMap contains key f_sKey
			[ ] //Arguments:
			[ ] //  MAP mMap
			[ ] //  STRING f_sKey
			[ ] //Return codes: none
			[ ] //Example:
			[ ] //  mNumbers = {...}
			[ ] //    {1, "one"}
			[ ] //    {2, "two"}
			[ ] //    {3, "three"}
			[ ] //  x = MapHasKey (mNumbers, 4) ? MapGet (4) : 0
			[ ] //
			[ ] //****************************************************************************
		[+] BOOLEAN MapHasKey (MAP h, STRING f_sKey null)
			[ ] BOOLEAN bRet = false
			[ ] INTEGER i
			[+] for(i=ListCount(h);i>0;i--)
				[+] if(h[i].sKey == f_sKey)
					[ ] bRet = true
					[ ] break
			[ ] return bRet
		[ ] 
		[+] //******************************************************************************
    //**Function: ANYTYPE MapGet (mMap, f_sKey)
			[ ] //Description: Get value from a map by key
			[ ] //Arguments:
			[ ] //  MAP mMap
			[ ] //  STRING f_sKey
			[ ] //Return codes:
			[ ] //  ANYTYPE - value of mMap element with key f_sKey
			[ ] //Example:
			[ ] //  sLastName = MapGet (mPatient, "sLastName")
			[ ] //****************************************************************************
		[+] ANYTYPE MapGet (MAP h, ANYTYPE f_sKey null)
			[ ] ANYTYPE a = NULL
			[ ] PAIR p
			[+] for each p in h
				[+] if (p.sKey == f_sKey)
					[+] if(IsSet(p.aValue))
						[ ] a = p.aValue
					[ ] break
			[ ] return a
		[ ] 
		[+] //******************************************************************************
    //**Function: void MapSet (mMap, f_sKey, f_aValue)
			[ ] //Description: Set value in map for the given key
			[ ] //Arguments:
			[ ] //  MAP mMap
			[ ] //  STRING f_sKey
			[ ] //  ANYTYPE f_aValue
			[ ] //Return codes:
			[ ] //  none
			[ ] //Example:
			[ ] //  MapSet (mCapitals, "Japan", "Tokyo")
			[ ] //****************************************************************************
		[+] void MapSet (out MAP h, ANYTYPE f_sKey null, ANYTYPE f_aValue null)
			[ ] INTEGER i
			[+] for i = 1 to ListCount (h)
				[+] if h[i].sKey == f_sKey
					[ ] h[i].aValue = f_aValue
					[ ] return
			[ ] 
			[ ] h += [MAP]{{f_sKey, f_aValue}}
		[ ] 
		[+] //******************************************************************************
    //**Function: LIST OF STRING MapKeys (mMap)
			[ ] //Description: Returns list of all keys in a map
			[ ] //Arguments:
			[ ] //  MAP mMap
			[ ] //Return codes: list of keys
			[ ] //Example:
			[ ] //  mPatient = {...}
			[ ] //    {"sLastName", "Ivanov"}
			[ ] //    {"sFirstName", "Petr"}
			[ ] //    {"sAge", 100}
			[ ] //    {"sSex", "M - male"}
			[ ] //  LIST OF STRING lsRequiredFileds = MapKeys (mPatient)
			[ ] //
			[ ] //****************************************************************************
		[+] LIST OF STRING MapKeys (MAP mMap)
			[ ] LIST OF STRING lsKeys
			[ ] INTEGER i
			[ ] 
			[+] for i = 1 to ListCount (mMap)
				[+] if ListFind (lsKeys, mMap[i].sKey) == 0
					[ ] lsKeys += {mMap[i].sKey}
			[ ] return lsKeys
		[ ] 
		[ ] 
	[ ] 
	[+] //******************************************************************************
    //**Function: BOOLEAN ListMatchString(STRING f_sStringFind, LIST OF STRING f_lsList, INTEGER f_iLineStart optional, 
    //**INTEGER f_iLineStop optional, out INTEGER f_iReturnRow optional)
		[ ] //Description: Find text in list (list element in text)
		[ ] //Arguments:
		[ ] //  f_sStringFind - string to find
		[ ] //  f_lsList - list to search
		[ ] //  f_iLineStart - start row - optional
		[ ] //  f_iLineStop - stop row - optional
		[ ] //  f_iReturnRow - return row - optional
		[ ] //  f_bReverse - search in reverse order - optional, FALSE by default
		[ ] //Return codes:
		[ ] //  TRUE if string is found in the list
		[ ] //  FALSE if not
		[ ] //  f_iReturnRow - return row - optional
		[ ] //****************************************************************************
	[+] BOOLEAN ListMatchString (STRING f_sStringFind, LIST OF STRING f_lsList, INTEGER f_iLineStart optional, 
                      INTEGER f_iLineStop optional, out INTEGER f_iReturnRow optional, BOOLEAN f_bReverse optional)
		[ ] INTEGER i = 0			// counter
		[ ] INTEGER iStartLine	= 1	// start line
		[ ] INTEGER iStopLine = 1	// stop line
		[ ] INTEGER iStep = 1		// loop step
		[ ] BOOLEAN bReturn = FALSE // return value
		[ ] 
		[+] if IsNull (f_bReverse)
			[ ] f_bReverse = FALSE
		[+] if IsNull (f_iLineStart)
			[ ] f_iLineStart = 1
		[+] if IsNull (f_iLineStop)
			[ ] f_iLineStop = ListCount(f_lsList)
		[ ] 
		[ ] iStartLine = f_bReverse ? f_iLineStop : f_iLineStart
		[ ] iStopLine = f_bReverse ? f_iLineStart : f_iLineStop
		[+] if (f_bReverse)
			[ ] iStep = -1
		[ ] 
		[+] for i = iStartLine to iStopLine step iStep
			[+] if MatchStr ("*{f_lsList[i]}*", f_sStringFind)
				[ ] bReturn = TRUE
				[ ] f_iReturnRow = i
				[ ] break
		[ ] return (bReturn)
		[ ] 
	[ ] 
	[+] //******************************************************************************
    //**Function: BOOLEAN ListMatchPhoto(STRING f_sStringFind, LIST OF STRING f_lsList, INTEGER f_iLineStart optional, 
    //**INTEGER f_iLineStop optional, out INTEGER f_iReturnRow optional)
		[ ] //Description: Find text in list (text list element)
		[ ] //Arguments:
		[ ] //  f_sStringFind - string to find
		[ ] //  f_lsList - list to search
		[ ] //  f_iLineStart - start row - optional
		[ ] //  f_iLineStop - stop row - optional
		[ ] //  f_iReturnRow - return row - optional
		[ ] //  f_bReverse - search in reverse order - optional, FALSE by default
		[ ] //Return codes:
		[ ] //  TRUE if string is found in the list
		[ ] //  FALSE if not
		[ ] //  f_iReturnRow - return row - optional
		[ ] //****************************************************************************
	[+] BOOLEAN ListMatchPhoto (STRING f_sStringFind, LIST OF STRING f_lsList, INTEGER f_iLineStart optional, 
                      INTEGER f_iLineStop optional, out INTEGER f_iReturnRow optional, BOOLEAN f_bReverse optional)
		[ ] INTEGER i = 0			// counter
		[ ] INTEGER iStartLine	= 1	// start line
		[ ] INTEGER iStopLine = 1	// stop line
		[ ] INTEGER iStep = 1		// loop step
		[ ] BOOLEAN bReturn = FALSE // return value
		[ ] INTEGER iFrom, iTo
		[ ] 
		[+] if IsNull (f_bReverse)
			[ ] f_bReverse = FALSE
		[+] if IsNull (f_iLineStart)
			[ ] f_iLineStart = 1
		[+] if IsNull (f_iLineStop)
			[ ] f_iLineStop = ListCount(f_lsList)
		[ ] 
		[ ] iStartLine = f_bReverse ? f_iLineStop : f_iLineStart
		[ ] iStopLine = f_bReverse ? f_iLineStart : f_iLineStop
		[+] if (f_bReverse)
			[ ] iStep = -1
		[ ] 
		[+] for i = iStartLine to iStopLine step iStep
			[ ] 
			[ ] iFrom = StrPos ("\", f_lsList[i], TRUE)
			[+] if iFrom != 0
				[ ] iFrom++
			[ ] 
			[ ] iTo = StrPos (" ", f_lsList[i], iFrom)
			[+] if iTo == 0
				[ ] iTo = Len (f_lsList[i])
			[ ] 
			[+] if MatchStr ("*{f_sStringFind}*", SubStr (f_lsList[i], iFrom, (iTo > iFrom ? (iTo - iFrom) : Len (f_lsList[i]))))
				[ ] bReturn = TRUE
				[ ] f_iReturnRow = i
				[ ] break
		[ ] 
		[+] if !bReturn
			[+] for i = iStartLine to iStopLine step iStep
				[+] if MatchStr ("*{f_sStringFind}*", f_lsList[i])
					[ ] bReturn = TRUE
					[ ] f_iReturnRow = i
					[ ] break
			[ ] 
		[ ] 
		[ ] return (bReturn)
		[ ] 
	[ ] 
	[+] //******************************************************************************
    //**Function: STRING ListToString(LIST OF STRING f_lsList, STRING f_sSeparator optional)
		[ ] //Description: Converts list of strings to string separated by Separator
		[ ] //Arguments:
		[ ] //  f_lsList - list of strings to convert
		[ ] //  f_sSeparator - separator string
		[ ] //Return codes:
		[ ] //  STRING - output string
		[ ] //****************************************************************************
	[+] STRING ListToString(LIST OF STRING f_lsList, STRING f_sSeparator optional)
		[ ] STRING sOut = (ListCount(f_lsList)==0) ? "" : f_lsList[1]
		[ ] STRING s
		[ ] INTEGER i
		[+] if(IsNull(f_sSeparator))
			[ ] f_sSeparator = Chr(10)
		[+] for(i=2;i<=ListCount(f_lsList);i++)
			[ ] sOut = "{sOut}{f_sSeparator}{f_lsList[i]}"
		[ ] return sOut
	[ ] 
	[+] // description
		[ ] // f_lpList - input list
		[ ] // f_iIndex - key index of list, 1 by default
		[+] // example
			[+] // LIST OF LIST OF STRING lls = {...}
				[ ] // {"x", "bb", "cc"}
				[ ] // {"i", "o", "a"}
				[ ] // {"e", "r", "t", "p", "e"}
			[ ] // print (ListOfListSortHoriz (lls, 3))
			[ ] // >> {i, o,  a}
			[ ] // >> {x, bb, cc}
			[ ] // >> {e, r,  t, p, e}}
	[+] LIST OF LIST OF ANYTYPE ListOfListSortHoriz (LIST OF LIST OF ANYTYPE f_llpList, int f_iIndex optional)
		[ ] int i
		[ ] 
		[+] if !IsNull (f_iIndex) && f_iIndex != 1
			[+] for i = 1 to ListCount (f_llpList)
				[+] if ListCount (f_llpList[i]) < f_iIndex
					[ ] print ("*** Sublist #{i} is shorter then key position!")
					[ ] return NULL
				[ ] ListInsert (f_llpList[i], 1, f_llpList[i][f_iIndex])
			[ ] ListSort (f_llpList)
			[+] for i = 1 to ListCount (f_llpList)
				[ ] ListDelete (f_llpList[i], 1)
		[+] else
			[ ] ListSort (f_llpList)
		[ ] 
		[ ] return f_llpList
	[ ] 
	[ ] // reverse horizontal and vertical rows
	[+] LIST OF LIST OF ANYTYPE Transpone (LIST OF LIST OF ANYTYPE f_llpList)
		[ ] int i, j, iLen = ListCount (f_llpList[1])
		[ ] LIST OF LIST OF ANYTYPE llRet = {}
		[ ] 
		[+] for i = 1 to iLen//ListCount (f_llpList)
			[ ] ListAppend (llRet, {})
			[+] for j = 1 to ListCount (f_llpList)//iLen
				[ ] ListAppend (llRet[i], f_llpList[j][1])
				[ ] ListDelete (f_llpList[j], 1)
		[ ] 
		[ ] return llRet
	[ ] 
	[+] // description
		[ ] // f_lpList - input list
		[ ] // f_iIndex - key index of list, 1 by default
		[+] // example
			[+] // LIST OF LIST OF STRING lls = {...}
				[ ] // {"x", "bb", "cc"}
				[ ] // {"i", "o", "a"}
				[ ] // {"e", "r", "t"}
			[ ] // print (ListOfListSortVert (lls, 1))
			[ ] // >> {bb, cc, x}
			[ ] // >> {o,  a,  i}
			[ ] // >> {r,  t,  e}
	[+] LIST OF LIST OF ANYTYPE ListOfListSortVert (LIST OF LIST OF ANYTYPE f_llpList, int f_iIndex optional)
		[ ] return Transpone (ListOfListSortHoriz (Transpone (f_llpList), f_iIndex))
	[ ] 
[ ] // ---------------------------------------------------------------------------
[ ] 
[ ] 
[ ] // ----------------------------- CONFIGURATION -------------------------------
[ ] 
[ ] STRING sVariant = ""	// for variant sandboxes
[ ] 
[ ] // List the directories to seach for help text
[+] list of SourceDirectories lsrSource = {...}
	[ ] // {sDir,					bUseSubDir}
	[ ] 
	[ ] {"{SilkDir}AG_SoftAR",		TRUE}			// NOTE: SilkDir is a Runtime Compiler constant pointing to the root of automation scripts (C:\SilkTest\)
	[ ] {"{SilkDir}GUICommon",		TRUE}
	[ ] {"{SilkDir}Common",			TRUE}
	[ ] {"{SilkDir}Common_Tools",	TRUE}
	[ ] {"{SilkDir}LMG_LabMicGUI",	TRUE}
	[ ] 
[ ] 
[ ] // File extensions to use
[+] list of string lsExtensions = {...}
	[ ] "inc"
	[ ] "t"
[ ] 
[ ] // Path to directory with script
[ ] STRING sWorkingDir = "!WORK\silk_help_generator\"
[ ] 
[ ] // In this folder group of functions = file name
[+] LIST OF STRING lsGroupFunctions = {...}
	[ ] "Common"
	[ ] "Common_Tools"
[ ] 
[ ] // Rename authors
[+] MAP mAuthorReplace = {...}
	[ ] // form						to
	[ ] {"vass Vasyl Evdokymov", 	"vass"}
	[ ] {"Yaroslav Yakovets", 		"yyak"}
[ ] 
[ ] // location to save the new 4Text file
[ ] string Save_4Text_Location = SilkDir + sWorkingDir			
[ ] 
[ ] string Orginal_4Text_Location = SYS_GetRegistryValue (HKEY_LOCAL_MACHINE, "SOFTWARE\Segue Software Inc\SilkTest\7.5", "DIRECTORY")
[ ] 
[ ] // USE PHOTOS
[ ] boolean bUsePhotos = TRUE
[ ] STRING sPhotoServer = "\\ISD103\Photos\guys"	// shared filder with photos
[ ] 
[ ] // CREATE HTML HELP
[ ] boolean bCreateHTMLHelp = TRUE
[ ] 
[ ] // delimeter for the html help file's
[ ] string sObjectDelimiter = "~"
[ ] 
[ ] string sBaseAutomationFolder = SilkDir
[ ] string sHelpTitle = "Autotesting Team 4Test Help"
[ ] string sHTMLSaveLocation = SilkDir + sWorkingDir + "Helps\Help" + "_" + FormatDateTime (GetDateTime (), "mm_dd_hhmm")
[ ] string sHTMLTemplatesLocation = SilkDir + sWorkingDir + "\HTML_Templates"
[ ] 
[ ] // DIVIDE TO MULTIPLE PROJECTS
[ ] boolean bMultipleProjects = TRUE
[+] list of MultipleProjects lrcProjects = {...}
	[ ] // {sDir,							sSaveTo, 			sName}		//NOTE: if "sSaveTo" coincide - "sName" be coincide too (1-st in list)
	[ ] 
	[ ] {"{SilkDir}AG_SoftAR", 			"AG_SoftAR", 		"AG_SoftAR"}
	[ ] {"{SilkDir}GUICommon", 			"GUICommon", 		"GUICommon"}
	[ ] {"{SilkDir}Common", 			"Common", 			"Common"}
	[ ] {"{SilkDir}Common_Tools", 		"Common", 			"Common"}
	[ ] {"{SilkDir}LMG_LabMicGUI", 		"LMG_LabMicGUI", 	"LabMicGUI"}
	[ ] 
[ ] 
[ ] // print trace
[ ] BOOLEAN bTrace = FALSE
[ ] 
[ ] 
[ ] // --------------------------- DATA RECORDS --------------------
[+] type SourceDirectories is record
	[ ] string		sDir
	[ ] boolean		bUseSubDir
[+] type MultipleProjects is record
	[ ] string		sDir
	[ ] string		sSaveTo
	[ ] string		sName
[+] private type Stats is record
	[ ] integer		iFilesProcessed
	[ ] integer		iDirProcessed
	[ ] integer		iMethods
	[ ] integer		iFunctions
	[ ] // integer		iPropertyes			// TODO: add
[+] private type DataRecord is record
	[ ] string		sType
	[ ] string		sURL
[+] private type GenHelp is record
	[ ] string			sKeyword
	[ ] string			sText
	[ ] list of string	lsExample
[+] private type Parameters is record
	[ ] string		sParam
	[ ] string		sDesc
	[ ] boolean		bOptional
	[ ] list of string	lsExample
[ ] 
[ ] private list of DataRecord rcData
[ ] private list of DataRecord rcDataFunctions
[ ] 
[ ] private Stats rcStat = {0,0, 0, 0}
[ ] 
[ ] // ------------- GLOBAL VARIABLES ------------------------------
[ ] private string sCurrentFile
[ ] private integer tocTab = 0
[ ] private integer tocCount = 0
[ ] private string sCurrentDir
[ ] 
[ ] string sFStart = "Function:"
[ ] string sMStart = "Method:"
[ ] string sPStart = "Property:"
[ ] 
[ ] MAP mAuthors = {}
[ ] 
[ ] // -------------- Directory Management -------------------------
[+] private InitializeDirectory()
	[ ] 
	[ ] string sDir = Save_4Text_Location + "\SilkHelpGen_Temp"
	[ ] string sOrgFile = Orginal_4Text_Location + "\4test.txt"
	[ ] string sCopyTo = sDir + "\4test.txt"
	[+] list of string lsHtmlCopy = {...}
		[ ] "blank.htm"
		[ ] "displayToc.js"
		[ ] "tocParas.js"
		[ ] "images\folder.gif"
		[ ] "images\folderopen.gif"
		[ ] "images\home.png"
		[ ] "images\information.png"
		[ ] "images\join.gif"
		[ ] "images\joinbottom.gif"
		[ ] "images\line.gif"
		[ ] "images\minus_tree.gif"
		[ ] "images\minusbottom.gif"
		[ ] "images\page.gif"
		[ ] "images\plus_tree.gif"
		[ ] "images\plusbottom.gif"
		[ ] "images\plus_silk.jpg"
		[ ] "images\minus_silk.jpg"
		[ ] "images\none.jpg"
		[ ] "images\back.gif"
		[ ] "images\forward.gif"
		[ ] "images\down.gif"
		[ ] "images\up.gif"
		[ ] "images\user.gif"
		[ ] "images\cut.gif"
		[ ] "images\clippy.swf"
	[ ] 
	[ ] string sFile
	[ ] HFILE FileHandle
	[ ] MultipleProjects rcProject
	[ ] 
	[ ] // create the directory, or remove any existing files if it exists
	[+] if (!SYS_DirExists (sDir))
		[ ] SYS_MakeDir (sDir)
	[+] else
		[ ] RemoveFiles (GetFileNames(sDir))
	[ ] 
	[ ] // copy the Segue 4test.txt into this new folder
	[ ] SYS_CopyFile(sOrgFile, sCopyTo)
	[ ] 
	[ ] // ******* CREATE HTML HELP ******
	[+] if bCreateHTMLHelp
		[+] if (!SYS_DirExists (sHTMLSaveLocation))
			[ ] SYS_MakeDir (sHTMLSaveLocation)
			[ ] SYS_MakeDir (sHTMLSaveLocation + "\images")
			[ ] SYS_MakeDir (sHTMLSaveLocation + "\HelpAPI{sVariant}")
			[ ] SYS_MakeDir (sHTMLSaveLocation + "\HelpAPI{sVariant}\API")
			[ ] SYS_MakeDir (sHTMLSaveLocation + "\HelpAPI{sVariant}\Code")
			[ ] SYS_MakeDir (sHTMLSaveLocation + "\js")
			[ ] 
			[+] if bMultipleProjects
				[+] for each rcProject in lrcProjects
					[+] if !SYS_DirExists (sHTMLSaveLocation + "\HelpAPI{sVariant}\" + rcProject.sSaveTo)
						[ ] SYS_MakeDir (sHTMLSaveLocation + "\HelpAPI{sVariant}\" + rcProject.sSaveTo)
					[+] if !SYS_DirExists (sHTMLSaveLocation + "\HelpAPI{sVariant}\Code\" + rcProject.sSaveTo)
						[ ] SYS_MakeDir (sHTMLSaveLocation + "\HelpAPI{sVariant}\Code\" + rcProject.sSaveTo)
					[ ] 
		[+] else
			[ ] // remove API files
			[ ] RemoveFiles (GetFileNames(sHTMLSaveLocation + "\HelpAPI{sVariant}"))
			[ ] 
			[+] if bMultipleProjects
				[+] for each rcProject in lrcProjects
					[ ] RemoveFiles (GetFileNames(sHTMLSaveLocation + "\HelpAPI{sVariant}\" + rcProject.sSaveTo))
			[ ] 
		[ ] 
		[ ] // delete existing base files
		[+] for each sFile in lsHtmlCopy
			[+] if (SYS_FileExists(sHTMLSaveLocation + "\" + sFile))
				[ ] SYS_RemoveFile(sHTMLSaveLocation + "\" + sFile)
		[ ] 
		[ ] // copy base files
		[+] for each sFile in lsHtmlCopy
			[ ] sOrgFile = sHTMLTemplatesLocation + "\" + sFile
			[ ] sCopyTo = sHTMLSaveLocation + "\" + sFile
			[ ] SYS_CopyFile(sOrgFile, sCopyTo)
		[ ] 
		[ ] // copy all js folder
		[ ] SYS_Execute ("xcopy {sHTMLTemplatesLocation}\js {sHTMLSaveLocation}\js /S")
		[ ] 
		[ ] // intialize the Table of Contents
		[ ] FileHandle = FileOpen (sHTMLSaveLocation + "\tocTab{sVariant}.js",  FM_WRITE)
		[ ] FileWriteLine (FileHandle, "var tocTab = new Array();")
		[ ] FileWriteLine (FileHandle, "")
		[ ] FileWriteLine (FileHandle, "tocTab[0] = new Array (""0"", ""{sHelpTitle}"", ""HelpAPI{sVariant}/API/API_Home.htm"");")
		[ ] FileWriteLine (FileHandle, "")
		[ ] FileClose (FileHandle)
		[ ] 
		[ ] // intialize the index file
		[ ] FileHandle = FileOpen (sHTMLSaveLocation + "\index.html",  FM_WRITE)
		[ ] FileWriteLine (FileHandle, "<html>")
		[ ] FileWriteLine (FileHandle, "<head>")
		[ ] FileWriteLine (FileHandle, "<title>{sHelpTitle}</title>")
		[ ] FileWriteLine (FileHandle, "<script language=""JavaScript"" src=""tocTab{sVariant}.js""></script>")
		[ ] FileWriteLine (FileHandle, "<script language=""JavaScript"" src=""tocParas.js""></script>")
		[ ] FileWriteLine (FileHandle, "<script language=""JavaScript"" src=""displayToc.js""></script>")
		[ ] FileWriteLine (FileHandle, "</head>")
		[ ] FileWriteLine (FileHandle, "<frameset cols=""280,*"" border=1 onload=""reDisplay('0',true);"">")
		[ ] FileWriteLine (FileHandle, "	<frame src=""blank.htm"" name=""toc"">")
		[ ] FileWriteLine (FileHandle, "	<frame src=""blank.htm"" name=""content"">")
		[ ] FileWriteLine (FileHandle, "</frameset>")
		[ ] FileWriteLine (FileHandle, "")
		[ ] 
		[ ] FileClose (FileHandle)
		[ ] 
	[ ] 
[+] private RemoveTempDir()
	[ ] 
	[ ] string sDir = Save_4Text_Location + "\SilkHelpGen_Temp"
	[ ] 
	[ ] // create the directory, or remove any existing files if it exists
	[ ] RemoveFiles (GetFileNames(sDir))
	[ ] 
	[ ] // remove the directory
	[ ] SYS_RemoveDir (sDir)
	[ ] 
[ ] 
[+] private list of string GetFileNames(string sDir, boolean bUseExt optional)
	[ ] list of string lsFileNames
	[ ] LIST OF FILEINFO lfFiles
	[ ] INTEGER iCount
	[ ] string sFullFile, sExt
	[ ] 
	[+] if IsNull(bUseExt)
		[ ] bUseExt = false
	[ ] 
	[ ] lfFiles = SYS_GetDirContents (sDir)
	[ ] 
	[+] for iCount = 1 to ListCount (lfFiles)
		[+] if (!lfFiles[iCount].bIsDir)
			[ ] sFullFile = "{sDir}\{lfFiles[iCount].sName}"
			[ ] 
			[+] if (bUseExt)
				[ ] sExt = GetFileExtension(lfFiles[iCount].sName)
				[+] if sExt != ""
					[+] if (ListFind(lsExtensions, sExt) > 0)
						[ ] ListAppend(lsFileNames, sFullFile)
			[+] else
				[ ] ListAppend(lsFileNames, sFullFile)
	[ ] 
	[ ] return lsFileNames
	[ ] 
[+] private list of string GetAPIFiles(string sDir)
	[ ] list of string lsFileNames
	[ ] LIST OF FILEINFO lfFiles
	[ ] INTEGER iCount
	[ ] string sFullFile
	[ ] 
	[ ] lfFiles = SYS_GetDirContents (sDir)
	[ ] 
	[+] for iCount = 1 to ListCount (lfFiles)
		[+] if (!lfFiles[iCount].bIsDir)
			[ ] sFullFile = "{lfFiles[iCount].sName}"
			[ ] 
			[ ] ListAppend(lsFileNames, sFullFile)
	[ ] 
	[ ] return lsFileNames
	[ ] 
[+] private string GetFileExtension (string sFileName)
	[ ] 
	[ ] STRING sExtension = ""
	[ ] 
	[ ] INTEGER iDotPos = StrPos (".", sFileName)
	[+] if (iDotPos == 0)
		[ ] sExtension = ""
	[+] else
		[ ] sExtension = SubStr (sFileName, iDotPos+1)
	[ ] 
	[ ] return (sExtension)
	[ ] 
[+] private string GetSaveToFolder()
	[ ] integer iPos = 0
	[ ] MultipleProjects rcProject
	[ ] list of string lsProjectsDir = {}
	[ ] string sFullDir
	[ ] string sFind = ""
	[ ] 
	[+] if (bMultipleProjects)
		[+] for each rcProject in lrcProjects
			[ ] ListAppend(lsProjectsDir, rcProject.sDir)
			[ ] 
			[+] if (Left(sCurrentDir, Len(rcProject.sDir)) == rcProject.sDir)
				[ ] sFind = rcProject.sDir
		[ ] 
		[+] if sFind != ""
			[ ] iPos = ListFind(lsProjectsDir, sFind)
		[+] if iPos > 0
			[ ] sFullDir = sHTMLSaveLocation + "\HelpAPI{sVariant}\" + lrcProjects[iPos].sSaveTo + "\" 
		[+] else
			[ ] sFullDir = sHTMLSaveLocation + "\HelpAPI{sVariant}\" 
	[+] else
		[ ] sFullDir = sHTMLSaveLocation + "\HelpAPI{sVariant}\"
	[ ] 
	[ ] return sFullDir
	[ ] 
[ ] 
[+] private list of string GetSubDirectories(string sDir)
	[ ] list of string lsDirs
	[ ] LIST OF FILEINFO lfFiles
	[ ] INTEGER iCount
	[ ] string sFullDir
	[ ] 
	[ ] lfFiles = SYS_GetDirContents (sDir)
	[ ] 
	[+] for iCount = 1 to ListCount (lfFiles)
		[+] if (lfFiles[iCount].bIsDir)
			[ ] sFullDir = sDir + "\" + lfFiles[iCount].sName
			[ ] ListAppend(lsDirs, sFullDir)
	[ ] 
	[ ] return lsDirs
	[ ] 
[+] private RemoveFiles(list of string lsFileNames)
	[ ] string sFile
	[ ] 
	[+] for each sFile in lsFileNames
		[+] if (SYS_FileExists(sFile))
			[ ] SYS_RemoveFile(sFile)
	[ ] 
[ ] 
[ ] // ------------- Help Processing --------------------------------
[+] private ProcessDirectory(SourceDirectories rcDir)
	[ ] 
	[ ] list of string lsFileNames
	[ ] list of string lsSubDir
	[ ] string sFile, sDir
	[ ] 
	[ ] print("")
	[ ] print("** Processing Directory: {rcDir.sDir} ....")
	[ ] rcStat.iDirProcessed++
	[ ] sCurrentDir = rcDir.sDir
	[ ] 
	[ ] lsFileNames = GetFileNames(rcDir.sDir, true)
	[ ] 
	[+] for each sFile in lsFileNames
		[ ] 
		[+] if bTrace
			[ ] print("   -- Processing File:   {sFile} ....")
		[ ] 
		[ ] rcStat.iFilesProcessed++
		[ ] 
		[ ] sCurrentFile = StrTran(sFile, sBaseAutomationFolder + "\", ".\")
		[ ] 
		[ ] // call code to process
		[ ] GenerateHelp(sFile, rcDir.sDir)
		[ ] 
	[ ] 
	[ ] // process sub-directories
	[+] if rcDir.bUseSubDir
		[ ] lsSubDir = GetSubDirectories(rcDir.sDir)
		[ ] 
		[+] for each sDir in lsSubDir
			[ ] ProcessDirectory({sDir, rcDir.bUseSubDir})
			[ ] 
	[ ] 
[ ] 
[ ] // ------------- Help Generation --------------------------------
[+] private GenerateHelp(string sFile, string sDir)
	[ ] list of string lsCodeLines
	[ ] list of string lsHelpCode
	[ ] string sLine, sGroup = "none"
	[ ] boolean bFoundStart = false
	[ ] boolean bFoundEnd = false
	[ ] list of GenHelp lsGenHelp
	[ ] integer i, j, k, iStr = 0
	[ ] 
	[ ] LIST OF STRING lsFuncNew
	[ ] STRING sPrefix
	[ ] INTEGER iFrom, iTo
	[ ] BOOLEAN bFuncStart
	[ ] 
	[ ] STRING sTCName 		= ""
	[ ] STRING sTCAuthor 	= ""
	[ ] LIST OF STRING lsCode = {}
	[ ] INTEGER iPos, n = 0
	[ ] STRING sCodeLine, sFolder
	[ ] 
	[ ] lsCodeLines = SYS_GetFileContents(sFile)
	[+] for each sLine in lsCodeLines
		[ ] iStr++
		[ ] i=StrPos("//", sLine)
		[ ] 
		[+] if (i == 0) && (Len (Trim (sLine)) == Len ("[ ]"))
			[ ] i=StrPos("[ ]", sLine)
		[ ] 
		[+] if((i > 0))	//**Function: 
			[+] if (!bFoundStart)
				[+] if (StrPos(sFStart, sLine) > 0 || StrPos(sMStart, sLine) > 0 || StrPos(sPStart, sLine) > 0)
					[ ] ListAppend(lsHelpCode, sLine) // line is part of help
					[ ] bFoundStart = TRUE
			[+] else
				[ ] ListAppend(lsHelpCode, sLine) // line is part of help
		[+] else
			[+] if (bFoundStart)
				[ ] ListDelete(lsHelpCode, ListCount(lsHelpCode))
				[ ] 
				[ ] lsFuncNew = {}
				[ ] iFrom = 0
				[ ] iTo = 0
				[ ] bFuncStart = FALSE
				[ ] sPrefix = ""
				[ ] 
				[+] for j = 1 to ListCount (lsHelpCode)
					[+] if (StrPos ("(", lsHelpCode[j]))
						[ ] iFrom = j
						[ ] iTo = j
						[ ] sPrefix = SubStr (lsHelpCode[j], 1, StrPos (":", lsHelpCode[j]))
						[ ] 
					[+] if (StrPos (")", lsHelpCode[j]))
						[ ] iTo = j
						[ ] break
					[ ] 
				[ ] 
				[+] if ListCount (lsHelpCode) > 0
					[+] for j = iFrom to iTo
						[ ] ListDelete (lsHelpCode, 1)
				[ ] 
				[+] for j = iStr to ListCount (lsCodeLines)
					[ ] 
					[+] if !bFuncStart
						[+] if ListCount (lsFuncNew) >= 1
							[ ] lsFuncNew += {lsCodeLines[j]}
						[ ] 
						[+] if ((StrPos("[+]", lsCodeLines[j]) > 0) || (StrPos("[-]", lsCodeLines[j]) > 0)) && (StrPos("(", lsCodeLines[j]) > 0)
							[ ] lsFuncNew += {lsCodeLines[j]}
						[ ] 
						[+] if (StrPos(")", lsCodeLines[j]) > 0)
							[ ] lsCode = {}
							[ ] 
							[ ] lsFuncNew = {ListToString (lsFuncNew, "<br>[ ] // ")}
							[ ] 
							[ ] bFuncStart = TRUE
							[ ] n = 0
					[+] else
						[+] if (bFuncStart) && (ListCount (lsFuncNew) > 0)
							[ ] 
							[ ] sCodeLine = lsCodeLines[j]
							[ ] 
							[+] if (StrPos ("[", sCodeLine) == 0)	|| (Trim (SubStr (sCodeLine, 1, StrPos ("[", sCodeLine) - 1)) != "")	// add ...[] for line with shift+enter
								[ ] 
								[+] if StrPos ("[", lsCode[ListCount (lsCode)]) != 0
									[ ] iPos = StrPos ("[", lsCode[ListCount (lsCode)])
								[ ] 
								[ ] sCodeLine = StrTran (SubStr (lsCode[ListCount (lsCode)], 1, iPos), "[", "   ") + sCodeLine
							[ ] 
							[ ] // found end of code
							[+] if (StrPos ("[", sCodeLine) > 0) && (StrPos ("[", lsFuncNew[1]) >= StrPos ("[", sCodeLine))
								[ ] 
								[ ] n += StrPos ("[", lsFuncNew[1]) - StrPos ("[", sCodeLine)
								[ ] n++
								[ ] 
								[ ] lsCode = lsFuncNew + lsCode
								[ ] 
								[ ] lsCode[1] = StrTran(lsCode[1], "[+]", "[+]<!-->[+]</-->")	// link with [+]
								[ ] lsCode[1] = StrTran(lsCode[1], "[-]", "[+]<!-->[+]</-->")	// link with [-]
								[ ] lsCode[1] = StrTran(lsCode[1], "[ ] //", "[shiftenter]")	// mark delete [ ] (shift+enter)
								[ ] 
								[ ] lsCode[1] = lsCode[1] + "<br><!-->Begin</-->"	// begin of collapse block
								[ ] 
								[+] for j = 1 to n
									[ ] lsCode += {"{Replicate (" ", n - j)}<!-->End</--><br>"}		// end of collapse block
								[ ] 
								[ ] break
							[ ] 
							[+] if (StrPos ("[+]", sCodeLine) > 0) || (StrPos ("[-]", sCodeLine) > 0)
								[ ] 
								[ ] n++
								[ ] sCodeLine = StrTran(sCodeLine, "[+]", "[+]<!-->[+]</-->")	// link with [+]
								[ ] sCodeLine = StrTran(sCodeLine, "[-]", "[+]<!-->[+]</-->")	// link with [-]
								[ ] sCodeLine = sCodeLine + "<br><!-->Begin</-->"	// begin of collapse block
							[+] else
								[ ] sCodeLine = sCodeLine + "<br>"
							[ ] 
							[+] if j < ListCount (lsCodeLines) && (StrPos ("[", lsCodeLines[j+1]) > 0)
								[+] if StrPos ("[", sCodeLine) > StrPos ("[", lsCodeLines[j+1])
									[+] for k = 1 to (StrPos ("[", sCodeLine) - StrPos ("[", lsCodeLines[j+1]))
										[ ] n--
										[ ] sCodeLine = sCodeLine + "<!-->End</-->"		// end of collapse block
							[ ] 
							[ ] lsCode += {sCodeLine}
							[ ] 
					[ ] 
				[ ] 
				[+] if ListCount (lsFuncNew) > 0 
					[ ] lsFuncNew[1] = StrTran (lsFuncNew[1], "[+]", "[-]")
					[ ] lsFuncNew[1] = StrTran (lsFuncNew[1], "[-]", sPrefix)
					[ ] lsHelpCode = lsFuncNew + lsHelpCode
				[ ] 
				[ ] bFoundEnd = TRUE
		[ ] 
		[+] if (bFoundEnd)
			[ ] 
			[ ] // find class for method (if needed)
			[ ] 
			[+] for each sLine in lsHelpCode
				[ ] 
				[+] if (StrPos (sFStart, sLine) > 0) && (StrPos ("_Frame.inc", SubStr (sFile, StrPos ("\", sFile, TRUE) + 1)) == 0)	// if function - generate group
					[ ] 
					[+] if SubStr (sFile, StrPos (".", sFile, TRUE)) == ".t"	// if TestCase - generate group: User functions - filename
						[ ] sGroup = SubStr (sFile, StrPos ("\", sFile, TRUE) + 1)
						[ ] sGroup = "User functions - " + SubStr (sGroup, 1, StrPos (".", sGroup, TRUE) - 1)		
						[ ] 
						[ ] // find TC name and get TC author
						[+] for j = iStr to ListCount (lsCodeLines)
							[ ] 
							[ ] // TC name
							[ ] iPos = StrPos("] testcase", lsCodeLines[j])
							[+] if iPos > 0
								[ ] sTCName = Trim (SubStr (lsCodeLines[j], iPos + 10))
								[ ] sTCName = StrTran (sTCName, chr (9), " ")
								[ ] sTCName = Trim (SubStr (sTCName, 1, StrPos (" ", sTCName) ))
								[ ] 
							[ ] 
							[ ] // Author TC
							[ ] iPos = StrPos("Author:", lsCodeLines[j])
							[+] if iPos > 0
								[ ] sTCAuthor = Trim (SubStr (lsCodeLines[j], iPos + 7))
								[ ] break
							[ ] 
						[ ] 
						[ ] break
					[ ] 
					[+] for each sFolder in lsGroupFunctions	// if Common - generate group: filename
						[ ] 
						[+] if StrPos (sFolder, sDir) > 0
							[ ] sGroup = SubStr (sFile, StrPos ("\", sFile, TRUE) + 1)
							[ ] sGroup = SubStr (sGroup, 1, StrPos (".", sGroup, TRUE) - 1)
							[ ] break
							[ ] 
						[+] else
							[ ] sGroup = SubStr (sDir, StrPos ("\", sDir, TRUE) + 1)
							[ ] break
							[ ] 
					[ ] 
				[+] else if (StrPos (sMStart, sLine) > 0) || (StrPos ("_Frame.inc", SubStr (sFile, StrPos ("\", sFile, TRUE) + 1)) > 0)	// if method - generate class
					[ ] 
					[ ] lsHelpCode[1] = StrTran (lsHelpCode[1], sFStart, sMStart)
					[ ] 
					[+] for j = iStr to 1 step -1
						[ ] 
						[+] if ( StrPos ("[+] window ", lsCodeLines[j]) > 0 ) || ( StrPos ("[-] window ", lsCodeLines[j]) > 0 )	// || ( StrPos ("] WINDOW ", lsCodeLines[j]) > 0 )
							[ ] sGroup = StrTran (lsCodeLines[j], chr (9), " ")
							[ ] sGroup = RTrim (sGroup)
							[ ] sGroup = LTrim (SubStr (sGroup, StrPos (" ", sGroup, TRUE ) + 1))
							[ ] break
							[ ] 
						[+] else if StrPos ("] winclass ", lsCodeLines[j]) > 0
								[ ] sGroup = SubStr (lsCodeLines[j], StrPos ("] winclass ", lsCodeLines[j]) + 11)
								[ ] sGroup = RTrim (SubStr (sGroup, 1, StrPos (":", sGroup) == 0 ? Len (sGroup) : StrPos (":", sGroup) - 1))
								[ ] break
								[ ] 
							[ ] 
					[ ] 
			[ ] 
			[ ] lsHelpCode = FormatHelp(lsHelpCode, sGroup, sTCName, sTCAuthor, lsCode) 	// add group or class if it not set
			[+] if(ListCount(lsHelpCode)>0)
				[ ] lsGenHelp = ExtractHelp(lsHelpCode)
				[ ] SaveHelp(lsGenHelp)
			[ ] lsGenHelp = {}
			[ ] lsHelpCode = {}
			[ ] bFoundEnd = FALSE
			[ ] bFoundStart = FALSE
		[ ] 
		[ ] // repeat until end of file (list in this case)
		[ ] 
	[ ] 
	[ ] // ******* CREATE HTML HELP ******
	[+] if bCreateHTMLHelp
		[ ] GenerateDataHelp(sFile)
	[ ] 
[+] private GenerateDataHelp(string sFile)
	[ ] list of string lsCodeLines
	[ ] list of string lsHelpCode
	[ ] string sLine, sOrginLine
	[ ] string sStart = "[ ] type "
	[ ] string sEnd1   = "[+]"
	[ ] string sEnd2   = "[-]"
	[ ] boolean bFoundStart = false
	[ ] boolean bFoundEnd = false
	[ ] list of string lsGenHelp
	[ ] 
	[ ] lsCodeLines = SYS_GetFileContents(sFile)
	[ ] 
	[+] for each sOrginLine in lsCodeLines
		[ ] 
		[ ] sLine = Ltrim (sOrginLine)   // becouse before may be tabs and witespases
		[+] if (!bFoundStart)
			[ ] sLine = StrTran(sLine, "[+", "[ ")
			[ ] sLine = StrTran(sLine, "[-", "[ ")
			[+] if (Left(sLine, 9) == sStart)
				[ ] bFoundStart = TRUE
				[ ] ListAppend(lsHelpCode, sLine)
		[+] else
			[+] if (Left(sLine, 3) == sEnd1) || (Left(sLine, 3) == sEnd2)
				[ ] bFoundEnd = TRUE
			[+] else
				[ ] // line is part of help
				[ ] ListAppend(lsHelpCode, sLine)
		[ ] 
		[+] if (bFoundEnd)
			[ ] lsGenHelp = ExtractDataHelp(lsHelpCode)
			[ ] CreateDataHTMLHelp(lsGenHelp)
			[ ] lsGenHelp = {}
			[ ] lsHelpCode = {}
			[ ] bFoundEnd = FALSE
			[ ] 
			[ ] sLine = StrTran(sLine, "[+", "[ ")
			[ ] sLine = StrTran(sLine, "[-", "[ ")
			[+] if (Left(sLine, 9) == sStart)
				[ ] bFoundStart = TRUE
				[ ] ListAppend(lsHelpCode, sLine)
			[+] else
				[ ] bFoundStart = FALSE
		[ ] 
		[ ] // repeat until end of file (list in this case)
		[ ] 
	[ ] 
[ ] 
[+] type Attributes is record
	[ ] string		sAttribute
	[ ] string 		sReplaceStr
[ ] 
[+] private list of string FormatHelp(list of string lsHelp, string sGroup, string sTCName, string sTCAuthor, list of string lsCode)
	[ ] list of string lsResult = {}
	[ ] list of string lsTmp = {}
	[ ] string sTmp
	[+] list of Attributes lsFAttr = {...}
		[ ] {" Group:", 				" @group:"}
		[ ] {sFStart, 					" @function:"}
		[ ] {"Return codes:", 			" @returns:"}
		[ ] {"Arguments:", 				" @parameter:"}
		[ ] {"Description:", 			" @notes:"}
		[ ] {"Example:", 				" @example:"}
		[ ] {"Author:", 				" @author:"}
	[+] list of Attributes lsMAttr = {...}
		[ ] {" Class:", 				" @class:"}
		[ ] {sMStart, 					" @method:"}
		[ ] {"Return codes:", 			" @returns:"}
		[ ] {"Arguments:", 				" @parameter:"}
		[ ] {"Description:", 			" @notes:"}
		[ ] {"Example:", 				" @example:"}
		[ ] {"Author:", 				" @author:"}
	[+] list of Attributes lsPAttr = {...}
		[ ] {"Class:", 					" @class:"}
		[ ] {sPStart, 					" @property:"}
		[ ] {"Description:", 			" @notes:"}
	[ ] 
	[+] MAP mFAttr = {...}
		[ ] {" @group:",		{" Group:", "*Group:", "//Group:"}	}
		[ ] {" @function:",		{sFStart}	}
		[ ] {" @returns:",		{"Return codes:", "Return:", "Returns:", "Result:", "Return values:", "Return value"}	}
		[ ] {" @parameter:",	{"Arguments:"}	}
		[ ] {" @notes:",		{"Description:"}	}
		[ ] {" @example:",		{"Example:", "Note:", "Generated exceptions:", "Call example:", "example:", "Examples:", "Example :", "Exceptions:", "Exception:", "NOTE:", "****************************************** SoftTest Info *******************************************"}	}
		[ ] {" @author:",		{"Author:"}	}
		[ ] 
	[+] MAP mMAttr = {...}
		[ ] {" @class:",		{" Class:", "*Class:", "//Class:", " Group:", "*Group:", "//Group:"}	}	//{"Class:"}	}
		[ ] {" @method:",		{sMStart}	}
		[ ] {" @returns:",		{"Return codes:", "Return:", "Returns:", "Result:", "Return values:", "Return value"}	}
		[ ] {" @parameter:",	{"Arguments:"}	}
		[ ] {" @notes:",		{"Description:"}	}
		[ ] {" @example:",		{"Example:", "Note:", "Generated exceptions:", "Call example:", "example:", "Examples:", "Example :", "Exceptions:", "Exception:", "NOTE:", "****************************************** SoftTest Info *******************************************"}	}
		[ ] {" @author:",		{"Author:"}	}
		[ ] 
	[+] MAP mPAttr = {...}
		[ ] {" @class:",		{"Class:"}	}
		[ ] {" @property:",		{sPStart}	}
		[ ] {" @notes:",		{"Description:"}	}
	[ ] 
	[ ] STRING sFind, sKey, sOriginalGroup
	[ ] LIST OF STRING lsFind
	[ ] INTEGER iLen = 0
	[ ] INTEGER iFrom = 1
	[ ] 
	[ ] boolean bNextProperty = false
	[ ] boolean bFound = false
	[ ] boolean bArguments = false
	[ ] Attributes sAttr
	[ ] integer i = 0
	[ ] integer j = 0
	[+] if(ListCount(lsHelp)>0)
		[ ] 
		[+] if(StrPos (sFStart, lsHelp[1]) > 0) 		// "//**Function:*"
			[ ] i = StrPos (sFStart, lsHelp[1])
			[ ] lsHelp[1] = "[ ] //"+Right(lsHelp[1], Len(lsHelp[1])-i+1)
			[+] for(i=1; i<=ListCount(lsHelp); i++)
				[ ] 
				[+] for(j=1; j<=ListCount(lsFAttr); j++)
					[ ] 
					[ ] lsFind = MapGet (mFAttr, lsFAttr[j].sReplaceStr)
					[ ] 
					[+] for each sFind in lsFind
						[ ] 
						[+] if StrPos (sFind, lsHelp[i])>0
							[ ] bFound = true
							[ ] 
							[+] if(StrPos("Author:", lsHelp[i])>0)
								[ ] bNextProperty = true
							[ ] 
							[ ] 
							[+] if(StrPos("Arguments:", lsHelp[i])>0)
								[ ] bArguments = true
							[+] else
								[ ] bArguments = false
							[ ] break
						[ ] 
					[ ] 
					[+] if bFound
						[ ] break
						[ ] 
				[+] if(bFound)
					[ ] 
					[+] if (lsFAttr[j].sReplaceStr == " @example:")
						[+] if lsFAttr[j].sAttribute == MapGet (mFAttr, lsFAttr[j].sReplaceStr) [1] //"Example:"
							[ ] lsFAttr[j].sAttribute = StrTran (lsHelp[i], sFind, lsFAttr[j].sReplaceStr + sFind + "<br>")
						[+] else
							[ ] lsFAttr[j].sAttribute +=  ("<br>" + StrTran (lsHelp[i], sFind, lsFAttr[j].sReplaceStr + sFind))
						[ ] 
					[+] else
						[+] if (j == 5 && lsFAttr[5].sAttribute != MapGet (mFAttr, lsFAttr[5].sReplaceStr) [1])
							[ ] j=6
							[ ] lsFAttr[j].sAttribute +=  ("<br>" + StrTran (lsHelp[i], sFind, lsFAttr[j].sReplaceStr + sFind) + "<br>")
							[ ] 
						[+] else 
							[+] if lsFAttr[j].sAttribute == MapGet (mFAttr, lsFAttr[j].sReplaceStr) [1]
								[+] if j == 5 		// Description
									[ ] lsFAttr[j].sAttribute = StrTran (lsHelp[i], sFind, lsFAttr[j].sReplaceStr) + "<br>"
								[+] else
									[ ] lsFAttr[j].sAttribute = StrTran (lsHelp[i], sFind, lsFAttr[j].sReplaceStr)
							[ ] 
							[+] else
								[ ] lsFAttr[j].sAttribute +=  ("<br>" + StrTran (lsHelp[i], sFind, lsFAttr[j].sReplaceStr + sFind))
						[ ] 
					[ ] 
					[+] for each sFind in {"[+]", "[-]"}
						[ ] lsFAttr[j].sAttribute = StrTran (lsFAttr[j].sAttribute, sFind, "[ ]")
					[ ] 
					[+] while(!bNextProperty)
						[ ] i++
						[+] if(i>ListCount(lsHelp))
							[ ] break
						[+] for each sAttr in lsFAttr
							[ ] 
							[+] if bNextProperty
								[ ] break
							[ ] 
							[ ] lsFind = MapGet (mFAttr, sAttr.sReplaceStr)
							[ ] 
							[+] for each sFind in lsFind
								[ ] 
								[+] if StrPos(sFind, lsHelp[i])>0
									[ ] bNextProperty = true
									[ ] i--
									[ ] break
							[ ] 
						[+] if(!bNextProperty)
							[+] if(bArguments && Len(Trim(lsFAttr[j].sAttribute)) > 18)
								[ ] lsFAttr[j].sAttribute += "†[ ] // @parameter: {lsHelp[i]}" 
							[+] else
								[ ] lsFAttr[j].sAttribute += " {lsHelp[i]}" + " <br>"
					[ ] bNextProperty = false
					[ ] bFound = false
			[ ] // @result attribute processing to satisfy Library Browser rules
			[ ] sTmp = Right(lsFAttr[2].sAttribute, Len(lsFAttr[2].sAttribute)-StrPos(":",lsFAttr[2].sAttribute))
			[ ] 
			[ ] sTmp = StrTran (sTmp, chr(9), " ")
			[ ] 
			[ ] i = StrPos("(",sTmp)-1
			[+] if(i>0)
				[ ] sTmp = Trim(Left(sTmp, i))
			[+] for(i=1,j=1; i<=Len(sTmp); i++)
				[+] if(sTmp[i]==" ")
					[ ] j=i
			[+] if(j>1)
				[ ] 
				[ ] sTmp = Trim(Left(sTmp, j))
				[ ] 
				[+] if lsFAttr[3].sAttribute == "Return codes:"
					[ ] lsFAttr[3].sAttribute = "[ ] // @returns:"
				[ ] 
				[+] if(MatchStr("VOID", sTmp))
					[ ] lsFAttr[2].sAttribute = StrTran(lsFAttr[2].sAttribute,"void","")
					[ ] lsFAttr[2].sAttribute = StrTran(lsFAttr[2].sAttribute,"VOID","")
				[+] else
					[ ] i = StrPos(sTmp,lsFAttr[2].sAttribute)
					[ ] lsFAttr[2].sAttribute = Left(lsFAttr[2].sAttribute,i-1)+"result ="+Right(lsFAttr[2].sAttribute, Len(lsFAttr[2].sAttribute)-Len(Left(lsFAttr[2].sAttribute,i-1))-Len(sTmp))
					[ ] i = StrPos(":",lsFAttr[3].sAttribute)
					[ ] lsFAttr[3].sAttribute = Left(lsFAttr[3].sAttribute, i)+" result: "+sTmp+"; <br>"+Right(lsFAttr[3].sAttribute, Len(lsFAttr[3].sAttribute)-i)
					[ ] 
			[ ] 
			[ ] // @group attribute processing
			[+] if(lsFAttr[1].sAttribute == " Group:")
				[ ] lsFAttr[1].sAttribute = "[ ] // @group: " + sGroup   // "[ ] // @group: User defined functions"
			[+] else
				[ ] lsFAttr[1].sAttribute = Trim (StrTran (StrTran (lsFAttr[1].sAttribute, chr(9), " "), "[ ]  ", "[ ] //"))
			[ ] 
			[ ] // @parameter attributes processing
			[ ] sTmp = Right(lsFAttr[4].sAttribute,Len(lsFAttr[4].sAttribute)-StrPos(":",lsFAttr[4].sAttribute)+1) 
			[ ] 
			[ ] // @Generated Return codes processing
			[+] if lsFAttr[3].sAttribute == "Return codes:"
				[ ] lsFAttr[3].sAttribute = ""
			[ ] 
			[ ] // @Generated Arguments processing
			[+] if lsFAttr[4].sAttribute == "Arguments:"
				[ ] lsFAttr[4].sAttribute = ""
			[ ] 
			[ ] // @Generated Description processing
			[+] if lsFAttr[5].sAttribute == "Description:"
				[ ] lsFAttr[5].sAttribute = ""
			[ ] 
			[ ] // @Generated Examples processing
			[+] if lsFAttr[6].sAttribute == "Example:"
				[ ] lsFAttr[6].sAttribute = ""
			[ ] 
			[ ] // @Author processing
			[+] if lsFAttr[7].sAttribute == "Author:"
				[+] if sTCAuthor != ""
					[ ] lsFAttr[7].sAttribute = "[ ] // @author: {sTCAuthor}"
				[+] else
					[ ] lsFAttr[7].sAttribute = "[ ] // @author: none"
			[ ] 
			[ ] // @Original Description processing
			[ ] sAttr.sAttribute = "[ ] // @originalnotes:" + ListToString (lsHelp, "<br>")
			[ ] sAttr.sReplaceStr = " @originalnotes:"
			[ ] lsFAttr += {sAttr}
			[ ] 
			[ ] // @TC Name Location processing
			[+] if sTCName != ""
				[ ] sAttr.sAttribute = "[ ] // @originallocation:" + sTCName
				[ ] sAttr.sReplaceStr = " @originallocation:"
				[ ] lsFAttr += {sAttr}
			[ ] 
			[ ] // @Code processing
			[ ] sAttr.sAttribute = ""
			[ ] sAttr.sReplaceStr = " @originalcode:"
			[+] if ListCount (lsCode) > 0
				[+] for i = 1 to ListCount (lsCode)
					[ ] iLen += Len (lsCode[i])
					[ ] sAttr.sAttribute += (lsCode[i])
					[+] if (iLen > 10000) && (StrPos ("<!-->Begin</-->", lsCode[i]) > 0)	// max string size
						[ ] 
						[+] while (i < ListCount (lsCode)) && StrPos ("<!-->End</-->", lsCode[i]) == 0
							[ ] i++
							[ ] iLen += Len (lsCode[i])
							[ ] sAttr.sAttribute += (lsCode[i])
							[ ] 
						[ ] sAttr.sAttribute += (lsCode[i])
						[ ] 
						[+] while (i < ListCount (lsCode)) && StrPos ("[+]<!-->[+]</-->", lsCode[i]) == 0
							[ ] i++
							[ ] iLen += Len (lsCode[i])
							[ ] sAttr.sAttribute += (lsCode[i])
							[ ] 
						[ ] 
						[ ] sAttr.sAttribute = "[ ] // @originalcode:"  + sAttr.sAttribute
						[ ] lsFAttr += {sAttr}
						[ ] 
						[ ] iLen = 0
						[ ] sAttr.sAttribute = ""
					[ ] 
				[ ] 
			[ ] sAttr.sAttribute = "[ ] // @originalcode:" + sAttr.sAttribute
			[ ] sAttr.sReplaceStr = " @originalcode:"
			[ ] lsFAttr += {sAttr}
			[ ] 
			[ ] // generating result list 
			[+] for(i=1; i <= ListCount(lsFAttr); i++)
				[+] if(StrPos("@parameter:", lsFAttr[i].sAttribute) > 0)
					[ ] j = split (lsFAttr[i].sAttribute, lsTmp, "†")
					[+] for each sTmp in lsTmp
						[ ] sTmp=StrTran(sTmp,"[ ] //  @", "[ ] // @")
						[ ] ListAppend(lsResult, sTmp)
				[+] else
					[ ] lsFAttr[i].sAttribute=StrTran(lsFAttr[i].sAttribute,"[ ] //  @", "[ ] // @")
					[ ] ListAppend(lsResult, lsFAttr[i].sAttribute)
				[ ] 
		[ ] 
		[+] else if(StrPos(sMStart, lsHelp[1]) > 0) 	// "//**Method:*"
			[ ] i = StrPos (sMStart, lsHelp[1])
			[ ] lsHelp[1] = "[ ] //"+Right(lsHelp[1], Len(lsHelp[1])-i+1)
			[+] for(i=1; i<=ListCount(lsHelp); i++)
				[ ] 
				[+] for(j=1; j<=ListCount(lsMAttr); j++)
					[ ] 
					[ ] lsFind = MapGet (mMAttr, lsMAttr[j].sReplaceStr)
					[ ] 
					[+] for each sFind in lsFind
						[+] if StrPos (sFind, lsHelp[i])>0
							[ ] bFound = true
							[ ] 
							[+] if(StrPos("Author:", lsHelp[i])>0)
								[ ] bNextProperty = true
							[ ] 
							[+] if(StrPos("Arguments:", lsHelp[i])>0)
								[ ] bArguments = true
							[+] else
								[ ] bArguments = false
							[ ] break
						[ ] 
					[ ] 
					[+] if bFound
						[ ] break
						[ ] 
				[+] if(bFound)
					[ ] 
					[+] if (lsMAttr[j].sReplaceStr == " @example:")
						[+] if lsMAttr[j].sAttribute == MapGet (mMAttr, lsMAttr[j].sReplaceStr) [1] //"Example:"
							[ ] lsMAttr[j].sAttribute = StrTran (lsHelp[i], sFind, lsMAttr[j].sReplaceStr + sFind + "<br>")
						[+] else
							[ ] lsMAttr[j].sAttribute +=  ("<br>" + StrTran (lsHelp[i], sFind, lsMAttr[j].sReplaceStr + sFind))
						[ ] 
					[+] else
						[+] if (j == 5 && lsMAttr[5].sAttribute != MapGet (mMAttr, lsMAttr[5].sReplaceStr) [1])
							[ ] j=6
							[ ] lsMAttr[j].sAttribute +=  ("<br>" + StrTran (lsHelp[i], sFind, lsMAttr[j].sReplaceStr + sFind) + "<br>")
							[ ] 
						[+] else 
							[+] if lsMAttr[j].sAttribute == MapGet (mMAttr, lsMAttr[j].sReplaceStr) [1]
								[+] if j == 5 		// Description
									[ ] lsMAttr[j].sAttribute = StrTran (lsHelp[i], sFind, lsMAttr[j].sReplaceStr) + "<br>"
								[+] else
									[ ] lsMAttr[j].sAttribute = StrTran (lsHelp[i], sFind, lsMAttr[j].sReplaceStr)
							[+] else
								[ ] lsMAttr[j].sAttribute +=  ("<br>" + StrTran (lsHelp[i], sFind, lsMAttr[j].sReplaceStr + sFind))
						[ ] 
					[ ] 
					[+] for each sFind in {"[+]", "[-]"}
						[ ] lsMAttr[j].sAttribute = StrTran (lsMAttr[j].sAttribute, sFind, "[ ]")
					[ ] 
					[+] while(!bNextProperty)
						[ ] i++
						[+] if(i>ListCount(lsHelp))
							[ ] break
						[+] for each sAttr in lsMAttr
							[ ] 
							[+] if bNextProperty
								[ ] break
							[ ] 
							[ ] lsFind = MapGet (mMAttr, sAttr.sReplaceStr)
							[ ] 
							[+] for each sFind in lsFind
								[+] if StrPos(sFind, lsHelp[i])>0
									[ ] bNextProperty = true
									[ ] i--
									[ ] break
							[ ] 
						[+] if(!bNextProperty)
							[+] if(bArguments && Len(Trim(lsMAttr[j].sAttribute)) > 18)
								[ ] lsMAttr[j].sAttribute += "†[ ] // @parameter: {lsHelp[i]}" 
							[+] else
								[ ] lsMAttr[j].sAttribute += " {lsHelp[i]}" + " <br>"
					[ ] bNextProperty = false
					[ ] bFound = false
			[ ] 
			[ ] // @result attribute processing to satisfy Library Browser rules
			[ ] sTmp = Right(lsMAttr[2].sAttribute, Len(lsMAttr[2].sAttribute)-StrPos(":",lsMAttr[2].sAttribute))
			[ ] 
			[ ] sTmp = StrTran (sTmp, chr(9), " ")
			[ ] 
			[ ] i = StrPos("(",sTmp)-1
			[+] if(i>0)
				[ ] sTmp = Trim(Left(sTmp, i))
			[+] for(i=1,j=1; i<=Len(sTmp); i++)
				[+] if(sTmp[i]==" ")
					[ ] j=i
			[+] if(j>1)
				[ ] 
				[ ] sTmp = Trim(Left(sTmp, j))
				[ ] 
				[+] if lsMAttr[3].sAttribute == "Return codes:"
					[ ] lsMAttr[3].sAttribute = "[ ] // @returns:"
				[ ] 
				[+] if(MatchStr("VOID", sTmp))
					[ ] lsMAttr[2].sAttribute = StrTran(lsMAttr[2].sAttribute,"void","")
					[ ] lsMAttr[2].sAttribute = StrTran(lsMAttr[2].sAttribute,"VOID","")
				[+] else 
					[ ] i = StrPos(sTmp,lsMAttr[2].sAttribute)
					[ ] lsMAttr[2].sAttribute = Left(lsMAttr[2].sAttribute,i-1)+"result ="+Right(lsMAttr[2].sAttribute, Len(lsMAttr[2].sAttribute)-Len(Left(lsMAttr[2].sAttribute,i-1))-Len(sTmp))
					[ ] i = StrPos(":",lsMAttr[3].sAttribute)
					[ ] lsMAttr[3].sAttribute = Left(lsMAttr[3].sAttribute, i)+" result: "+sTmp+"; <br>"+Right(lsMAttr[3].sAttribute, Len(lsMAttr[3].sAttribute)-i)
			[ ] 
			[ ] sOriginalGroup = Trim (StrTran (StrTran (StrTran (StrTran (lsMAttr[1].sAttribute, chr(9), " "), "[ ]  ", "[ ] //"), "Class:<br>", ""), "[ ] // @class:", ""))
			[ ] lsMAttr[1].sAttribute = "[ ] // @class: " + sGroup
			[ ] 
			[ ] // @parameter attributes processing
			[ ] sTmp = Right(lsMAttr[4].sAttribute,Len(lsMAttr[4].sAttribute)-StrPos(":",lsMAttr[4].sAttribute)+1) 
			[ ] 
			[ ] // @Generated Return codes processing
			[+] if lsMAttr[3].sAttribute == "Return codes:"
				[ ] lsMAttr[3].sAttribute = ""
			[ ] 
			[ ] // @Generated Arguments processing
			[+] if lsMAttr[4].sAttribute == "Arguments:"
				[ ] lsMAttr[4].sAttribute = ""
			[ ] 
			[ ] // @Generated Description processing
			[+] if lsMAttr[5].sAttribute == "Description:"
				[ ] lsMAttr[5].sAttribute = ""
			[ ] 
			[ ] // @Generated Examples processing
			[+] if lsMAttr[6].sAttribute == "Example:"
				[ ] lsMAttr[6].sAttribute = ""
			[ ] 
			[ ] // @Author processing !!!!!!!!!!!!!!!
			[+] if lsMAttr[7].sAttribute == "Author:"
				[+] if sTCAuthor != ""
					[ ] lsMAttr[7].sAttribute = "[ ] // @author: {sTCAuthor}"
				[+] else
					[ ] lsMAttr[7].sAttribute = "[ ] // @author: none"
			[ ] 
			[ ] // @Original Description processing
			[ ] sAttr.sAttribute = "[ ] // @originalnotes:" + ListToString (lsHelp, "<br>")
			[ ] sAttr.sReplaceStr = " @originalnotes:"
			[ ] lsMAttr += {sAttr}
			[ ] 
			[ ] // @Group for Class processing
			[+] if sOriginalGroup != "Class:"
				[ ] sAttr.sAttribute = "[ ] // @originalgroup:" + sOriginalGroup
				[ ] sAttr.sReplaceStr = " @originalgroup:"
				[ ] lsMAttr += {sAttr}
			[ ] 
			[ ] // @Code processing
			[ ] sAttr.sAttribute = ""
			[ ] sAttr.sReplaceStr = " @originalcode:"
			[+] if ListCount (lsCode) > 0
				[+] for i = 1 to ListCount (lsCode)
					[ ] iLen += Len (lsCode[i])
					[ ] 
					[ ] sAttr.sAttribute += (lsCode[i])
					[ ] 
					[+] if (iLen > 10000) && (StrPos ("<!-->Begin</-->", lsCode[i]) > 0)	// max string size
						[ ] 
						[+] while (i < ListCount (lsCode)) && StrPos ("<!-->End</-->", lsCode[i]) == 0
							[ ] i++
							[ ] iLen += Len (lsCode[i])
							[ ] sAttr.sAttribute += (lsCode[i])
							[ ] 
						[ ] sAttr.sAttribute += (lsCode[i])
						[ ] 
						[+] while (i < ListCount (lsCode)) && StrPos ("[+]<!-->[+]</-->", lsCode[i]) == 0
							[ ] i++
							[ ] iLen += Len (lsCode[i])
							[ ] sAttr.sAttribute += (lsCode[i])
							[ ] 
						[ ] 
						[ ] sAttr.sAttribute = "[ ] // @originalcode:"  + sAttr.sAttribute
						[ ] lsMAttr += {sAttr}
						[ ] 
						[ ] iLen = 0
						[ ] sAttr.sAttribute = ""
					[ ] 
				[ ] 
			[ ] sAttr.sAttribute = "[ ] // @originalcode:" + sAttr.sAttribute
			[ ] sAttr.sReplaceStr = " @originalcode:"
			[ ] lsMAttr += {sAttr}
			[ ] 
			[ ] // generating result list 
			[+] for(i=1; i <= ListCount(lsMAttr); i++)
				[+] if(StrPos("@parameter:", lsMAttr[i].sAttribute) > 0)
					[ ] j = split (lsMAttr[i].sAttribute, lsTmp, "†")
					[+] for each sTmp in lsTmp
						[ ] sTmp=StrTran(sTmp,"[ ] //  @", "[ ] // @")
						[ ] ListAppend(lsResult, sTmp)
				[+] else
					[ ] lsMAttr[i].sAttribute=StrTran(lsMAttr[i].sAttribute,"[ ] //  @", "[ ] // @")
					[ ] ListAppend(lsResult, lsMAttr[i].sAttribute)
			[ ] 
		[ ] 
		[+] else if(StrPos(sPStart, lsHelp[1]) > 0) 	// "*//**Property:*"
			[ ] // TODO: add code
	[ ] 
	[ ] return lsResult
[ ] 
[+] private list of GenHelp ExtractHelp(list of string lsHelp)
	[ ] 
	[+] list of GenHelp lsGenHelp = {...}
		[ ] {"@group:", "", null}
		[ ] {"@function:", "", null}
		[ ] {"@class:", "", null}
		[ ] {"@method:", "", null}
		[ ] {"@property:", "", null}
		[ ] {"@returns:", "", null}
		[ ] {"@parameter:", "", null}
		[ ] {"@parameter:", "", null}
		[ ] {"@parameter:", "", null}
		[ ] {"@parameter:", "", null}
		[ ] {"@parameter:", "", null}
		[ ] {"@parameter:", "", null}
		[ ] {"@parameter:", "", null}
		[ ] {"@parameter:", "", null}
		[ ] {"@parameter:", "", null}
		[ ] {"@parameter:", "", null}
		[ ] {"@parameter:", "", null}
		[ ] {"@notes:", "", null}
		[ ] {"@author:", "", null}
		[ ] 
		[ ] {"@originalnotes:", "", null}
		[ ] {"@originallocation:", "", null}
		[ ] {"@originalgroup:", "", null}
		[ ] 
		[ ] {"@originalcode:", "", null}
		[ ] {"@originalcode:", "", null}
		[ ] {"@originalcode:", "", null}
		[ ] {"@originalcode:", "", null}
		[ ] {"@originalcode:", "", null}
		[ ] {"@originalcode:", "", null}
		[ ] {"@originalcode:", "", null}
		[ ] {"@originalcode:", "", null}
		[ ] {"@originalcode:", "", null}
		[ ] {"@originalcode:", "", null}
		[ ] 
		[ ] 
	[ ] list of GenHelp lsActualHelp
	[ ] 
	[ ] GenHelp rcData
	[ ] string sLine
	[ ] string sTempLine, sTempLine2
	[ ] boolean bFoundCurrentKey = false
	[ ] boolean bFoundNextKey = false
	[ ] integer iCurrLine = 0, iExtraLines = 0
	[ ] 
	[+] for each sLine in lsHelp
		[ ] iCurrLine++
		[+] for each rcData in lsGenHelp
			[+] if (StrPos(rcData.sKeyword, sLine) > 0)		// get data for keyword
				[ ] 
				[ ] sTempLine = StrTran(sLine, "[ ] // {rcData.sKeyword}", "")
				[ ] sTempLine = StrTran(sTempLine, rcData.sKeyword, "")
				[ ] 
				[+] if (rcData.sKeyword != "@originalnotes:") && (rcData.sKeyword != "@originalcode:")
					[ ] sTempLine2 = StrTran(sTempLine, "[ ] //" , "")
				[+] else
					[ ] sTempLine2 = StrTran(sTempLine, "[ ] // [ ] //" , "[ ] //")
				[ ] 
				[ ] rcData.sText = clean(sTempLine2)
				[ ] bFoundCurrentKey = true
				[ ] iExtraLines = iCurrLine + 1
				[ ] 
				[+] while (!bFoundNextKey)
					[+] do
						[+] if (StrPos("[ ] // @", lsHelp[iExtraLines]) > 0)		// have the next line
							[+] if (StrPos("[ ] // @example:", lsHelp[iExtraLines]) > 0)		// it is an example line
								[ ] sTempLine = StrTran(lsHelp[iExtraLines], "[ ] // @example:", "")
								[ ] rcData.lsExample = {sTempLine}
								[ ] iExtraLines++
							[+] else
								[ ] bFoundNextKey = true
						[+] else				// this is the extra line
							[ ] 
							[ ] sTempLine = StrTran(lsHelp[iExtraLines], "[ ]", "")
							[ ] sTempLine = StrTran(sTempLine, "//", "")
							[ ] sTempLine2 = clean(sTempLine)
							[ ] rcData.sText = rcData.sText + " " + sTempLine2
							[ ] iExtraLines++
							[ ] 
					[+] except
						[ ] bFoundNextKey=true
				[ ] 
				[ ] ListAppend(lsActualHelp, rcData)
				[ ] bFoundNextKey = false
				[ ] bFoundCurrentKey = false
				[ ] 
				[ ] break
				[ ] 
	[ ] 
	[ ] return lsActualHelp
	[ ] 
[ ] 
[+] private list of string ExtractDataHelp(list of string lsHelp)
	[ ] 
	[ ] list of string lsActualHelp
	[ ] 
	[ ] string sLine
	[ ] string sNewLine
	[ ] 
	[+] for each sLine in lsHelp
		[ ] sNewLine = StrTran(sLine, "+", " ")
		[ ] sNewLine = StrTran(sNewLine, "-", " ")
		[ ] sNewLine = StrTran(sNewLine, "[ ]", "")
		[ ] 
		[ ] ListAppend(lsActualHelp, sNewLine)
		[ ] 
	[ ] 
	[ ] return lsActualHelp
	[ ] 
[ ] 
[ ] // ------------- Help File Creation -----------------------------
[+] private SaveHelp(list of GenHelp lsGenHelp)
	[ ] GenHelp rcHelp
	[ ] string sFullFile
	[ ] string sGoodFile = ""
	[+] for each rcHelp in lsGenHelp
		[ ] sFullFile = CreateObjectFile(rcHelp)
		[ ] 
		[+] if sFullFile != ""
			[ ] sGoodFile = sFullFile
		[ ] 
	[ ] 
	[ ] lsGenHelp = ValidateSyntax(lsGenHelp)
	[ ] CreateHelpBlock(lsGenHelp, sGoodFile)
	[ ] 
	[ ] // ******* CREATE HTML HELP ******
	[+] if bCreateHTMLHelp
		[ ] 
		[ ] CreateHTMLHelp(lsGenHelp)
		[ ] 
	[ ] 
[ ] 
[+] private string CreateObjectFile(GenHelp rcHelp)
	[ ] string sFile
	[ ] string sFullFile = ""
	[ ] HFILE FileHandle
	[ ] string sKeyword, sRemoveSymbol
	[ ] string sTAB = Chr(9)
	[ ] 
	[+] if (rcHelp.sKeyword == "@group:") || (rcHelp.sKeyword == "@class:")
		[ ] sKeyword = StrTran(rcHelp.sKeyword, "@", "")
		[ ] 
		[ ] sFile = Trim(rcHelp.sText)
		[ ] sFile = "{sKeyword}{sObjectDelimiter}{sFile}.txt"
		[ ] 
		[+] for each sRemoveSymbol in {"	", "\", "/", ":", "*", "?", "<", ">", "|", """", "'"} //" ", 
			[ ] sFile = StrTran(sFile, sRemoveSymbol, "")
		[ ] 
		[ ] sFullFile = Save_4Text_Location + "\SilkHelpGen_Temp\" + sFile
		[ ] 
		[+] if (!SYS_FileExists(sFullFile))
			[ ] FileHandle = FileOpen (sFullFile,  FM_WRITE)
			[ ] FileWriteLine (FileHandle, "#********************************************")
			[ ] FileWriteLine (FileHandle, "")
			[ ] FileWriteLine (FileHandle, "{sKeyword}:{sTAB}{sTAB}{rcHelp.sText}")
			[ ] FileWriteLine (FileHandle, "")
			[ ] FileClose (FileHandle)
		[ ] 
	[ ] 
	[ ] return sFullFile
	[ ] 
[ ] 
[+] private string CreateHTMLObjectFile(string sFile, string sTitle)
	[ ] string sFullFile = ""
	[ ] HFILE FileHandle
	[ ] string sKeyword, sRemoveSymbol
	[ ] string sTAB = Chr(9)
	[ ] 
	[+] for each sRemoveSymbol in {"	", "\", "/", ":", "*", "?", "<", ">", "|", """", "'"}	//" ", 
		[ ] sFile = StrTran(sFile, sRemoveSymbol, "")
	[ ] 
	[ ] sFullFile = GetSaveToFolder() + sFile
	[ ] 
	[ ] FileHandle = FileOpen (sFullFile,  FM_WRITE)
	[ ] FileWriteLine (FileHandle, "<html>")
	[ ] FileWriteLine (FileHandle, "<head>")
	[ ] FileWriteLine (FileHandle, "<title>{sTitle} - {sHelpTitle}</title>")
	[ ] FileWriteLine (FileHandle, "<link id=""themeStyles"" rel=""stylesheet"" href=""../../js/dijit/themes/soria/soria.css"">")
	[ ] 
	[ ] FileWriteLine (FileHandle, "<style type=""text/css"">")
	[ ] FileWriteLine (FileHandle, "@import ""../../js/dojo/resources/dojo.css"";")
	[ ] FileWriteLine (FileHandle, "</style>")
	[ ] 
	[ ] FileWriteLine (FileHandle, "<script type=""text/javascript"" src=""../../js/dojo/dojo.js"" djConfig=""parseOnLoad: true, isDebug: false""></script>")
	[ ] FileWriteLine (FileHandle, "<script type=""text/javascript"" src=""../../js/dijit/dijit.js""></script>")
	[ ] FileWriteLine (FileHandle, "<script type=""text/javascript"" src=""../../js/dijit/dijit-all.js""></script>")
	[ ] FileWriteLine (FileHandle, "")
	[ ] FileWriteLine (FileHandle, "<script src=""../../js/src/prettify.js"" type=""text/javascript""></script>")
	[ ] FileWriteLine (FileHandle, "<link rel=""stylesheet"" type=""text/css"" href=""../../js/src/prettify.css""/>")
	[ ] FileWriteLine (FileHandle, "")
	[ ] 
	[ ] FileWriteLine (FileHandle, "<script language=""JavaScript"" src=""../../tocTab{sVariant}.js""></script>")
	[ ] FileWriteLine (FileHandle, "<script language=""JavaScript"" src=""../../tocParas.js""></script>")
	[ ] FileWriteLine (FileHandle, "<script language=""JavaScript"" src=""../../displayToc.js""></script>")
	[ ] FileWriteLine (FileHandle, "<style type=""text/css"">")
	[ ] 
	[ ] FileWriteLine (FileHandle, "body " + chr(123) + "scrollbar-face-color: #FFF; scrollbar-3dlight-color: #FFF; scrollbar-track-color: #FFF; scrollbar-shadow-color: #527194;	scrollbar-darkshadow-color: #FFF; scrollbar-arrow-color: #527194; scrollbar-highlight-color: #527194;" + chr(125))
	[ ] FileWriteLine (FileHandle, ".heading " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14px; color: #FFFFFF; font-weight: bold" + chr(125))
	[ ] FileWriteLine (FileHandle, "p " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px" + chr(125))
	[ ] FileWriteLine (FileHandle, "pre " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; background-color: transparent; border-style: none" + chr(125))
	[ ] FileWriteLine (FileHandle, ".keyword " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; font-weight: bold" + chr(125))
	[ ] FileWriteLine (FileHandle, "td " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px" + chr(125))
	[ ] FileWriteLine (FileHandle, ".variable " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; font-weight: bold; text-decoration: underline" + chr(125))
	[ ] FileWriteLine (FileHandle, ".timestamp " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; font-style: italic; color: #999999" + chr(125))
	[ ] FileWriteLine (FileHandle, ".navlink  " + chr(123) + "background: transparent; color: #333; text-decoration: underline " + chr(125))
	[ ] FileWriteLine (FileHandle, "a:hover.navlink  " + chr(123) + "background: #D8E0FC; font-weight: bold; color: #111; text-decoration: none" + chr(125))
	[ ] FileWriteLine (FileHandle, ".navlink2  " + chr(123) + "background: transparent; color: #527194; text-decoration: none" + chr(125))
	[ ] FileWriteLine (FileHandle, "a:hover.navlink2  " + chr(123) + "background: transparent; font-weight: bold; color: #A1ACFC; text-decoration: underline" + chr(125))
	[ ] FileWriteLine (FileHandle, ".spoiler   " + chr(123) + " display: none; " + chr(125))
	[ ] FileWriteLine (FileHandle, "  .div.cut_sep   " + chr(123) + " background:transparent url('../../images/cut.gif') 100% 0 repeat-x;height:16px;overflow:hidden;margin:10px 0 7px 0;text-indent:-9999px; " + chr(125))
	[ ] 
	[ ] FileWriteLine (FileHandle, "</style>")
	[ ] FileWriteLine (FileHandle, "</head>")
	[ ] FileWriteLine (FileHandle, "")
	[ ] FileWriteLine (FileHandle, "<body onload=""prettyPrint()"" bgcolor=""#FFFFFF"" text=""#000000"" class=""soria"">")
	[ ] FileWriteLine (FileHandle, "")
	[ ] FileClose (FileHandle)
	[ ] 
	[ ] return sFullFile
	[ ] 
[ ] 
[ ] // create file with Code
[+] private CreateHTMLCodeFile(string sFile, list of GenHelp rcCode, string sTitle)
	[ ] string sFullFile = ""
	[ ] HFILE FileHandle
	[ ] string sKeyword, sRemoveSymbol
	[ ] string sTAB = Chr(9)
	[ ] INTEGER i, iPos, iPos2, n = 0
	[ ] STRING sCode, sFind, sReplace
	[ ] INTEGER iFrom, iTo, iCount, iPosB
	[ ] STRING sTmp
	[ ] 
	[+] for each sRemoveSymbol in {"	", "\", "/", ":", "*", "?", "<", ">", "|", """", "'"}	//" ", 
		[ ] sFile = StrTran(sFile, sRemoveSymbol, "")
	[ ] 
	[ ] sFullFile = GetSaveToFolder() + sFile
	[ ] 
	[ ] sFullFile = StrTran (sFullFile, "\HelpAPI{sVariant}\", "\HelpAPI{sVariant}\Code\")
	[ ] 
	[ ] 
	[ ] FileHandle = FileOpen (sFullFile,  FM_WRITE)
	[ ] FileWriteLine (FileHandle, "<html>")
	[ ] FileWriteLine (FileHandle, "<head>")
	[ ] FileWriteLine (FileHandle, "<title>{sTitle} - {sHelpTitle}</title>")
	[ ] FileWriteLine (FileHandle, "<link id=""themeStyles"" rel=""stylesheet"" href=""../../../js/dijit/themes/soria/soria.css"">")
	[ ] 
	[ ] FileWriteLine (FileHandle, "<style type=""text/css"">")
	[ ] FileWriteLine (FileHandle, "@import ""../../../js/dojo/resources/dojo.css"";")
	[ ] FileWriteLine (FileHandle, "</style>")
	[ ] 
	[ ] FileWriteLine (FileHandle, "<script type=""text/javascript"" src=""../../../js/dojo/dojo.js"" djConfig=""parseOnLoad: true, isDebug: false""></script>")
	[ ] FileWriteLine (FileHandle, "<script type=""text/javascript"" src=""../../../js/dijit/dijit.js""></script>")
	[ ] FileWriteLine (FileHandle, "<script type=""text/javascript"" src=""../../../js/dijit/dijit-all.js""></script>")
	[ ] FileWriteLine (FileHandle, "")
	[ ] FileWriteLine (FileHandle, "<script src=""../../../js/src/prettify.js"" type=""text/javascript""></script>")
	[ ] FileWriteLine (FileHandle, "<link rel=""stylesheet"" type=""text/css"" href=""../../../js/src/prettify.css""/>")
	[ ] FileWriteLine (FileHandle, "")
	[ ] 
	[ ] 
	[ ] FileWriteLine (FileHandle, "<script language=""JavaScript"" src=""../../../tocTab{sVariant}.js""></script>")
	[ ] FileWriteLine (FileHandle, "<script language=""JavaScript"" src=""../../../tocParas.js""></script>")
	[ ] FileWriteLine (FileHandle, "<script language=""JavaScript"" src=""../../../displayToc.js""></script>")
	[ ] FileWriteLine (FileHandle, "<style type=""text/css"">")
	[ ] 
	[ ] FileWriteLine (FileHandle, "body " + chr(123) + "scrollbar-face-color: #FFF; scrollbar-3dlight-color: #FFF; scrollbar-track-color: #FFF; scrollbar-shadow-color: #527194;	scrollbar-darkshadow-color: #FFF; scrollbar-arrow-color: #527194; scrollbar-highlight-color: #527194;" + chr(125))
	[ ] FileWriteLine (FileHandle, ".heading " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14px; color: #FFFFFF; font-weight: bold" + chr(125))
	[ ] FileWriteLine (FileHandle, "p " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px" + chr(125))
	[ ] FileWriteLine (FileHandle, "pre " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; background-color: transparent; border-style: none" + chr(125))
	[ ] FileWriteLine (FileHandle, ".keyword " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; font-weight: bold" + chr(125))
	[ ] FileWriteLine (FileHandle, "td " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px" + chr(125))
	[ ] FileWriteLine (FileHandle, ".variable " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; font-weight: bold; text-decoration: underline" + chr(125))
	[ ] FileWriteLine (FileHandle, ".timestamp " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; font-style: italic; color: #999999" + chr(125))
	[ ] FileWriteLine (FileHandle, ".navlink  " + chr(123) + "background: transparent; color: #333; text-decoration: underline " + chr(125))
	[ ] FileWriteLine (FileHandle, "a:hover.navlink  " + chr(123) + "background: #D8E0FC; font-weight: bold; color: #111; text-decoration: none" + chr(125))
	[ ] FileWriteLine (FileHandle, ".navlink2  " + chr(123) + "background: transparent; color: #527194; text-decoration: none" + chr(125))
	[ ] FileWriteLine (FileHandle, "a:hover.navlink2  " + chr(123) + "background: transparent; font-weight: bold; color: #A1ACFC; text-decoration: underline" + chr(125))
	[ ] FileWriteLine (FileHandle, ".spoiler   " + chr(123) + " display: none; " + chr(125))
	[ ] FileWriteLine (FileHandle, " .div.cut_sep   " + chr(123) + " background:transparent url('../../../images/cut.gif') 100% 0 repeat-x;height:16px;overflow:hidden;margin:10px 0 7px 0;text-indent:-9999px; " + chr(125))
	[ ] 
	[ ] FileWriteLine (FileHandle, "</style>")
	[ ] FileWriteLine (FileHandle, "</head>")
	[ ] FileWriteLine (FileHandle, "")
	[ ] FileWriteLine (FileHandle, "<body onload=""prettyPrint();toggleCode(1);return false;"" bgcolor=""#FFFFFF"" text=""#000000"" class=""soria"">")
	[ ] FileWriteLine (FileHandle, "")
	[ ] 
	[ ] FileWriteLine (FileHandle, "<pre class=""prettyprint lang-java""  id=""java_lang"" style=""border-style: none"">")
	[ ] FileWriteLine (FileHandle, "")
	[ ] FileWriteLine (FileHandle, "<p class=""keyword"">Code</p>")
	[ ] FileWriteLine (FileHandle, "<p>")
	[ ] 
	[ ] FileWriteLine (FileHandle, "<a class=""navlink"" href=""../..{StrTran (SubStr (sFullFile, StrPos ("\HelpAPI{sVariant}\Code", sFullFile) + 13 + Len (sVariant)), "\", "/")}""><img src=""../../../images/back.gif""> back</a><br><div class=""cut_sep"" id=""cut"">----------------------&lt;cut&gt;----------------------</div>")
	[ ] n++
	[ ] 
	[+] for i = 1 to ListCount (rcCode)
		[ ] 
		[ ] sCode = CleanStr (rcCode[i].sText)
		[ ] 
		[ ] sFind 		= "[+]&lt;!-->[+]&lt;/-->"	// link with [+]
		[ ] sReplace 	= "<a class=""navlink"" href=""javascript://"" onClick=""toggleCode({n});return false;"">[+]</a>"
		[ ] iPos = StrPos (sFind, sCode)
		[ ] 
		[ ] // count of [ ] 
		[ ] iFrom = iPos
		[ ] sTmp = SubStr (sCode, 1, iFrom)
		[ ] iCount = Len (sTmp) - Len (StrTran (sTmp, "[ ]", "[]"))
		[+] if iCount < Len (sTmp)
			[ ] n += iCount
		[ ] 
		[+] while iPos > 0
			[ ] 
			[ ] // change [+]
			[+] if iPos == 1
				[ ] sCode = sReplace + SubStr (sCode, iPos + Len (sFind))
			[+] else if iPos != 0
				[ ] sCode = SubStr (sCode, 1, iPos - 1) + sReplace + SubStr (sCode, iPos + Len (sFind))
			[ ] 
			[ ] // change Begin
			[ ] sFind 		= "&lt;!-->Begin&lt;/-->"	// begin of collapse block
			[ ] sReplace 	= "<div class=""spoiler"" id=""{n++}"">"
			[ ] iPosB = StrPos (sFind, sCode)
			[ ] 
			[+] if iPosB > 0
				[ ] sCode = SubStr (sCode, 1, iPosB - 1) + sReplace + SubStr (sCode, iPosB + Len (sFind))
			[+] else
				[ ] print ("!!! ERROR: iPosB = 0 !")
				[ ] print ("++++++++++++++++++++++++++++++++")
				[ ] print ("sCode: " + sCode)
				[ ] print ("sFind: " + sFind)
				[ ] print ("i: " + "{i}")
				[ ] print ("iPos: " + "{iPos}")
				[ ] print ("++++++++++++++++++++++++++++++++")
				[ ] 
			[ ] 
			[ ] // count of [ ] 
			[ ] iFrom = iPos
			[ ] 
			[ ] sTmp = SubStr (sCode, iFrom)
			[ ] iTo = StrPos (sFind, sTmp)
			[+] if iTo > 0 
				[ ] sTmp = SubStr (sTmp, 1, iTo - 1)
			[ ] iCount = Len (sTmp) - Len (StrTran (sTmp, "[ ]", "[]"))
			[+] if iCount < Len (sTmp)
				[ ] n += iCount
			[ ] 
			[ ] // find [+] position
			[ ] sFind 		= "[+]&lt;!-->[+]&lt;/-->"	// link with [+]
			[ ] sReplace 	= "<a class=""navlink"" href=""javascript://"" onClick=""toggleCode({n});return false;"">[+]</a>"
			[ ] iPos = StrPos (sFind, sCode)
			[ ] 
			[ ] 
		[ ] 
		[ ] sFind 		= "&lt;!-->End&lt;/-->"		// end of collapse block
		[ ] sReplace 	= "</div>"
		[ ] sCode = StrTran (sCode, sFind, sReplace)
		[ ] 
		[ ] sFind 		= "&lt;!-->End&lt;/-->"		// end of collapse block
		[ ] sReplace 	= "</div>"
		[ ] sCode = StrTran (sCode, sFind, sReplace)
		[ ] 
		[ ] sFind 		= "[+]"		// [+] -> pic
		[ ] sReplace 	= "<img src=""../../../images/plus_silk.jpg"">"
		[ ] sCode = StrTran (sCode, sFind, sReplace)
		[ ] 
		[ ] sFind 		= "[ ]"		// [ ] -> pic
		[ ] sReplace 	= "<img class=""none"" src=""../../../images/none.jpg"">"
		[ ] sCode = StrTran (sCode, sFind, sReplace)
		[ ] 
		[ ] sFind 		= "[shiftenter]"		// shift+enter
		[ ] sReplace 	= " "
		[ ] sCode = StrTran (sCode, sFind, sReplace)
		[ ] 
		[ ] FileWriteLine (FileHandle, sCode)
		[ ] 
	[ ] 
	[ ] FileWriteLine (FileHandle, "</p>")
	[ ] 
	[ ] // page footer
	[ ] FileWriteLine (FileHandle, "</pre>")
	[ ] FileWriteLine (FileHandle, "")
	[ ] FileWriteLine (FileHandle, "<div class=""cut_sep"" id=""cut"">----------------------&lt;cut&gt;----------------------</div>")
	[ ] FileWriteLine (FileHandle, "<span class=""timestamp"">&#169; 2002-2010 ISD Automated Testing. (Created By Silk Help Generator {DateStr()}  {TimeStr()})</span>")
	[ ] FileWriteLine (FileHandle, "</body>")
	[ ] FileWriteLine (FileHandle, "</html>")
	[ ] FileWriteLine (FileHandle, "")
	[ ] 
	[ ] FileClose (FileHandle)
[ ] 
[+] private CreateHelpBlock(list of GenHelp lsGenHelp, string sFile)
	[ ] string sFullFile 
	[ ] HFILE FileHandle
	[ ] HFILE FileHandleCode
	[ ] string sKeyword
	[ ] string sTAB = Chr(9)
	[ ] GenHelp rcHelp
	[ ] string sTempLine
	[ ] string sKeyWord
	[ ] string sTabSpace
	[ ] list of string lsLineLen
	[ ] 
	[+] if (SYS_FileExists(sFile))
		[ ] FileHandle = FileOpen (sFile,  FM_APPEND)
		[ ] 
		[+] for each rcHelp in lsGenHelp
			[ ] 
			[ ] sKeyword = StrTran(rcHelp.sKeyword, "@", "")
			[ ] 
			[+] if (Len(sKeyword) < 8)
				[ ] sTabSpace = "{sTAB}{sTAB}"
			[+] else
				[ ] sTabSpace = sTAB
			[ ] 
			[+] if (rcHelp.sKeyword == "@group:") || (rcHelp.sKeyword == "@class:") || (rcHelp.sKeyword == "@originalnotes:") || (rcHelp.sKeyword == "@originallocation:") || (rcHelp.sKeyword == "@originalgroup:")|| (rcHelp.sKeyword == "@originalcode:")
				[ ] // skip
			[+] else
				[+] if rcHelp.sText != ""
					[+] if (rcHelp.sKeyword == "@method:")
						[ ] rcStat.iMethods++
					[+] if (rcHelp.sKeyword == "@function:")
						[ ] rcStat.iFunctions++
					[ ] lsLineLen = CheckLineLength(rcHelp.sText)
					[+] if (ListCount(lsLineLen) == 1)
						[ ] FileWriteLine (FileHandle, "{sKeyword}{sTabSpace}{rcHelp.sText}")
					[+] else
						[ ] FileWriteLine (FileHandle, "{sKeyword}{sTabSpace}{lsLineLen[1]} [more..]")
				[ ] 
			[ ] 
		[ ] FileWriteLine (FileHandle, "")
		[ ] FileClose (FileHandle)
	[+] else
		[ ] Print ("+++ ERROR: File '{sFile}' not found !!")
	[ ] 
[ ] 
[+] private CreateHTMLHelp(list of GenHelp lsGenHelp)
	[ ] string sFullFile 
	[ ] string sFile2, sFile = ""
	[ ] HFILE FileHandle
	[ ] HFILE FileHandleCode
	[ ] string sKeyword
	[ ] string sTAB = Chr(9)
	[ ] GenHelp rcHelp
	[ ] string sTempLine
	[ ] string sKeyWord
	[ ] string sTabSpace
	[ ] list of string lsLineLen
	[ ] string sAPI
	[ ] string sFormatedAPI
	[ ] string sReturns
	[ ] list of Parameters lsParm = null
	[ ] Parameters rcParm
	[ ] Parameters rcReturn
	[ ] string sExample
	[ ] string sLocation
	[ ] string sTitle
	[ ] 
	[ ] STRING sAuthor
	[ ] LIST OF STRING lsAuthors
	[ ] LIST OF ANYTYPE laStatAut
	[ ] INTEGER i
	[ ] 
	[ ] GenHelp rcClass
	[ ] GenHelp rcMethod
	[ ] GenHelp rcReturns
	[ ] list of GenHelp rcParameter = {}
	[ ] GenHelp rcNotes
	[ ] GenHelp rcProperty
	[ ] GenHelp rcGroup
	[ ] GenHelp rcFunction
	[ ] GenHelp rcData 
	[ ] GenHelp rcAuthor
	[ ] GenHelp rcOriginalnotes
	[ ] GenHelp rcLocation
	[ ] GenHelp rcOriginalGroup
	[ ] list of GenHelp rcCode
	[ ] 
	[ ] string sType = ""
	[ ] 
	[+] for each rcData in lsGenHelp
		[+] switch rcData.sKeyword
			[+] case "@class:"
				[ ] rcClass = rcData
			[+] case "@method:"
				[ ] rcMethod = rcData
				[+] if (rcData.sText != "")
					[ ] sType = "method"
					[ ] sLocation = rcClass.sText
			[+] case "@returns:"
				[ ] rcReturns = rcData
			[+] case "@parameter:"
				[ ] ListAppend(rcParameter, rcData)
			[+] case "@notes:"
				[ ] rcNotes = rcData
			[+] case "@property:"
				[ ] rcProperty = rcData
				[+] if (rcData.sText != "")
					[ ] sType = "property"
					[ ] sLocation = rcClass.sText
			[+] case "@group:"
				[ ] rcGroup = rcData
			[+] case "@function:"
				[ ] rcFunction = rcData
				[+] if (rcData.sText != "")
					[ ] sType = "function"
					[ ] sLocation = rcGroup.sText
			[+] case "@author:"
				[ ] rcAuthor = rcData
				[ ] 
				[+] if MapHasKey (mAuthorReplace, rcAuthor.sText)
					[ ] rcAuthor.sText = MapGet (mAuthorReplace, rcAuthor.sText)
				[ ] 
			[ ] 
			[+] case "@originalnotes:"
				[ ] rcOriginalnotes = rcData
			[+] case "@originallocation:"
				[ ] rcLocation = rcData
			[+] case "@originalgroup:"
				[ ] rcOriginalGroup = rcData
			[ ] 
			[+] case "@originalcode:"
				[ ] ListAppend(rcCode, rcData)
			[ ] 
			[+] default
				[ ] LogWarning("*** WARNING: Recieved unknown keyword: '{rcData.sKeyword}'")
				[ ] ListPrint([LIST]rcData)
				[ ] print("********************************************")
	[ ] 
	[+] if IsSet (sLocation)	// workaroud for functions in ..\Common\CMN_Terminal.inc
		[ ] sLocation = StrTran(sLocation, "@", "")
		[ ] sLocation = StrTran(sLocation, ":", "")
		[ ] 
		[+] switch sType
			[+] case "method"
				[ ] sAPI = "{GetAPIName(rcMethod.sText)} Method"
				[ ] sFormatedAPI = GetFormatedAPI(rcMethod.sText)
				[ ] sReturns = GetAPIReturn(rcMethod.sText)
				[+] if sReturns != ""
					[+] if IsSet(rcReturns.sText)
						[ ] rcReturn = {sReturns, Trim(StrTran(rcReturns.sText, "{sReturns}:", "")), false, null}
					[+] else
						[ ] LogError("Method syntax has return, but there is no return value :: {rcMethod}")
				[ ] lsParm = ParseParameters(rcParameter, rcMethod.sText)
				[ ] sFile = "Class{sObjectDelimiter}{rcClass.sText}{sObjectDelimiter}Method{sObjectDelimiter}{GetAPIName(rcMethod.sText)}.htm"
				[ ] sTitle = "Class: {rcClass.sText}  Method: {GetAPIName(rcMethod.sText)}"
			[+] case "property"
				[ ] sAPI = "{GetAPIName(rcProperty.sText)} Property"
				[ ] sFormatedAPI = rcProperty.sText
				[ ] sReturns = ""
				[ ] lsParm = null
				[ ] sFile = "Class{sObjectDelimiter}{rcClass.sText}{sObjectDelimiter}Property{sObjectDelimiter}{GetAPIName(rcProperty.sText)}.htm"
				[ ] sTitle = "Class: {rcClass.sText}  Property: {GetAPIName(rcProperty.sText)}"
			[+] case "function"
				[ ] sAPI = "{GetAPIName(rcFunction.sText)} Function"
				[ ] sFormatedAPI = GetFormatedAPI(rcFunction.sText)
				[ ] sReturns = GetAPIReturn(rcFunction.sText)
				[+] if sReturns != ""
					[+] if IsSet(rcReturns.sText)
						[ ] rcReturn = {sReturns, Trim(StrTran(rcReturns.sText, "{sReturns}:", "")), false, null}
					[+] else
						[ ] LogError("Function syntax has return, but there is no return value :: {rcMethod}")
					[ ] 
				[ ] lsParm = ParseParameters(rcParameter, rcFunction.sText)
				[ ] sFile = "Group{sObjectDelimiter}{rcGroup.sText}{sObjectDelimiter}Function{sObjectDelimiter}{GetAPIName(rcFunction.sText)}.htm"
				[ ] sTitle = "Group: {rcGroup.sText}  Function: {GetAPIName(rcFunction.sText)}"
		[ ] 
		[ ] sFile2 = sFile
		[ ] sFile = CreateHTMLObjectFile(sFile, sTitle)
		[ ] 
		[+] if (SYS_FileExists(sFile))
			[ ] FileHandle = FileOpen (sFile,  FM_APPEND)
			[ ]     
			[ ] // make heading
			[ ] FileWriteLine (FileHandle, "<table width=""100%"" border=""0"">")
			[ ] FileWriteLine (FileHandle, "  <tr>")
			[ ] FileWriteLine (FileHandle, "    <td bgcolor=""#6D76AB"" class=""heading"">{sAPI}</td>")
			[ ] FileWriteLine (FileHandle, "  </tr>")
			[ ] FileWriteLine (FileHandle, "</table>")
			[ ] FileWriteLine (FileHandle, "")
			[ ] 
			[ ] FileWriteLine (FileHandle, "<pre class=""prettyprint lang-java""  id=""java_lang"" style=""border-style: none"">")
			[ ] FileWriteLine (FileHandle, "")
			[ ] 
			[ ] // write action
			[ ] FileWriteLine (FileHandle, "<p class=""keyword"">Action</p>")
			[ ] FileWriteLine (FileHandle, "<p>{cleanStr(rcNotes.sText)}</p>")
			[ ] 
			[ ] // write syntax
			[ ] FileWriteLine (FileHandle, "<p class=""keyword"">Syntax</p>")
			[ ] FileWriteLine (FileHandle, "<p>{cleanStr(sFormatedAPI)}</p>")
			[ ] 
			[ ] // write parameters, if they exists
			[+] if (!IsNull(lsParm)) || (sReturns != "")
				[ ] // table heading
				[ ] FileWriteLine (FileHandle, "")
				[ ] FileWriteLine (FileHandle, "<table border=""0"" cellpadding=""1"" cellspacing=""4"">")
				[ ] FileWriteLine (FileHandle, "  <tr>")
				[ ] FileWriteLine (FileHandle, "    <td valign=""top"" nowrap class=""variable"">Variable&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>")
				[ ] FileWriteLine (FileHandle, "    <td valign=""top"" class=""variable"">Description&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>")
				[ ] FileWriteLine (FileHandle, "  </tr>")
				[ ] 
				[+] if (sReturns != "")
					[ ] FileWriteLine (FileHandle, "  <tr>")
					[ ] 
					[ ] FileWriteLine (FileHandle, "    <td valign=""top"" nowrap>{cleanStr(rcReturn.sParam)}</td>")
					[ ] FileWriteLine (FileHandle, "    <td valign=""top"">{cleanStr(rcReturn.sDesc)}</td>")
					[ ] FileWriteLine (FileHandle, "  </tr>")
				[ ] 
				[+] if (!IsNull(lsParm)) 
					[+] for each rcParm in lsParm
						[ ] FileWriteLine (FileHandle, "  <tr>")
						[+] if rcParm.bOptional
							[ ] FileWriteLine (FileHandle, "    <td valign=""top"" nowrap><i>{cleanStr(rcParm.sParam)}</i></td>")
						[+] else
							[ ] FileWriteLine (FileHandle, "    <td valign=""top"" nowrap>{cleanStr(rcParm.sParam)}</td>")
						[+] if !(IsNull(rcParm.lsExample))
							[ ] FileWriteLine (FileHandle, "    <td valign=""top"">{cleanStr(rcParm.sDesc)} [10]<br> [11]<br>")
							[+] for each sExample in rcParm.lsExample
								[ ] FileWriteLine (FileHandle, "    {cleanStr(sExample)} [9]<br>")
							[ ] FileWriteLine (FileHandle, "    </td>")
						[+] else
							[ ] FileWriteLine (FileHandle, "    <td valign=""top"">{cleanStr(rcParm.sDesc)}</td>")
						[ ] 
						[ ] FileWriteLine (FileHandle, "  </tr>")
						[ ] 
				[ ] 
				[ ] FileWriteLine (FileHandle, "</table>")
				[ ] FileWriteLine (FileHandle, "")
				[ ] 
			[ ] 
			[ ] // set any additional notes
			[+] if IsSet(rcNotes.lsExample)  && !(IsNull(rcNotes.lsExample))
				[ ] FileWriteLine (FileHandle, "<p class=""keyword"">Notes</p>")
				[ ] FileWriteLine (FileHandle, "<p>")
				[+] for each sExample in rcNotes.lsExample
					[ ] sExample = StrTran(sExample, "] //", "] ")
					[ ] sExample = StrTran(sExample, "]//", "]")
					[ ] sExample = StrTran(sExample, "[+]", "[-]")
					[ ] FileWriteLine (FileHandle, "{cleanStr(sExample)}<br>")
				[ ] 
				[ ] FileWriteLine (FileHandle, "</p>")
			[ ] 
			[ ] // write author
			[ ] FileWriteLine (FileHandle, "<p class=""keyword"">Author</p>")
			[ ] 
			[+] if (rcAuthor.sText == "none")
				[ ] FileWriteLine (FileHandle, "<p>{rcAuthor.sText}</p>")
			[+] else
				[ ] 
				[ ] FileWriteLine (FileHandle, "<SCRIPT type=""text/javascript""> ")
				[ ] 
				[ ] lsAuthors = MapKeys (mAuthors)
				[ ] 
				[+] for each sAuthor in lsAuthors 
					[+] if (StrPos (sAuthor, rcAuthor.sText) != 0)
						[ ] FileWriteLine (FileHandle, "document.write (DisplayAuthor (""{sAuthor}""));")
				[ ] 
				[ ] FileWriteLine (FileHandle, " </SCRIPT> <br>")
			[ ] 
			[ ] // write Original Description
			[ ] 
			[ ] FileWriteLine (FileHandle, "<a class=""navlink"" href=""javascript://"" onClick=""toggle('OriginalDescription');return false;""><p class=""keyword""><img src=""../../images/down.gif""> Original Description</p></a>")
			[ ] FileWriteLine (FileHandle, "<div class=""spoiler"" id=""OriginalDescription"">")
			[ ] FileWriteLine (FileHandle, "<p>{cleanStr (StrTran (rcOriginalnotes.sText, "[+]", "[-]"))}</p>")
			[ ] FileWriteLine (FileHandle, "</div>")
			[ ] 
			[ ] // location
			[ ] FileWriteLine (FileHandle, "<p class=""keyword"">Location</p>")
			[ ] FileWriteLine (FileHandle, "<p>")
			[+] switch sType
				[+] case "method", "property"
					[ ] FileWriteLine (FileHandle, "Class: {sLocation}<br>")
					[+] if (IsSet (rcOriginalGroup)) && (!IsNull (rcOriginalGroup))
						[ ] FileWriteLine (FileHandle, "Group: {rcOriginalGroup.sText}<br>")
					[ ] 
				[+] case "function"
					[ ] FileWriteLine (FileHandle, "Group: {sLocation}<br>")
					[+] if (IsSet (rcLocation)) && (!IsNull (rcLocation))
						[ ] FileWriteLine (FileHandle, "Test Case: {rcLocation.sText}<br>")
					[ ] 
			[ ] FileWriteLine (FileHandle, "<SCRIPT type=""text/javascript""> document.write (DisplaySilkDirLocations (""{StrTran (StrTran (sCurrentFile, SilkDir, ""{SilkDir}"), "\", "\\")}"")); </SCRIPT></p>")
			[ ] FileWriteLine (FileHandle, "")
			[ ] 
			[ ] // see code link
			[ ] FileWriteLine (FileHandle, "<p><SCRIPT type=""text/javascript""> ")
			[ ] FileWriteLine (FileHandle, "document.write (DisplayCode (""{StrTran (StrTran (SubStr (sFile, StrPos ("HelpAPI{sVariant}\", sFile)), "HelpAPI{sVariant}\", "Code\"), "\", "\\")}""));")
			[ ] FileWriteLine (FileHandle, " </SCRIPT></p>")
			[ ] 
			[ ] // page footer
			[ ] FileWriteLine (FileHandle, "</pre>")
			[ ] FileWriteLine (FileHandle, "")
			[ ] FileWriteLine (FileHandle, "<div class=""cut_sep"" id=""cut"">----------------------&lt;cut&gt;----------------------</div>")
			[ ] FileWriteLine (FileHandle, "<span class=""timestamp"">&#169; 2002-2010 ISD Automated Testing. (Created By Silk Help Generator {DateStr()}  {TimeStr()})</span>")
			[ ] FileWriteLine (FileHandle, "</body>")
			[ ] FileWriteLine (FileHandle, "</html>")
			[ ] FileWriteLine (FileHandle, "")
			[ ] 
			[+] if rcAuthor.sText != "none"
				[ ] rcAuthor.sText = StrTran (rcAuthor.sText, "/" , "")
				[ ] rcAuthor.sText = StrTran (rcAuthor.sText, "	" , " ")
				[ ] 
				[ ] lsAuthors = MapKeys (mAuthors)
				[ ] 
				[+] for each sAuthor in lsAuthors
					[ ] 
					[ ] laStatAut = MapGet (mAuthors, sAuthor)
					[ ] 
					[+] switch sType
						[+] case "method"
							[+] for i = 1 to ListCount (laStatAut[3])
								[+] if (laStatAut[3][i] == rcMethod.sText) && (StrPos (sAuthor, rcAuthor.sText) != 0)
									[ ] laStatAut[3][i] = GetAPIName(rcMethod.sText)	// method name
									[ ] laStatAut[4][i] = StrTran (sFile, sHTMLSaveLocation + "\HelpAPI{sVariant}\", "") 	// method url
									[ ] MapSet (mAuthors, sAuthor, laStatAut)
									[ ] break
								[ ] 
						[+] case "function"
							[+] for i = 1 to ListCount (laStatAut[3])
								[+] if (laStatAut[3][i] == rcFunction.sText) && (StrPos (sAuthor, rcAuthor.sText) != 0)
									[ ] laStatAut[3][i] = GetAPIName(rcFunction.sText)	// func name
									[ ] laStatAut[4][i] = StrTran (sFile, sHTMLSaveLocation + "\HelpAPI{sVariant}\", "") 	// func url
									[ ] MapSet (mAuthors, sAuthor, laStatAut)
									[ ] break
						[ ] 
					[ ] 
			[ ] 
			[ ] FileClose (FileHandle)
		[+] else
			[ ] Print ("+++ ERROR: File '{sFile}' not found !!")
		[ ] 
		[ ] // create file with Code
		[ ] CreateHTMLCodeFile (sFile2, rcCode, sTitle)
		[ ] 
	[ ] 
[ ] 
[+] private CreateDataHTMLHelp(list of string lsGenHelp)
	[ ] string sFullFile 
	[ ] string sFile = ""
	[ ] HFILE FileHandle
	[ ] string sKeyword
	[ ] string sTAB = Chr(9)
	[ ] string sTempLine
	[ ] string sKeyWord
	[ ] string sTabSpace
	[ ] list of string lsLineLen
	[ ] string sAPI
	[ ] string sFormatedAPI
	[ ] string sReturns
	[ ] list of Parameters lsParm = null
	[ ] Parameters rcParm
	[ ] Parameters rcReturn
	[ ] string sTitle
	[ ] integer iPos
	[ ] string sTemp, sType
	[ ] integer iLine = 0
	[ ] 
	[ ] sReturns = lsGenHelp[1]
	[ ] iPos = StrPos("type", sReturns)
	[ ] sTemp = Right(sReturns, Len(sReturns)-(iPos + 4))
	[ ] 
	[ ] iPos = StrPos(" is ", sTemp) == 0 ? StrPos("	is ", sTemp) : StrPos(" is ", sTemp)
	[ ] 
	[ ] sReturns = Trim(Left(sTemp, iPos))
	[ ] sType = Trim(Right(sTemp, Len(sTemp) - (iPos + 3)))
	[ ] 
	[ ] iPos = StrPos("//", sType)
	[+] if iPos > 1
		[ ] sType = Trim(Left(sType, iPos-1))
	[ ] 
	[ ] sAPI = "{sReturns} {sType}"
	[ ] sFile = "Data{sObjectDelimiter}{sType}{sObjectDelimiter}Name{sObjectDelimiter}{sReturns}.htm"
	[ ] sTitle = sAPI
	[ ] 
	[ ] 
	[ ] sFile = CreateHTMLObjectFile(sFile, sTitle)
	[ ] 
	[+] if (SYS_FileExists(sFile))
		[ ] FileHandle = FileOpen (sFile,  FM_APPEND)
		[ ] 
		[ ] // make heading
		[ ] FileWriteLine (FileHandle, "<table width=""100%"" border=""0"">")
		[ ] FileWriteLine (FileHandle, "  <tr>")
		[ ] FileWriteLine (FileHandle, "    <td bgcolor=""#6D76AB"" class=""heading"">{sAPI}</td>")
		[ ] FileWriteLine (FileHandle, "  </tr>")
		[ ] FileWriteLine (FileHandle, "</table>")
		[ ] FileWriteLine (FileHandle, "")
		[ ] 
		[ ] FileWriteLine (FileHandle, "<pre class=""prettyprint lang-java""  id=""java_lang"" style=""border-style: none"">")
		[ ] FileWriteLine (FileHandle, "")
		[ ] 
		[ ] FileWriteLine (FileHandle, "<p>")
		[ ] 
		[+] for each sTempLine in lsGenHelp
			[ ] 
			[ ] iLine++
			[+] if iLine == 1
				[ ] FileWriteLine (FileHandle, "<b>{cleanStr(sTempLine)}</b><br>")
			[+] else
				[ ] FileWriteLine (FileHandle, "{cleanStr(sTempLine)}<br>")
		[ ] 
		[ ] FileWriteLine (FileHandle, "</p>")
		[ ] FileWriteLine (FileHandle, "")
		[ ] 
		[ ] // location
		[ ] FileWriteLine (FileHandle, "<p class=""keyword"">Location</p>")
		[ ] FileWriteLine (FileHandle, "<p> <SCRIPT type=""text/javascript""> document.write (DisplaySilkDirLocations (""{StrTran (StrTran (sCurrentFile, SilkDir, ""{SilkDir}"), "\", "\\")}"")); </SCRIPT></p>")
		[ ] 
		[ ] FileWriteLine (FileHandle, "")
		[ ] 
		[ ] // page footer
		[ ] FileWriteLine (FileHandle, "")
		[ ] FileWriteLine (FileHandle, "</pre>")
		[ ] FileWriteLine (FileHandle, "<div class=""cut_sep"" id=""cut"">----------------------&lt;cut&gt;----------------------</div>")
		[ ] FileWriteLine (FileHandle, "<span class=""timestamp"">&#169; 2002-2010 ISD Automated Testing. (Created By Silk Help Generator {DateStr()}  {TimeStr()})</span>")
		[ ] FileWriteLine (FileHandle, "</body>")
		[ ] FileWriteLine (FileHandle, "</html>")
		[ ] FileWriteLine (FileHandle, "")
		[ ] 
		[ ] 
		[ ] FileClose (FileHandle)
	[+] else
		[ ] Print ("+++ ERROR: File '{sFile}' not found !!")
	[ ] 
[ ] 
[+] private CreateHTMLLinks()
	[ ] string sAPIDir = sHTMLSaveLocation + "\HelpAPI{sVariant}"
	[ ] string sAPIDirCode = sHTMLSaveLocation + "\HelpAPI{sVariant}\Code"
	[ ] list of string lsFiles = {}
	[ ] list of string lsFilesCode = {}
	[ ] string sFile
	[ ] list of string lsCodeLines, lsNewCodeLines
	[ ] string sLine, sTmpLine
	[ ] string sFullFile 
	[ ] HFILE FileHandle
	[ ] string sAPICurrentDir
	[ ] integer iPos
	[ ] BOOLEAN bSave, bLeave, bCode
	[ ] INTEGER i, iLen=0
	[+] list of string lsAPIDirs = {...}
		[ ] sAPIDir
		[ ] sAPIDirCode
	[ ] 
	[ ] MultipleProjects rcProject
	[+] if bMultipleProjects
		[+] for each rcProject in lrcProjects
			[ ] ListAppend(lsAPIDirs, "{sAPIDir}\{rcProject.sSaveTo}")
			[ ] ListAppend(lsAPIDirs, "{sAPIDirCode}\{rcProject.sSaveTo}")
	[ ] 
	[+] for each sAPICurrentDir in lsAPIDirs
		[ ] lsFiles = GetAPIFiles(sAPICurrentDir)
		[ ] ListSort(lsFiles)
		[ ] 
		[ ] iPos = ListFind(lsFiles, "API/API_Home.htm")
		[+] if iPos > 0
			[ ] ListDelete(lsFiles, iPos)
		[ ] 
		[+] for each sFile in lsFiles
			[ ] lsCodeLines = {}
			[ ] lsNewCodeLines = {}
			[ ] 
			[ ] sFullFile = sAPICurrentDir + "\" + sFile
			[ ] 
			[+] if StrPos ("\HelpAPI{sVariant}\Code", sFullFile) > 0
				[ ] sFile = StrTran ("../" + SubStr (sFullFile, StrPos ("\HelpAPI{sVariant}\Code\", sFullFile) + 14), "\", "/")
				[ ] bCode = TRUE
			[+] else
				[ ] bCode = FALSE
				[ ] sFile = StrTran ("../" + SubStr (sFullFile, StrPos ("\HelpAPI{sVariant}\", sFullFile) + 9), "\", "/")
			[ ] 
			[ ] bSave = FALSE
			[ ] bLeave = FALSE
			[ ] 
			[+] do
				[ ] lsCodeLines = SYS_GetFileContents(sFullFile)
			[+] except
				[ ] LogError("Unable to find file '{sFullFile}'")
			[ ] 
			[+] for each sLine in lsCodeLines
				[+] if !bLeave
					[+] if StrPos ("<p class=""keyword""><img src=""../../images/down.gif""> Original Description</p>", sLine) > 0 	// StrPos ("<p class=""keyword"">Original Description</p>", sLine) > 0
						[ ] bLeave = TRUE
				[+] else
					[+] if StrPos ("<p class=""keyword"">Location</p>", sLine) > 0
						[ ] bLeave = TRUE
				[ ] 
				[+] if !bLeave
					[ ] ListAppend(lsNewCodeLines, CreateLink(sLine, sFile, bCode))
					[+] if (!bSave ) && (sLine != lsNewCodeLines[ListCount (lsNewCodeLines)])
						[ ] bSave = TRUE
				[+] else
					[ ] ListAppend(lsNewCodeLines, sLine)
				[ ] 
			[ ] 
			[+] if bSave
				[ ] FileHandle = FileOpen (sFullFile,  FM_WRITE)
				[+] if !bCode 
					[+] for each sLine in lsNewCodeLines
						[ ] FileWriteLine (FileHandle, sLine)
				[+] else
					[ ] sLine = ""
					[ ] iLen = 0
					[+] for i = 1 to ListCount (lsNewCodeLines)
						[ ] iLen += Len (lsNewCodeLines[i])
						[ ] 
						[ ] sTmpLine = sLine
						[ ] sLine += (lsNewCodeLines[i])
						[ ] 
						[+] if (iLen > 10000) 	// max string size
							[ ] 
							[+] if StrPos ("<br>", sLine, TRUE) != 0
								[ ] sTmpLine = SubStr (sLine, StrPos ("<br>", sLine, TRUE) + 4)
								[ ] sLine = SubStr (sLine, 1, StrPos ("<br>", sLine, TRUE) + 3)
							[+] else 
								[ ] sLine = sTmpLine
								[ ] sTmpLine = ""
								[ ] 
							[ ] FileWriteLine (FileHandle, sLine)
							[ ] 
							[ ] iLen = 0
							[ ] sLine = sTmpLine
						[ ] 
					[ ] 
					[+] if sLine != ""
						[ ] FileWriteLine (FileHandle, sLine)
					[ ] 
				[ ] FileClose(FileHandle)
			[ ] 
	[ ] 
[ ] 
[+] private STRING CreateLink(string sLine, string sFile, boolean bCode)
	[ ] DataRecord rcDataRecord
	[ ] string sRecord1, sRecord2, sRecord3, sRecord4
	[ ] string sReplace1, sReplace2, sReplace3, sReplace4
	[ ] string sNewLine = sLine
	[ ] 
	[ ] INTEGER iFindFrom, iFindTo
	[ ] STRING sCharFrom, sCharTo
	[ ] LIST OF STRING lsCharsFrom, lsCharsTo
	[+] for each rcDataRecord in (bCode ? rcData + rcDataFunctions : rcData)
		[+] if (rcDataRecord.sType != "Name") && (rcDataRecord.sType != "object") && (StrPos (rcDataRecord.sType, sNewLine) != 0) && (rcDataRecord.sURL != sFile) //&& ((sFile == "@codefile") || (rcDataRecord.sURL != sFile))
			[ ] lsCharsFrom = 	{" ", "(", "=", "!", "-", "+", "<", ">", "@", "&", "|", ":", "?", "*", "/"}
			[ ] lsCharsTo = lsCharsFrom
			[ ] 
			[+] for each sCharFrom in lsCharsFrom	
				[ ] iFindFrom = StrPos ("{sCharFrom}{rcDataRecord.sType}", sNewLine)
				[+] if iFindFrom != 0	
					[+] for each sCharTo in lsCharsTo	
						[ ] iFindTo = StrPos ("{sCharFrom}{rcDataRecord.sType}{sCharTo}", sNewLine)
						[+] if iFindTo != 0
							[ ] sRecord1 = "{sCharFrom}{rcDataRecord.sType}{sCharTo}"
							[ ] sReplace1 = "{sCharFrom}<a class=""navlink"" href=""{rcDataRecord.sURL}"">{rcDataRecord.sType}</a>{sCharTo}"
							[ ] sNewLine = StrTran(sNewLine, sRecord1, sReplace1)
							[ ] 
							[+] if bCode
								[ ] sNewLine = StrTran(sNewLine, rcDataRecord.sURL, "../{rcDataRecord.sURL}")
			[ ] 
	[ ] 
	[ ] return sNewLine
	[ ] 
[ ] 
[+] private CreateAuthorsStat()
		[ ] 
		[ ] HFILE FileHandle
		[ ] 
		[ ] STRING sAuthor
		[ ] LIST OF STRING lsAuthors
		[ ] LIST OF ANYTYPE laStatAut
		[ ] INTEGER i
		[ ] 
		[+] if (!SYS_DirExists (sHTMLSaveLocation + "\HelpAPI{sVariant}\Stat"))
			[ ] SYS_MakeDir (sHTMLSaveLocation + "\HelpAPI{sVariant}\Stat")
		[+] else
			[ ] RemoveFiles (GetFileNames(sHTMLSaveLocation + "\HelpAPI{sVariant}\Stat"))
		[ ] 
		[ ] lsAuthors = MapKeys (mAuthors)
		[ ] 
		[+] for each sAuthor in lsAuthors
			[ ] 
			[ ] FileHandle = FileOpen (sHTMLSaveLocation + "\HelpAPI{sVariant}\Stat\" + StrTran (sAuthor, " ", "_") + ".htm" ,  FM_WRITE)
			[ ] 
			[ ] FileWriteLine (FileHandle, "<html>")
			[ ] FileWriteLine (FileHandle, "<head>")
			[ ] FileWriteLine (FileHandle, "<title>Authors statistic: {sAuthor}</title>")
			[ ] FileWriteLine (FileHandle, "<style type=""text/css"">")
			[ ] FileWriteLine (FileHandle, "body " + chr(123) + "scrollbar-face-color: #FFF; scrollbar-3dlight-color: #FFF; scrollbar-track-color: #FFF; scrollbar-shadow-color: #527194;	scrollbar-darkshadow-color: #FFF; scrollbar-arrow-color: #527194; scrollbar-highlight-color: #527194;" + chr(125))
			[ ] FileWriteLine (FileHandle, ".heading " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14px; color: #FFFFFF; font-weight: bold" + chr(125))
			[ ] FileWriteLine (FileHandle, "p " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px" + chr(125))
			[ ] FileWriteLine (FileHandle, ".keyword " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; font-weight: bold" + chr(125))
			[ ] FileWriteLine (FileHandle, "td " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px" + chr(125))
			[ ] FileWriteLine (FileHandle, ".variable " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; font-weight: bold; text-decoration: none" + chr(125))
			[ ] FileWriteLine (FileHandle, ".timestamp " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; font-style: italic; color: #999999" + chr(125))
			[ ] 
			[ ] FileWriteLine (FileHandle, "</style>")
			[ ] FileWriteLine (FileHandle, "</head>")
			[ ] FileWriteLine (FileHandle, "")
			[ ] FileWriteLine (FileHandle, "<body bgcolor=""#FFFFFF"" text=""#000000"">")
			[ ] FileWriteLine (FileHandle, "")
			[ ] 
			[ ] FileWriteLine (FileHandle, "<ul>")
			[ ] 
			[ ] laStatAut = MapGet (mAuthors, sAuthor)
			[ ] laStatAut = ListOfListSortVert ({laStatAut[3], laStatAut[4]}, 1)
			[ ] 
			[+] for i = 1 to ListCount (laStatAut[1])
				[ ] FileWriteLine (FileHandle, "<li><a class=""navlink2"" href=""..\{laStatAut[2][i]}"">{laStatAut[1][i]}</a></li>")
			[ ] 
			[ ] FileWriteLine (FileHandle, "</ul>")
			[ ] FileWriteLine (FileHandle, "</body>")
			[ ] FileWriteLine (FileHandle, "</html>")
			[ ] FileWriteLine (FileHandle, "")
			[ ] 
			[ ] FileClose (FileHandle)
			[ ] 
		[ ] 
	[ ] 
[ ] 
[ ] // ------------- Create HTML Navigation -------------------------
[+] private CreateFinalHelp()
	[ ] 
	[ ] string sDirTemp = Save_4Text_Location + "\SilkHelpGen_Temp"
	[ ] list of string lsFiles = GetFileNames(sDirTemp)
	[ ] string sHelpFile = sDirTemp + "\4test.txt"
	[ ] string sFile
	[ ] HFILE FileHandle
	[ ] list of string lsFileLines
	[ ] string sLine
	[ ] 
	[ ] // remove the 4test.txt file
	[ ] ListDelete(lsFiles, ListFind(lsFiles, sHelpFile))
	[ ] 
	[+] if (SYS_FileExists(sHelpFile))
		[ ] FileHandle = FileOpen (sHelpFile,  FM_APPEND)
	[+] else
		[ ] print("*** ERROR: Unable to find 4test.txt file: {sHelpFile} ***")
		[ ] return
	[ ] 
	[+] for each sFile in lsFiles
		[+] if (SYS_FileExists(sHelpFile))
			[ ] lsFileLines = SYS_GetFileContents(sFile)
			[+] for each sLine in lsFileLines
				[ ] FileWriteLine (FileHandle, sLine)
			[ ] 
			[ ] FileWriteLine (FileHandle, "")
		[+] else
			[ ] print (" ** ERROR: Unable to find file for processing: {sFile}")
	[ ] 
	[ ] FileWriteLine (FileHandle, "# ========== Created By Silk Help Generator {DateStr()}  {TimeStr()} ===========")
	[ ] FileWriteLine (FileHandle, "")
	[ ] FileClose (FileHandle)
	[ ] 
	[ ] // copy 4Test.txt to desired location
	[+] if (SYS_FileExists(Save_4Text_Location + "\4test.txt"))
		[ ] SYS_RemoveFile(Save_4Text_Location + "\4test.txt")
	[ ] 
	[ ] SYS_CopyFile(sHelpFile, Save_4Text_Location + "\4test.txt")
	[ ] 
	[ ] print("=== New Help File Generated: {Save_4Text_Location}\4test.txt ===")
	[ ] 
[ ] 
[+] private CreateFinalHTMLHelp()
	[ ] HFILE FileHandle
	[ ] string sAPICurrentDir
	[ ] string sFile = sHTMLSaveLocation + "\tocTab{sVariant}.js"
	[ ] string sAPIDir = sHTMLSaveLocation + "\HelpAPI{sVariant}"
	[ ] MultipleProjects rcProject
	[ ] list of string lsFiles = {}
	[ ] integer iPos = 0
	[ ] integer iLevel = 0
	[ ] integer iIndex
	[ ] 
	[ ] list of string lsAPIDirs = {}
	[ ] 
	[ ] list of MultipleProjects lrcAllProjects = {}
	[ ] 
	[+] if bMultipleProjects
		[+] for each rcProject in lrcProjects
			[+] if ListFind (lsAPIDirs, "{sAPIDir}\{rcProject.sSaveTo}") == 0
				[ ] ListAppend(lsAPIDirs, "{sAPIDir}\{rcProject.sSaveTo}")
				[ ] ListAppend(lrcAllProjects, rcProject)
	[ ] 
	[ ] // --- Get Classes ----
	[ ] tocTab++
	[ ] GenerateTOCNode("HelpAPI{sVariant}/API/API_Home.htm", "Class API", "{tocTab}")
	[+] for each sAPICurrentDir in lsAPIDirs
		[ ] iPos ++
		[ ] iLevel++
		[ ] lsFiles = GetAPIFiles(sAPICurrentDir)
		[ ] ListSort(lsFiles)
		[ ] 
		[ ] iIndex = ListFind(lsFiles, "API_Home.htm")
		[+] if iIndex > 0
			[ ] ListDelete(lsFiles, iIndex)
		[ ] 
		[+] if (lrcAllProjects[iPos].sSaveTo == "")
			[ ] sCurrentDir = "HelpAPI{sVariant}"				// the framework files
		[+] else
			[ ] sCurrentDir = "HelpAPI{sVariant}/{lrcAllProjects[iPos].sSaveTo}"		// project files
		[ ] 
		[+] if bMultipleProjects
			[ ] GenerateTOCNode("", lrcAllProjects[iPos].sName, "{tocTab}.{iLevel}")
			[ ] GenerateTOC(lsFiles, "Class", "{tocTab}.{iLevel}")
		[+] else
			[ ] GenerateTOC(lsFiles, "Class", "{tocTab}")
	[ ] 
	[ ] // --- Get Functions ----
	[ ] tocTab++
	[ ] iPos = 0
	[ ] iLevel = 0
	[ ] GenerateTOCNode("HelpAPI{sVariant}/API/API_Home.htm", "Function API", "{tocTab}")
	[+] for each sAPICurrentDir in lsAPIDirs
		[ ] iPos++
		[ ] iLevel++
		[ ] lsFiles = GetAPIFiles(sAPICurrentDir)
		[ ] ListSort(lsFiles)
		[ ] 
		[ ] sCurrentDir = "HelpAPI{sVariant}/{lrcAllProjects[iPos].sSaveTo}"
		[ ] 
		[+] if bMultipleProjects
			[ ] GenerateTOCNode("", lrcAllProjects[iPos].sName, "{tocTab}.{iLevel}")
			[ ] GenerateTOC(lsFiles, "Group", "{tocTab}.{iLevel}")
		[+] else
			[ ] GenerateTOC(lsFiles, "Group", "{tocTab}")
	[ ] 
	[ ] // --- Get Data Types ------
	[ ] tocTab++
	[ ] iLevel = 0
	[ ] iPos = 0
	[ ] GenerateTOCNode("HelpAPI{sVariant}/API/API_Home.htm", "Data Types", "{tocTab}")
	[ ] boolean bFirst = true
	[+] for each sAPICurrentDir in lsAPIDirs
		[ ] bFirst = true
		[ ] iPos++
		[ ] iLevel++
		[ ] lsFiles = GetAPIFiles(sAPICurrentDir)
		[ ] ListSort(lsFiles)
		[ ] 
		[ ] sCurrentDir = "HelpAPI{sVariant}/{lrcAllProjects[iPos].sSaveTo}"
		[ ] 
		[+] if bFirst && bMultipleProjects
			[ ] GenerateTOCNode("", lrcAllProjects[iPos].sName, "{tocTab}.{iLevel}")
			[ ] bFirst = false
		[ ] 
		[ ] // records
		[+] if bMultipleProjects
			[ ] GenerateTOCNode("", "Data Records", "{tocTab}.{iLevel}.1")
			[ ] GenerateDataTOC(lsFiles, "record", "{tocTab}.{iLevel}", 1)
		[+] else
			[ ] GenerateTOCNode("", "Data Records", "{tocTab}.1")
			[ ] GenerateDataTOC(lsFiles, "record", "{tocTab}", 1)
		[ ] 
		[ ] // enums
		[+] if bMultipleProjects
			[ ] GenerateTOCNode("", "Data Enums", "{tocTab}.{iLevel}.2")
			[ ] GenerateDataTOC(lsFiles, "enum", "{tocTab}.{iLevel}", 2)
		[+] else
			[ ] GenerateTOCNode("", "Data Enums", "{tocTab}.2")
			[ ] GenerateDataTOC(lsFiles, "enum", "{tocTab}", 2)
		[ ] 
		[ ] // other data types
		[+] if bMultipleProjects
			[ ] GenerateTOCNode("", "Data Other", "{tocTab}.{iLevel}.3")
			[ ] GenerateDataOtherTOC(lsFiles, "other", "{tocTab}.{iLevel}", 3)
		[+] else
			[ ] GenerateTOCNode("", "Data Other", "{tocTab}.3")
			[ ] GenerateDataOtherTOC(lsFiles, "other", "{tocTab}", 3)
		[ ] 
	[ ] 
	[ ] // close TOC file
	[ ] FileHandle = FileOpen (sFile,  FM_APPEND)
	[+] if bMultipleProjects
		[ ] FileWriteLine (FileHandle, "var nCols = 4;")
	[+] else
		[ ] FileWriteLine (FileHandle, "var nCols = 3;")
	[ ] 
	[ ] FileWriteLine (FileHandle, "var variant = ""{sVariant}"";   // for variant sandbox")
	[ ] 
	[ ] FileWriteLine (FileHandle, "")
	[ ] 
[ ] 
[+] private GenerateTOCNode(string sTOC, string sTitle, string sTOCLevel)
	[ ] HFILE FileHandle
	[ ] string sFile
	[ ] sFile = sHTMLSaveLocation + "\tocTab{sVariant}.js"
	[ ] 
	[ ] sTOC = StrTRan(sTOC, "//", "/")
	[ ] 
	[ ] FileHandle = FileOpen (sFile,  FM_APPEND)
	[ ] 
	[ ] // Create top level tree
	[ ] tocCount++
	[ ] FileWriteLine (FileHandle, "tocTab[{tocCount}] = new Array (""{sTOCLevel}"", ""{sTitle}"", ""{sTOC}"");")
	[ ] FileClose (FileHandle)
	[ ] 
[ ] 
[+] private GenerateTOC(list of string lsFileNames, string sObjectType, string sTOCLevel)
	[ ] string sFile
	[ ] HFILE FileHandle
	[ ] list of string lsParsedFileName
	[ ] integer tocLevel2 = 0
	[ ] integer tocLevel3 = 0
	[ ] string sCurrentAPI = ""
	[ ] boolean bCurrentAPISet = false
	[ ] 
	[ ] sFile = sHTMLSaveLocation + "\tocTab{sVariant}.js"
	[ ] FileHandle = FileOpen (sFile,  FM_APPEND)
	[ ] 
	[ ] sCurrentDir = StrTran(sCurrentDir, "//", "/")
	[ ] 
	[+] for each sFile in lsFileNames
		[ ] 
		[+] if (Left(sFile, Len(sObjectType)) == sObjectType)
			[ ] lsParsedFileName = {}
			[ ] split(StrTran(sFile, ".htm", ""), lsParsedFileName, "{sObjectDelimiter}")
			[+] if lsParsedFileName[2] != sCurrentAPI
				[ ] sCurrentAPI = lsParsedFileName[2]
				[ ] tocCount++
				[ ] tocLevel2++
				[ ] tocLevel3 = 0
				[ ] FileWriteLine (FileHandle, "tocTab[{tocCount}] = new Array (""{sTOCLevel}.{tocLevel2}"", ""{StrTran(sCurrentAPI, "-", " ")}"", """");")
			[ ] 
			[ ] tocCount++
			[ ] tocLevel3++
			[ ] FileWriteLine (FileHandle, "tocTab[{tocCount}] = new Array (""{sTOCLevel}.{tocLevel2}.{tocLevel3}"", ""{StrTran(lsParsedFileName[4], "-", " ")}"", ""{StrTran("{sCurrentDir}/{sFile}", "//", "/")}"");")
			[ ] 
			[+] if StrPos ("Class~", sFile) != 1
				[ ] ListAppend(rcDataFunctions, {lsParsedFileName[4], StrTran(sCurrentDir, "HelpAPI{sVariant}/", "../") + "/" + sFile})
			[ ] 
	[ ] FileWriteLine (FileHandle, "")
	[ ] 
	[ ] FileClose (FileHandle)
	[ ] 
[ ] 
[+] private GenerateDataTOC(list of string lsFileNames, string sObjectType, string sTOCLevel, integer tocLevel2)
	[ ] 
	[ ] string sFile
	[ ] HFILE FileHandle
	[ ] list of string lsParsedFileName
	[ ] integer tocLevel3 = 0
	[ ] string sCurrentAPI = ""
	[ ] boolean bCurrentAPISet = false
	[ ] 
	[ ] sFile = sHTMLSaveLocation + "\tocTab{sVariant}.js"
	[ ] FileHandle = FileOpen (sFile,  FM_APPEND)
	[ ] 
	[ ] string sObjectTypeFull = "Data{sObjectDelimiter}{sObjectType}"
	[ ] 
	[ ] sCurrentDir = StrTran(sCurrentDir, "//", "/")
	[+] for each sFile in lsFileNames
		[+] if (Left(sFile, Len(sObjectTypeFull)) == sObjectTypeFull)
			[ ] lsParsedFileName = {}
			[ ] split(StrTran(sFile, ".htm", ""), lsParsedFileName, "{sObjectDelimiter}")
			[ ] 
			[ ] tocCount++
			[ ] tocLevel3++
			[ ] FileWriteLine (FileHandle, "tocTab[{tocCount}] = new Array (""{sTOCLevel}.{tocLevel2}.{tocLevel3}"", ""{lsParsedFileName[4]}"", ""{StrTran("{sCurrentDir}/{sFile}", "//", "/")}"");")
			[ ] ListAppend(rcData, {lsParsedFileName[4], StrTran(sCurrentDir, "HelpAPI{sVariant}/", "../") + "/" + sFile})
			[ ] 
	[ ] FileWriteLine (FileHandle, "")
	[ ] 
	[ ] FileClose (FileHandle)
	[ ] 
[ ] 
[+] private GenerateDataOtherTOC(list of string lsFileNames, string sObjectType, string sTOCLevel, integer tocLevel2)
	[ ] string sFile
	[ ] HFILE FileHandle
	[ ] list of string lsParsedFileName
	[ ] integer tocLevel3 = 0
	[ ] string sCurrentAPI = ""
	[ ] boolean bCurrentAPISet = false
	[ ] 
	[ ] sFile = sHTMLSaveLocation + "\tocTab{sVariant}.js"
	[ ] FileHandle = FileOpen (sFile,  FM_APPEND)
	[ ] 
	[ ] sCurrentDir = StrTran(sCurrentDir, "//", "/")
	[ ] 
	[+] for each sFile in lsFileNames
		[ ] lsParsedFileName = {}
		[ ] split(StrTran(sFile, ".htm", ""), lsParsedFileName, "{sObjectDelimiter}")
		[ ] 
		[+] if lsParsedFileName[1] == "Data"
			[+] if (lsParsedFileName[2] != "record") && (lsParsedFileName[2] != "enum")
				[ ] 
				[ ] tocCount++
				[ ] tocLevel3++
				[ ] FileWriteLine (FileHandle, "tocTab[{tocCount}] = new Array (""{sTOCLevel}.{tocLevel2}.{tocLevel3}"", ""{lsParsedFileName[4]}"", ""{StrTran("{sCurrentDir}/{sFile}", "//", "/")}"");")
				[ ] ListAppend(rcData, {lsParsedFileName[4], StrTran(sCurrentDir, "HelpAPI{sVariant}/", "../") + "/" + sFile})
				[ ] 
	[ ] FileWriteLine (FileHandle, "")
	[ ] 
	[ ] FileClose (FileHandle)
	[ ] 
[ ] 
[ ] // ------------- Help Validation and Cleaning -------------------
[+] private list of string CheckLineLength(string sLine)
	[ ] integer iMax = 235
	[ ] list of string lsLines = {}
	[ ] string sTempLine
	[ ] integer iPos
	[ ] 
	[+] while (Len(sLine) > iMax)
		[ ] sTempLine = Left(sLine, iMax)
		[ ] iPos = StrPos(" ", sTempLine, true)
		[ ] sTempLine = Left(sTempLine, iPos)
		[ ] sTempLine = Trim (sTempLine)
		[ ] ListAppend(lsLines, sTempLine)
		[ ] 
		[ ] sLine = Right(sLine, Len(sLine) - Len(sTempLine))
		[ ] sLine = Trim (sLine)
	[ ] 
	[ ] ListAppend(lsLines, sLine)
	[ ] 
	[ ] return lsLines
	[ ] 
[ ] 
[+] private string clean (string theString)
	[ ] string rString = theString
	[ ] rString = StrTran (rString, chr(10), "")
	[ ] rString = Trim(rString)
	[ ] return rString
[ ] 
[+] private string cleanStr (string theString)
	[ ] string rString = theString
	[ ] rString = StrTran (rString, chr(10), "<br>")
	[ ] rString = StrTran (rString, chr(9), "    ")//&#009;
	[ ] rString = StrTran (rString, "<", "&lt;")
	[ ] rString = StrTran (rString, "&lt;br>", "<br>")
	[ ] return rString
[ ] 
[+] private list of GenHelp ValidateSyntax(list of GenHelp lrcHelp)
	[ ] GenHelp rcClass
	[ ] GenHelp rcMethod
	[ ] GenHelp rcReturns
	[ ] list of GenHelp rcParameter = {}
	[ ] GenHelp rcNotes
	[ ] GenHelp rcProperty
	[ ] GenHelp rcGroup
	[ ] GenHelp rcFunction
	[ ] GenHelp rcData
	[ ] GenHelp rcAuthor
	[ ] GenHelp rcOriginalnotes
	[ ] GenHelp rcLocation
	[ ] GenHelp rcOriginalGroup
	[ ] list of GenHelp rcCode
	[ ] 
	[ ] list of GenHelp lrcReturnHelp = {}
	[ ] STRING sAutors, sAut, sTmpAut
	[ ] LIST OF ANYTYPE liAStatAut
	[ ] 
	[+] if bTrace
		[ ] print ("-----------------------------")
		[ ] print (lrcHelp)
		[ ] print ("-----------------------------")
	[ ] 
	[ ] string sType = ""
	[+] for each rcData in lrcHelp
		[+] switch rcData.sKeyword
			[+] case "@class:"
				[ ] rcClass = rcData
			[+] case "@method:"
				[ ] rcMethod = rcData
				[+] if (rcData.sText != "")
					[ ] sType = "method"
			[+] case "@returns:"
				[ ] rcReturns = rcData
			[+] case "@parameter:"
				[ ] ListAppend(rcParameter, rcData)
			[+] case "@notes:"
				[ ] rcNotes = rcData
			[+] case "@property:"
				[ ] rcProperty = rcData
				[+] if (rcData.sText != "")
					[ ] sType = "property"
			[+] case "@group:"
				[ ] rcGroup = rcData
			[+] case "@function:"
				[ ] rcFunction = rcData
				[+] if (rcData.sText != "")
					[ ] sType = "function"
			[+] case "@author:"
				[ ] rcAuthor = rcData
			[+] case "@originalnotes:"
				[ ] rcOriginalnotes = rcData
			[+] case "@originallocation:"
				[ ] rcLocation = rcData
			[+] case "@originalgroup:"
				[ ] rcOriginalGroup = rcData
			[+] case "@originalcode:"
				[ ] ListAppend(rcCode, rcData)
			[+] default
				[ ] LogWarning("*** WARNING: Recieved unknown keyword: '{rcData.sKeyword}'")
				[ ] ListPrint([LIST]rcData)
				[ ] print("********************************************")
	[ ] 
	[+] if !IsSet (sType) || sType == "" 
		[ ] sType = "none"
		[ ] print("*** ERROR: Unable to get the Help Type *****") 
		[ ] ListPrint([LIST]lrcHelp)
		[ ] print("********************************************")
		[ ] return lrcHelp
	[ ] 
	[+] switch sType
		[+] case "method"
			[+] if (IsSet (rcClass.sText) && rcClass.sText != "")
				[ ] ListAppend(lrcReturnHelp, rcClass)
			[+] else
				[ ] rcClass.sText = "none"
				[ ] ListAppend(lrcReturnHelp, rcClass)
				[ ] Print("*** ERROR: Class keyword value required for all methods! ***")
				[ ] ListPrint([LIST]rcClass)
				[ ] print("********************************************")
			[ ] 
			[+] if (IsSet (rcMethod.sText) && rcMethod.sText != "")
				[ ] ListAppend(lrcReturnHelp, rcMethod)
			[+] else
				[ ] rcMethod.sText = "none"
				[ ] ListAppend(lrcReturnHelp, rcMethod)
				[ ] print("*** ERROR: Method keyword value required for all methods! ***")
				[ ] ListPrint([LIST]rcMethod)
				[ ] print("********************************************")
			[ ] 
			[+] if IsSet(rcReturns.sText)
				[ ] ListAppend(lrcReturnHelp, rcReturns)
			[ ] 
			[+] for each rcData in rcParameter
				[ ] ListAppend(lrcReturnHelp, rcData)
			[ ] 
			[+] if (IsSet (rcNotes.sText) && rcNotes.sText != "")
				[ ] ListAppend(lrcReturnHelp, rcNotes)
			[+] else
				[ ] rcNotes.sKeyword = "@notes:"
				[ ] rcNotes.sText = "none"
				[ ] ListAppend(lrcReturnHelp, rcNotes)
				[ ] print("*** ERROR: Notes keyword value required for all methods! ***")
				[ ] ListPrint([LIST]rcNotes)
				[ ] print("********************************************")
			[ ] 
			[+] if (IsSet (rcAuthor.sText) && rcAuthor.sText != "")
				[ ] ListAppend(lrcReturnHelp, rcAuthor)
				[ ] 
				[+] if rcAuthor.sText != "none"
					[ ] sAutors = StrTran (rcAuthor.sText, "/" , "")
					[ ] sAutors = StrTran (sAutors, "	" , " ")
					[ ] 
					[+] while StrPos (",", sAutors) > 0
						[ ] sTmpAut = Trim (SubStr (sAutors, 1, StrPos (",", sAutors) - 1))
						[ ] 
						[+] if MapHasKey (mAuthorReplace, sTmpAut)
							[ ] sTmpAut = MapGet (mAuthorReplace, sTmpAut)
						[ ] 
						[+] if MapHasKey (mAuthors, sTmpAut)
							[ ] liAStatAut = MapGet (mAuthors, sTmpAut)
							[ ] liAStatAut[1]++
							[ ] ListAppend (liAStatAut[3], rcMethod.sText)
							[ ] ListAppend (liAStatAut[4], "")
						[+] else
							[ ] liAStatAut = {1, 0, {rcMethod.sText}, {""}}
						[ ] MapSet (mAuthors, sTmpAut, liAStatAut)
						[ ] sAutors = SubStr (sAutors, StrPos (",", sAutors) + 1)
						[ ] 
					[+] if Trim (sAutors) != "" && Trim (sAutors) != "..."
						[ ] sTmpAut = Trim (sAutors)
						[ ] 
						[+] if MapHasKey (mAuthorReplace, sTmpAut)
							[ ] sTmpAut = MapGet (mAuthorReplace, sTmpAut)
						[ ] 
						[+] if MapHasKey (mAuthors, sTmpAut)
							[ ] liAStatAut = MapGet (mAuthors, sTmpAut)
							[ ] liAStatAut[1]++
							[ ] ListAppend (liAStatAut[3], rcMethod.sText)
							[ ] ListAppend (liAStatAut[4], "")
						[+] else
							[ ] liAStatAut = {1, 0, {rcMethod.sText}, {""}}
						[ ] 
						[ ] MapSet (mAuthors, sTmpAut, liAStatAut)
						[ ] 
					[ ] 
				[ ] 
			[+] else
				[ ] rcAuthor.sKeyword = "@author:"
				[ ] rcAuthor.sText = "none"
				[ ] ListAppend(lrcReturnHelp, rcAuthor)
				[ ] print("*** ERROR: Author keyword value required for all methods! ***")
				[ ] ListPrint([LIST]rcAuthor)
				[ ] print("********************************************")
			[ ] 
			[+] if (IsSet (rcOriginalnotes.sText) && rcOriginalnotes.sText != "")
				[ ] ListAppend(lrcReturnHelp, rcOriginalnotes)
			[+] else
				[ ] print("*** ERROR: Group keyword value required for all functions! ***")
				[ ] ListPrint([LIST]rcClass)
				[ ] print("********************************************")
			[ ] 
			[+] if (IsSet (rcOriginalGroup.sText) && rcOriginalGroup.sText != "")
				[ ] ListAppend(lrcReturnHelp, rcOriginalGroup)
			[+] else
				[ ] print("*** ERROR: Group keyword value required for all functions! ***")
				[ ] ListPrint([LIST]rcClass)
				[ ] print("********************************************")
			[ ] 
			[+] for each rcData in rcCode
				[ ] ListAppend(lrcReturnHelp, rcData)
			[ ] 
		[+] case "property"
			[+] if (IsSet (rcClass.sText) && rcClass.sText != "")
				[ ] ListAppend(lrcReturnHelp, rcClass)
			[+] else
				[ ] rcClass.sText = "none"
				[ ] ListAppend(lrcReturnHelp, rcClass)
				[ ] print("*** ERROR: Class keyword value required for all properties! ***")
				[ ] ListPrint([LIST]rcClass)
				[ ] print("********************************************")
			[ ] 
			[+] if (IsSet (rcProperty.sText) && rcProperty.sText != "")
				[ ] ListAppend(lrcReturnHelp, rcProperty)
			[+] else
				[ ] rcProperty.sText = "none"
				[ ] ListAppend(lrcReturnHelp, rcProperty)
				[ ] print("*** ERROR: Property keyword value required for all properties! ***")
				[ ] ListPrint([LIST]rcProperty)
				[ ] print("********************************************")
			[ ] 
			[+] if (IsSet (rcNotes.sText) && rcNotes.sText != "")
				[ ] ListAppend(lrcReturnHelp, rcNotes)
			[+] else
				[ ] rcNotes.sText = "none"
				[ ] ListAppend(lrcReturnHelp, rcNotes)
				[ ] print("*** ERROR: Notes keyword value required for all properties! ***")
				[ ] ListPrint([LIST]rcNotes)
				[ ] print("********************************************")
			[ ] 
		[+] case "function"
			[+] if (IsSet (rcGroup.sText) && rcGroup.sText != "")
				[ ] ListAppend(lrcReturnHelp, rcGroup)
			[+] else
				[ ] rcGroup.sText = "none"
				[ ] ListAppend(lrcReturnHelp, rcGroup)
				[ ] print("*** ERROR: Group keyword value required for all functions! ***")
				[ ] ListPrint([LIST]rcClass)
				[ ] print("********************************************")
			[ ] 
			[+] if (IsSet (rcFunction.sText) && rcFunction.sText != "")
				[ ] ListAppend(lrcReturnHelp, rcFunction)
			[+] else
				[ ] rcFunction.sText = "none"
				[ ] ListAppend(lrcReturnHelp, rcFunction)
				[ ] print("*** ERROR: Function keyword value required for all functions! ***")
				[ ] ListPrint([LIST]rcClass)
				[ ] print("********************************************")
			[ ] 
			[+] if IsSet(rcReturns.sText)
				[ ] ListAppend(lrcReturnHelp, rcReturns)
			[ ] 
			[+] for each rcData in rcParameter
				[ ] ListAppend(lrcReturnHelp, rcData)
			[ ] 
			[+] if (IsSet (rcNotes.sText) && rcNotes.sText != "")
				[ ] ListAppend(lrcReturnHelp, rcNotes)
			[+] else
				[ ] rcNotes.sKeyword = "@notes:"
				[ ] rcNotes.sText = "none"
				[ ] ListAppend(lrcReturnHelp, rcNotes)
				[ ] print("*** ERROR: Notes keyword value required for all functions! ***")
				[ ] ListPrint([LIST]rcNotes)
				[ ] print("********************************************")
			[ ] 
			[+] if (IsSet (rcAuthor.sText) && rcAuthor.sText != "")
				[ ] ListAppend(lrcReturnHelp, rcAuthor)
				[ ] 
				[+] if rcAuthor.sText != "none"
					[ ] sAutors = StrTran (rcAuthor.sText, "/" , "")
					[ ] sAutors = StrTran (sAutors, "	" , " ")
					[ ] 
					[+] while StrPos (",", sAutors) > 0
						[ ] sTmpAut = Trim (SubStr (sAutors, 1, StrPos (",", sAutors) - 1))
						[+] if MapHasKey (mAuthors, sTmpAut)
							[ ] liAStatAut = MapGet (mAuthors, sTmpAut)
							[ ] liAStatAut[2]++
							[ ] ListAppend (liAStatAut[3], rcFunction.sText)
							[ ] ListAppend (liAStatAut[4], "")
						[+] else
							[ ] liAStatAut = {0, 1, {rcFunction.sText}, {""}}
						[ ] MapSet (mAuthors, sTmpAut, liAStatAut)
						[ ] sAutors = SubStr (sAutors, StrPos (",", sAutors) + 1)
					[+] if Trim (sAutors) != "" && Trim (sAutors) != "..." && sAutors != "<enter your user name here>"
						[ ] sTmpAut = Trim (sAutors)
						[+] if MapHasKey (mAuthors, sTmpAut)
							[ ] liAStatAut = MapGet (mAuthors, sTmpAut)
							[ ] liAStatAut[2]++
							[ ] ListAppend (liAStatAut[3], rcFunction.sText)
							[ ] ListAppend (liAStatAut[4], "")
						[+] else
							[ ] liAStatAut = {0, 1, {rcFunction.sText}, {""}}
						[ ] MapSet (mAuthors, sTmpAut, liAStatAut)
						[ ] 
				[ ] 
			[+] else
				[ ] rcAuthor.sKeyword = "@author:"
				[ ] rcAuthor.sText = "none"
				[ ] ListAppend(lrcReturnHelp, rcAuthor)
				[ ] print("*** ERROR: Author keyword value required for all methods! ***") //LogError
				[ ] ListPrint([LIST]rcAuthor)
				[ ] print("********************************************")
			[ ] 
			[+] if (IsSet (rcOriginalnotes.sText) && rcOriginalnotes.sText != "")
				[ ] ListAppend(lrcReturnHelp, rcOriginalnotes)
			[+] else
				[ ] print("*** ERROR: Group keyword value required for all functions! ***") //LogError
				[ ] ListPrint([LIST]rcClass)
				[ ] print("********************************************")
			[ ] 
			[+] if (IsSet (rcLocation.sText) && rcLocation.sText != "")
				[ ] ListAppend(lrcReturnHelp, rcLocation)
			[+] else
				[ ] print("*** ERROR: Group keyword value required for all functions! ***") //LogError
				[ ] ListPrint([LIST]rcClass)
				[ ] print("********************************************")
			[ ] 
			[+] for each rcData in rcCode
				[ ] ListAppend(lrcReturnHelp, rcData)
			[ ] 
		[ ] 
	[ ] 
	[ ] return lrcReturnHelp
	[ ] 
[ ] 
[+] private string GetAPIName(string sAPI, boolean bIncludeClass optional)
	[ ] string sLeft = "="
	[ ] string sRight = "("
	[ ] integer iPos
	[ ] string sAPINew
	[ ] 
	[+] if IsNull(bIncludeClass)
		[ ] bIncludeClass = false
	[ ] 
	[ ] iPos = StrPos(sLeft, sAPI)
	[+] if iPos > 0
		[ ] sAPINew = Right(sAPI, Len(sAPI) - (iPos))
	[+] else
		[ ] sAPINew = sAPI
	[ ] 
	[ ] iPos = StrPos(sRight, sAPINew)
	[+] if iPos > 0
		[ ] sAPINew = Left(sAPINew, iPos-1)
	[ ] 
	[+] if (!bIncludeClass)
		[ ] iPos = StrPos(".", sAPINew, true)
		[+] if iPos > 0
			[ ] sAPINew = Right(sAPINew, Len(sAPINew) - iPos)
	[ ] 
	[ ] sAPINew = Trim(sAPINew)
	[ ] 
	[ ] return sAPINew
	[ ] 
[ ] 
[+] private string GetAPIReturn(string sAPI)
	[ ] string sLeft = "="
	[ ] string sRight = "("
	[ ] integer iPos
	[ ] string sAPINew = ""
	[ ] 
	[ ] iPos = StrPos(sLeft, sAPI)
	[+] if iPos > 0
		[ ] sAPINew = Left(sAPI, iPos-1)
	[ ] sAPINew = Trim(sAPINew)
	[ ] 
	[ ] return sAPINew
	[ ] 
[ ] 
[+] private string FormatAPIParameters(string sAPI)
	[ ] string sLeft = "("
	[ ] integer iPos
	[ ] string sAPINew
	[ ] 
	[ ] iPos = StrPos(sLeft, sAPI)
	[+] if iPos > 0
		[ ] sAPINew = Right(sAPI, Len(sAPI)-(iPos-1))
	[+] else
		[ ] sAPINew = sAPI
	[ ] 
	[ ] sAPINew = Trim(sAPINew)
	[ ] 
	[ ] sAPINew = StrTran(sAPINew, "[", "[<i>")
	[ ] sAPINew = StrTran(sAPINew, "]", "</i>]")
	[ ] 
	[ ] return sAPINew
	[ ] 
[ ] 
[+] private string GetFormatedAPI(string sAPI)
	[ ] string APIName = GetAPIName(sAPI, true)
	[ ] string APIReturn = GetAPIReturn(sAPI)
	[ ] string APIParam = FormatAPIParameters(sAPI)
	[ ] string sTAB = Chr(9)
	[ ] 
	[ ] string sFormatedAPI = ""
	[ ] 
	[+] if APIReturn != ""
		[ ] sFormatedAPI += APIReturn + " = "
	[ ] 
	[ ] sFormatedAPI += APIName + " " + APIParam
	[ ] 
	[+] if StrPos ("//", sFormatedAPI) != 0
		[ ] sFormatedAPI = Stuff (sFormatedAPI, StrPos ("//", sFormatedAPI), 2, "<br>")
	[ ] 
	[ ] sFormatedAPI = StrTran (sFormatedAPI, "//" , "")
	[ ] 
	[ ] return sFormatedAPI
	[ ] 
[ ] 
[+] private list of string GetOptionalParams(string sSyntax)
	[ ] string sLeft = "("
	[ ] integer iPos, iCount, i, iOption = 0
	[ ] string sSyntaxNew = ""
	[ ] list of string lsOptionalParams
	[ ] list of string lsParams
	[ ] string sParamClean
	[ ] string APIParam = FormatAPIParameters(sSyntax)
	[ ] APIParam = StrTran(APIParam, "<i>", "")
	[ ] APIParam = StrTran(APIParam, "</i>", "")
	[ ] 
	[ ] sSyntax = APIParam
	[ ] 
	[ ] iPos = StrPos(sLeft, sSyntax)
	[+] if iPos > 0
		[ ] sSyntaxNew = Right(sSyntax, Len(sSyntax)-iPos)
		[ ] sSyntaxNew = Left(sSyntaxNew, Len(sSyntaxNew)-1)
		[ ] sSyntaxNew = Trim(sSyntaxNew)
	[ ] 
	[+] if sSyntaxNew == ""
		[ ] return null
	[ ] 
	[ ] // find if optional parameters exists
	[ ] iCount = split(sSyntaxNew, lsParams, ",")
	[+] for i = 1 to iCount
		[ ] iPos = StrPos(" NULL optional", lsParams[i])
		[+] if iPos == 0
			[ ] iPos = StrPos(" null optional", lsParams[i])
		[+] if iPos == 0
			[ ] iPos = StrPos(" optional", lsParams[i])
		[ ] 
		[+] if iPos > 0
			[ ] iOption = i
			[ ] break
	[ ] 
	[+] if iOption > 0
		[+] for i = iOption to iCount
			[ ] 
			[ ] sParamClean = Trim(StrTran(lsParams[i], " NULL optional", ""))
			[ ] sParamClean = Trim(StrTran(lsParams[i], " null optional", ""))
			[ ] sParamClean = Trim(StrTran(lsParams[i], " optional", ""))
			[ ] iPos = StrPos(" ", sParamClean, TRUE)
			[+] if iPos > 0
				[ ] sParamClean = SubStr (sParamClean, iPos + 1) 
			[ ] 
			[ ] iPos = StrPos(")", sParamClean, TRUE)
			[+] if iPos > 0
				[ ] sParamClean = SubStr (sParamClean, 1, iPos - 1) 
			[ ] 
			[ ] ListAppend(lsOptionalParams, sParamClean)
		[ ] 
	[ ] 
	[ ] return lsOptionalParams
	[ ] 
[ ] 
[+] private list of Parameters ParseParameters(list of GenHelp lrcParameter, string sSyntax)
	[ ] GenHelp rcHelp
	[ ] list of Parameters lrcReturnParam 
	[ ] Parameters rcTemp
	[ ] string sParam = ""
	[ ] string sDesc = ""
	[ ] STRING sTmp
	[ ] STRING sDelimiter = ""
	[ ] list of string lsOptional = GetOptionalParams(sSyntax)
	[ ] boolean bOptional
	[ ] INTEGER i, iStr = 0
	[ ] 
	[+] if (Len(FormatAPIParameters(sSyntax)) < 3)
		[ ] return null
	[ ] 
	[+] for iStr = 1 to ListCount (lrcParameter)
		[ ] rcHelp = lrcParameter[iStr]
		[+] if rcHelp.sText != ""
			[ ] 
			[+] if sDelimiter == ""
				[+] for each sDelimiter in {":", "-", "	", " "}
					[+] if StrPos (sDelimiter, rcHelp.sText) > 0
						[ ] break
			[+] if sParam == ""
				[ ] sParam = GetField(rcHelp.sText, sDelimiter, 1)
			[ ] 
			[ ] sDesc += Trim (StrTran (rcHelp.sText, sParam + sDelimiter, "")) + "<br>"	// [13]
			[ ] sDesc = StrTran (sDesc, "<br><br>", "<br>")
			[ ] sParam = Trim (sParam)
			[ ] 
			[+] if (iStr < ListCount (lrcParameter)) && (lrcParameter[iStr+1].sText != "") && (StrPos (sDelimiter, lrcParameter[iStr+1].sText) == 0)
				[ ] continue
			[ ] 
			[+] if (IsNull(lsOptional))
				[ ] bOptional = FALSE
			[+] else
				[+] if ListMatchString (sParam, lsOptional)
					[ ] bOptional = TRUE
				[+] else
					[ ] bOptional = FALSE
			[ ] 
			[ ] rcTemp = {sParam, sDesc, bOptional, rcHelp.lsExample}
			[ ] 
			[ ] ListAppend(lrcReturnParam, rcTemp)
			[ ] 
			[ ] sParam = ""
			[ ] sDesc = ""
		[ ] 
	[ ] 
	[+] if !IsSet(lrcReturnParam)
		[ ] lrcReturnParam = null
	[ ] return lrcReturnParam
	[ ] 
[ ] 
[ ] // ------------- Help Statistic Output ----------------------------
[+] private ShowStats()
	[ ] Print("")
	[ ] Print("")
	[ ] 
	[ ] Print("*************************************************")
	[ ] Print("Directories Processed            {rcStat.iDirProcessed}")
	[ ] Print("Files Processed                  {rcStat.iFilesProcessed}")
	[ ] Print("Methods Processed				{rcStat.iMethods}")
	[ ] Print("Functions Processed				{rcStat.iFunctions}")
	[ ] Print("*************************************************")
	[ ] 
[ ] 
[+] private HTMLStats()
	[ ] string sFullFile = ""
	[ ] HFILE FileHandle
	[ ] string sFile = "API\API_Home.htm"
	[ ] STRING sAuthor
	[ ] LIST OF STRING lsAuthors
	[ ] 
	[ ] sFullFile = sHTMLSaveLocation + "\HelpAPI{sVariant}\" + sFile
	[ ] 
	[ ] FileHandle = FileOpen (sFullFile,  FM_WRITE)
	[ ] FileWriteLine (FileHandle, "<html>")
	[ ] FileWriteLine (FileHandle, "<head>")
	[ ] FileWriteLine (FileHandle, "<title>{sHelpTitle}</title>")
	[ ] 
	[ ] FileWriteLine (FileHandle, "<link id=""themeStyles"" rel=""stylesheet"" href=""../../js/dijit/themes/soria/soria.css"">")
	[ ] 
	[ ] FileWriteLine (FileHandle, "<style type=""text/css"">")
	[ ] 
	[ ] FileWriteLine (FileHandle, "body " + chr(123) + "scrollbar-face-color: #FFF; scrollbar-3dlight-color: #FFF; scrollbar-track-color: #FFF; scrollbar-shadow-color: #527194;	scrollbar-darkshadow-color: #FFF; scrollbar-arrow-color: #527194; scrollbar-highlight-color: #527194;" + chr(125))
	[ ] FileWriteLine (FileHandle, ".heading " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 14px; color: #FFFFFF; font-weight: bold" + chr(125))
	[ ] FileWriteLine (FileHandle, "p " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px" + chr(125))
	[ ] FileWriteLine (FileHandle, ".keyword " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; font-weight: bold" + chr(125))
	[ ] FileWriteLine (FileHandle, "td " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px" + chr(125))
	[ ] FileWriteLine (FileHandle, ".variable " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; font-weight: bold; text-decoration: underline" + chr(125))
	[ ] FileWriteLine (FileHandle, ".timestamp " + chr(123) + "font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; font-style: italic; color: #999999" + chr(125))
	[ ] FileWriteLine (FileHandle, ".navlink  " + chr(123) + "background: transparent; font-weight: bold; color: #527194; text-decoration: none" + chr(125))
	[ ] FileWriteLine (FileHandle, "a:hover.navlink  " + chr(123) + "background: transparent; color: #A1ACFC; text-decoration: underline" + chr(125))
	[ ] FileWriteLine (FileHandle, ".navlink2  " + chr(123) + "background: transparent; color: #527194; text-decoration: none" + chr(125))
	[ ] FileWriteLine (FileHandle, "a:hover.navlink2  " + chr(123) + "background: transparent; font-weight: bold; color: #A1ACFC; text-decoration: underline" + chr(125))
	[ ] FileWriteLine (FileHandle, " .div.cut_sep   " + chr(123) + " background:transparent url('../../images/cut.gif') 100% 0 repeat-x;height:16px;overflow:hidden;margin:10px 0 7px 0;text-indent:-9999px; " + chr(125))
	[ ] 
	[ ] FileWriteLine (FileHandle, "@import ""../../js/dojo/resources/dojo.css"";")
	[ ] 
	[ ] FileWriteLine (FileHandle, "</style>")
	[ ] 
	[ ] FileWriteLine (FileHandle, "<script type=""text/javascript"" src=""../../js/dojo/dojo.js"" djConfig=""parseOnLoad: true, isDebug: false""></script>")
	[ ] FileWriteLine (FileHandle, "<script type=""text/javascript"" src=""../../js/dijit/dijit.js""></script>")
	[ ] FileWriteLine (FileHandle, "<script type=""text/javascript"" src=""../../js/dijit/dijit-all.js""></script>")
	[ ] FileWriteLine (FileHandle, "")
	[ ] 
	[ ] /// for photos
	[ ] FileWriteLine (FileHandle, "<script type=""text/javascript"" src=""../../js/overlib.js""></script>")
	[ ] FileWriteLine (FileHandle, "")
	[ ] 
	[ ] 
	[ ] FileWriteLine (FileHandle, "</head>")
	[ ] FileWriteLine (FileHandle, "")
	[ ] FileWriteLine (FileHandle, "<body bgcolor=""#FFFFFF"" text=""#000000"" class=""soria"">")
	[ ] FileWriteLine (FileHandle, "")
	[ ] 
	[ ] // make heading
	[ ] FileWriteLine (FileHandle, "<table width=""100%"" border=""0"">")
	[ ] FileWriteLine (FileHandle, "  <tr>")
	[ ] FileWriteLine (FileHandle, "    <td bgcolor=""#6D76AB"" class=""heading"">&nbsp;<img src=""..\..\images\information.png"" border=0> {sHelpTitle}</td>")
	[ ] FileWriteLine (FileHandle, "  </tr>")
	[ ] FileWriteLine (FileHandle, "</table>")
	[ ] FileWriteLine (FileHandle, "")
	[ ] 
	[ ] // write statistics
	[ ] FileWriteLine (FileHandle, "")
	[ ] FileWriteLine (FileHandle, "<table border=""0"" cellpadding=""1"" cellspacing=""4"">")
	[ ] FileWriteLine (FileHandle, "  <tr>")
	[ ] FileWriteLine (FileHandle, "    <td nowrap class=""variable"">Measurement&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>")
	[ ] FileWriteLine (FileHandle, "    <td class=""variable"">Count&nbsp;&nbsp;</td>")
	[ ] FileWriteLine (FileHandle, "  </tr>")
	[ ] 
	[ ] 
	[ ] FileWriteLine (FileHandle, "  <tr>")
	[ ] FileWriteLine (FileHandle, "    <td nowrap>Directories Processed</td>")
	[ ] FileWriteLine (FileHandle, "    <td>{rcStat.iDirProcessed}</td>")
	[ ] FileWriteLine (FileHandle, "  </tr>")
	[ ] 
	[ ] FileWriteLine (FileHandle, "  <tr>")
	[ ] FileWriteLine (FileHandle, "    <td nowrap>Files Processed</td>")
	[ ] FileWriteLine (FileHandle, "    <td>{rcStat.iFilesProcessed}</td>")
	[ ] FileWriteLine (FileHandle, "  </tr>")
	[ ] 
	[ ] FileWriteLine (FileHandle, "  <tr>")
	[ ] FileWriteLine (FileHandle, "    <td nowrap>Methods Processed</td>")
	[ ] FileWriteLine (FileHandle, "    <td>{rcStat.iMethods}</td>")
	[ ] FileWriteLine (FileHandle, "  </tr>")
	[ ] 
	[ ] FileWriteLine (FileHandle, "  <tr>")
	[ ] FileWriteLine (FileHandle, "    <td nowrap>Functions Processed</td>")
	[ ] FileWriteLine (FileHandle, "    <td>{rcStat.iFunctions}</td>")
	[ ] FileWriteLine (FileHandle, "  </tr>")
	[ ] FileWriteLine (FileHandle, "</table>")
	[ ] 
	[ ] // write authors statistics
	[ ] FileWriteLine (FileHandle, "<table width=""100%"" border=""0"">")
	[ ] FileWriteLine (FileHandle, "  <tr>")
	[ ] FileWriteLine (FileHandle, "    <td bgcolor=""#6D76AB"" class=""heading"">&nbsp;<img src=""..\..\images\information.png"" border=0> Authors statistic</td>")
	[ ] FileWriteLine (FileHandle, "  </tr>")
	[ ] FileWriteLine (FileHandle, "</table>")
	[ ] 
	[ ] FileWriteLine (FileHandle, "<table border=""0"" cellpadding=""1"" cellspacing=""4"">")
	[ ] 
	[ ] FileWriteLine (FileHandle, "  <tr>")
	[ ] FileWriteLine (FileHandle, "    <td nowrap class=""variable"">Author&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>")
	[ ] FileWriteLine (FileHandle, "    <td class=""variable"">Mehtods&nbsp;&nbsp;</td>")
	[ ] FileWriteLine (FileHandle, "    <td class=""variable"">Functions&nbsp;&nbsp;</td>")
	[ ] FileWriteLine (FileHandle, "  </tr>")
	[ ] 
	[ ] lsAuthors = MapKeys (mAuthors)
	[ ] ListSort (lsAuthors)
	[ ] 
	[+] for each sAuthor in lsAuthors
		[ ] FileWriteLine (FileHandle, "  <tr>")
		[ ] FileWriteLine (FileHandle, "<td nowrap>")
		[ ] 
		[ ] // for photos
		[ ] FileWriteLine (FileHandle, "<a class=""navlink"" href=""#"" onclick=""dijit.byId('{sAuthor}').show()"" onmouseover=""overlib('<img src=\'../Stat/photos/{sAuthor}.jpg\' width=96 height=128 border=0 alt=\'\' >', FULLHTML); return true;"" onmouseout=""cClick(); return true;""><img src=""..\..\images\user.gif""> {sAuthor}</a>")
		[ ] 
		[ ] FileWriteLine (FileHandle, "<div id=""{sAuthor}"" dojoType=""dijit.Dialog""")
		[ ] FileWriteLine (FileHandle, "title=""{sAuthor}"" style=""display:none;""")
		[ ] FileWriteLine (FileHandle, "href=""../Stat/" + StrTran (sAuthor, " ", "_") + ".htm""></div>")
		[ ] 
		[ ] 
		[ ] FileWriteLine (FileHandle, "    <td>{MapGet(mAuthors, sAuthor)[1]}</td>")
		[ ] FileWriteLine (FileHandle, "    <td>{MapGet(mAuthors, sAuthor)[2]}</td>")
		[ ] FileWriteLine (FileHandle, "  </tr>")
		[ ] 
	[ ] 
	[ ] FileWriteLine (FileHandle, "</table>")
	[ ] 
	[ ] FileWriteLine (FileHandle, "")
	[ ] FileWriteLine (FileHandle, "<p>&nbsp;</p>")
	[ ] 
	[ ] // page footer
	[ ] FileWriteLine (FileHandle, "")
	[ ] FileWriteLine (FileHandle, "<div class=""cut_sep"" id=""cut"">----------------------&lt;cut&gt;----------------------</div>")
	[ ] FileWriteLine (FileHandle, "<span class=""timestamp"">&#169; 2002-2010 ISD Automated Testing. (Created By Silk Help Generator {DateStr()}  {TimeStr()})</span>")
	[ ] FileWriteLine (FileHandle, "</body>")
	[ ] FileWriteLine (FileHandle, "</html>")
	[ ] FileWriteLine (FileHandle, "")
	[ ] 
	[ ] FileClose (FileHandle)
	[ ] 
[ ] 
[ ] // ------------- Common functions --------------------------------
[+] integer split (string theString, inout list of string theList, string delimiter optional)
	[+] // @HELP
		[ ] // @group:		Utility Functions
		[ ] // @function:	iCount = split(theString, theList[, delimiter])
		[ ] // @returns:	iCount: A count of how many items were put into the list (INTEGER)
		[ ] // @parameter:	theString: String to be sply (STRING)
		[ ] // @parameter:  theList: List to place the split items into (LIST OF STRING [inout])
		[ ] // @parameter:  delimiter: Delimiter to use (STRING; Optional; Default='|')
		[ ] // @notes:		This function is used to convert a delimited string into an
		[ ] //				array, so that the items may be manipulated more easily.
		[ ] //
		[ ] // @END
	[ ] 
	[ ] integer numberOfItems = 0, pos
	[ ] boolean done = FALSE
	[ ] string tempString
	[ ] 
	[ ] SetDefault(delimiter, "|")
	[ ] 
	[+] if (theString == "")
		[ ] done = TRUE
	[ ] 
	[+] while (!done)
		[ ] pos = StrPos (delimiter, theString)
		[+] if (pos == 0)
			[ ] pos = Len(theString) + 1
			[ ] done = TRUE
			[ ] 
		[+] if (Len(theString) == 0)
			[ ] tempString = ""
		[+] else
			[ ] tempString = Left (theString, pos - 1)
		[ ] 
		[ ] ListAppend(theList, tempString)
		[ ] numberOfItems = numberOfItems + 1
		[ ] 
		[+] if (!done)
			[ ] theString = Right (theString, Len(theString) - pos)
	[ ] 
	[ ] return numberOfItems
[ ] 
[+] SetDefault(inout anytype aSetWhat null, anytype aDefaultValue)
	[+] // @HELP
		[ ] // @group:		Utility Functions
		[ ] // @function:	aSetWhat = SetDefault(aSetWhat, aDefaultValue)
		[ ] // @returns:	aSetWhat: This in an inout parameter.  It is the variable 
		[ ] //				that will be set
		[ ] // @parameter:	aSetWhat: inout value of the variable to set (ANYTYPE)
		[ ] // @parameter:	aDefaultValue: the data to set.  Can be null (ANYTYPE)
		[ ] // @notes:		Used when an OPTIONAL parameter is sent to a function.
		[ ] //				Calling this, will only set aSetWhat if it is null
		[ ] //
		[ ] // @END
	[ ] 
	[+] if IsNull(aSetWhat)
		[ ] aSetWhat = aDefaultValue
	[ ] 
[ ] 
[+] LIST OF STRING getFiles (STRING f_sDir)
	[ ] 
	[ ] LIST OF STRING lsRet = {}
	[ ] LIST OF STRING lsDirs
	[ ] STRING sDir
	[ ] 
	[ ] lsDirs = GetSubDirectories (f_sDir)
	[ ] 
	[+] if lsDirs != {}
		[+] for each sDir in lsDirs
			[ ] 
			[+] if SYS_DirExists (sDir)
				[ ] lsRet += getFiles (sDir)
			[+] else
				[ ] lsRet += GetFileNames (sDir)
	[+] else
		[ ] lsRet += GetFileNames (f_sDir)
	[ ] 
	[ ] return lsRet
	[ ] 
[ ] 
[ ] // ------------- FindPhotos functions --------------------------------
[+] void FindPhotos ()
	[ ] 
	[ ] LIST OF STRING lsDirs, lsAuthors, lsFiles = {}
	[ ] STRING sDir, sPht, sAuthor
	[ ] STRING pPhtDir = sHTMLSaveLocation + "\HelpAPI{sVariant}\Stat\photos\"
	[ ] STRING sNoPhoto = sHTMLTemplatesLocation + "\" + "images\nophoto.jpg"
	[ ] INTEGER i
	[ ] HFILE FileHandle
	[ ] 
	[+] if (!SYS_DirExists (pPhtDir))
		[ ] SYS_MakeDir (pPhtDir)
	[+] else
		[ ] RemoveFiles (GetFileNames(pPhtDir))
	[ ] 
	[ ] lsFiles = getFiles (sPhotoServer)
	[ ] ListSort (lsFiles) 
	[ ] 
	[ ] lsAuthors = MapKeys (mAuthors)
	[ ] ListSort (lsAuthors)
	[ ] 
	[+] for each sAuthor in lsAuthors
		[ ] 
		[+] if ListMatchPhoto (sAuthor, lsFiles, null, null, i)
			[ ] sPht = lsFiles[i]
		[+] else
			[ ] sPht = sNoPhoto
		[ ] 
		[+] do
			[ ] SYS_CopyFile (sPht, pPhtDir + sAuthor + Lower (SubStr (sPht, StrPos (".", sPht, TRUE))))
		[+] except
			[ ] sPht = sNoPhoto
			[ ] SYS_CopyFile (sPht, pPhtDir + sAuthor + Lower (SubStr (sPht, StrPos (".", sPht, TRUE))))
			[ ] print("   -- Can`t find photo:   {pPhtDir + sAuthor + Lower (SubStr (sPht, StrPos (".", sPht, TRUE)))} ....")
	[ ] 
[ ] 
[ ] 
[ ] 
[ ] // -------------- MAIN -----------------------------------------
[+] main()
	[ ] 
	[ ] SourceDirectories rcDir
	[ ] 
	[ ] print("Starting SilkTest 4Text.txt Help Generation ..... ")
	[ ] 
	[ ] InitializeDirectory()
	[ ] 
	[+] for each rcDir in lsrSource
		[ ] ProcessDirectory(rcDir)
	[ ] 
	[ ] CreateFinalHelp()
	[ ] 
	[ ] RemoveTempDir()
	[ ] 
	[ ] ShowStats()
	[ ] 
	[ ] // ******* CREATE HTML HELP ******
	[+] if bCreateHTMLHelp
		[ ] HTMLStats()
		[ ] CreateFinalHTMLHelp()
		[ ] 
		[ ] CreateAuthorsStat ()
		[ ] 
		[ ] CreateHTMLLinks()
		[ ] 
		[ ] // find photos
		[+] if bUsePhotos
			[ ] FindPhotos ()
		[ ] 
	[ ]  
	[ ] print(".... Finished SilkHelp Generation !!! ")
[ ] 
