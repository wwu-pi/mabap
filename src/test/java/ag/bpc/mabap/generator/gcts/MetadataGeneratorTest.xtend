package ag.bpc.mabap.generator.gcts

import org.eclipse.xtext.generator.InMemoryFileSystemAccess
import org.junit.jupiter.api.Test
import ag.bpc.mabap.model.Repository
import ag.bpc.mabap.generator.gcts.MetadataGenerator

import static org.junit.jupiter.api.Assertions.assertEquals;
import static ag.bpc.mabap.helper.TestHelper.*

class MetadataGeneratorTest {

	InMemoryFileSystemAccess fsa

	@Test
	def void testGenerator() {
		fsa = new InMemoryFileSystemAccess();
		val repository = new Repository("my-awesome-repository")
		
		new MetadataGenerator(fsa, repository).generate
		
		assertFileEquals(fsa, "../.gcts.properties.json", 
			'''{"name":"my-awesome-repository","version":"1.0.0","description":"my-awesome-repository","repositoryLayout":{"formatVersion":4,"format":"json","objectStorage":"plain","metaInformation":".gctsmetadata/","tableContent":"true","subdirectory":"src/"}}'''
		)
		
		assertFileExists(fsa, "../.gitignore")
		
		/*
		 * 1x .gcts.properties.json
		 * 1x .gitignore
		 * 64x nametab metadata 
		 */
		assertEquals(66, fsa.allFiles.size())
	}
	
}
