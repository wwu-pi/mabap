CLASS zcl_joh_gsst_conv_asst_fi DEFINITION
  PUBLIC
  INHERITING FROM zcl_gsst_conv
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

  PROTECTED SECTION.
    METHODS open_file_dialog
      IMPORTING
        !iv_window_title TYPE string
        !iv_file_filter TYPE string
      EXPORTING
        !ev_filename TYPE dirname_al11 .
    METHODS import_data
        REDEFINITION .
    METHODS map_raw_to_object
        REDEFINITION
    .

  PRIVATE SECTION.
    TYPES:
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
    TYPES:
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
    TYPES:
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
    TYPES:
      BEGIN OF lty_st_raw_asst_fi,
        zrow TYPE zgsst_de_raw_row,
        zcol TYPE zgsst_de_raw_col,
        zval TYPE zgsst_de_raw_val,
      END OF lty_st_raw_asst_fi.
    TYPES:
      lty_tt_raw_csv_asst_fi TYPE TABLE OF lty_st_raw_asst_fi WITH DEFAULT KEY.
    TYPES:
      lty_tt_bpos_asst_fi    TYPE TABLE OF lty_st_bpos_asst_fi WITH DEFAULT KEY.
    TYPES:
      BEGIN OF lty_st_beleg_asst_fi,
        imdat   TYPE dats,
        datname TYPE c LENGTH 30,
        bkpf    TYPE lty_st_bkpf_asst_fi,
        bpos    TYPE lty_tt_bpos_asst_fi,
        cpd     TYPE lty_st_cpd_asst_fi,
      END OF lty_st_beleg_asst_fi.
    TYPES:
      lty_tt_beleg_asst_fi TYPE TABLE OF lty_st_beleg_asst_fi WITH DEFAULT KEY.
    TYPES:
      BEGIN OF lty_st_import_csv_asst_fi,
        av_importdate TYPE dats,
        av_user       TYPE uname,
        at_beleg      TYPE lty_tt_beleg_asst_fi,
      END OF lty_st_import_csv_asst_fi.

    DATA:
      av_headline TYPE c .

    METHODS create_cpd
      IMPORTING
        !i_av_runid TYPE zgsst_de_runid
        !i_av_objectid TYPE zgsst_de_objectid
        !i_av_posid TYPE zgsst_de_posid
        !is_cpd TYPE lty_st_cpd_asst_fi
      EXPORTING
        !eo_cpd TYPE REF TO zcl_gsst_cpd
      RAISING
        zcx_gsst_conv .
    METHODS create_pos_customer
      IMPORTING
        !i_as_bpos TYPE lty_st_bpos_asst_fi
        !i_av_runid TYPE zgsst_de_runid
        !i_av_objectid TYPE zgsst_de_objectid
        !i_av_posid TYPE zgsst_de_posid
        !i_as_cpd TYPE zgsst_st_cpd
      EXPORTING
        !eo_pos_customer TYPE REF TO zcl_gsst_pos_customer
      RAISING
        zcx_gsst_conv .
    METHODS create_pos_discount
      IMPORTING
        !i_as_bpos TYPE lty_st_bpos_asst_fi
        !i_av_runid TYPE zgsst_de_runid
        !i_av_posid TYPE zgsst_de_posid
        !i_av_objectid TYPE zgsst_de_objectid
      EXPORTING
        !eo_pos_discount TYPE REF TO zcl_gsst_pos_discount .
    METHODS create_pos_gl
      IMPORTING
        !i_as_bpos TYPE lty_st_bpos_asst_fi
        !i_av_runid TYPE zgsst_de_runid
        !i_av_posid TYPE zgsst_de_posid
        !i_av_objectid TYPE zgsst_de_objectid
      EXPORTING
        !eo_pos_gl TYPE REF TO zcl_gsst_pos_gl .
    METHODS create_pos_tax
      IMPORTING
        !i_as_bpos TYPE lty_st_bpos_asst_fi
        !i_av_runid TYPE zgsst_de_runid
        !i_av_posid TYPE zgsst_de_posid
        !i_av_objectid TYPE zgsst_de_objectid
        !i_av_amtbase TYPE bapiamtbase
        !i_av_bukrs TYPE bukrs
      EXPORTING
        !eo_pos_tax TYPE REF TO zcl_gsst_pos_tax .
    METHODS create_pos_vendor
      IMPORTING
        !i_as_bpos TYPE lty_st_bpos_asst_fi
        !i_av_runid TYPE zgsst_de_runid
        !i_av_posid TYPE zgsst_de_posid
        !i_av_objectid TYPE zgsst_de_objectid
        !i_as_cpd TYPE zgsst_st_cpd
      EXPORTING
        !eo_pos_vendor TYPE REF TO zcl_gsst_pos_vendor
      RAISING
        zcx_gsst_conv .
    METHODS map_import_structure_to_object
      IMPORTING
        !it_import_structure TYPE lty_tt_beleg_asst_fi
      EXPORTING
        !et_objects TYPE zgsst_tt_objects
      RAISING
        zcx_gsst_conv .
    METHODS map_raw_to_import_structure
      EXPORTING
        !et_import_structure TYPE lty_tt_beleg_asst_fi
      RAISING
        zcx_gsst_conv
    .
ENDCLASS.


CLASS zcl_joh_gsst_conv_asst_fi IMPLEMENTATION.
    METHOD create_cpd.
    ENDMETHOD.


    METHOD create_pos_customer.
    ENDMETHOD.


    METHOD create_pos_discount.
    ENDMETHOD.


    METHOD create_pos_gl.
    ENDMETHOD.


    METHOD create_pos_tax.
    ENDMETHOD.


    METHOD create_pos_vendor.
    ENDMETHOD.


    METHOD map_import_structure_to_object.
    ENDMETHOD.


    METHOD map_raw_to_import_structure.
    ENDMETHOD.


    METHOD open_file_dialog.
    ENDMETHOD.


    METHOD import_data.
    ENDMETHOD.


    METHOD map_raw_to_object.
    ENDMETHOD.
ENDCLASS.