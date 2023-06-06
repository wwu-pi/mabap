package ag.bpc.mabap.generator.gcts

import ag.bpc.mabap.model.Repository
import org.eclipse.xtext.generator.IFileSystemAccess2
import ag.bpc.mabap.model.Class
import ag.bpc.mabap.model.Visibility

class ClassPlainGenerator {
	static val CLAS_PLAIN_DIR = "../.debug/"

	Repository repo;
	IFileSystemAccess2 fsa;

	new (IFileSystemAccess2 fsa, Repository repo) {
		this.fsa = fsa
		this.repo = repo
	}

	def void generate() {
		for (clas : repo.classes) {
			generateClas(clas)
		}
	}

	def void generateClas(Class clas) {
		fsa.generateFile(CLAS_PLAIN_DIR + clas.getName.toUpperCase + ".abap",
			'''
			«generateDefinition(clas)»
			
			
			«generateImplementation(clas)»
			'''
		)
	}
	
	private def generateDefinition(Class clas) {
		'''
		CLASS «clas.getName» DEFINITION
		  PUBLIC
		  «IF clas.getSuperClass !== null »INHERITING FROM «clas.getSuperClass»«ENDIF»
		  FINAL
		  CREATE PUBLIC .
		
		«ClassGeneratorHelper.generateDefinitionSection(clas.publicLocalDataTypes, clas.publicClassAttributes, clas.publicMethods, Visibility.PUBLIC)»
		
		«ClassGeneratorHelper.generateDefinitionSection(clas.protectedLocalDataTypes, clas.protectedClassAttributes, clas.protectedMethods, Visibility.PROTECTED)»
		
		«ClassGeneratorHelper.generateDefinitionSection(clas.privateLocalDataTypes, clas.privateClassAttributes, clas.privateMethods, Visibility.PRIVATE)»
		ENDCLASS.
		'''
	}
	
	private def generateImplementation(Class clas) {
		'''
		CLASS «clas.getName» IMPLEMENTATION.
		«FOR method : clas.getMethods SEPARATOR "\n\n"»
		«ClassGeneratorHelper.indentBy(method.getBody, 4)»
		«ENDFOR»
		ENDCLASS.
		'''
	}
	
}