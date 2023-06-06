package ag.bpc.mabap.generator.gcts

import org.eclipse.xtext.generator.InMemoryFileSystemAccess
import org.junit.jupiter.api.Test
import ag.bpc.mabap.model.Repository
import ag.bpc.mabap.generator.gcts.PackageGenerator
import java.time.LocalDateTime

import static ag.bpc.mabap.helper.TestHelper.*
import ag.bpc.mabap.model.Package

class PackageGeneratorTest {

	InMemoryFileSystemAccess fsa

	@Test
	def void testGenerator() {

		fsa = new InMemoryFileSystemAccess();
		val repository = new Repository()
		val pkg = new Package("ZGSST_JOH_GCTS", "ZGSST_SST", "HOCHSTRAT", "Testpaket fuer gCTS",
			Package.DEFAULT_SOFTWARE_COMPONENT, Package.DEFAULT_NAMESPACE, Package.DEFAULT_TRANSPORT_LAYER,
			LocalDateTime.of(2022, 11, 14, 0, 0, 0))

		repository.addPackage(pkg)

		new PackageGenerator(fsa, repository).generate

		assertFileComparesToFixture(fsa, "objects/DEVC/ZGSST_JOH_GCTS/DEVC ZGSST_JOH_GCTS.asx.json",
			"/fixtures/simple-package/DEVC ZGSST_JOH_GCTS.asx.json"
		)
	}

}
