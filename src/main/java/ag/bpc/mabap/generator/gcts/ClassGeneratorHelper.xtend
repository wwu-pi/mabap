package ag.bpc.mabap.generator.gcts

import java.util.List
import ag.bpc.mabap.model.Attribute
import ag.bpc.mabap.model.DataType
import ag.bpc.mabap.model.Visibility
import ag.bpc.mabap.model.Method

class ClassGeneratorHelper {
		static def String generateDefinitionSection(List<DataType> types, List<Attribute> attributes, List<Method> methods, Visibility visibility) {
		'''
		«""»  «visibility.toString.toUpperCase» SECTION.
		«FOR type : types AFTER "\n"»
		«""»    TYPES:
		«""»«indentBy(type.getBody, 6)»
		«""»
		«ENDFOR»
		«FOR attribute : attributes AFTER "\n"»
		«""»    DATA:
		«""»«indentBy(attribute.getBody, 6)»
		«""»
		«ENDFOR»
		«FOR method : methods SEPARATOR " ." AFTER "    ."»
		«""»    METHODS «method.getName»
        «IF !method.isRedefinition»
        «IF method.imports.size() > 0»
		«""»      IMPORTING
        «FOR imp : method.imports»
        «IF imp.isReference»
        «""»        !«imp.getName» TYPE REF TO «imp.getType»
        «ELSE»
		«""»        !«imp.getName» TYPE «imp.getType»
		«ENDIF»
        «ENDFOR»
        «ENDIF»
      	«IF method.exports.size() > 0»
        «""»      EXPORTING
        «FOR export : method.exports»
		«IF export.isReference»
        «""»        !«export.getName» TYPE REF TO «export.getType»
        «ELSE»
		«""»        !«export.getName» TYPE «export.getType»
		«ENDIF»
        «ENDFOR»
        «ENDIF»
      	«IF method.raises.size() > 0»
		«""»      RAISING
        «FOR raise : method.raises»
		«""»        «raise.getName»
        «ENDFOR»
		«ENDIF»
        «ENDIF»
        «IF method.isRedefinition»
		«""»        REDEFINITION
        «ENDIF»
		«ENDFOR»
		'''
	}
	
	static def indentBy(String content, int numerOfSpaces) {
		// add temporary identifiers to preserve line breaks in empty lines
		content.replace("\n", "««««\n").split("\n").stream().map([String l|" ".repeat(numerOfSpaces) + l]).toArray.join(
			"\n").replace("««««", "")
	}
}