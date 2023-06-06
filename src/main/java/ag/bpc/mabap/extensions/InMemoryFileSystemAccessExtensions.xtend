package ag.bpc.mabap.extensions

import org.eclipse.xtext.generator.InMemoryFileSystemAccess
import org.eclipse.xtext.generator.IFileSystemAccess

class InMemoryFileSystemAccessExtensions {

	static def hasFileInDefaultOutput(InMemoryFileSystemAccess fsa, String filePath) {
		fsa.allFiles.containsKey(IFileSystemAccess::DEFAULT_OUTPUT + filePath)
	}

	static def getFileInDefaultOutput(InMemoryFileSystemAccess fsa, String filePath) {
		fsa.allFiles.get(IFileSystemAccess::DEFAULT_OUTPUT + filePath)
	}
}
