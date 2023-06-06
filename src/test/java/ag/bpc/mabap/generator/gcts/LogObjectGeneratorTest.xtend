package ag.bpc.mabap.generator.gcts

import org.eclipse.xtext.generator.InMemoryFileSystemAccess
import org.junit.jupiter.api.Test
import ag.bpc.mabap.model.Repository
import ag.bpc.mabap.generator.gcts.RepositoryGenerator

import static ag.bpc.mabap.helper.TestHelper.*
import ag.bpc.mabap.model.LogObject

class LogObjectGeneratorTest {
	InMemoryFileSystemAccess fsa

	@Test
	def void testLogObjectGenerator() {
		fsa = new InMemoryFileSystemAccess()
		val repo = new Repository

		// the hashes for BALSUBT in V_BALSUP.index.json have been replaced with hashes from BALSUB
		repo.addLogObject(
			new LogObject("ASST_FIJOH", "Testschnittstelle ASST_FI (angepasst)", "ZGSST",
				"FaFvEuhsVXLyryeKlnxTgA7W/MQ="))
		repo.addLogObject(new LogObject("JOH_TEST", "JOH Testschnittstelle", "ZGSST", "STTa9xLx0tHT0zk259H2x9sJqn4="))

		new RepositoryGenerator(fsa, repo, #[RepositoryGenerator.LOG_OBJECT]).generate

		assertFileComparesToFixture(
			fsa,
			"objects/CDAT/APPL_LOG/V_BALSUB.index.json",
			"/fixtures/log-object/APPL_LOG/V_BALSUB.index.json"
		)
		assertFileComparesToFixture(
			fsa,
			"tabledata/BALSUB.asx.json",
			"/fixtures/log-object/tabledata/BALSUB.asx.json"
		)
		assertFileComparesToFixture(
			fsa,
			"tabledata/BALSUBT.asx.json",
			"/fixtures/log-object/tabledata/BALSUBT.asx.json"
		)
	}
}
