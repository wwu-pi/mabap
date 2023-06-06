  METHOD import_data.
    TYPES: BEGIN OF ty_file,
             data(80),
           END OF ty_file.

    DATA: lt_file TYPE TABLE OF ty_file,
          ls_file LIKE LINE OF lt_file.

    DATA: lv_filename        TYPE dirname_al11,
          lv_filename_string TYPE string.

    DATA: lv_msgv1 TYPE msgv1.

    DATA: ls_sst TYPE zgsst_st_raw.

    DATA: lv_dup_count TYPE i VALUE 0,
          lv_name      TYPE string,
          lv_path      TYPE string,
          lv_answer    TYPE c.

    me->open_file_dialog(
      EXPORTING
        iv_window_title = 'Dateiauswahl'
        iv_file_filter  = '*.csv'
      IMPORTING
        ev_filename     = lv_filename
    ).
    lv_filename_string = lv_filename.
    IF lv_filename_string EQ space.
      MESSAGE 'Wählen Sie eine Datei aus!' TYPE 'E'.

    ELSE.
      TRY.
          DATA(lv_filename_for_split) = lv_filename_string.
          REPLACE ALL OCCURRENCES OF '/' IN lv_filename_for_split WITH '\'.

          CALL FUNCTION 'SO_SPLIT_FILE_AND_PATH'
            EXPORTING
              full_name     = lv_filename_for_split
            IMPORTING
              stripped_name = lv_name
              file_path     = lv_path
            EXCEPTIONS
              x_error       = 1
              OTHERS        = 2.

          me->av_filename = lv_name.

        CATCH cx_bcs.
          MESSAGE 'Dateiname ist ungültig!' TYPE 'E'.
      ENDTRY.

      IF av_src_server EQ abap_false.
        SELECT SINGLE filename
          FROM zgsst_sst_run
          WHERE sst_id = @me->av_sst_id AND
                filename = @lv_name
          INTO @DATA(lv_fn).

        " TOGGLE
        IF sy-subrc = 0.
          CALL FUNCTION 'POPUP_WITH_2_BUTTONS_TO_CHOOSE'
            EXPORTING
              "DEFAULTOPTION = '1'
              diagnosetext1 = TEXT-004
              diagnosetext2 = lv_name
              "DIAGNOSETEXT3 = ' '
              textline1     = 'Soll die Datei trotzdem importiert werden?'
              "TEXTLINE2     = ' '
              "TEXTLINE3     = ' '
              text_option1  = 'Ja'
              text_option2  = 'Nein'
              titel         = 'Datei bereits eingelesen'
            IMPORTING
              answer        = lv_answer.
        ENDIF.
        IF lv_answer = '2'.
          MESSAGE 'Datei Upload vom User abgebrochen!' TYPE 'E'.
        ENDIF.

        " TOGGLE CSV / Other Formats
        CALL FUNCTION 'POPUP_WITH_2_BUTTONS_TO_CHOOSE'
          EXPORTING
            "DEFAULTOPTION = '1'
            diagnosetext1 = TEXT-002
            diagnosetext2 = TEXT-003
            "DIAGNOSETEXT3 = ' '
            textline1     = 'Sind die erste Zeile Beschriftungen?'
            "TEXTLINE2     = ' '
            "TEXTLINE3     = ' '
            text_option1  = 'Ja'
            text_option2  = 'Nein'
            titel         = 'Überschriftenzeile'
          IMPORTING
            answer        = me->av_headline.
      ELSE.
        me->av_headline = '1'.
      ENDIF.

      " SELECT data type
      me->csv(
        EXPORTING
          iv_filename = lv_filename_string
        IMPORTING
          et_raw      = me->at_raw
      ).
    ENDIF.


  ENDMETHOD.