package ag.bpc.mabap.generator.gcts

import ag.bpc.mabap.model.Repository
import org.eclipse.xtext.generator.IFileSystemAccess2
import java.time.format.DateTimeFormatter
import ag.bpc.mabap.model.Package

class PackageGenerator {
	static val DEVC_DIR = "objects/DEVC/"

	Repository repo
	IFileSystemAccess2 fsa

	new(IFileSystemAccess2 fsa, Repository repo) {
		this.fsa = fsa
		this.repo = repo
	}
	
	def generate() {
		for(pkg : repo.packages) {
			generatePackage(pkg)
		}	
	}
	
	private def generatePackage(Package pkg) {
		fsa.generateFile(DEVC_DIR + pkg.getName + "/DEVC " + pkg.getName + ".asx.json",
			'''
			[
			 {
			  "table":"TADIR",
			  "data":
			  [
			   {
			    "PGMID":"R3TR",
			    "OBJECT":"DEVC",
			    "OBJ_NAME":"«pkg.getName»",
			    "KORRNUM":"",
			    "SRCSYSTEM":"...",
			    "AUTHOR":"«pkg.getAuthor»",
			    "SRCDEP":"",
			    "DEVCLASS":"«pkg.getName»",
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
			    "CREATED_ON":"«generateFormattedDate(pkg)»",
			    "CHECK_DATE":"«generateFormattedDate(pkg)»",
			    "CHECK_CFG":""
			   }
			  ]
			 },
			 {
			  "table":"TDEVC",
			  "data":
			  [
			   {
			    "DEVCLASS":"«pkg.getName»",
			    "INTSYS":"",
			    "CONSYS":"",
			    "CTEXT":"",
			    "KORRFLAG":"X",
			    "AS4USER":"",
			    "PDEVCLASS":"«pkg.getTransportSystem»",
			    "DLVUNIT":"«pkg.getUnit»",
			    "COMPONENT":"",
			    "NAMESPACE":"«pkg.getNamespace»",
			    "TPCLASS":"",
			    "SHIPMENT":"",
			    "PARENTCL":"«pkg.getParent»",
			    "APPLICAT":"",
			    "ERRSEVRTY":"",
			    "PERMINHER":"",
			    "INTFPREFX":"",
			    "PACKTYPE":"",
			    "RESTRICTED":"",
			    "MAINPACK":"",
			    "CREATED_BY":"«pkg.getAuthor»",
			    "CREATED_ON":"«generateFormattedDate(pkg)»",
			    "CHANGED_BY":"«pkg.getAuthor»",
			    "CHANGED_ON":"«generateFormattedDate(pkg)»",
			    "SRV_CHECK":"",
			    "CLI_CHECK":"",
			    "EXT_ALIAS":"",
			    "PROJECT_GUID":"",
			    "PROJECT_PASSDOWN":"",
			    "IS_ENHANCEABLE":"",
			    "PACKAGE_KIND":"",
			    "ENHANCED_PACKAGE":"",
			    "ACCESS_OBJECT":"",
			    "DEFAULT_INTF":"",
			    "INHERIT_CLI_INTF":"",
			    "TECH_CHG_TSTMP":"0",
			    "OVERALL_TSTMP":"0",
			    "ENCAPSULATION":"",
			    "DCL_ENABLED":"",
			    "SUB_KEY":"",
			    "ALLOW_STATIC":"",
			    "SWITCH_ID":"",
			    "CHECK_RULE":""
			   }
			  ]
			 },
			 {
			  "table":"TDEVCT",
			  "data":
			  [
			   {
			    "DEVCLASS":"«pkg.getName»",
			    "SPRAS":"D",
			    "CTEXT":"«pkg.getDescription»"
			   }
			  ]
			 }
			]
			'''
		)
	}
	
	private def String generateFormattedDate(Package pkg) {
		var dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd")
		dtf.format(pkg.getCreatedAt)
	}
}
