package ag.bpc.mabap.helper

import java.util.ArrayList
import org.eclipse.xtext.generator.InMemoryFileSystemAccess
import java.io.InputStream
import java.io.IOException
import java.io.BufferedReader
import java.io.InputStreamReader

import static org.junit.jupiter.api.Assertions.assertEquals
import static org.junit.jupiter.api.Assertions.assertTrue

import static extension ag.bpc.mabap.extensions.InMemoryFileSystemAccessExtensions.*


class TestHelper {
	static def assertFileComparesToFixture(InMemoryFileSystemAccess fsa, String filePath, String fixturePath) {
		var inputStream = TestHelper.getResourceAsStream(fixturePath)
		var dataList = new ArrayList<String>
		val content = readFromInputStream(inputStream)
		dataList.add(content);

		assertFileEquals(fsa, filePath, content)
	}

	static def assertFileEquals(InMemoryFileSystemAccess fsa, String filePath, String expectedContent) {
		assertFileExists(fsa, filePath)
		val fileContentsWithoutCR = fsa.getFileInDefaultOutput(filePath).toString.replace("\r", "").trim // remove CR since in memory fsa does not use them
		val expectedContentWithoutCR = expectedContent.replace("\r", "").trim
		assertEquals(expectedContentWithoutCR, fileContentsWithoutCR)
	}

	static def assertFileContains(InMemoryFileSystemAccess fsa, String filePath, String[] expectedContents) {
		assertFileExists(fsa, filePath)
		val fileContents = fsa.getFileInDefaultOutput(filePath).toString.replace("\r", "") // remove CR since in memory fsa does not use them
		expectedContents.forEach [
			assertTrue(
				fileContents.
					contains(it.trim), '''File at path "«filePath»" doesn't contain the expected content "«it»"".''')
		]
	}

	static def assertFileExists(InMemoryFileSystemAccess fsa, String filePath) {
		assertTrue(fsa.hasFileInDefaultOutput(filePath), '''File at path "«filePath»" doesn't exist."''')
	}

	private static def String readFromInputStream(InputStream inputStream) throws IOException {
		var resultStringBuilder = new StringBuilder();
		try (var br = new BufferedReader(new InputStreamReader(inputStream))) {

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
