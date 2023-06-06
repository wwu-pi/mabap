  METHOD create_pos_gl.
    DATA: lo_pos    TYPE REF TO zcl_gsst_pos_gl,
          lo_cx_pos TYPE REF TO zcx_gsst_pos.

    zcl_gsst_pos_gl=>create_instance(
      EXPORTING
        iv_sstid      = me->av_sst_id
        iv_runid      = i_av_runid
        iv_objectid   = i_av_objectid
        iv_objecttype = 'DOC'
        iv_posid      = i_av_posid
      IMPORTING
        r_pos_gl      = lo_pos
    ).


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
    lo_pos->dset_res_doc( i_res_doc = i_as_bpos-res_doc ).
    lo_pos->set_res_item( i_res_item = i_as_bpos-res_item ).
    lo_pos->dset_aufnr_blank( i_as_bpos-aufnr ).
    lo_pos->set_geber( i_as_bpos-geber ).
    lo_pos->dset_hkont_blank( i_as_bpos-hkont ).
    lo_pos->dset_kostl_blank( i_as_bpos-kostl ).
    lo_pos->set_mwskz( i_as_bpos-mwskz ).
    lo_pos->dset_pspel_blank( i_as_bpos-pspel ).
    lo_pos->set_valut( i_as_bpos-valut ).
    lo_pos->set_gsber( i_as_bpos-gsber ).
    lo_pos->set_fund_ctr( i_fund_ctr = i_as_bpos-fund_ctr ).

    DATA lv_fipos TYPE fipos.
    CALL FUNCTION 'CONVERSION_EXIT_FMCIS_INPUT'
      EXPORTING
        input         = i_as_bpos-cmmt_item_ext
      IMPORTING
        output        = lv_fipos
      EXCEPTIONS
        error_message = 1.
    IF sy-subrc <> 0.
      me->ao_applog->add_messages( iv_sstid         = lo_pos->get_sstid( )
                                   iv_runid         = lo_pos->get_runid( )
                                   iv_objecttype    = lo_pos->get_objecttype( )
                                   iv_objectid      = lo_pos->get_objectid( )
                                   iv_problem_class = '1'
                                   iv_detaillvl     = '1'
                                   it_bapiret2      = VALUE bapiret2_t( ( id = 'ZMC_GSST_ASST_FI' type = 'E' number = '009' message_v1 = i_as_bpos-cmmt_item_ext ) ) ).
    ENDIF.
    lo_pos->set_cmmt_item( i_cmmt_item = lv_fipos ).
    lo_pos->set_asset_no( i_asset_no = i_as_bpos-asset_no ).
    lo_pos->set_sub_number( i_sub_number = i_as_bpos-sub_number ).
    lo_pos->set_cs_trans_t( i_cs_trans_t = i_as_bpos-cs_trans_t ).
    lo_pos->set_measure( i_measure = i_as_bpos-measure ).
    lo_pos->set_anbwa( i_anbwa = i_as_bpos-anbwa ).

    eo_pos_gl = lo_pos.

  ENDMETHOD.