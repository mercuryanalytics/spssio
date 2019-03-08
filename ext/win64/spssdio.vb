' ***************************************************************
' IBM Confidential
' 
' OCO Source Materials
' 
' IBM SPSS Products: Statistics Common
' 
' (C) Copyright IBM Corp. 1989, 2017
' 
' The source code for this program is not published or otherwise divested of its trade secrets, 
' irrespective of what has been deposited with the U.S. Copyright Office.
' ***************************************************************

Module SpssDioInterface

    ' Modification history:
    ' 16 Sep 96 - SPSS 7.5
    ' 05 Dec 97 - SPSS 8.0
    ' 27 Aug 98 - SPSS 9.0
    ' 02 Sep 99 - SPSS 10.0
    ' 29 mar 01 - SPSS 11.0
    ' 04 Feb 03 - SPSS 12.0 - Long variable names
    ' 27 Aug 04 - SPSS 13.0 - Extended strings
    ' 23 Aug 07 - SPSS 16.0 - Unicode
    ' 03 Apr 13 - Statistics 22.0 - Password protection

    ' Error codes returned by functions
    Public Const SPSS_OK = 0

    Public Const SPSS_FILE_OERROR = 1
    Public Const SPSS_FILE_WERROR = 2
    Public Const SPSS_FILE_RERROR = 3
    Public Const SPSS_FITAB_FULL = 4
    Public Const SPSS_INVALID_HANDLE = 5
    Public Const SPSS_INVALID_FILE = 6
    Public Const SPSS_NO_MEMORY = 7

    Public Const SPSS_OPEN_RDMODE = 8
    Public Const SPSS_OPEN_WRMODE = 9

    Public Const SPSS_INVALID_VARNAME = 10
    Public Const SPSS_DICT_EMPTY = 11
    Public Const SPSS_VAR_NOTFOUND = 12
    Public Const SPSS_DUP_VAR = 13
    Public Const SPSS_NUME_EXP = 14
    Public Const SPSS_STR_EXP = 15
    Public Const SPSS_SHORTSTR_EXP = 16
    Public Const SPSS_INVALID_VARTYPE = 17

    Public Const SPSS_INVALID_MISSFOR = 18
    Public Const SPSS_INVALID_COMPSW = 19
    Public Const SPSS_INVALID_PRFOR = 20
    Public Const SPSS_INVALID_WRFOR = 21
    Public Const SPSS_INVALID_DATE = 22
    Public Const SPSS_INVALID_TIME = 23

    Public Const SPSS_NO_VARIABLES = 24
    Public Const SPSS_MIXED_TYPES = 25
    Public Const SPSS_DUP_VALUE = 27

    Public Const SPSS_INVALID_CASEWGT = 28
    Public Const SPSS_INCOMPATIBLE_DICT = 29
    Public Const SPSS_DICT_COMMIT = 30
    Public Const SPSS_DICT_NOTCOMMIT = 31

    Public Const SPSS_NO_TYPE2 = 33
    Public Const SPSS_NO_TYPE73 = 41
    Public Const SPSS_INVALID_DATEINFO = 45
    Public Const SPSS_NO_TYPE999 = 46
    Public Const SPSS_EXC_STRVALUE = 47
    Public Const SPSS_CANNOT_FREE = 48
    Public Const SPSS_BUFFER_SHORT = 49
    Public Const SPSS_INVALID_CASE = 50
    Public Const SPSS_INTERNAL_VLABS = 51
    Public Const SPSS_INCOMPAT_APPEND = 52
    Public Const SPSS_INTERNAL_D_A = 53
    Public Const SPSS_FILE_BADTEMP = 54
    Public Const SPSS_DEW_NOFIRST = 55
    Public Const SPSS_INVALID_MEASURELEVEL = 56
    Public Const SPSS_INVALID_7SUBTYPE = 57
    Public Const SPSS_INVALID_VARHANDLE = 58
    Public Const SPSS_INVALID_ENCODING = 59
    Public Const SPSS_FILES_OPEN = 60

    Public Const SPSS_INVALID_MRSETDEF = 70
    Public Const SPSS_INVALID_MRSETNAME = 71
    Public Const SPSS_DUP_MRSETNAME = 72
    Public Const SPSS_BAD_EXTENSION = 73
    Public Const SPSS_INVALID_EXTENDEDSTRING = 74
    Public Const SPSS_INVALID_ATTRNAME = 75
    Public Const SPSS_INVALID_ATTRDEF = 76
    Public Const SPSS_INVALID_MRSETINDEX = 77
    Public Const SPSS_INVALID_VARSETDEF = 78
    Public Const SPSS_INVALID_ROLE = 79

    ' Warning codes returned by functions
    Public Const SPSS_EXC_LEN64 = -1
    Public Const SPSS_EXC_LEN120 = -2
    Public Const SPSS_EXC_VARLABEL = -2
    Public Const SPSS_EXC_LEN60 = -4
    Public Const SPSS_EXC_VALLABEL = -4
    Public Const SPSS_FILE_END = -5
    Public Const SPSS_NO_VARSETS = -6
    Public Const SPSS_EMPTY_VARSETS = -7
    Public Const SPSS_NO_LABELS = -8
    Public Const SPSS_NO_LABEL = -9
    Public Const SPSS_NO_CASEWGT = -10
    Public Const SPSS_NO_DATEINFO = -11
    Public Const SPSS_NO_MULTRESP = -12
    Public Const SPSS_EMPTY_MULTRESP = -13
    Public Const SPSS_NO_DEW = -14
    Public Const SPSS_EMPTY_DEW = -15


    ' Missing value format codes
    Public Const SPSS_NO_MISSVAL As Integer = 0
    Public Const SPSS_ONE_MISSVAL As Integer = 1
    Public Const SPSS_TWO_MISSVAL As Integer = 2
    Public Const SPSS_THREE_MISSVAL As Integer = 3
    Public Const SPSS_MISS_RANGE As Integer = -2
    Public Const SPSS_MISS_RANGEANDVAL As Integer = -3



    ' SPSS Format Type Codes
    Public Const SPSS_FMT_A As Integer = 1              ' Alphanumeric
    Public Const SPSS_FMT_AHEX As Integer = 2           ' Alphanumeric hexadecimal
    Public Const SPSS_FMT_COMMA As Integer = 3          ' F Format with commas
    Public Const SPSS_FMT_DOLLAR As Integer = 4         ' Commas and floating dollar sign
    Public Const SPSS_FMT_F As Integer = 5              ' Default Numeric Format
    Public Const SPSS_FMT_IB As Integer = 6             ' Integer binary
    Public Const SPSS_FMT_PIBHEX As Integer = 7         ' Positive integer binary - hex
    Public Const SPSS_FMT_P As Integer = 8              ' Packed decimal
    Public Const SPSS_FMT_PIB As Integer = 9            ' Positive integer binary unsigned
    Public Const SPSS_FMT_PK As Integer = 10            ' Positive integer binary unsigned
    Public Const SPSS_FMT_RB As Integer = 11            ' Floating point binary
    Public Const SPSS_FMT_RBHEX As Integer = 12         ' Floating point binary hex
    Public Const SPSS_FMT_Z As Integer = 15             ' Zoned decimal
    Public Const SPSS_FMT_N As Integer = 16             ' N Format- unsigned with leading 0s
    Public Const SPSS_FMT_E As Integer = 17             ' E Format- with explicit power of 10
    Public Const SPSS_FMT_DATE As Integer = 20          ' Date format dd-mmm-yyyy
    Public Const SPSS_FMT_TIME As Integer = 21          ' Time format hh:mm:ss.s
    Public Const SPSS_FMT_DATE_TIME As Integer = 22     ' Date and Time
    Public Const SPSS_FMT_ADATE As Integer = 23         ' Date format dd-mmm-yyyy
    Public Const SPSS_FMT_JDATE As Integer = 24         ' Julian date - yyyyddd
    Public Const SPSS_FMT_DTIME As Integer = 25         ' Date-time dd hh:mm:ss.s
    Public Const SPSS_FMT_WKDAY As Integer = 26         ' Day of the week
    Public Const SPSS_FMT_MONTH As Integer = 27         ' Month
    Public Const SPSS_FMT_MOYR As Integer = 28          ' mmm yyyy
    Public Const SPSS_FMT_QYR As Integer = 29           ' q Q yyyy
    Public Const SPSS_FMT_WKYR As Integer = 30          ' ww WK yyyy
    Public Const SPSS_FMT_PCT As Integer = 31           ' Percent - F followed by %
    Public Const SPSS_FMT_DOT As Integer = 32           ' Like COMMA, switching dot for comma
    Public Const SPSS_FMT_CCA As Integer = 33           ' User Programmable currency format
    Public Const SPSS_FMT_CCB As Integer = 34           ' User Programmable currency format
    Public Const SPSS_FMT_CCC As Integer = 35           ' User Programmable currency format
    Public Const SPSS_FMT_CCD As Integer = 36           ' User Programmable currency format
    Public Const SPSS_FMT_CCE As Integer = 37           ' User Programmable currency format
    Public Const SPSS_FMT_EDATE As Integer = 38         ' Date in dd/mm/yyyy style
    Public Const SPSS_FMT_SDATE As Integer = 39         ' Date in yyyy/mm/dd style
    Public Const SPSS_FMT_MTIME As Integer = 85         ' Time format mm:ss.ss
    Public Const SPSS_FMT_YMDHMS As Integer = 86        ' Data format yyyy-mm-dd hh:mm:ss.ss


    ' Definitions of "type 7" records
    Public Const SPSS_T7_DOCUMENTS As Integer = 0       ' Documents (actually type 6
    Public Const SPSS_T7_VAXDE_DICT As Integer = 1      ' VAX Data Entry - dictionary version
    Public Const SPSS_T7_VAXDE_DATA As Integer = 2      ' VAX Data Entry - data
    Public Const SPSS_T7_SOURCE As Integer = 3          ' Source system characteristics
    Public Const SPSS_T7_HARDCONST As Integer = 4       ' Source system floating pt constants
    Public Const SPSS_T7_VARSETS As Integer = 5         ' Variable sets
    Public Const SPSS_T7_TRENDS As Integer = 6          ' Trends date information
    Public Const SPSS_T7_MULTRESP As Integer = 7        ' Multiple response groups
    Public Const SPSS_T7_DEW_DATA As Integer = 8        ' Windows Data Entry data
    Public Const SPSS_T7_TEXTSMART As Integer = 10      ' TextSmart data
    Public Const SPSS_T7_MSMTLEVEL As Integer = 11      ' Msmt level, col width, & alignment
    Public Const SPSS_T7_DEW_GUID As Integer = 12       ' Windows Data Entry GUID
    Public Const SPSS_T7_XVARNAMES As Integer = 13      ' Extended variable names
    Public Const SPSS_T7_XSTRINGS As Integer = 14       'Extended strings
    Public Const SPSS_T7_CLEMENTINE As Integer = 15     'Clementine Metadata
    Public Const SPSS_T7_NCASES As Integer = 16         '64 bit N of cases
    Public Const SPSS_T7_FILE_ATTR As Integer = 17      'File level attributes
    Public Const SPSS_T7_VAR_ATTR As Integer = 18       'Variable attributes
    Public Const SPSS_T7_EXTMRSETS As Integer = 19      ' Extended multiple response groups
    Public Const SPSS_T7_ENCODING As Integer = 20       ' Encoding, aka code page
    Public Const SPSS_T7_LONGSTRLABS As Integer = 21    ' Value labels for long strings
    Public Const SPSS_T7_LONGSTRMVAL As Integer = 22    ' Missing values for long strings

    ' Encoding modes
    Public Const SPSS_ENCODING_CODEPAGE As Integer = 0  ' Text encoded in current code page
    Public Const SPSS_ENCODING_UTF8 As Integer = 1      ' Text encoded as UTF-8


    ' Diagnostics regarding SPSS variable names
    Public Const SPSS_NAME_OK = 0              ' Valid standard name
    Public Const SPSS_NAME_SCRATCH = 1         ' Valid scratch var name
    Public Const SPSS_NAME_SYSTEM = 2          ' Valid system var name
    Public Const SPSS_NAME_BADLTH = 3          ' Empty or longer than SPSS_MAX_VARNAME
    Public Const SPSS_NAME_BADCHAR = 4         ' Invalid character or imbedded blank
    Public Const SPSS_NAME_RESERVED = 5        ' Name is a reserved word
    Public Const SPSS_NAME_BADFIRST = 6        ' Invalid initial character (otherwise OK)

    ' Maximum lengths of SPSS data file objects
    Public Const SPSS_MAX_VARNAME = 64         ' Variable name
    Public Const SPSS_MAX_SHORTVARNAME = 8     ' Short (compatibility) variable name
    Public Const SPSS_MAX_SHORTSTRING = 8      ' Short string variable
    Public Const SPSS_MAX_IDSTRING = 64        ' File label string
    Public Const SPSS_MAX_LONGSTRING = 32767   ' Long string variable
    Public Const SPSS_MAX_VALLABEL = 120       ' Value label
    Public Const SPSS_MAX_VARLABEL = 256       ' Variable label
    Public Const SPSS_MAX_7SUBTYPE = 40        ' Maximum record 7 subtype
    Public Const SPSS_MAX_ENCODING = 64        ' Maximum encoding text


    ' Functions exported by spssio64.dll in alphabetical order
    Public Declare PtrSafe Function spssAddFileAttribute Lib "spssio64.dll" _
                            (ByVal handle As Integer, ByVal attribName As String, ByVal attribSub As Integer, ByVal attribText As String) As Integer
    ' Public Declare PtrSafe Function   spssAddMultRespDefC Lib "spssio64.dll" Alias "spssAddMultRespDefC" _
    '                           (ByVal handle As Integer, ByVal mrSetName As String, ByVal mrSetLabel As String, ByVal isDichotomy As Integer, ByVal countedValue As Integer, ByVal *varNames As String, ByVal numVars As Integer) As Integer
    ' Public Declare PtrSafe Function   spssAddMultRespDefExt "spssio64.dll" Alias "spssAddMultRespDefExt" _
    '                           (ByVal handle As Integer, ByVal pSet as String) As Integer
    ' Public Declare PtrSafe Function   spssAddMultRespDefN Lib "spssio64.dll" Alias "spssAddMultRespDefN" _
    '                           (ByVal handle As Integer, ByVal mrSetName As String, ByVal mrSetLabel As String, ByVal isDichotomy As Integer, ByVal countedValue As String, ByVal *varNames As String, ByVal numVars As Integer) As Integer
    Public Declare PtrSafe Function spssAddVarAttribute Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal attribName As String, ByVal attribSub As Integer, ByVal attribText As String) As Integer
    Public Declare PtrSafe Function spssCloseAppend Lib "spssio64.dll" _
                                (ByVal handle As Integer) As Integer
    Public Declare PtrSafe Function spssCloseRead Lib "spssio64.dll" _
                                (ByVal handle As Integer) As Integer
    Public Declare PtrSafe Function spssCloseWrite Lib "spssio64.dll" _
                                (ByVal handle As Integer) As Integer
    Public Declare PtrSafe Function spssCommitCaseRecord Lib "spssio64.dll" _
                                (ByVal handle As Integer) As Integer
    Public Declare PtrSafe Function spssCommitHeader Lib "spssio64.dll" _
                                (ByVal handle As Integer) As Integer
    Public Declare PtrSafe Function spssConvertDate Lib "spssio64.dll" _
                                (ByVal day As Integer, ByVal month As Integer, ByVal year As Integer, ByRef spssDate As Double) As Integer
    Public Declare PtrSafe Function spssConvertSPSSDate Lib "spssio64.dll" _
                                (ByRef day As Integer, ByRef month As Integer, ByRef year As Integer, ByVal spssDate As Double) As Integer
    Public Declare PtrSafe Function spssConvertSPSSTime Lib "spssio64.dll" _
                                (ByRef day As Integer, ByRef hourh As Integer, ByRef minute As Integer, ByRef second As Double, ByVal spssDate As Double) As Integer
    Public Declare PtrSafe Function spssConvertTime Lib "spssio64.dll" _
                                (ByVal day As Integer, ByVal hour As Integer, ByVal minute As Integer, ByVal second As Double, ByRef spssTime As Double) As Integer
    Public Declare PtrSafe Function spssCopyDocuments Lib "spssio64.dll" _
                                (ByVal fromHandle As Integer, ByVal toHandle As Integer) As Integer
    ' Public Declare PtrSafe Function   spssFreeAttributes Lib "spssio64.dll" Alias "spssFreeAttributes" _
    '                           (ByRef *attribNames As String, ByRef *attribText As String, ByVal nAttributes) As Integer
    Public Declare PtrSafe Function spssFreeDateVariables Lib "spssio64.dll" _
                                (ByRef pDateInfo As Integer) As Integer
    Public Declare PtrSafe Function spssFreeMultRespDefs Lib "spssio64.dll" _
                                (ByVal pMrespDefs As Integer) As Integer
    ' Public Declare PtrSafe Function   spssFreeMultRespDefStruct Lib "spssio64.dll" Alias "spssFreeMultRespDefStruct" _
    '                           (ByVal pSet As String) As Integer
    ' Public Declare PtrSafe Function   spssFreeVarCValueLabels Lib "spssio64.dll" Alias "spssFreeVarCValueLabels" _
    '                           (ByRef *values As String, ByRef *labels As String, ByVal numLabels As Integer) As Integer
    Public Declare PtrSafe Function spssFreeVariableSets Lib "spssio64.dll" _
                                (ByVal pVarSets As Integer) As Integer
    ' Public Declare PtrSafe Function   spssFreeVarNames Lib "spssio64.dll" Alias "spssFreeVarNames" _
    '                           (ByVal *varNames As String, ByRef varTypes As Integer, ByVal numVars As Integer) As Integer
    ' Public Declare PtrSafe Function   spssFreeVarNValueLabels Lib "spssio64.dll" Alias "spssFreeVarNValueLabels" _
    '                           (ByRef values As Double, ByVal *labels As String, ByVal numLabels As Integer) As Integer
    Public Declare PtrSafe Function spssGetCaseSize Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByRef caseSize As Integer) As Integer
    Public Declare PtrSafe Function spssGetCaseWeightVar Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String) As Integer
    Public Declare PtrSafe Function spssGetCompression Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByRef compSwitch As Integer) As Integer
    Public Declare PtrSafe Function spssGetDateVariables Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByRef numofElements As Integer, ByRef pDateInfo As Integer) As Integer
    Public Declare PtrSafe Function spssGetDEWFirst Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal Data As String, ByVal maxData As Integer, ByRef Data As Integer) As Integer
    Public Declare PtrSafe Function spssGetDEWGUID Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal asciiGUID As String) As Integer
    Public Declare PtrSafe Function spssGetDEWInfo Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByRef Length As Integer, ByRef HashTotal As Integer) As Integer
    Public Declare PtrSafe Function spssGetDEWNext Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal Data As String, ByVal maxData As Integer, ByRef nData As Integer) As Integer
    Public Declare PtrSafe Function spssGetEstimatedNofCases Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByRef caseCount As Integer) As Integer
    ' Public Declare PtrSafe Function   spssGetFileAttributes Lib "spssio64.dll" Alias "spssGetFileAttributes" _
    '                           (ByVal handle As Integer, ByVal **attribNames As String, ByVal **attribText As String, ByRef nAttributes As Integer) As Integer
    Public Declare PtrSafe Function spssGetFileCodePage Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByRef nCodePage As Integer) As Integer
    Public Declare PtrSafe Function spssGetFileEncoding Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal szEncoding As String) As Integer
    Public Declare PtrSafe Function spssGetIdString Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal id As String) As Integer
    Public Declare PtrSafe Function spssGetInterfaceEncoding Lib "spssio64.dll" _
                                () As Integer
    Public Declare PtrSafe Function spssGetMultRespCount Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByRef nSets As Integer) As Integer
    ' Public Declare PtrSafe Function   spssGetMultRespDefByIndex Lib "spssio64.dll" Alias "spssGetMultRespDefByIndex" _
    '                           (ByVal handle As Integer, ByVal iSet As Integer, ByVal *ppSet As String) As Integer
    Public Declare PtrSafe Function spssGetMultRespDefs Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByRef pMrespDefs As Integer) As Integer
    Public Declare PtrSafe Function spssGetMultRespDefsEx Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByRef pMrespDefs As Integer) As Integer
    Public Declare PtrSafe Function spssGetNumberofCases Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByRef caseCount As Long) As Integer
    Public Declare PtrSafe Function spssGetNumberofVariables Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByRef numVars As Long) As Integer
    Public Declare PtrSafe Function spssGetReleaseInfo Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByRef relInfo As Integer) As Integer
    Public Declare PtrSafe Function spssGetSystemString Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal sysName As String) As Integer
    Public Declare PtrSafe Function spssGetTextInfo Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal textInfo As String) As Integer
    Public Declare PtrSafe Function spssGetTimeStamp Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal fileDate As String, ByVal fileTime As String) As Integer
    Public Declare PtrSafe Function spssGetValueChar Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varHandle As Double, ByVal value As String, ByVal valueSize As Integer) As Integer
    Public Declare PtrSafe Function spssGetValueNumeric Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varHandle As Double, ByRef value As Double) As Integer
    Public Declare PtrSafe Function spssGetVarAlignment Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByRef alignment As Integer) As Integer
    ' Public Declare PtrSafe Function   spssGetVarAttributes Lib "spssio64.dll" Alias "spssGetVarAttributes" _
    '                           (ByVal handle As Integer, ByVal varName As String, ByVal **attribNames As String, ByVal **attribText As String, ByRef nAttributes As Integer) As Integer
    Public Declare PtrSafe Function spssGetVarCMissingValues Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByRef missingFormat As Integer, ByVal missingVal1 As String, ByVal missingVal2 As String, ByVal missingVal3 As String) As Integer
    Public Declare PtrSafe Function spssGetVarColumnWidth Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByRef columnWidth As Integer) As Integer
    Public Declare PtrSafe Function spssGetVarCompatName Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal longName As String, ByVal shortName As String) As Integer
    Public Declare PtrSafe Function spssGetVarCValueLabel Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal value As String, ByVal label As String) As Integer
    Public Declare PtrSafe Function spssGetVarCValueLabelLong Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal value As String, ByVal labelBuff As String, ByVal lenBuff As Integer, ByRef lenLabel As Integer) As Integer
    ' Public Declare PtrSafe Function   spssGetVarCValueLabels Lib "spssio64.dll" Alias "spssGetVarCValueLabels" _
    '                           (ByVal handle As Integer, ByVal varName As String, ByVal **values As String, ByVal **labels As String, ByRef numofLabels As Integer) As Integer
    Public Declare PtrSafe Function spssGetVarHandle Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByRef varHandle As Double) As Integer
    Public Declare PtrSafe Function spssGetVariableSets Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByRef pVarSets As Integer) As Integer
    Public Declare PtrSafe Function spssGetVarInfo Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal iVar As Integer, ByVal varName As String, ByRef varType As Long) As Integer
    Public Declare PtrSafe Function spssGetVarLabel Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal varLabel As String) As Integer
    Public Declare PtrSafe Function spssGetVarLabelLong Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal labelBuff As String, ByVal lenBuff As Integer, ByRef lenLabel As Integer) As Integer
    Public Declare PtrSafe Function spssGetVarMeasureLevel Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByRef measureLevel As Integer) As Integer
    Public Declare PtrSafe Function spssGetVarRole Lib "spssio64.dll" _
                            (ByVal handle As Integer, ByVal varName As String, ByRef varRole As Integer) As Integer
    ' Public Declare PtrSafe Function   spssGetVarNames Lib "spssio64.dll" Alias "spssGetVarNames" _
    '                           (ByVal handle As Integer, ByRef numVars As Integer, ByRef **varNames As String, ByRef *varTypes As Integer) As Integer
    Public Declare PtrSafe Function spssGetVarNMissingValues Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByRef missingFormat As Integer, ByRef missingVal1 As Double, ByRef missingVal2 As Double, ByRef missingVal3 As Double) As Integer
    Public Declare PtrSafe Function spssGetVarNValueLabel Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal value As Double, ByVal label As String) As Integer
    Public Declare PtrSafe Function spssGetVarNValueLabelLong Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal value As Double, ByVal labelBuff As String, ByVal lenBuff As Integer, ByRef lenLabel As Integer) As Integer
    ' Public Declare PtrSafe Function   spssGetVarNValueLabels Lib "spssio64.dll" Alias "spssGetVarNValueLabels" _
    '                           (ByVal handle As Integer, ByVal varName As String, ByRef *values As Double, ByVal **labels As String, ByRef numofLabels As Integer) As Integer
    Public Declare PtrSafe Function spssGetVarPrintFormat Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByRef printType As Integer, ByRef printDec As Integer, ByRef printWidth As Integer) As Integer
    Public Declare PtrSafe Function spssGetVarWriteFormat Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByRef writeType As Integer, ByRef writeDec As Integer, ByRef writeWidth As Integer) As Integer
    Public Declare PtrSafe Sub spssHostSysmisVal Lib "spssio64.dll" _
                                (ByRef missVal As Double)
    Public Declare PtrSafe Function spssIsCompatibleEncoding Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByRef bCompatible As Integer) As Integer
    Public Declare PtrSafe Sub spssLowHighVal Lib "spssio64.dll" _
                                (ByRef lowest As Double, ByRef highest As Double)
    Public Declare PtrSafe Function spssOpenAppend Lib "spssio64.dll" _
                                (ByVal fileName As String, ByRef handle As Integer) As Integer
    Public Declare PtrSafe Function spssOpenAppendEx Lib "spssio64.dll" _
                                (ByVal fileName As String, ByVal password As String, ByRef handle As Integer) As Integer
    Public Declare PtrSafe Function spssOpenRead Lib "spssio64.dll" _
                                (ByVal fileName As String, ByRef handle As Integer) As Integer
    Public Declare PtrSafe Function spssOpenReadEx Lib "spssio64.dll" _
                                (ByVal fileName As String, ByVal password As String, ByRef handle As Integer) As Integer
    Public Declare PtrSafe Function spssOpenWrite Lib "spssio64.dll" _
                                (ByVal fileName As String, ByRef handle As Integer) As Integer
    Public Declare PtrSafe Function spssOpenWriteEx Lib "spssio64.dll" _
                                (ByVal fileName As String, ByVal password As String, ByRef handle As Integer) As Integer
    Public Declare PtrSafe Function spssOpenWriteCopy Lib "spssio64.dll" _
                                (ByVal fileName As String, ByVal dictFileName As String, ByRef handle As Integer) As Integer
    Public Declare PtrSafe Function spssOpenWriteCopyEx Lib "spssio64.dll" _
                                (ByVal fileName As String, ByVal password As String, ByVal dictFileName As String, ByVal dictPassword As String, ByRef handle As Integer) As Integer
    Public Declare PtrSafe Function spssOpenWriteCopyExFile Lib "spssio64.dll" _
                                (ByVal fileName As String, ByVal password As String, ByVal dictFileName As String, ByRef handle As Integer) As Integer
    Public Declare PtrSafe Function spssOpenWriteCopyExDict Lib "spssio64.dll" _
                                (ByVal fileName As String, ByVal dictFileName As String, ByVal dictPassword As String, ByRef handle As Integer) As Integer
    Public Declare PtrSafe Function spssQueryType7 Lib "spssio64.dll" _
                                (ByVal fromHandle As Integer, ByVal subType As Integer, ByRef bFound As Integer) As Integer
    Public Declare PtrSafe Function spssReadCaseRecord Lib "spssio64.dll" _
                                (ByVal handle As Integer) As Integer
    Public Declare PtrSafe Function spssSeekNextCase Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal caseNumber As Integer) As Integer
    Public Declare PtrSafe Function spssSetCaseWeightVar Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String) As Integer
    Public Declare PtrSafe Function spssSetCompression Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal compSwitch As Integer) As Integer
    Public Declare PtrSafe Function spssSetDateVariables Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal numofElements As Integer, ByRef dateInfo As Integer) As Integer
    Public Declare PtrSafe Function spssSetDEWFirst Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal Data As String, ByVal nBytes As Integer) As Integer
    Public Declare PtrSafe Function spssSetDEWGUID Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal asciiGUID As String) As Integer
    Public Declare PtrSafe Function spssSetDEWNext Lib "spssio64.dll" Alias "spssSetDEWNext12" _
                                (ByVal handle As Integer, ByVal Data As String, ByVal nBytes As Integer) As Integer
    ' Public Declare PtrSafe Function   spssSetFileAttributes Lib "spssio64.dll" Alias "spssSetFileAttributes" _
    '                           (ByVal handle As Integer, ByVal *attribNames As String, ByVal *attribText As String, ByVal nAttributes As Integer) As Integer
    Public Declare PtrSafe Function spssSetIdString Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal id As String) As Integer
    Public Declare PtrSafe Function spssSetInterfaceEncoding Lib "spssio64.dll" _
                                (ByVal iEncoding As Integer) As Integer
    ' Public Declare PtrSafe Function   spssSetLocale Lib "spssio64.dll" Alias "spssSetLocale" _
    '                           (ByVal iCategory As Integer, ByVal szLocale As String) As String
    Public Declare PtrSafe Function spssSetMultRespDefs Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal mrespDefs As String) As Integer
    Public Declare PtrSafe Function spssSetTempDir Lib "spssio64.dll" _
                                (ByVal dirName As String) As Integer
    Public Declare PtrSafe Function spssSetTextInfo Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal textInfo As String) As Integer
    Public Declare PtrSafe Function spssSetValueChar Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varHandle As Double, ByVal value As String) As Integer
    Public Declare PtrSafe Function spssSetValueNumeric Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varHandle As Double, ByVal value As Double) As Integer
    Public Declare PtrSafe Function spssSetVarAlignment Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal alignment As Integer) As Integer
    ' Public Declare PtrSafe Function   spssSetVarAttributes Lib "spssio64.dll" Alias "spssSetVarAttributes" _
    '                           (ByVal handle As Integer, ByVal varName As String, ByVal *attribNames As String, ByVal *attribText As String, ByVal nAttributes As Integer) As Integer
    Public Declare PtrSafe Function spssSetVarCMissingValues Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal missingFormat As Integer, ByVal missingVal1 As String, ByVal missingVal2 As String, ByVal missingVal3 As String) As Integer
    Public Declare PtrSafe Function spssSetVarColumnWidth Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal columnWidth As Integer) As Integer
    Public Declare PtrSafe Function spssSetVarCValueLabel Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal value As String, ByVal label As String) As Integer
    ' Public Declare PtrSafe Function   spssSetVarCValueLabels Lib "spssio64.dll" Alias "spssSetVarCValueLabels" _
    '                           (ByVal handle As Integer, ByVal *varNames As String, ByVal numofVars As Integer, ByVal *values As String, ByVal *labels As String, ByVal numofLabels As Integer) As Integer
    Public Declare PtrSafe Function spssSetVariableSets Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varSets As String) As Integer
    Public Declare PtrSafe Function spssSetVarLabel Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal varLabel As String) As Integer
    Public Declare PtrSafe Function spssSetVarMeasureLevel Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal measureLevel As Integer) As Integer
    Public Declare PtrSafe Function spssSetVarRole Lib "spssio64.dll" _
                            (ByVal handle As Integer, ByVal varName As String, ByVal varRole As Integer) As Integer
    Public Declare PtrSafe Function spssSetVarName Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal varType As Integer) As Integer
    Public Declare PtrSafe Function spssSetVarNMissingValues Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal missingFormat As Integer, ByVal missingVal1 As Double, ByVal missingVal2 As Double, ByVal missingVal3 As Double) As Integer
    Public Declare PtrSafe Function spssSetVarNValueLabel Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal value As Double, ByVal label As String) As Integer
    ' Public Declare PtrSafe Function   spssSetVarNValueLabels Lib "spssio64.dll" Alias "spssSetVarNValueLabels" _
    '                           (ByVal handle As Integer, ByVal *varNames As String, ByVal numofVars As Integer, ByRef values As Double, ByVal *labels As String, ByVal numofLabels As Integer) As Integer
    Public Declare PtrSafe Function spssSetVarPrintFormat Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal printType As Integer, ByVal printDec As Integer, ByVal printWidth As Integer) As Integer
    Public Declare PtrSafe Function spssSetVarWriteFormat Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByVal varName As String, ByVal writeType As Integer, ByVal writeDec As Integer, ByVal writeWidth As Integer) As Integer
    Public Declare PtrSafe Function spssSysmisVal Lib "spssio64.dll" _
                                () As Double
    Public Declare PtrSafe Function spssValidateVarname Lib "spssio64.dll" _
                                (ByVal varName As String) As Integer
    Public Declare PtrSafe Function spssWholeCaseIn Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByRef caseRec As Double) As Integer
    Public Declare PtrSafe Function spssWholeCaseOut Lib "spssio64.dll" _
                                (ByVal handle As Integer, ByRef caseRec As Double) As Integer
End Module

