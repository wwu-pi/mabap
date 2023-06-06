  METHOD create_pos_discount.
    DATA: lo_pos TYPE REF TO zcl_gsst_pos_discount.

    CALL METHOD zcl_gsst_pos_discount=>create_instance
      EXPORTING
        iv_sstid       = me->av_sst_id
        iv_runid       = i_av_runid
        iv_objectid    = i_av_objectid
        iv_objecttype  = 'DOC'
        iv_posid       = i_av_posid
      IMPORTING
        r_pos_discount = lo_pos.

    lo_pos->set_gsber( i_gsber = i_as_bpos-gsber ).
    lo_pos->set_buzei( i_as_bpos-buzei ).
    lo_pos->set_buzid( i_as_bpos-buzid ).
    lo_pos->set_sgtxt( i_as_bpos-sgtxt ).
    lo_pos->set_shkzg( i_as_bpos-shkzg ).
    lo_pos->set_wrbtr( i_as_bpos-wrbtr ).
    lo_pos->set_wrbtr_org( i_as_bpos-wrbtr ).
    lo_pos->set_zuonr( i_as_bpos-zuonr ).
    lo_pos->set_cf_1( i_cf_1 = i_as_bpos-cf_1 ).
    lo_pos->set_cf_2( i_cf_2 = i_as_bpos-cf_2 ).
    lo_pos->set_cf_3( i_cf_3 = i_as_bpos-cf_3 ).
    lo_pos->set_cf_4( i_cf_4 = i_as_bpos-cf_4 ).
    lo_pos->dset_hkont_blank( iv_hkont = i_as_bpos-hkont ).
    lo_pos->set_valut( i_as_bpos-valut ).

    eo_pos_discount = lo_pos.
  ENDMETHOD.