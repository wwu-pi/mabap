  METHOD map_raw_to_import_structure.
    TYPES: BEGIN OF lty_tab,
             row   TYPE n LENGTH 5,
             col   TYPE n LENGTH 3,
             value TYPE c LENGTH 50,
           END OF lty_tab.

    DATA: ls_raw   TYPE string,
          ls_beleg TYPE lty_st_beleg_asst_fi,
          lt_beleg TYPE lty_tt_beleg_asst_fi,
          ls_bkpf  TYPE lty_st_bkpf_asst_fi,
          ls_bpos  TYPE lty_st_bpos_asst_fi,
          lt_bpos  TYPE lty_tt_bpos_asst_fi,
          ls_cpd   TYPE lty_st_cpd_asst_fi,
          lx_error TYPE REF TO cx_sy_conversion_no_number,
          lx_root  TYPE REF TO cx_root.

    DATA: lv_row       TYPE zgsst_de_raw_row,
          lv_row_old   TYPE zgsst_de_raw_row,
          lv_belid_old TYPE lty_st_bkpf_asst_fi-belid,
          lv_col       TYPE zgsst_de_raw_col,
          lv_col_old   TYPE zgsst_de_raw_col,
          lv_val       TYPE zgsst_de_raw_val,
          lv_length    TYPE i,
          lv_linetype  TYPE c LENGTH 50,
          lt_tab_imp   TYPE TABLE OF lty_tab,
          ls_tab_imp   TYPE lty_tab.

    DATA: lv_m1 TYPE msgv1,
          lv_m2 TYPE msgv2,
          lv_m3 TYPE msgv3.

    lv_row = 1.
    lv_col = 1.

    LOOP AT me->at_raw INTO ls_raw.
      CLEAR ls_tab_imp.
      WHILE ls_raw IS NOT INITIAL.
        IF ls_raw+0(1) EQ '"'.
          SPLIT ls_raw AT '";' INTO ls_tab_imp-value ls_raw.
          SHIFT ls_tab_imp-value LEFT BY 1 PLACES.
          IF ls_raw IS INITIAL.
            lv_length = numofchar( ls_tab_imp-value ) - 1.
            IF lv_length GT 0
              AND ls_tab_imp-value+lv_length(1) EQ '"'.
              ls_tab_imp-value = ls_tab_imp-value+0(lv_length).
            ELSEIF lv_length EQ 0
              AND ls_tab_imp-value EQ '"'.
              CLEAR ls_tab_imp-value.
            ENDIF.
          ENDIF.
        ELSE.
          SPLIT ls_raw AT ';' INTO ls_tab_imp-value ls_raw.
        ENDIF.
        ls_tab_imp-row = lv_row.
        ls_tab_imp-col = lv_col.
        IF me->av_headline EQ 1 AND lv_row EQ 1.
          CLEAR ls_tab_imp.
        ELSEIF ls_tab_imp-value IS NOT INITIAL.
          APPEND ls_tab_imp TO lt_tab_imp.
        ENDIF.
        lv_col = lv_col + 1.

      ENDWHILE.
      lv_col = 1.
      lv_row = lv_row + 1.

    ENDLOOP.


    LOOP AT lt_tab_imp INTO ls_tab_imp.
      TRY.
          IF ls_tab_imp-row NE lv_row_old AND lv_row_old IS NOT INITIAL.
            APPEND ls_bpos TO lt_bpos.
            CLEAR: ls_bpos.
          ENDIF.
          lv_row_old = ls_tab_imp-row.


          CASE ls_tab_imp-col.
            WHEN '001'. "BELID
              IF lv_belid_old IS INITIAL.
                lv_belid_old = ls_tab_imp-value.
                ls_bkpf-belid = ls_tab_imp-value.
              ELSE.
                IF lv_belid_old NE ls_tab_imp-value AND ls_tab_imp-value IS NOT INITIAL.
                  lv_belid_old = ls_tab_imp-value.
                  ls_beleg-bkpf = ls_bkpf.
                  ls_beleg-bpos = lt_bpos.
                  IF ls_cpd IS NOT INITIAL.
                    ls_beleg-cpd = ls_cpd.
                  ENDIF.
                  APPEND ls_beleg TO lt_beleg.
                  CLEAR: ls_bkpf, lt_bpos, ls_bpos, ls_cpd, ls_beleg.
                  ls_bkpf-belid = ls_tab_imp-value.

                ENDIF.

              ENDIF.

            WHEN '002'. "BUKRS
              IF ls_bkpf-bukrs IS INITIAL.
                ls_bkpf-bukrs = ls_tab_imp-value.
              ENDIF.
            WHEN '003'. "BLART
              IF ls_bkpf-blart IS INITIAL.
                ls_bkpf-blart = ls_tab_imp-value.
              ENDIF.
            WHEN '004'. "BLDAT
              IF ls_bkpf-bldat IS INITIAL.
                ls_bkpf-bldat = ls_tab_imp-value.
              ENDIF.
            WHEN '005'. "BUDAT
              IF ls_bkpf-budat IS INITIAL.
                ls_bkpf-budat = ls_tab_imp-value.
              ENDIF.
            WHEN '006'. "XBLNR
              IF ls_bkpf-xblnr IS INITIAL.
                ls_bkpf-xblnr = ls_tab_imp-value.
                TRANSLATE ls_bkpf-xblnr TO UPPER CASE.
              ENDIF.
            WHEN '007'. "BKTXT
              IF ls_bkpf-bktxt IS INITIAL.
                ls_bkpf-bktxt = ls_tab_imp-value.
              ENDIF.
            WHEN '008'. "WAERS
              IF ls_bkpf-waers IS INITIAL.
                ls_bkpf-waers = ls_tab_imp-value.
              ENDIF.
            WHEN '009'. "KURSF
              IF ls_bkpf-kursf IS INITIAL.
                REPLACE ALL OCCURRENCES OF ',' IN ls_tab_imp-value WITH '.'.
                ls_bkpf-kursf = ls_tab_imp-value.
              ENDIF.
            WHEN '010'. "WWERT
              IF ls_bkpf-wwert IS INITIAL.
                ls_bkpf-wwert = ls_tab_imp-value.
              ENDIF.
            WHEN '011'. "XMWST
              IF ls_bkpf-xmwst IS INITIAL.
                ls_bkpf-xmwst = to_upper( ls_tab_imp-value ).
              ENDIF.
            WHEN '012'. "XSKON
              IF ls_bkpf-xskon IS INITIAL.
                ls_bkpf-xskon = to_upper( ls_tab_imp-value ).
              ENDIF.
            WHEN '013'. "CF_1
              IF ls_bkpf-cf_1 IS INITIAL.
                ls_bkpf-cf_1 = ls_tab_imp-value.
              ENDIF.
            WHEN '014'. "CF_2
              IF ls_bkpf-cf_2 IS INITIAL.
                ls_bkpf-cf_2 = ls_tab_imp-value.
              ENDIF.
            WHEN '015'. "CF_3
              IF ls_bkpf-cf_3 IS INITIAL.
                ls_bkpf-cf_3 = ls_tab_imp-value.
              ENDIF.
            WHEN '016'. "CF_4
              IF ls_bkpf-cf_4 IS INITIAL.
                ls_bkpf-cf_4 = ls_tab_imp-value.
              ENDIF.
            WHEN '017'. "BUZEI
              ls_bpos-buzei = ls_tab_imp-value.
            WHEN '018'. "BUZID
              ls_bpos-buzid = ls_tab_imp-value.
            WHEN '019'. "SHKZG
              ls_bpos-shkzg = ls_tab_imp-value.
            WHEN '20'. "WRBTR
              REPLACE ALL OCCURRENCES OF ',' IN ls_tab_imp-value WITH '.'.
              ls_bpos-wrbtr = ls_tab_imp-value.
            WHEN '021'. "MWSKZ
              ls_bpos-mwskz = ls_tab_imp-value.
            WHEN '022'. "ZUONR
              ls_bpos-zuonr = ls_tab_imp-value.
            WHEN '023'. "SGTXT
              ls_bpos-sgtxt = ls_tab_imp-value.
            WHEN '024'. "KOSTL
              ls_bpos-kostl = ls_tab_imp-value.
            WHEN '025'. "AUFNR
              ls_bpos-aufnr = ls_tab_imp-value.
            WHEN '026'. "POSID
              ls_bpos-pspel = ls_tab_imp-value.
            WHEN '027'. "GEBER
              ls_bpos-geber = ls_tab_imp-value.
            WHEN '028'. "HKONT
              ls_bpos-hkont = ls_tab_imp-value.
            WHEN '029'. "KUNNR
              " CUSTOM LOGIC
              " IF TABLE LOOKUP -> value
              " ELSE TABLE LOOKUP -> value from table
              IF me->av_sst_id CP '*PRI_02'.
                TRY.
                    SELECT SINGLE @abap_true
                      FROM kna1
                      WHERE kunnr = @ls_tab_imp-value
                      INTO @DATA(lv_bp_exists).
                  CATCH cx_sy_open_sql_data_error.
                ENDTRY.

                IF lv_bp_exists = abap_true.
                  ls_bpos-kunnr = ls_tab_imp-value.
                ELSE.
                  TRY.
                      SELECT SINGLE partner
                        FROM but0id
                        WHERE type = 'MATRNR'
                        AND idnumber = @ls_tab_imp-value
                        INTO @ls_bpos-kunnr.
                      IF sy-subrc NE 0.
                        ls_bpos-kunnr = ls_tab_imp-value.
                      ENDIF.

                    CATCH  cx_sy_open_sql_data_error.
                      ls_bpos-kunnr = '?????'.
                  ENDTRY.

                  ls_bpos-cf_1 = |Mat.-Nr. { ls_tab_imp-value }|.
                ENDIF.
              ELSE.
                ls_bpos-kunnr = ls_tab_imp-value.
              ENDIF.
            WHEN '030'. "LIFNR
              ls_bpos-lifnr = ls_tab_imp-value.
            WHEN '031'. "VALUT
              ls_bpos-valut = ls_tab_imp-value.
            WHEN '032'. "ZFBDT
              ls_bpos-zfbdt = ls_tab_imp-value.
            WHEN '033'. "ZTERM
              ls_bpos-zterm = ls_tab_imp-value.
            WHEN '033'. "ZLSCH
              ls_bpos-zlsch = ls_tab_imp-value.
            WHEN '035'. "ZLSPR
              ls_bpos-zlspr = ls_tab_imp-value.
            WHEN '036'. "BVTYP
              ls_bpos-bvtyp = ls_tab_imp-value.
            WHEN '037'. "MANSP
              ls_bpos-mansp = ls_tab_imp-value.
            WHEN '038'. "ANRED
              IF ls_cpd-anred IS INITIAL.
                ls_cpd-anred = ls_tab_imp-value.
              ENDIF.
            WHEN '039'. "NAME1
              IF ls_cpd-name1 IS INITIAL.
                ls_cpd-name1 = ls_tab_imp-value.
              ENDIF.
            WHEN '040'. "NAME2
              IF ls_cpd-name2 IS INITIAL.
                ls_cpd-name2 = ls_tab_imp-value.
              ENDIF.
            WHEN '041'. "NAME3
              IF ls_cpd-name3 IS INITIAL.
                ls_cpd-name3 = ls_tab_imp-value.
              ENDIF.
            WHEN '042'. "NAME4
              IF ls_cpd-name4 IS INITIAL.
                ls_cpd-name4 = ls_tab_imp-value.
              ENDIF.
            WHEN '043'. "PSTLZ
              IF ls_cpd-pstlz IS INITIAL.
                ls_cpd-pstlz = ls_tab_imp-value.
              ENDIF.
            WHEN '044'. "ORT01
              IF ls_cpd-ort01 IS INITIAL.
                ls_cpd-ort01 = ls_tab_imp-value.
              ENDIF.
            WHEN '045'. "LAND1
              IF ls_cpd-land1 IS INITIAL.
                ls_cpd-land1 = ls_tab_imp-value.
              ENDIF.
            WHEN '046'. "STRAS
              IF ls_cpd-stras IS INITIAL.
                ls_cpd-stras = ls_tab_imp-value.
              ENDIF.
            WHEN '047'. "PFACH
              IF ls_cpd-pfach IS INITIAL.
                ls_cpd-pfach = ls_tab_imp-value.
              ENDIF.
            WHEN '048'. "PSTL2
              IF ls_cpd-pstl2 IS INITIAL.
                ls_cpd-pstl2 = ls_tab_imp-value.
              ENDIF.
            WHEN '049'. "BANKN
              IF ls_cpd-bankn IS INITIAL.
                ls_cpd-bankn = ls_tab_imp-value.
              ENDIF.
            WHEN '050'. "BANKL
              IF ls_cpd-bankl IS INITIAL.
                ls_cpd-bankl = ls_tab_imp-value.
              ENDIF.
            WHEN '051'. "BANKS
              IF ls_cpd-banks IS INITIAL.
                ls_cpd-banks = ls_tab_imp-value.
              ENDIF.
            WHEN '052'. "IBAN
              IF ls_cpd-iban IS INITIAL.
                ls_cpd-iban = ls_tab_imp-value.
              ENDIF.
            WHEN '053'. "SWIFT
              IF ls_cpd-swift IS INITIAL.
                ls_cpd-swift = ls_tab_imp-value.
              ENDIF.
            WHEN '054'. "STKZU
              IF ls_cpd-stkzu IS INITIAL.
                ls_cpd-stkzu = to_upper( ls_tab_imp-value ).
              ENDIF.
            WHEN '055'. "STCD1
              IF ls_cpd-stcd1 IS INITIAL.
                ls_cpd-stcd1 = ls_tab_imp-value.
              ENDIF.
            WHEN '056'. "STCD2
              IF ls_cpd-stcd2 IS INITIAL.
                ls_cpd-stcd2 = ls_tab_imp-value.
              ENDIF.
            WHEN '057'. "STCD3
              IF ls_cpd-stcd3 IS INITIAL.
                ls_cpd-stcd3 = ls_tab_imp-value.
              ENDIF.
            WHEN '058'. "STCD4
              IF ls_cpd-stcd4 IS INITIAL.
                ls_cpd-stcd4 = ls_tab_imp-value.
              ENDIF.
            WHEN '059'. "Mittelreservierung
              IF ls_bpos-res_doc IS INITIAL.
                ls_bpos-res_doc = ls_tab_imp-value.
              ENDIF.
            WHEN '060'. "Mittelreservierung Position
              IF ls_bpos-res_item IS INITIAL.
                ls_bpos-res_item = ls_tab_imp-value.
              ENDIF.
            WHEN '061'. " Finanzposition
              IF ls_bpos-cmmt_item_ext IS INITIAL.
                ls_bpos-cmmt_item_ext  = ls_tab_imp-value.
              ENDIF.
            WHEN '062'. " Finanzstelle
              IF ls_bpos-fund_ctr IS INITIAL.
                ls_bpos-fund_ctr = ls_tab_imp-value.
              ENDIF.
            WHEN '063'. " Geschäftsbereich
              IF ls_bpos-gsber IS INITIAL.
                ls_bpos-gsber = ls_tab_imp-value.
              ENDIF.
            WHEN OTHERS.
              lv_m1 = ls_tab_imp-col.
              RAISE EXCEPTION TYPE zcx_gsst_conv
                EXPORTING
                  textid       = zcx_gsst_conv=>col_error
                  av_status_v1 = lv_m1.
          ENDCASE.
        CATCH cx_sy_conversion_no_number INTO lx_error.
          lv_m1 = ls_tab_imp-value.
          lv_m2 = ls_tab_imp-row.
          lv_m3 = ls_tab_imp-col.
          RAISE EXCEPTION TYPE zcx_gsst_conv
            EXPORTING
              textid       = zcx_gsst_conv=>map_error_det
              av_status_v1 = lv_m1
              av_status_v2 = lv_m2
              av_status_v3 = lv_m3
              previous     = lx_error.

      ENDTRY.
    ENDLOOP.

    ls_beleg-bkpf = ls_bkpf.
    IF ls_bpos IS NOT INITIAL.
      APPEND ls_bpos TO lt_bpos.
    ENDIF.
    ls_beleg-bpos = lt_bpos.
    IF ls_cpd IS NOT INITIAL.
      ls_beleg-cpd = ls_cpd.
    ENDIF.
    APPEND ls_beleg TO lt_beleg.

    et_import_structure = lt_beleg.
  ENDMETHOD.