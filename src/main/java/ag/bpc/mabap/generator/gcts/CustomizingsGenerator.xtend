package ag.bpc.mabap.generator.gcts

import ag.bpc.mabap.model.Repository
import org.eclipse.xtext.generator.IFileSystemAccess2
import ag.bpc.mabap.model.Customizing
import java.util.stream.Collectors

class CustomizingsGenerator {
	
	static val TABU_DIR = "objects/TABU/"
	static val TABLE_DATA_DIR = "tabledata/"
	
	Repository repo;
	IFileSystemAccess2 fsa;

	new(IFileSystemAccess2 fsa, Repository repo) {
		this.fsa = fsa
		this.repo = repo
	}

	def generate() {
		for (table : groupCustomizingsByTable.keySet()) {
			generateCustomizingsForTable(table, groupCustomizingsByTable.get(table))
		}
	}
	
	private def void generateCustomizingsForTable(String tableName, Customizing[] custs) {
		fsa.generateFile(TABU_DIR + tableName.toUpperCase() +".index.json",
			'''
			[
			 {
			  "table":"«tableName»",
			  "index":
			  [
			   «FOR cust : custs SEPARATOR ","»
			   {
			    "columns":
			    [
			     «FOR key : cust.keys SEPARATOR ","»
			     {
			      "key":"«key»",
			      "value":"«cust.values.get(key)»"
			     }
			     «ENDFOR»
			    ],
			    "hash":"«cust.hash»"
			   }
			   «ENDFOR»
			  ]
			 }
			]'''
		)
		
		fsa.generateFile(TABLE_DATA_DIR + tableName.toUpperCase() + ".asx.json",
			'''
			[
			 {
			  "table":"«tableName»",
			  "data":
			  [
			   «FOR cust : custs SEPARATOR ","»
			   {
			    «FOR key : cust.values.keySet() SEPARATOR ","»
			      "«key»":"«cust.values.get(key)»"
			    «ENDFOR»
			   }
			   «ENDFOR»
			  ]
			 }
			]'''
		)
		
	}

	private def groupCustomizingsByTable() {
		repo.customizings.stream().collect(Collectors.groupingBy([c|c.table]))
	}

}
