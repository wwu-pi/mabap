package ag.bpc.mabap.generator.gcts

import org.eclipse.xtext.generator.InMemoryFileSystemAccess
import org.junit.jupiter.api.Test
import ag.bpc.mabap.model.Repository
import ag.bpc.mabap.model.MessageClass
import java.time.LocalDateTime
import ag.bpc.mabap.generator.gcts.MessageClassGenerator

import static ag.bpc.mabap.helper.TestHelper.*

class MessageClassGeneratorTest {

	InMemoryFileSystemAccess fsa

	@Test
	def void testSimpleMessageClass() {
		fsa = new InMemoryFileSystemAccess();
		val repository = new Repository()

		var mc = new MessageClass("ZMC_JOH_GSST_ASST_FI", "Nachrichtenklassen fuer die ASST_FI",
			"ZGSST_JOH_ASST_FI", "HOCHSTRAT", LocalDateTime.of(2022, 12, 12, 0, 0))
		mc.addMessage("&1 ist keine Nettobelegart. Skonto nicht moeglich.")
		mc.addMessage("Steuer rechnen nicht moeglich. Beleg &1 enthaelt bereits Steuerzeile.")
		mc.addMessage("Fehler bei Verarbeitung der Datei.")
		mc.addMessage("Feld CF_3 gefuellt, Customizing fuer Anhang-Upload aber unvollstaendig.")
		mc.addMessage("Anlage: Datei &1 in Verzeichnis &2 konnte nicht geoeffnet werden (&3).")
		mc.addMessage("Anlage: Kopieren &1 --> &2 nicht erfolgreich.")
		mc.addMessage("Anlage: Loeschen der Datei &1 nicht erfolgreich.")
		mc.addMessage("Berechnung der Steuerzeile aufgrund anderer Fehler ggf. auch fehlerhaft.")
		mc.addMessage("Berechnung der Skontozeile aufgrund anderer Fehler ggf. auch fehlerhaft.")
		mc.addMessage("Stammsatz fuer Finanzposition &1 nicht vorhanden.")
		
		repository.addMessageClass(mc)
		
		new MessageClassGenerator(fsa, repository).generate()
		
		assertFileComparesToFixture(fsa, "objects/MSAG/ZMC_JOH_GSST_ASST_FI/MSAG ZMC_JOH_GSST_ASST_FI.asx.json",
			"/fixtures/MSAG/ZMC_JOH_GSST_ASST_FI/MSAG ZMC_JOH_GSST_ASST_FI.asx.json")
	}
}
