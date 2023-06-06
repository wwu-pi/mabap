  METHOD create_cpd.
    DATA: lo_cpd TYPE REF TO zcl_gsst_cpd.

    zcl_gsst_cpd=>create_instance(
      EXPORTING
        iv_sstid      = me->av_sst_id   " Schnittstellen-ID (eindeutiger Schlüssel für SST)
        iv_runid      = i_av_runid   " Lauf-ID (eindeutiger Schlüssel)
        iv_objectid   = i_av_objectid   " Object-ID (eindeutiger Schlüssel für OBJECT)
        iv_objecttype = 'DOC'   " Objektart die im SST-Lauf verarbeitet wird
        iv_posid      = i_av_posid   " Positions-ID (eindeutiger Schlüssel)
      IMPORTING
        ro_cpd        = lo_cpd  " CPD
    ).

    lo_cpd->set_anred( is_cpd-anred ).
    lo_cpd->set_name1( is_cpd-name1 ).
    lo_cpd->set_name2( is_cpd-name2 ).
    lo_cpd->set_name3( is_cpd-name3 ).
    lo_cpd->set_name4( is_cpd-name4 ).
    lo_cpd->set_pstlz( is_cpd-pstlz ).
    lo_cpd->set_ort01( is_cpd-ort01 ).
    lo_cpd->set_land1( is_cpd-land1 ).
    lo_cpd->set_stras( is_cpd-stras ).
    lo_cpd->set_pfach( is_cpd-pfach ).
    lo_cpd->set_pstl2( is_cpd-pstl2 ).
    lo_cpd->set_bankn( is_cpd-bankn ).
    lo_cpd->set_bankl( is_cpd-bankl ).
    lo_cpd->set_banks( is_cpd-banks ).
    lo_cpd->set_iban( is_cpd-iban ).
    lo_cpd->set_swift( is_cpd-swift ).
    lo_cpd->set_stkzu( is_cpd-stkzu ).
    lo_cpd->set_stcd1( is_cpd-stcd1 ).
    lo_cpd->set_stcd2( is_cpd-stcd2 ).
    lo_cpd->set_stcd3( is_cpd-stcd3 ).
    lo_cpd->set_stcd4( is_cpd-stcd4 ).

    eo_cpd = lo_cpd.

  ENDMETHOD.