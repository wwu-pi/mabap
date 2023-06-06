package ag.bpc.mabap.generator.gcts

import ag.bpc.mabap.model.MessageClass
import java.time.format.DateTimeFormatter
import java.time.LocalDateTime
import ag.bpc.mabap.model.Repository
import org.eclipse.xtext.generator.IFileSystemAccess2

class MessageClassGenerator {
	
	static val MSAG_DIR = "objects/MSAG/"
	
	Repository repo;
	IFileSystemAccess2 fsa;

	new (IFileSystemAccess2 fsa, Repository repo) {
		this.fsa = fsa
		this.repo = repo
	}
	
	def void generate() {
		for (msgClass : repo.messageClasses) {
			generateMessageClass(msgClass)
		}
	}
	
	private def generateMessageClass(MessageClass msgClass) {
		fsa.generateFile(MSAG_DIR + msgClass.name.toUpperCase + "/MSAG " + msgClass.name.toUpperCase + ".asx.json", generateMessageTables(msgClass))
	}
	
	private def String generateMessageTables(MessageClass msgClass) {
		'''
		[
		 «generateT100(msgClass)»
		 {
		  "table":"T100A",
		  "data":
		  [
		   {
		    "ARBGB":"«msgClass.name.toUpperCase»",
		    "MASTERLANG":"D",
		    "APPLCLASS":"",
		    "RESPUSER":"«msgClass.author»",
		    "LASTUSER":"«msgClass.author»",
		    "LDATE":"0000-00-00",
		    "LTIME":"00:00:00",
		    "STEXT":"«msgClass.description»"
		   }
		  ]
		 },
		 {
		  "table":"T100T",
		  "data":
		  [
		   {
		    "SPRSL":"D",
		    "ARBGB":"«msgClass.name.toUpperCase»",
		    "STEXT":"«msgClass.description»"
		   }
		  ]
		 },
		 «generateT100U(msgClass)»
		 {
		  "table":"TADIR",
		  "data":
		  [
		   {
		    "PGMID":"R3TR",
		    "OBJECT":"MSAG",
		    "OBJ_NAME":"«msgClass.name.toUpperCase»",
		    "KORRNUM":"",
		    "SRCSYSTEM":"...",
		    "AUTHOR":"«msgClass.author»",
		    "SRCDEP":"",
		    "DEVCLASS":"«msgClass.devPackage»",
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
		    "CREATED_ON":"«generateFormattedDate(msgClass.createdAt)»",
		    "CHECK_DATE":"«generateFormattedDate(msgClass.createdAt)»",
		    "CHECK_CFG":""
		   }
		  ]
		 }
		]
		'''
	}
	
	private def generateT100(MessageClass msgClass) {
		'''
		{
		 "table":"T100",
		 "data":
		 [
		  «FOR msg : msgClass.messages SEPARATOR ","»
		  {
		   "SPRSL":"D",
		   "ARBGB":"«msgClass.name.toUpperCase»",
		   "MSGNR":"«generateMessageNumber(msgClass.getNumberForMessage(msg))»",
		   "TEXT":"«msg»"
		  }
		  «ENDFOR»
		 ]
		},
		'''
	}
	
	private def generateT100U(MessageClass msgClass) {
		'''
		 {
		  "table":"T100U",
		  "data":
		  [
		   «FOR msg : msgClass.messages SEPARATOR ","»
		   {
		    "ARBGB":"«msgClass.name.toUpperCase»",
		    "MSGNR":"«generateMessageNumber(msgClass.getNumberForMessage(msg))»",
		    "NAME":"«luserFromAuthor(msgClass.author)»",
		    "DATUM":"0000-00-00",
		    "SELFDEF":"3"«/* 3: No longtext; TODO: Add longtext support */»
		   }
		   «ENDFOR»
		  ]
		 },
		'''
	}
	
	private def String generateMessageNumber(int i){
		var prefixedNumber = "000" + i.toString
		return prefixedNumber.subSequence(prefixedNumber.length() - 3, prefixedNumber.length()).toString
	}
	
	private def String luserFromAuthor(String author) {
		return "L-" + author
	}
	
	private def String generateFormattedDate(LocalDateTime date) {
		var dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd")
		dtf.format(date)
	}
}