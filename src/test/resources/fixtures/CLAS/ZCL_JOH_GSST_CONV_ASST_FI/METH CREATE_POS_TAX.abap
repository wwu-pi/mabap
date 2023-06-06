  METHOD create_pos_tax.
    DATA: lo_pos   TYPE REF TO zcl_gsst_pos_tax,
          lv_hkont TYPE hkont,
          lv_ktopl TYPE ktopl,
          lv_ktosl TYPE ktosl.
    zcl_gsst_pos_tax=>create_instance(
      EXPORTING
        iv_sstid      = me->av_sst_id
        iv_runid      = i_av_runid
        iv_objectid   = i_av_objectid
        iv_objecttype = 'DOC'
        iv_posid      = i_av_posid
      IMPORTING
        r_pos_tax     = lo_pos
    ).

    lo_pos->set_gsber( i_gsber = i_as_bpos-gsber ).
    lo_pos->set_buzei( i_as_bpos-buzei ).
    lo_pos->set_mwskz( i_as_bpos-mwskz ).
    lo_pos->set_buzid( i_as_bpos-buzid ).
    lo_pos->set_sgtxt( i_as_bpos-sgtxt ).
    lo_pos->set_shkzg( i_as_bpos-shkzg ).
    lo_pos->set_wrbtr( i_as_bpos-wrbtr ).
    lo_pos->set_wrbtr_org( i_as_bpos-wrbtr ).
    lo_pos->set_zuonr( i_as_bpos-zuonr ).
    lo_pos->set_amt_base( i_av_amtbase ).
    lo_pos->set_cf_1( i_cf_1 = i_as_bpos-cf_1 ).
    lo_pos->set_cf_2( i_cf_2 = i_as_bpos-cf_2 ).
    lo_pos->set_cf_3( i_cf_3 = i_as_bpos-cf_3 ).
    lo_pos->set_cf_4( i_cf_4 = i_as_bpos-cf_4 ).

    "Kontenplan des Buchungskreises auslesen
    SELECT SINGLE ktopl FROM t001 INTO lv_ktopl
      WHERE bukrs EQ i_av_bukrs.
    "Steuerkonto zu Steuerkennzeichen auslesen
    CASE i_as_bpos-shkzg.
      WHEN 'S'.
        SELECT SINGLE konts FROM t030k INTO lv_hkont
          WHERE ktopl EQ lv_ktopl
          AND mwskz EQ i_as_bpos-mwskz.
        "War dies nicht erfolgreich: Vorgang zum Steuerkennzeichen auslesen und entsprechendes Steuerkonto finden
        IF sy-subrc EQ 4.
          SELECT SINGLE ktosl FROM t007k INTO lv_ktosl
        WHERE mwskz EQ i_as_bpos-mwskz.
          SELECT SINGLE konts FROM t030k INTO lv_hkont
            WHERE ktopl EQ lv_ktopl
            AND ktosl EQ lv_ktosl.
        ENDIF.
        "Analoges Vorgehen wie zuvor für Haben Buchung
      WHEN 'H'.
        SELECT SINGLE konth FROM t030k INTO lv_hkont
          WHERE ktopl EQ lv_ktopl
          AND mwskz EQ i_as_bpos-mwskz.
        IF sy-subrc EQ 4.
          SELECT SINGLE ktosl FROM t007k INTO lv_ktosl
        WHERE mwskz EQ i_as_bpos-mwskz.
          SELECT SINGLE konth FROM t030k INTO lv_hkont
            WHERE ktopl EQ lv_ktopl
            AND ktosl EQ lv_ktosl.
        ENDIF.
    ENDCASE.
    "Steuerkonto setzen und Objektreferenz übergeben
    lo_pos->dset_hkont_blank( iv_hkont = lv_hkont ).
    eo_pos_tax = lo_pos.
  ENDMETHOD.