package ag.bpc.mabap.generator.gcts

import ag.bpc.mabap.model.Repository
import java.io.BufferedReader
import java.io.IOException
import java.io.InputStream
import java.io.InputStreamReader
import org.eclipse.xtext.generator.IFileSystemAccess2

class MetadataGenerator {

	static val GCTS_NAMETABS_DIR = "../.gctsmetadata/nametabs/"
	static val ROOT_DIR = "../"

	static val RESOURCE_NAMETAB_PREFIX = "/metadata/nametabs/"
	static val RESOURCE_NAMETAB_INDEX = RESOURCE_NAMETAB_PREFIX + "_index"
	
	static val RESOURCE_GIT_GITIGNORE = "/metadata/git/gitignore"

	Repository repo;
	IFileSystemAccess2 fsa;

	new(IFileSystemAccess2 fsa, Repository repo) {
		this.fsa = fsa
		this.repo = repo
	}

	def generate() {
		generateGitIgnoreFile
		generatePropertiesFile
		copyMetadataFiles
	}
	
	def generateGitIgnoreFile() {
		fsa.generateFile(ROOT_DIR + ".gitignore",
			readInputStreamToString(this.class.getResourceAsStream(RESOURCE_GIT_GITIGNORE))
		)
	}

	def generatePropertiesFile() {
		fsa.generateFile(
			MetadataGenerator.ROOT_DIR + ".gcts.properties.json",
			'''{"name":"«repo.name»","version":"1.0.0","description":"«repo.name»","repositoryLayout":{"formatVersion":4,"format":"json","objectStorage":"plain","metaInformation":".gctsmetadata/","tableContent":"true","subdirectory":"src/"}}'''
		)
	}

	def copyMetadataFiles() {
		var nameTabList = loadNametabResourceList.trim.split("\n")
		for (String nametabName : nameTabList) {
			var inputStream = this.class.getResourceAsStream(RESOURCE_NAMETAB_PREFIX + nametabName)
			fsa.generateFile(GCTS_NAMETABS_DIR + nametabName,
				readInputStreamToString(inputStream))
		}
	}

	private def loadNametabResourceList() {
		readInputStreamToString(this.class.getResourceAsStream(RESOURCE_NAMETAB_INDEX))
	}

	// adapted from https://www.baeldung.com/reading-file-in-java
	// files are not working here because JARs do not support java.io.File
	private def readInputStreamToString(InputStream inputStream) throws IOException {
		val resultStringBuilder = new StringBuilder();
		try (val br
	      = new BufferedReader(new InputStreamReader(inputStream))) {

			var line = "";
			while ((line = br.readLine()) !== null) {
				resultStringBuilder.append(line).append("\n");
			}
		} finally {
			if (inputStream !== null) {
				try {
					inputStream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		return resultStringBuilder.toString();
	}

}
