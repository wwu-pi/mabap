package ag.bpc.mabap.generator.gcts

import ag.bpc.mabap.model.Repository
import org.eclipse.xtext.generator.IFileSystemAccess2
import java.util.stream.Collectors
import ag.bpc.mabap.model.Customization

class CustomizationGenerator {
	
	static val TABU_DIR = "objects/TABU/"
	static val TABLE_DATA_DIR = "tabledata/"
	
	Repository repo;
	IFileSystemAccess2 fsa;

	new(IFileSystemAccess2 fsa, Repository repo) {
		this.fsa = fsa
		this.repo = repo
	}

	def generate() {
		for (table : groupCustomizationsByTable.keySet()) {
			generateCustomizationsForTable(table, groupCustomizationsByTable.get(table))
		}
	}
	
	private def void generateCustomizationsForTable(String tableName, Customization[] custs) {
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
			     «FOR key : cust.getKeys SEPARATOR ","»
			     {
			      "key":"«key»",
			      "value":"«cust.getValues.get(key)»"
			     }
			     «ENDFOR»
			    ],
			    "hash":"«cust.getHash»"
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
			    «FOR key : cust.getValues.keySet() SEPARATOR ","»
			      "«key»":"«cust.getValues.get(key)»"
			    «ENDFOR»
			   }
			   «ENDFOR»
			  ]
			 }
			]'''
		)
		
	}

	private def groupCustomizationsByTable() {
		repo.customizations.stream().collect(Collectors.groupingBy([c|c.getTable]))
	}

}
