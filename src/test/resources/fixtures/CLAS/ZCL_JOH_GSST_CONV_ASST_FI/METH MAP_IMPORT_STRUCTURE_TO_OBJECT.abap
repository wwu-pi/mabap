  METHOD map_import_structure_to_object.
    DATA: ls_beleg        TYPE lty_st_beleg_asst_fi,
          ls_bkpf         TYPE zgsst_st_bkpf,
          ls_bpos         TYPE lty_st_bpos_asst_fi,
          ls_cpd          TYPE zgsst_st_cpd,
          lt_bpos         TYPE zgsst_tt_bpos,
          lv_wrbtr        TYPE wrbtr,
          ls_bapiret2     TYPE bapiret2,
          lt_bapiret2     TYPE bapiret2_t,
          lt_bapiret2_all TYPE bapiret2_t.


    DATA: lv_objectid     TYPE zgsst_de_objectid,
          lv_posid        TYPE zgsst_de_posid,
          lv_runid        TYPE zgsst_de_runid,
          lo_run          TYPE REF TO zcl_gsst_run,
          lv_objecttype   TYPE zgsst_de_objecttype,
          lo_inv_inc      TYPE REF TO zcl_gsst_inv_inc,
          lo_inv_out      TYPE REF TO zcl_gsst_inv_out,
          lo_gl_post      TYPE REF TO zcl_gsst_gl_post,
          ls_object       TYPE zgsst_st_object,
          lo_document     TYPE REF TO zcl_gsst_document,
          lo_pos          TYPE REF TO zcl_gsst_pos,
          lo_pos_gl       TYPE REF TO zcl_gsst_pos_gl,
          lo_pos_vendor   TYPE REF TO zcl_gsst_pos_vendor,
          lo_pos_customer TYPE REF TO zcl_gsst_pos_customer,
          lo_pos_tax      TYPE REF TO zcl_gsst_pos_tax,
          lo_pos_discount TYPE REF TO zcl_gsst_pos_discount,
          lo_cpd          TYPE REF TO zcl_gsst_cpd,
          lv_amt_base     TYPE bapiamtbase,
          lv_status       TYPE zgsst_de_status,
          lv_m1           TYPE msgv1,
          lv_koart        TYPE koart,
          lo_pos_2        TYPE REF TO zcl_gsst_pos.

    DATA: lv_filename TYPE localfile.

    DATA: lv_tax_row TYPE xfeld.

    " Custoimzing Tabelle
    DATA: lv_folder_path TYPE zgsst_de_cf3.

    FIELD-SYMBOLS: <fs_bpos> TYPE lty_st_bpos_asst_fi.


    lv_posid = 0.
    lv_objectid = 0.
    IF lv_runid IS INITIAL.
      SELECT MAX( run_id ) FROM zgsst_sst_run
        INTO lv_runid
        WHERE sst_id = me->av_sst_id.
      ADD 1 TO lv_runid.
    ENDIF.

    lv_objecttype = 'DOC'.
    me->new_run(
      EXPORTING
        iv_sst_id     = me->av_sst_id
        iv_run_id     = lv_runid
        iv_objecttype = lv_objecttype
        io_logger     = me->ao_applog
      IMPORTING
        ro_run        = lo_run
    ).

    ls_bapiret2-id = 'ZMC_GSST_RUN'.
    ls_bapiret2-type = 'I'.
    ls_bapiret2-number = '005'.
    ls_bapiret2-message_v1 = sy-uzeit.
    ls_bapiret2-message_v2 = sy-uname.
    APPEND ls_bapiret2 TO lt_bapiret2_all.

    CLEAR: ls_bapiret2,
           lt_bapiret2.


    DATA lt_bapiret2_doc TYPE bapiret2_t.
    LOOP AT it_import_structure INTO ls_beleg.

      ADD '0000000001' TO lv_objectid.


      LOOP AT ls_beleg-bpos INTO ls_bpos WHERE ( kunnr IS NOT INITIAL OR
                                                 lifnr IS NOT INITIAL ).
        CLEAR: lv_koart.
        IF ls_bpos-kunnr IS NOT INITIAL.
          lv_koart = 'D'.
          EXIT.
        ENDIF.
        IF ls_bpos-lifnr IS NOT INITIAL.
          lv_koart = 'K'.
          EXIT.
        ENDIF.
      ENDLOOP.


      IF lv_koart EQ 'D'.
        " Debitorenrechnung oder -Gutschrift
        zcl_gsst_inv_out=>create_instance(
          EXPORTING
            iv_sstid      = me->av_sst_id
            iv_runid      = lv_runid
            iv_objectid   = lv_objectid
            iv_objecttype = lv_objecttype
          IMPORTING
            ro_inv_out    = lo_inv_out
        ).

        lo_document = lo_inv_out.
      ELSEIF lv_koart EQ 'K'.
        " Kreditorenrechnung oder -Gutschrift
        zcl_gsst_inv_inc=>create_instance(
          EXPORTING
            iv_sstid      = me->av_sst_id
            iv_runid      = lv_runid
            iv_objectid   = lv_objectid
            iv_objecttype = lv_objecttype
          IMPORTING
            ro_inv_inc    = lo_inv_inc
        ).

        lo_document = lo_inv_inc.
      ELSE.
        " Sachkontenbuchung
        zcl_gsst_gl_post=>create_instance(
          EXPORTING
            iv_sstid      = me->av_sst_id
            iv_runid      = lv_runid
            iv_objectid   = lv_objectid
            iv_objecttype = lv_objecttype
          IMPORTING
            r_gl_post     = lo_gl_post
        ).

        lo_document = lo_gl_post.
      ENDIF.

      ls_object-objectref = lo_document.
      APPEND ls_object TO et_objects.

      lo_run->add_object( ls_object ).


      " OBJECT DATA
      lo_document->set_av_bktxt( ls_beleg-bkpf-bktxt ).
      lo_document->set_av_blart( ls_beleg-bkpf-blart ).
      lo_document->set_av_bldat( ls_beleg-bkpf-bldat ).
      lo_document->set_av_budat( ls_beleg-bkpf-budat ).
      IF ls_beleg-bkpf-gjahr IS INITIAL.
        ls_beleg-bkpf-gjahr = ls_beleg-bkpf-budat(4).
      ELSE.
        lo_document->set_av_gjahr( ls_beleg-bkpf-gjahr ).
      ENDIF.
      IF ls_beleg-bkpf-periode EQ space.
        lo_document->set_av_monat( ls_beleg-bkpf-budat+4(2) ).
      ELSE.
        lo_document->set_av_monat( ls_beleg-bkpf-periode ).
      ENDIF.
      IF ls_beleg-bkpf-waers IS INITIAL.
        lo_document->set_av_waers( 'EUR' ).
      ELSE.
        lo_document->set_av_waers( ls_beleg-bkpf-waers ).
      ENDIF.
      lo_document->set_av_bukrs( ls_beleg-bkpf-bukrs ).
      lo_document->set_av_xblnr( ls_beleg-bkpf-xblnr ).
      lo_document->set_av_xmwst( to_upper( ls_beleg-bkpf-xmwst ) ).
      lo_document->set_av_xskon( to_upper( ls_beleg-bkpf-xskon ) ).
      lo_document->set_av_trans_date( ls_beleg-bkpf-wwert ).
      lo_document->set_av_cf_1( ls_beleg-bkpf-cf_1 ).
      lo_document->set_av_cf_2( ls_beleg-bkpf-cf_2 ).
      lo_document->set_av_cf_3( ls_beleg-bkpf-cf_3 ).
      lo_document->set_av_cf_4( ls_beleg-bkpf-cf_4 ).

      " SYSTEM DATA
      lo_document->set_av_crdat( sy-datum ).
      lo_document->set_av_crtim( sy-timlo ).
      lo_document->set_av_crusr( sy-uname ).
      lo_document->set_av_dmode( zif_gsst_types=>mode_imported ).
      lo_document->set_av_dstat( zif_gsst_types=>status_pending ).


      " Positionen
      lv_posid = '000'.
      "LOOP AT lr_is_doc->t_pos REFERENCE INTO DATA(ls_bpos).
      LOOP AT ls_beleg-bpos INTO ls_bpos.
        CLEAR: ls_cpd.

        ADD '001' TO lv_posid.

        " CPD-Position
        ls_cpd = ls_beleg-cpd.

        CASE ls_bpos-buzid.
          WHEN 'T'.
            lv_amt_base = 0.
            LOOP AT ls_beleg-bpos ASSIGNING <fs_bpos>.
              IF <fs_bpos>-mwskz EQ ls_bpos-mwskz AND <fs_bpos>-buzid EQ space.
                lv_amt_base = lv_amt_base + <fs_bpos>-wrbtr.
              ENDIF.
            ENDLOOP.
            me->create_pos_tax(
              EXPORTING
                i_as_bpos     = ls_bpos
                i_av_runid    = lv_runid
                i_av_posid    = lv_posid
                i_av_objectid = lv_objectid
                i_av_amtbase  = lv_amt_base
                i_av_bukrs    = ls_beleg-bkpf-bukrs
              IMPORTING
                eo_pos_tax    = lo_pos_tax
            ).
            lo_pos = lo_pos_tax.
            lv_tax_row = 'X'.
          WHEN 'Z'.
            me->create_pos_discount(
              EXPORTING
                i_as_bpos       = ls_bpos
                i_av_runid      = lv_runid
                i_av_posid      = lv_posid
                i_av_objectid   = lv_objectid
              IMPORTING
                eo_pos_discount = lo_pos_discount
            ).



            lo_pos = lo_pos_discount.

            " Belegpositionsobjekte erzeugen
          WHEN OTHERS.
            IF ls_bpos-lifnr IS NOT INITIAL. " Kreditorenzeile inkl. CPD
              me->create_pos_vendor(
                EXPORTING
                  i_as_bpos     = ls_bpos
                  i_as_cpd      = ls_cpd
                  i_av_runid    = lv_runid
                  i_av_objectid = lv_objectid
                  i_av_posid    = lv_posid
                IMPORTING
                  eo_pos_vendor = lo_pos_vendor
              ).
              lo_pos = lo_pos_vendor.
            ELSEIF ls_bpos-kunnr IS NOT INITIAL. " Debitorenzeile inkl. CPD
              me->create_pos_customer(
                EXPORTING
                  i_as_bpos       = ls_bpos
                  i_as_cpd        = ls_cpd
                  i_av_runid      = lv_runid
                  i_av_objectid   = lv_objectid
                  i_av_posid      = lv_posid
                IMPORTING
                  eo_pos_customer = lo_pos_customer
              ).
              lo_pos = lo_pos_customer.
            ELSE. " Sachkontozeile
              me->create_pos_gl(
                EXPORTING
                  i_as_bpos     = ls_bpos
                  i_av_runid    = lv_runid
                  i_av_objectid = lv_objectid
                  i_av_posid    = lv_posid
                IMPORTING
                  eo_pos_gl     = lo_pos_gl
              ).
              lo_pos = lo_pos_gl.
            ENDIF.
        ENDCASE.

        " CUSTOM LOGIC? YES aber kommt häufig vor
        " Bei jeder Position muss in Abhängigkeit des S/H-Kennzeichen der Betrag gesetzt werden
        " Das in der ZGSST angezeigt S/H-Kennzeichen wird wieder aus dem VZ des Betrags abgeleitet
        IF lo_pos->get_shkzg( ) EQ 'H'.
          lv_wrbtr = lo_pos->get_wrbtr( ).
          lv_wrbtr = ( -1 ) * abs( lv_wrbtr ).
          lo_pos->set_wrbtr( i_wrbtr = lv_wrbtr ).
          lo_pos->set_wrbtr_org( i_wrbtr_org = lv_wrbtr ).
        ENDIF.

        lo_document->add_pos( lo_pos ).
      ENDLOOP.

      TRY.
          " Steuer- und Skontozeilen erzeugen.
          IF lo_document->get_av_xmwst( ) EQ abap_true.
            IF lv_tax_row = 'X'.
              ls_bapiret2-id = 'ZMC_GSST_ASST_FI'.
              ls_bapiret2-type = 'W'.
              ls_bapiret2-number = '001'.
              ls_bapiret2-message_v1 = ls_beleg-bkpf-belid.
              APPEND ls_bapiret2 TO lt_bapiret2_doc.
              lo_document->set_av_xmwst( ' ' ).
            ELSE.
              lo_document->calculate_tax( IMPORTING et_return = DATA(lt_tax_return) ).
              IF line_exists( lt_tax_return[ type = 'E' ] ).
                APPEND LINES OF lt_tax_return TO lt_bapiret2_doc.
                ls_bapiret2-id = 'ZMC_GSST_ASST_FI'.
                ls_bapiret2-type = 'W'.
                ls_bapiret2-number = '007'.
                APPEND ls_bapiret2 TO lt_bapiret2_doc.
              ENDIF.

            ENDIF.
          ENDIF.

          CLEAR: lv_tax_row.

          " Muss eine Skontozeile berechnet und hinzugefügt werden?
          IF lo_document->get_av_xskon( ) EQ abap_true AND lo_pos_vendor->get_zterm( ) NE space. " lo_document->get_av_blart( ) EQ 'KN' AND
            " Überprüfung Netto Belegart
            SELECT SINGLE *
              FROM t003
              WHERE blart = @ls_beleg-bkpf-blart "lo_document->get_av_blart( )
               AND  xnetb = 'X'
               INTO @DATA(lv_bl).
            IF sy-subrc = 0.
              lo_document->calculate_discount( IMPORTING es_return = DATA(ls_discount_return) ).
              IF ls_discount_return-type = 'E'.
                APPEND ls_discount_return TO lt_bapiret2_doc.
                ls_bapiret2-id = 'ZMC_GSST_ASST_FI'.
                ls_bapiret2-type = 'W'.
                ls_bapiret2-number = '008'.
                APPEND ls_bapiret2 TO lt_bapiret2_doc.
              ENDIF.
            ELSE.
              ls_bapiret2-id = 'ZMC_GSST_ASST_FI'.
              ls_bapiret2-type = 'E'.
              ls_bapiret2-number = '000'.
              ls_bapiret2-message_v1 = ls_beleg-bkpf-blart.
              APPEND ls_bapiret2 TO lt_bapiret2_doc.
            ENDIF.
          ENDIF.

          me->ao_applog->add_messages(
            EXPORTING
              iv_sstid         = lo_document->get_av_sstid( )
              iv_runid         = lo_document->get_av_runid( )
              iv_objecttype    = lo_document->get_av_objecttype( )
              iv_problem_class = '1'
              iv_detaillvl     = '1'
              it_bapiret2      = lt_bapiret2_doc
              iv_objectid      = lo_document->get_av_objectid( )
          ).
          CLEAR lt_bapiret2_doc.

        CATCH cx_root.
          ls_bapiret2-id = 'ZMC_GSST_ASST_FI'.
          ls_bapiret2-type = 'E'.
          ls_bapiret2-number = '002'.
          MESSAGE e002(zmc_gsst_asst_fi) DISPLAY LIKE 'E'.
          APPEND ls_bapiret2 TO lt_bapiret2_all.
          EXIT.
      ENDTRY.

      LOOP AT lo_document->get_at_pos( ) ASSIGNING FIELD-SYMBOL(<fo_t>).
        TRY.
            lo_pos_2 ?= <fo_t>.
            lo_pos_2->set_exch_rate( ls_beleg-bkpf-kursf ).
          CATCH cx_root.

        ENDTRY.

      ENDLOOP.

      " JOH Upload Anhang entfernt


    ENDLOOP.

    lo_run->update_counter( ).

    me->ao_applog->add_messages(
      EXPORTING
        iv_sstid         = me->av_sst_id
        iv_runid         = lv_runid
        iv_objecttype    = lv_objecttype
        iv_problem_class = '1'
        iv_detaillvl     = '1'
        it_bapiret2      = lt_bapiret2_all
    ).
  ENDMETHOD.