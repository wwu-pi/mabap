package ag.bpc.mabap.generator.gcts

import ag.bpc.mabap.model.Repository
import org.eclipse.xtext.generator.IFileSystemAccess2
import ag.bpc.mabap.model.LogObject

class LogObjectGenerator {
	static val APPL_LOG_DIR = "objects/CDAT/APPL_LOG/"
	static val TABLE_DATA_DIR = "tabledata/"
	
	Repository repo;
	IFileSystemAccess2 fsa;

	new(IFileSystemAccess2 fsa, Repository repo) {
		this.fsa = fsa
		this.repo = repo
	}

	def generate() {
		generateLogObjects(repo.logObjects)

	}
	
	private def generateLogObjects(LogObject[] logObjects){
		generateAppLogFile(logObjects)
		generateTableDataFiles(logObjects)
	}
	
	private def generateAppLogFile(LogObject[] logObjects) {
		fsa.generateFile(APPL_LOG_DIR + "V_BALSUB.index.json", 
			'''
			[
			 {
			  "table":"BALSUB",«/* This is fix for log objects */»
			  "index":
			  [
			   «FOR logObject : logObjects SEPARATOR ","»
			   {
			    "columns":
			    [
			     {
			      "key":"OBJECT",
			      "value":"«logObject.parentObject»"
			     },
			     {
			      "key":"SUBOBJECT",
			      "value":"«logObject.sstID»"
			     }
			    ],
			    "hash":"«logObject.hash»"
			   }
			   «ENDFOR»
			  ]
			 },
			 {
			  "table":"BALSUBT",
			  "index":
			  [
			   «FOR logObject : logObjects SEPARATOR ","»
			   {
			    "columns":
			    [
			     {
			      "key":"SPRAS",
			      "value":"D"
			     },
			     {
			      "key":"OBJECT",
			      "value":"«logObject.parentObject»"
			     },
			     {
			      "key":"SUBOBJECT",
			      "value":"«logObject.sstID»"
			     }
			    ],
			    "hash":"«logObject.hash»"
			   }
			   «ENDFOR»
			  ]
			 }
			]
			'''
		)
	}
	
	private def generateTableDataFiles(LogObject[] logObjects) {
		fsa.generateFile(TABLE_DATA_DIR + "BALSUB.asx.json", 
			'''
			[
			 {
			  "table":"BALSUB",
			  "data":
			  [
			   «FOR logObject : logObjects SEPARATOR ","»
			   {
			    "OBJECT":"«logObject.parentObject»",
			    "SUBOBJECT":"«logObject.sstID»"
			   }
			   «ENDFOR»
			  ]
			 }
			]
			'''
		)
		
		fsa.generateFile(TABLE_DATA_DIR + "BALSUBT.asx.json", 
			'''
			[
			 {
			  "table":"BALSUBT",
			  "data":
			  [
			   «FOR logObject : logObjects SEPARATOR ","»
			   {
			    "SPRAS":"D",
			    "OBJECT":"«logObject.parentObject»",
			    "SUBOBJECT":"«logObject.sstID»",
			    "SUBOBJTXT":"«logObject.description»"
			   }
			   «ENDFOR»
			  ]
			 }
			]
			'''
		)
	}
}
	
	