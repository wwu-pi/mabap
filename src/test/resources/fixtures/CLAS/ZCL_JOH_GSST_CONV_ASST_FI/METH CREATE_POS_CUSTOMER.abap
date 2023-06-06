  METHOD create_pos_customer.
    DATA: lo_pos TYPE REF TO zcl_gsst_pos_customer,
          lo_cpd TYPE REF TO zcl_gsst_cpd,
          ls_cpd TYPE bapiacpa09,
          lv_m1  TYPE msgv1.
    TRY.
        zcl_gsst_pos_customer=>create_instance(
          EXPORTING
            iv_sstid       = me->av_sst_id
            iv_runid       = i_av_runid
            iv_objectid    = i_av_objectid
            iv_objecttype  = 'DOC'
            iv_posid       = i_av_posid
          IMPORTING
            r_pos_customer = lo_pos
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
        lo_pos->dset_kunnr_blank( i_as_bpos-kunnr ).
        lo_pos->set_mansp( i_as_bpos-mansp ).
        lo_pos->set_zfbdt( i_as_bpos-zfbdt ).
        lo_pos->set_zlsch( i_as_bpos-zlsch ).
        lo_pos->set_zlspr( i_as_bpos-zlspr ).
        lo_pos->set_zterm( i_as_bpos-zterm ).

        IF i_as_cpd IS NOT INITIAL.
          me->create_cpd(
            EXPORTING
              is_cpd        = i_as_cpd
              i_av_runid    = i_av_runid
              i_av_objectid = i_av_objectid
              i_av_posid    = '1'
            IMPORTING
              eo_cpd        = lo_cpd
          ).

          lo_cpd->map_to_bapi(
            IMPORTING
              es_customer_cpd = ls_cpd
          ).
          lo_pos->set_as_cpd( i_as_cpd = ls_cpd ).

        ENDIF.
        eo_pos_customer = lo_pos.
      CATCH zcx_gsst_conv.
        lv_m1 = i_av_objectid.
        RAISE EXCEPTION TYPE zcx_gsst_conv
          EXPORTING
            textid       = zcx_gsst_conv=>cpd_error
            av_status_v1 = lv_m1.
    ENDTRY.
  ENDMETHOD.