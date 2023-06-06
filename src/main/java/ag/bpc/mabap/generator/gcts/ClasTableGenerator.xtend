package ag.bpc.mabap.generator.gcts

import ag.bpc.mabap.model.IClasElement
import java.time.format.DateTimeFormatter
import ag.bpc.mabap.model.Class
import ag.bpc.mabap.model.Attribute
import ag.bpc.mabap.model.DataType
import ag.bpc.mabap.model.Visibility
import ag.bpc.mabap.model.ObjectType
import ag.bpc.mabap.model.Method

class ClasTableGenerator {
	static val String[] ALWAYS_PRESENT_FILES_SUFFIXES = #["CCAU", "CCDEF", "CCIMP", "CCMAC", "CI", "CO", "CP", "CT",
	"CU"]
	
	new(Class clas) {
		this.clas = clas
	}
	
	Class clas
	
	var methodTRDIRIndex = 1
	var methodTMDIRindex = 1

	def String generate() {
		'''
		[
		 {
		  "table":"DDTYPES",
		  "data":
		  [
		   {
		    "TYPENAME":"«clas.getName»",
		    "STATE":"A",
		    "TYPEKIND":"CLAS"
		   }
		  ]
		 },
		 {
		  "table":"SEOCLASS",
		  "data":
		  [
		   {
		    "CLSNAME":"«clas.getName»",
		    "CLSTYPE":0,
		    "UUID":"«clas.getUuid»",
		    "REMOTE":""
		   }
		  ]
		 },
		 {
		  "table":"SEOCLASSDF",
		  "data":
		  [
		   {
		    "CLSNAME":"«clas.getName»",
		    "VERSION":1,
		    "CATEGORY":0,
		    "EXPOSURE":2,
		    "STATE":1,
		    "RELEASE":0,
		    "AUTHOR":"«clas.getAuthor»",
		    "CREATEDON":"«generateFormattedDate»",
		    "CHANGEDBY":"",
		    "CHANGEDON":"0000-00-00",
		    "CHGDANYBY":"",
		    "CHGDANYON":"0000-00-00",
		    "CLSEMBED":"",
		    "CLSABSTRCT":"",
		    "CLSFINAL":"X",
		    "CLSCCINCL":"X",
		    "CLSDEFATT":"",
		    "CLSDEFMTD":"",
		    "REFCLSNAME":"",
		    "FIXPT":"X",
		    "VARCL":"",
		    "UNICODE":"X",
		    "RSTAT":"",
		    "CLSBCIMPL":"",
		    "R3RELEASE":"756",
		    "CLSBCTRANS":"",
		    "CLSBCCAT":0,
		    "CLSBCNODEL":"",
		    "CLSADDON":"",
		    "MSG_ID":"",
		    "CLSPROXY":"",
		    "CLSSHAREDMEMORY":"",
		    "WITH_UNIT_TESTS":"X",
		    "DURATION_TYPE":"0",
		    "RISK_LEVEL":"0",
		    "WITHIN_PACKAGE":""
		   }
		  ]
		 },
		 {
		  "table":"SEOCLASSTX",
		  "data":
		  [
		   {
		    "CLSNAME":"«clas.getName»",
		    "LANGU":"D",
		    "DESCRIPT":"«clas.getDescription»"
		   }
		  ]
		 },
		 «IF clas.clasElements.size > 0»
		 	«generateSEOCOMPO»
		 	«generateSEOCOMPODF»
		 	«generateSEOCOMPOTX»
		 «ENDIF»
		 {
		  "table":"SEOMETAREL",
		  "data":
		  [
		   {
		    "CLSNAME":"«clas.getName»",
		    "REFCLSNAME":"«clas.getSuperClass»",
		    "VERSION":1,
		    "STATE":1,
		    "AUTHOR":"«clas.getAuthor»",
		    "CREATEDON":"«generateFormattedDate»",
		    "CHANGEDBY":"",
		    "CHANGEDON":"0000-00-00",
		    "RELTYPE":2,
		    "RELNAME":"",
		    "EXPOSURE":0,
		    "IMPFINAL":"",
		    "IMPABSTRCT":"",
		    "EDITORDER":0,
		    "PARTIALLYIMP":""
		   }
		  ]
		 },
		 {
		  "table":"SEOREDEF",
		  "data":
		  [
		   «FOR method : clas.redefinedMethods SEPARATOR ','»
		   {
		    "CLSNAME":"«clas.getName»",
		    "REFCLSNAME":"«clas.getSuperClass»",
		    "VERSION":1,
		    "MTDNAME":"«method.getName.toUpperCase»",
		    "MTDABSTRCT":"",
		    "MTDFINAL":"",
		    "ATTVALUE":"",
		    "EXPOSURE":0
		   }
		   «ENDFOR»
		  ]
		 },
		 «IF clas.anyMethodWithParametersOrRaises»
		 «generateSEOSUBCO»
		 «generateSEOSUBCODF»
		 «generateSEOSUBCOTX»
		 «ENDIF»
		 {
		  "table":"TADIR",
		  "data":
		  [
		   {
		    "PGMID":"R3TR",
		    "OBJECT":"CLAS",
		    "OBJ_NAME":"«clas.getName»",
		    "KORRNUM":"",
		    "SRCSYSTEM":"...",
		    "AUTHOR":"«clas.getAuthor»",
		    "SRCDEP":"",
		    "DEVCLASS":"«clas.getPackage»",
		    "GENFLAG":"",
		    "EDTFLAG":"",
		    "CPROJECT":" S",
		    "MASTERLANG":"D",
		    "VERSID":"",
		    "PAKNOCHECK":"",
		    "OBJSTABLTY":"",
		    "COMPONENT":"",
		    "CRELEASE":"",
		    "DELFLAG":"",
		    "TRANSLTTXT":"",
		    "CREATED_ON":"«generateFormattedDate»",
		    "CHECK_DATE":"«generateFormattedDate»",
		    "CHECK_CFG":""
		   }
		  ]
		 },
		 {
		  "table":"TMDIR",
		  "data":
		  [
		   {
		    "CLASSNAME":"«clas.getName»",
		    "METHODINDX":0,
		    "METHODNAME":" ",
		    "FLAGS":0
		   }«IF clas.getMethods.size > 0»,«ENDIF»
		   «FOR method : clas.getMethods SEPARATOR ','»
		    «generateMethodTMDIREntry(method)»
		   «ENDFOR»
		  ]
		 },
		 {
		  "table":"TRDIR",
		  "data":
		  [
		   «FOR suffix : ALWAYS_PRESENT_FILES_SUFFIXES SEPARATOR ','»
		   	«generateFileEntry(suffix)»
		   «ENDFOR»
		   «FOR method : clas.getMethods SEPARATOR ','»
		   	{
		   	 "NAME":"«generateFixedLengthClassPartName(clas.getName, generateMethodIdentifier(method, methodTRDIRIndex))»",
		   	 "VARCL":"X",
		   	 "DBAPL":"S",
		   	 "DBNA":"D$",
		   	 "SUBC":"I",
		   	 "APPL":"S",
		   	 "UNAM":"«clas.getAuthor»",
		   	 "RMAND":"«clas.getClient»",
		   	 "FIXPT":"X",
		   	 "LDBNAME":"D$S",
		   	 "UCCHECK":"X"
		   	}
		   «ENDFOR»
		  ]
		 }
		]
		'''
	}
	
	private def generateSEOCOMPO() {
		'''
		{
		 "table":"SEOCOMPO",
		 "data":
		 [
		  «FOR clasElement : clas.sortedClasElements SEPARATOR ','»
		   {
		    "CLSNAME":"«clas.getName»",
		    "CMPNAME":"«clasElement.name.toUpperCase»",
		    "CMPTYPE":«getSEOCOMPOCMPTYPEFromElement(clasElement)»,
		    "MTDTYPE":0
		   }
		   «ENDFOR»
		 ]
		},
		 '''
	}
	
	private def String getSEOCOMPOCMPTYPEFromElement(IClasElement element){
		switch element {
			Attribute : return "0"
			Method : return "1"
			DataType : return "3"
			default : return ""
		}
	}
	
	private def String generateSEOCOMPODF() {
		'''
		{
		 "table":"SEOCOMPODF",
		 "data":
		 [
		  «FOR clasElement : clas.sortedClasElements SEPARATOR ','»
		   {
		    "CLSNAME":"«clas.getName»",
		    "CMPNAME":"«clasElement.name.toUpperCase»",
		    "VERSION":1,
		    "ALIAS":"",
		    "REDEFIN":"",
		    "EXPOSURE":«if (clasElement.visibility == Visibility.PROTECTED) "1" else if (clasElement.visibility == Visibility.PUBLIC) "2" else "0"»,«/* assumption: 0:private, 1:protected, 2:public */»
		    "STATE":1,
		    "EDITORDER":«clas.getEditOrderOfClasElement(clasElement)»,«/* Is the index of an element differentiated by type and visibility */»
		    "LOCKED":"",
		    "DISPID":0,
		    "R3RELEASE":"«if (clasElement instanceof DataType) "756"»",«/*Datatype: the following information is stored for datatypes */»
		    "AUTHOR":"",«/* Could be filled here be SAP does not; exception PROTECTED (and PUBLIC?) methods; try without it for now*/»
		    "CREATEDON":"0000-00-00",«/* Could be filled here be SAP does not; exception PROTECTED (and PUBLIC?) methods; try without it for now*/»
		    "CHANGEDBY":"",
		    "CHANGEDON":"0000-00-00",
		    "MTDDECLTYP":0,
		    "MTDABSTRCT":"",
		    "MTDFINAL":"",
		    "DSRNOTEOM":"",
		    "EDTX":"",
		    "MTDNEWEXC":"«if (clasElement instanceof Method && (clasElement as Method).raises.size() > 0) "X"»",«/* any method that can raise exceptions will be flagged here */»
		    "MTDREPLACE":"",
		    "MTDOPTNL":"",
		    "MTDAMDPRDONLY":"",
		    "MTDAMDPCDSCLNT":"",
		    "ATTDECLTYP":0,
		    "ATTDYNAMIC":"",
		    "ATTGETMTD":"",
		    "ATTSETMTD":"",
		    "ATTRDONLY":"",
		    "ATTVALUE":"",
		    "ATTPERSIST":"",
		    "ATTBUSOBJ":"",
		    "ATTKEYFLD":"",
		    "ATTEXPVIRT":0,
		    "EVTDECLTYP":0,
		    "TYPDUMMY":"",
		    "TYPTYPE":«getSEOCOMPODFTYPTYPEFromElement(clasElement)»,«/* 0: methods, 1: attributes, 4: datatypes */»
		    "TYPE":"«if (clasElement instanceof Attribute) "C"»",«/* attributes are flagged with 'C' */»
		    "TABLEOF":"",
		    "SRCROW1":0,«/* TODO: Datatype: This field references the position of a datatype in the declaration (begin line) */»
		    "SRCCOLUMN1":0,«/* TODO: Datatype: This field references the position of a datatype in the declaration (begin character )*/»
		    "SRCROW2":0,«/* TODO: Datatype: This field references the position of a datatype in the declaration (end line)*/»
		    "SRCCOLUMN2":0,«/* TODO: Datatype: This field references the position of a datatype in the declaration (end character)*/»
		    "REFCLSNAME":"",
		    "REFINTNAME":"",
		    "REFCMPNAME":"",
		    "BCMTDINST":"",
		    "BCMTDCAT":0,
		    "BCMTDDIA":"",
		    "BCMTDCOM":"",
		    "BCMTDSYN":0,
		    "BCEVTCAT":0,
		    "TYPESRC_LENG":0,«/* TODO: Datatype: Count might not match body.strip.length*/»
		    "TYPESRC":""«/* TODO: Datatype: There is currently no way to escape the line-breaks and carriage-returns*/»
		   }
		  «ENDFOR»
		 ]
		},
		'''
	}
	
	private def String getSEOCOMPODFTYPTYPEFromElement(IClasElement element) {
		switch element {
			Method : "0"
			Attribute : "1"
			DataType : "4"
			default : ""
		}
	}
	
	private def String generateSEOCOMPOTX() {
		'''
		 {
		  "table":"SEOCOMPOTX",
		  "data":
		  [
		   «FOR clasElement : clas.sortedClasElements SEPARATOR ','»
		   {
		    "CLSNAME":"«clas.getName»",
		    "CMPNAME":"«clasElement.name.toUpperCase»",
		    "LANGU":"D",
		    "DESCRIPT":""
		   }
		   «ENDFOR»
		  ]
		 },
		'''
	}
	
	private def String generateSEOSUBCO() {
		'''
		{
		 "table":"SEOSUBCO",
		 "data":
		 [
		  «FOR method : clas.notRedefinedMethods SEPARATOR ","»
		  «FOR param : method.sortedParameters SEPARATOR ","»
		   {
		    "CLSNAME":"«clas.getName»",
		    "CMPNAME":"«method.getName.toUpperCase»",
		    "SCONAME":"«param.getName.toUpperCase»",
		    "CMPTYPE":1,
		    "MTDTYPE":0,
		    "SCOTYPE":«if (param.getObjectType == ObjectType.RAISE) "1" else "0"»
		   }
		  «ENDFOR»
		  «ENDFOR»
		 ]
		},
		'''
	}
	
	private def String generateSEOSUBCODF() {
		'''
		{
		 "table":"SEOSUBCODF",
		 "data":
		 [
		  «FOR method : clas.notRedefinedMethods SEPARATOR ","»
		  «FOR param : method.sortedParameters SEPARATOR ","»
		   {
		    "CLSNAME":"«clas.getName»",
		    "CMPNAME":"«method.getName.toUpperCase»",
		    "SCONAME":"«param.getName.toUpperCase»",
		    "VERSION":1,
		    "EDITORDER":«method.getEditOrderOfParam(param)»,«/* Position of the param in the method. Imports first, then export, new count for exceptions */»
		    "LOCKED":"",
		    "DISPID":0,
		    "AUTHOR":"«clas.getAuthor»",
		    "CREATEDON":"«generateFormattedDate»",
		    "CHANGEDBY":"",
		    "CHANGEDON":"0000-00-00",
		    "PARDECLTYP":«if (param.getObjectType == ObjectType.EXPORT) "1" else "0"»,«/* 0: Import, 1: Export, 0: Raise */»
		    "PARPASSTYP":«if (param.getObjectType == ObjectType.RAISE) "0" else "1"»,«/* 1: Import,Export 0: Raise */»
		    "TYPTYPE":«if (param.getObjectType == ObjectType.RAISE) "0" else if (param.getType.toUpperCase.contains("ZCL_")) "3" else "1"»,«/* 0: Exception Class, 1: Datatype (global or local), 3: Class reference */»
		    "TYPE":"«if (param.getType !== null) param.getType.toUpperCase»",
		    "TABLEOF":"",
		    "SRCROW1":0,
		    "SRCCOLUMN1":0,
		    "SRCROW2":0,
		    "SRCCOLUMN2":0,
		    "PARVALUE":"",
		    "PAROPTIONL":"",
		    "PARPREFERD":"",
		    "EXCDECLTYP":0,
		    "IS_RESUMABLE":""
		   }
		 «ENDFOR»
		 «ENDFOR»
		 ]
		},
		'''
	}
	
	private def String generateSEOSUBCOTX() {
		'''
		{
		 "table":"SEOSUBCOTX",
		 "data":
		 [
		  «FOR method : clas.notRedefinedMethods SEPARATOR ","»
		  «FOR param : method.sortedParameters SEPARATOR ","»
		   {
		    "CLSNAME":"«clas.getName»",
		    "CMPNAME":"«method.getName.toUpperCase»",
		    "SCONAME":"«param.getName.toUpperCase»",
		    "LANGU":"D",
		    "DESCRIPT":""
		   }
		  «ENDFOR»
		  «ENDFOR»
		 ]
		},
		'''
	}
	
	private def String generateMethodTMDIREntry(Method method) {
		val currentMethodIndex = methodTMDIRindex
		methodTMDIRindex += 1
		'''
	    {
	     "CLASSNAME":"«clas.getName»",
	     "METHODINDX":«currentMethodIndex»,
	     "METHODNAME":"«method.getName.toUpperCase»",
	     "FLAGS":0
	    }
		'''
	}
	
	private def String generateFileEntry(String suffix) {
		'''
		{
		 "NAME":"«generateFixedLengthClassPartName(clas.getName, suffix)»",
		 «IF suffix == "CP"»"EDTX":"X",«ENDIF»
		 «IF suffix != "CT"»"VARCL":"X",«ENDIF»
		 "DBAPL":"S",
		 "DBNA":"D$",
		 "SUBC":"«IF suffix == "CP"»K«ELSE»I«ENDIF»",
		 "APPL":"S",
		 "UNAM":"«clas.getAuthor»",
		 "RMAND":"«clas.getClient»",
		 "FIXPT":"X",
		 "LDBNAME":"D$S",
		 "UCCHECK":"X"
		}«IF suffix== "CU" && clas.getMethods.size() > 0»,«ENDIF»
		'''
	}
	
	private def String generateFixedLengthClassPartName(String name, String suffix) {
		(name + "==============================").subSequence(0, 30) + suffix
	}

	private def String generateFormattedDate() {
		var dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd")
		dtf.format(clas.getCreatedAt)
	}
	
	private def String generateMethodIdentifier(Method method, int index){
		var prefixedNumber = "000" + generateMethodIdentifierNumber(index)
		methodTRDIRIndex += 1
		"CM" + prefixedNumber.subSequence(prefixedNumber.length() - 3, prefixedNumber.length())	
	}
	
	private def String generateMethodIdentifierNumber(int index) {
		if (index > 35) throw new IllegalArgumentException("Index must not be greater than 35.")
		if (index < 10) return index.toString()
		
		val alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".toCharArray()
		alphabet.get(index-10).toString()
	}

}
