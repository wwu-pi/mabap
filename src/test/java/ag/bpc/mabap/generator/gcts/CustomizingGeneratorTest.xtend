package ag.bpc.mabap.generator.gcts

import org.eclipse.xtext.generator.InMemoryFileSystemAccess
import org.junit.jupiter.api.Test
import ag.bpc.mabap.model.Repository
import ag.bpc.mabap.model.Customizing
import ag.bpc.mabap.generator.gcts.RepositoryGenerator

import static ag.bpc.mabap.helper.TestHelper.*
import com.google.common.collect.ImmutableList
import com.google.common.collect.ImmutableMap

class CustomizingGeneratorTest {
	
	final ImmutableMap<String, String> ZGSST_CUST_SST_VALUES = ImmutableMap.<String, String>builder()
			.put("MANDT", "").put("SST_ID", "").put("CLASS", "").put("SST_NAME", "").put("STRUCTUR", "").put("PARK", "")
			.put("CHECK_AUTH", "").put("GOS_FLG", "").put("NKO", "").put("NR_RANGE_NR", "").put("SUBS_TEST", "")
			.put("SUBS_POST", "").put("EXPORT", "").put("BATCH_FLG", "").put("POST_MAN_FORB", "")
			.put("SEPERATION_OF_FUNCTIONS", "").build();

	final ImmutableList<String> ZGSST_CUST_SST_KEYS = ImmutableList.<String>builder().add("MANDT")
			.add("SST_ID").build();

	InMemoryFileSystemAccess fsa

	@Test
	def void testSimpleCustomizings() {
		fsa = new InMemoryFileSystemAccess();
		val repository = new Repository()

		// create customizings
		var cust1 = new Customizing("ZGSST_CUST_SST", "i7/vUO+UJ6oY+kyQN3IZLZZOkgI=", "501",
			ZGSST_CUST_SST_VALUES, ZGSST_CUST_SST_KEYS)
		cust1.values.put("MANDT", "501")
		cust1.values.put("SST_ID", "JOH_TEST")
		cust1.values.put("CLASS", "ZGSST_FI_REFERENCE")
		cust1.values.put("SST_NAME", "Testschnittstelle FI")

		var cust2 = new Customizing("ZGSST_CUST_SST", "sYDKuq0hMQflPNPXICjF4tmWcIs=", "501",
			ZGSST_CUST_SST_VALUES, ZGSST_CUST_SST_KEYS)
		cust2.values.put("MANDT", "501")
		cust2.values.put("SST_ID", "JOH_TEST_T")
		cust2.values.put("CLASS", "ANTOTHER_FI_REFERENCE")
		cust2.values.put("SST_NAME", "FI Testschnittstelle")

		repository.addCustomizing(cust1)
		repository.addCustomizing(cust2)

		new RepositoryGenerator(fsa, repository, #[RepositoryGenerator.CUSTOMIZING]).generate

		assertFileComparesToFixture(fsa, "objects/TABU/ZGSST_CUST_SST.index.json",
			"/fixtures/simple-cust/objects/TABU/ZGSST_CUST_SST/ZGSST_CUST_SST.index.json")
		assertFileComparesToFixture(fsa, "tabledata/ZGSST_CUST_SST.asx.json",
			"/fixtures/simple-cust/tabledata/ZGSST_CUST_SST.asx.json")
	}
}
