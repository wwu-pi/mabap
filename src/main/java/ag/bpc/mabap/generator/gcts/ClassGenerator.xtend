package ag.bpc.mabap.generator.gcts

import ag.bpc.mabap.model.Repository
import org.eclipse.xtext.generator.IFileSystemAccess2
import ag.bpc.mabap.model.Class
import ag.bpc.mabap.model.Visibility

class ClassGenerator {

	static val CLAS_DIR = "objects/CLAS/"

	Repository repo;
	IFileSystemAccess2 fsa;

	new (IFileSystemAccess2 fsa, Repository repo) {
		this.fsa = fsa
		this.repo = repo
	}

	def void generate() {
		for (clas : repo.classes) {
			generateClass(clas)
		}
	}

	def void generateClass(Class clas) {
		fsa.generateFile(
			getCurrentClassDir(clas.getName) + generateFixedLengthClassPartFilename("CINC", clas.getName, "CCAU"),
			'''
				*"* use this source file for your ABAP unit test classes
			'''
		)

		fsa.generateFile(
			getCurrentClassDir(clas.getName) + generateFixedLengthClassPartFilename("CINC", clas.getName, "CCDEF"),
			'''
				*"* use this source file for any type of declarations (class
				*"* definitions, interfaces or type declarations) you need for
				*"* components in the private section
			'''
		)

		fsa.generateFile(
			getCurrentClassDir(clas.getName) + generateFixedLengthClassPartFilename("CINC", clas.getName, "CCIMP"),
			'''
				*"* use this source file for the definition and implementation of
				*"* local helper classes, interface definitions and type
				*"* declarations
			'''
		)

		fsa.generateFile(
			getCurrentClassDir(clas.getName) + generateFixedLengthClassPartFilename("CINC", clas.getName, "CCMAC"),
			'''
				*"* use this source file for any macro definitions you need
				*"* in the implementation part of the class
			'''
		)
		
		fsa.generateFile(getCurrentClassDir(clas.getName) + generateClassFilename("CLSD", clas.getName, ""),
			'''
			class-pool .
			*"* class pool for class «clas.getName»
			
			*"* local type definitions
			include «generateFixedLengthClassPartName(clas.getName, "ccdef")».
			
			*"* class «clas.getName» definition
			*"* public declarations
			  include «generateFixedLengthClassPartName(clas.getName, "cu")».
			*"* protected declarations
			  include «generateFixedLengthClassPartName(clas.getName, "co")».
			*"* private declarations
			  include «generateFixedLengthClassPartName(clas.getName, "ci")».
			endclass. "«clas.getName» definition
			
			*"* macro definitions
			include «generateFixedLengthClassPartName(clas.getName, "ccmac")».
			*"* local class implementation
			include «generateFixedLengthClassPartName(clas.getName, "ccimp")».
			
			*"* test class
			include «generateFixedLengthClassPartName(clas.getName, "ccau")».
			
			class «clas.getName» implementation.
			*"* method's implementations
			  include methods.
			endclass. "«clas.getName» implementation
			'''
		)
		
		fsa.generateFile(getCurrentClassDir(clas.getName) + generateClassFilename("CPRI", clas.getName, ""),
			ClassGeneratorHelper.generateDefinitionSection(clas.privateLocalDataTypes, clas.privateClassAttributes, clas.privateMethods, Visibility.PRIVATE)
		)
		
		fsa.generateFile(getCurrentClassDir(clas.getName) + generateClassFilename("CPRO", clas.getName, ""),
			ClassGeneratorHelper.generateDefinitionSection(clas.protectedLocalDataTypes, clas.protectedClassAttributes, clas.protectedMethods, Visibility.PROTECTED)
		)
		
		fsa.generateFile(getCurrentClassDir(clas.getName) + generateClassFilename("CPUB", clas.getName, ""),
			'''
			CLASS «clas.getName» DEFINITION
			  PUBLIC
			  «IF clas.getSuperClass !== null »INHERITING FROM «clas.getSuperClass»«ENDIF»
			  FINAL
			  CREATE PUBLIC .
			
			«ClassGeneratorHelper.generateDefinitionSection(clas.publicLocalDataTypes, clas.publicClassAttributes, clas.publicMethods, Visibility.PUBLIC)»
			'''
		)
		
		for (method : clas.getMethods) {
			// indent method body by 2 spaces
			val methodBody = method.getBody.split("\n").stream().map([String l|"  " + l]).toArray.join("\n")
			 
			fsa.generateFile(getCurrentClassDir(clas.getName) + generateClassMethodFilename(method.getName.toUpperCase),
				'''«methodBody»'''
			)
		}

		fsa.generateFile(getCurrentClassDir(clas.getName) + generateFixedLengthClassPartFilename("REPS", clas.getName, "CT"),
			'''
			*"* dummy include to reduce generation dependencies between
			*"* class «clas.getName» and it's users.
			*"* touched if any type reference has been changed
			'''
		)


		fsa.generateFile(
			getCurrentClassDir(clas.getName) + "CLAS " + clas.getName + ".asx.json",
			new ClasTableGenerator(clas).generate
		)
	}

	private def String getCurrentClassDir(String className) {
		CLAS_DIR + className + "/"
	}

	private def String generateFixedLengthClassPartFilename(String prefix, String name, String suffix) {
		prefix + " " + generateFixedLengthClassPartName(name, suffix) + ".abap"
	}

	private def String generateFixedLengthClassPartName(String name, String suffix) {
		(name + "==============================").subSequence(0, 30) + suffix
	}

	private def String generateClassFilename(String prefix, String name, String suffix) {
		prefix + " " + name + suffix + ".abap"
	}

	private def String generateClassMethodFilename(String methodName) {
		'''METH «methodName.toUpperCase».abap'''
	}
	
}
