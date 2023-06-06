  METHOD create_pos_vendor.
    DATA: lo_pos   TYPE REF TO zcl_gsst_pos_vendor,
          lo_cpd   TYPE REF TO zcl_gsst_cpd,
          ls_cpd   TYPE bapiacpa09,
          lv_m1    TYPE msgv1,

          lv_zterm TYPE dzterm.
    TRY.
        zcl_gsst_pos_vendor=>create_instance(
          EXPORTING
            iv_sstid      = me->av_sst_id
            iv_runid      = i_av_runid
            iv_objectid   = i_av_objectid
            iv_objecttype = 'DOC'
            iv_posid      = i_av_posid
          IMPORTING
            r_pos_vendor  = lo_pos
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
        lo_pos->set_gsber( i_gsber = i_as_bpos-gsber ).
        lo_pos->set_bvtyp( i_as_bpos-bvtyp ).
        lo_pos->dset_lifnr_blank( i_as_bpos-lifnr ).
        lo_pos->set_zfbdt( i_as_bpos-zfbdt ).
        lo_pos->set_zlsch( i_as_bpos-zlsch ).
        lo_pos->set_zlspr( i_as_bpos-zlspr ).

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = i_as_bpos-zterm
          IMPORTING
            output = lv_zterm.

        lo_pos->set_zterm( lv_zterm ).


        IF i_as_cpd IS NOT INITIAL.
          me->create_cpd(
            EXPORTING
              is_cpd        = i_as_cpd
              i_av_runid    = i_av_runid
              i_av_objectid = i_av_objectid
              i_av_posid    = '1'
            IMPORTING
              eo_cpd        = lo_cpd  " CPD
          ).
          lo_cpd->map_to_bapi(
            IMPORTING
              es_customer_cpd = ls_cpd
          ).
          lo_pos->set_as_cpd( i_as_cpd = ls_cpd ).

        ENDIF.
        eo_pos_vendor = lo_pos.
      CATCH zcx_gsst_conv.
        lv_m1 = i_av_objectid.
        RAISE EXCEPTION TYPE zcx_gsst_conv
          EXPORTING
            textid       = zcx_gsst_conv=>cpd_error
            av_status_v1 = lv_m1.
    ENDTRY.
  ENDMETHOD.