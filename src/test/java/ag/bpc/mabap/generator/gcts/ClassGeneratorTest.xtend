package ag.bpc.mabap.generator.gcts

import ag.bpc.mabap.model.Repository
import java.time.LocalDateTime
import org.eclipse.xtext.generator.InMemoryFileSystemAccess
import org.junit.jupiter.api.Test

import static org.junit.jupiter.api.Assertions.assertEquals;
import static ag.bpc.mabap.helper.TestHelper.*
import ag.bpc.mabap.model.Class
import ag.bpc.mabap.model.Attribute
import ag.bpc.mabap.model.DataType
import ag.bpc.mabap.model.Visibility
import ag.bpc.mabap.model.Method

class ClassGeneratorTest {

	InMemoryFileSystemAccess fsa

	@Test
	def void testSimpleClass() {
		fsa = new InMemoryFileSystemAccess();
		val repository = new Repository()

		// create class
		val clas = new Class("ZCL_GSST_JOH_TEST", "FV0BZxQe3ZmAqjQ4LYD7", "ZGSST_JOH_GCTS", "ZCL_GSST_CONV", "HOCHSTRAT",
			"Test GSST Class", "001", LocalDateTime.of(2022, 11, 14, 0, 0, 0))
		clas.addMethod(new Method("import_data", Visibility.PROTECTED, true, '''
		METHOD import_data.
		ENDMETHOD.'''))
		clas.addMethod(new Method("map_raw_to_object", Visibility.PROTECTED, true, ""))

		repository.addClas(clas)

		// generate files
		new ClassGenerator(fsa, repository).generate()

		// load fixture
		assertFileComparesToFixture(fsa, "objects/CLAS/ZCL_GSST_JOH_TEST/CINC ZCL_GSST_JOH_TEST=============CCAU.abap",
			"/fixtures/CLAS/ZCL_GSST_JOH_TEST/CINC ZCL_GSST_JOH_TEST=============CCAU.abap")
		assertFileComparesToFixture(fsa, "objects/CLAS/ZCL_GSST_JOH_TEST/CINC ZCL_GSST_JOH_TEST=============CCDEF.abap",
			"/fixtures/CLAS/ZCL_GSST_JOH_TEST/CINC ZCL_GSST_JOH_TEST=============CCDEF.abap")
		assertFileComparesToFixture(fsa, "objects/CLAS/ZCL_GSST_JOH_TEST/CINC ZCL_GSST_JOH_TEST=============CCIMP.abap",
			"/fixtures/CLAS/ZCL_GSST_JOH_TEST/CINC ZCL_GSST_JOH_TEST=============CCIMP.abap")
		assertFileComparesToFixture(fsa, "objects/CLAS/ZCL_GSST_JOH_TEST/CINC ZCL_GSST_JOH_TEST=============CCMAC.abap",
			"/fixtures/CLAS/ZCL_GSST_JOH_TEST/CINC ZCL_GSST_JOH_TEST=============CCMAC.abap")
		assertFileComparesToFixture(fsa, "objects/CLAS/ZCL_GSST_JOH_TEST/CLSD ZCL_GSST_JOH_TEST.abap",
			"/fixtures/CLAS/ZCL_GSST_JOH_TEST/CLSD ZCL_GSST_JOH_TEST.abap")
		assertFileComparesToFixture(fsa, "objects/CLAS/ZCL_GSST_JOH_TEST/CPRI ZCL_GSST_JOH_TEST.abap",
			"/fixtures/CLAS/ZCL_GSST_JOH_TEST/CPRI ZCL_GSST_JOH_TEST.abap")
		assertFileComparesToFixture(fsa, "objects/CLAS/ZCL_GSST_JOH_TEST/CPRO ZCL_GSST_JOH_TEST.abap",
			"/fixtures/CLAS/ZCL_GSST_JOH_TEST/CPRO ZCL_GSST_JOH_TEST.abap")
		assertFileComparesToFixture(fsa, "objects/CLAS/ZCL_GSST_JOH_TEST/CPUB ZCL_GSST_JOH_TEST.abap",
			"/fixtures/CLAS/ZCL_GSST_JOH_TEST/CPUB ZCL_GSST_JOH_TEST.abap")
		assertFileComparesToFixture(fsa, "objects/CLAS/ZCL_GSST_JOH_TEST/METH IMPORT_DATA.abap",
			"/fixtures/CLAS/ZCL_GSST_JOH_TEST/METH IMPORT_DATA.abap")
		assertFileComparesToFixture(fsa, "objects/CLAS/ZCL_GSST_JOH_TEST/METH MAP_RAW_TO_OBJECT.abap",
			"/fixtures/CLAS/ZCL_GSST_JOH_TEST/METH MAP_RAW_TO_OBJECT.abap")
		assertFileComparesToFixture(fsa, "objects/CLAS/ZCL_GSST_JOH_TEST/REPS ZCL_GSST_JOH_TEST=============CT.abap",
			"/fixtures/CLAS/ZCL_GSST_JOH_TEST/REPS ZCL_GSST_JOH_TEST=============CT.abap")
		assertFileComparesToFixture(fsa, "objects/CLAS/ZCL_GSST_JOH_TEST/CLAS ZCL_GSST_JOH_TEST.asx.json",
			"/fixtures/CLAS/ZCL_GSST_JOH_TEST/CLAS ZCL_GSST_JOH_TEST.asx.json")

	}

	@Test
	def void testComplexClass() {
		fsa = new InMemoryFileSystemAccess();
		val repository = new Repository()

		// create class
		val clas = new Class("ZCL_JOH_GSST_CONV_ASST_FI", "FV0BZxQe3Z7APl6Zp8D7", "ZGSST_JOH_ASST_FI", "ZCL_GSST_CONV",
			"HOCHSTRAT", "Testklasse fuer FI Objekt Schnittstellen in GCTS", "001",
			LocalDateTime.of(2022, 12, 12, 0, 0, 0))

		// data-types
		clas.addLocalDataType(new DataType("lty_st_bkpf_asst_fi", '''
			BEGIN OF lty_st_bkpf_asst_fi,
			  mandt   TYPE mandt,
			  bukrs   TYPE bukrs,
			  belid   TYPE docnr,
			  blart   TYPE blart,
			  bldat   TYPE bldat,
			  budat   TYPE budat,
			  xblnr   TYPE xblnr,
			  bktxt   TYPE bktxt,
			  waers   TYPE waers,
			  xmwst   TYPE zgsst_de_xmwst,
			  xskon   TYPE zgsst_de_xskon,
			  periode TYPE monat,
			  gjahr   TYPE gjahr,
			  cf_1    TYPE zgsst_de_cf1,
			  cf_2    TYPE zgsst_de_cf2,
			  cf_3    TYPE zgsst_de_cf3,
			  cf_4    TYPE zgsst_de_cf4,
			  wwert   TYPE wwert_d,
			  kursf   TYPE kursf,
			END OF lty_st_bkpf_asst_fi.
		'''))
		clas.addLocalDataType(new DataType("lty_st_bpos_asst_fi", '''
			BEGIN OF lty_st_bpos_asst_fi,
			  buzei         TYPE buzei,
			  buzid         TYPE buzid,
			  shkzg         TYPE shkzg,
			  wrbtr         TYPE wrbtr,
			  mwskz         TYPE mwskz,
			  zuonr         TYPE dzuonr,
			  sgtxt         TYPE sgtxt,
			  kostl         TYPE kostl,
			  aufnr         TYPE aufnr,
			  pspel         TYPE ps_posid,
			  geber         TYPE bp_geber,
			  hkont         TYPE hkont,
			  kunnr         TYPE kunnr,
			  lifnr         TYPE lifnr,
			  valut         TYPE valut,
			  zfbdt         TYPE dzfbdt,
			  zterm         TYPE dzterm,
			  zlsch         TYPE dzlsch,
			  zlspr         TYPE dzlspr,
			  bvtyp         TYPE bvtyp,
			  mansp         TYPE mansp,
			  fund_ctr      TYPE fistl,
			  cmmt_item_ext TYPE fm_fipex,
			  asset_no      TYPE anln1,
			  sub_number    TYPE anln2,
			  anbwa         TYPE anbwa,
			  cs_trans_t    TYPE rmvct,
			  measure       TYPE fm_measure,
			  cf_1          TYPE zgsst_de_cf1,
			  cf_2          TYPE zgsst_de_cf2,
			  cf_3          TYPE zgsst_de_cf3,
			  cf_4          TYPE zgsst_de_cf4,
			  umskz         TYPE umskz,
			  gsber         TYPE gsber,
			  res_doc       TYPE kblnr,
			  res_item      TYPE kblpos,
			END OF lty_st_bpos_asst_fi.
		'''))
		clas.addLocalDataType(new DataType("lty_st_cpd_asst_fi", '''
			BEGIN OF lty_st_cpd_asst_fi,
			  anred TYPE anred,
			  name1 TYPE name1,
			  name2 TYPE name2,
			  name3 TYPE name2,
			  name4 TYPE name4,
			  pstlz TYPE pstlz,
			  ort01 TYPE ort01,
			  land1 TYPE land1,
			  stras TYPE stras,
			  pfach TYPE pfach,
			  pstl2 TYPE pstl2,
			  bankn TYPE bankn,
			  bankl TYPE bankl,
			  banks TYPE banks,
			  iban  TYPE iban,
			  swift TYPE swift,
			  stkzu TYPE stkzu,
			  stcd1 TYPE stcd1,
			  stcd2 TYPE stcd2,
			  stcd3 TYPE stcd3,
			  stcd4 TYPE stcd4,
			END OF lty_st_cpd_asst_fi.
		'''))
		clas.addLocalDataType(new DataType("lty_st_raw_asst_fi", '''
			BEGIN OF lty_st_raw_asst_fi,
			  zrow TYPE zgsst_de_raw_row,
			  zcol TYPE zgsst_de_raw_col,
			  zval TYPE zgsst_de_raw_val,
			END OF lty_st_raw_asst_fi.
		'''))
		clas.addLocalDataType(new DataType("lty_tt_raw_csv_asst_fi", '''
			lty_tt_raw_csv_asst_fi TYPE TABLE OF lty_st_raw_asst_fi WITH DEFAULT KEY.
		'''))
		clas.addLocalDataType(new DataType("lty_tt_bpos_asst_fi", '''
			lty_tt_bpos_asst_fi    TYPE TABLE OF lty_st_bpos_asst_fi WITH DEFAULT KEY.
		'''))
		clas.addLocalDataType(new DataType("lty_st_beleg_asst_fi", '''
			BEGIN OF lty_st_beleg_asst_fi,
			  imdat   TYPE dats,
			  datname TYPE c LENGTH 30,
			  bkpf    TYPE lty_st_bkpf_asst_fi,
			  bpos    TYPE lty_tt_bpos_asst_fi,
			  cpd     TYPE lty_st_cpd_asst_fi,
			END OF lty_st_beleg_asst_fi.
		'''))
		clas.addLocalDataType(new DataType("lty_tt_beleg_asst_fi", '''
			lty_tt_beleg_asst_fi TYPE TABLE OF lty_st_beleg_asst_fi WITH DEFAULT KEY.
		'''))
		clas.addLocalDataType(new DataType("lty_st_import_csv_asst_fi", '''
			BEGIN OF lty_st_import_csv_asst_fi,
			  av_importdate TYPE dats,
			  av_user       TYPE uname,
			  at_beleg      TYPE lty_tt_beleg_asst_fi,
			END OF lty_st_import_csv_asst_fi.
		'''))

		// attributes
		clas.addClasAttribute(new Attribute("av_headline", "av_headline TYPE c ."))

		// methods
		var create_cpd = new Method("create_cpd", Visibility.PRIVATE)
		create_cpd.addImportFromParams("i_av_runid", "zgsst_de_runid")
		create_cpd.addImportFromParams("i_av_objectid", "zgsst_de_objectid")
		create_cpd.addImportFromParams("i_av_posid", "zgsst_de_posid")
		create_cpd.addImportFromParams("is_cpd", "lty_st_cpd_asst_fi")
		create_cpd.addExportFromParams("eo_cpd", "zcl_gsst_cpd", true)
		create_cpd.addRaise("zcx_gsst_conv")
		clas.addMethod(create_cpd)

		var create_pos_customer = new Method("create_pos_customer", Visibility.PRIVATE)
		create_pos_customer.addImportFromParams("i_as_bpos", "lty_st_bpos_asst_fi")
		create_pos_customer.addImportFromParams("i_av_runid", "zgsst_de_runid")
		create_pos_customer.addImportFromParams("i_av_objectid", "zgsst_de_objectid")
		create_pos_customer.addImportFromParams("i_av_posid", "zgsst_de_posid")
		create_pos_customer.addImportFromParams("i_as_cpd", "zgsst_st_cpd")
		create_pos_customer.addExportFromParams("eo_pos_customer", "zcl_gsst_pos_customer", true)
		create_pos_customer.addRaise("zcx_gsst_conv")
		clas.addMethod(create_pos_customer)

		var create_pos_discount = new Method("create_pos_discount", Visibility.PRIVATE)
		create_pos_discount.addImportFromParams("i_as_bpos", "lty_st_bpos_asst_fi")
		create_pos_discount.addImportFromParams("i_av_runid", "zgsst_de_runid")
		create_pos_discount.addImportFromParams("i_av_posid", "zgsst_de_posid")
		create_pos_discount.addImportFromParams("i_av_objectid", "zgsst_de_objectid")
		create_pos_discount.addExportFromParams("eo_pos_discount", "zcl_gsst_pos_discount", true)
		clas.addMethod(create_pos_discount)

		var create_pos_gl = new Method("create_pos_gl", Visibility.PRIVATE)
		create_pos_gl.addImportFromParams("i_as_bpos", "lty_st_bpos_asst_fi")
		create_pos_gl.addImportFromParams("i_av_runid", "zgsst_de_runid")
		create_pos_gl.addImportFromParams("i_av_posid", "zgsst_de_posid")
		create_pos_gl.addImportFromParams("i_av_objectid", "zgsst_de_objectid")
		create_pos_gl.addExportFromParams("eo_pos_gl", "zcl_gsst_pos_gl", true)
		clas.addMethod(create_pos_gl)

		var create_pos_tax = new Method("create_pos_tax", Visibility.PRIVATE)
		create_pos_tax.addImportFromParams("i_as_bpos", "lty_st_bpos_asst_fi")
		create_pos_tax.addImportFromParams("i_av_runid", "zgsst_de_runid")
		create_pos_tax.addImportFromParams("i_av_posid", "zgsst_de_posid")
		create_pos_tax.addImportFromParams("i_av_objectid", "zgsst_de_objectid")
		create_pos_tax.addImportFromParams("i_av_amtbase", "bapiamtbase")
		create_pos_tax.addImportFromParams("i_av_bukrs", "bukrs")
		create_pos_tax.addExportFromParams("eo_pos_tax", "zcl_gsst_pos_tax", true)
		clas.addMethod(create_pos_tax)

		var create_pos_vendor = new Method("create_pos_vendor", Visibility.PRIVATE)
		create_pos_vendor.addImportFromParams("i_as_bpos", "lty_st_bpos_asst_fi")
		create_pos_vendor.addImportFromParams("i_av_runid", "zgsst_de_runid")
		create_pos_vendor.addImportFromParams("i_av_posid", "zgsst_de_posid")
		create_pos_vendor.addImportFromParams("i_av_objectid", "zgsst_de_objectid")
		create_pos_vendor.addImportFromParams("i_as_cpd", "zgsst_st_cpd")
		create_pos_vendor.addExportFromParams("eo_pos_vendor", "zcl_gsst_pos_vendor", true)
		create_pos_vendor.addRaise("zcx_gsst_conv")
		clas.addMethod(create_pos_vendor)

		var map_import_structure_to_object = new Method("map_import_structure_to_object", Visibility.PRIVATE)
		map_import_structure_to_object.addImportFromParams("it_import_structure", "lty_tt_beleg_asst_fi")
		map_import_structure_to_object.addExportFromParams("et_objects", "zgsst_tt_objects")
		map_import_structure_to_object.addRaise("zcx_gsst_conv")
		clas.addMethod(map_import_structure_to_object)

		var map_raw_to_import_structure = new Method("map_raw_to_import_structure", Visibility.PRIVATE)
		map_raw_to_import_structure.addExportFromParams("et_import_structure", "lty_tt_beleg_asst_fi")
		map_raw_to_import_structure.addRaise("zcx_gsst_conv")
		clas.addMethod(map_raw_to_import_structure)

		var open_file_dialog = new Method("open_file_dialog", Visibility.PROTECTED)
		open_file_dialog.addImportFromParams("iv_window_title", "string")
		open_file_dialog.addImportFromParams("iv_file_filter", "string")
		open_file_dialog.addExportFromParams("ev_filename", "dirname_al11")
		clas.addMethod(open_file_dialog)

		clas.addMethod(new Method("import_data", Visibility.PROTECTED, true, ''''''))

		clas.addMethod(new Method("map_raw_to_object", Visibility.PROTECTED, true, ""))

		repository.addClas(clas)

		// generate files
		new ClassGenerator(fsa, repository).generate()

		assertFileComparesToFixture(fsa, "objects/CLAS/ZCL_JOH_GSST_CONV_ASST_FI/CPRO ZCL_JOH_GSST_CONV_ASST_FI.abap",
			"/fixtures/CLAS/ZCL_JOH_GSST_CONV_ASST_FI/CPRO ZCL_JOH_GSST_CONV_ASST_FI.abap")
		assertFileComparesToFixture(fsa, "objects/CLAS/ZCL_JOH_GSST_CONV_ASST_FI/CPRI ZCL_JOH_GSST_CONV_ASST_FI.abap",
			"/fixtures/CLAS/ZCL_JOH_GSST_CONV_ASST_FI/CPRI ZCL_JOH_GSST_CONV_ASST_FI.abap")
		// TODO: Fix generation of datatype metadata
		assertFileComparesToFixture(fsa,
			"objects/CLAS/ZCL_JOH_GSST_CONV_ASST_FI/CLAS ZCL_JOH_GSST_CONV_ASST_FI.asx.json",
			"/fixtures/CLAS/ZCL_JOH_GSST_CONV_ASST_FI/CLAS ZCL_JOH_GSST_CONV_ASST_FI-without-datatypes.asx.json")

		assertEquals(21, fsa.allFiles.size())
	}
}
