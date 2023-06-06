package ag.bpc.mabap.generator.gcts

import ag.bpc.mabap.model.Repository
import org.eclipse.xtext.generator.IFileSystemAccess2

class RepositoryGenerator {
	
	Repository repo;
	IFileSystemAccess2 fsa;
	String[] objectsToGenerate;
	
	public static val CLAS = "CLASS"
	public static val PLAIN_CLAS = "PLAIN_CLASS"
	public static val CUSTOMIZING = "CUSTOMIZING"
	public static val PACKAGE = "PACKAGE"
	public static val METADATA = "METADATA"
	public static val LOG_OBJECT = "LOG_OBJECT"
	
	
	new(IFileSystemAccess2 fsa, Repository repo, String[] objectToGenerate){
		this.repo =repo
		this.fsa = fsa
		this.objectsToGenerate = objectToGenerate
	}
	
	def generate() {
		// if nothing has been provided, generate everything
		if (objectsToGenerate === null || objectsToGenerate.size == 0) {
			objectsToGenerate = newArrayList(CLAS, PLAIN_CLAS, CUSTOMIZING, PACKAGE, METADATA, LOG_OBJECT)
		}
		
		if (objectsToGenerate.contains(METADATA)) {
			new MetadataGenerator(fsa, repo).generate
		}
		if (objectsToGenerate.contains(CLAS)) {
			new ClassGenerator(fsa, repo).generate
		}
		if (objectsToGenerate.contains(PLAIN_CLAS)) {
			new ClassPlainGenerator(fsa, repo).generate
		}
		if (objectsToGenerate.contains(CUSTOMIZING)) {
			new CustomizingsGenerator(fsa, repo).generate
		}
		if (objectsToGenerate.contains(PACKAGE)) {
			new PackageGenerator(fsa, repo).generate
		}
		if(objectsToGenerate.contains(LOG_OBJECT)) {
			new LogObjectGenerator(fsa, repo).generate
		}
	}
	
}