  METHOD open_file_dialog.
    IF av_src_server EQ abap_true.
      ev_filename = av_filename.
      RETURN.
    ENDIF.

    DATA: lo_frontend_service TYPE REF TO cl_gui_frontend_services,
          lt_files            TYPE filetable,
          ls_file             TYPE file_table,
          lv_subrc            TYPE sysubrc.

    FIELD-SYMBOLS: <fs_sst> TYPE any.

    CREATE OBJECT lo_frontend_service.

    " Datei öffnen Dialog ausführen
    lo_frontend_service->file_open_dialog(
      EXPORTING
        window_title            = iv_window_title
        file_filter             = iv_file_filter
        multiselection          = space
      CHANGING
        file_table              = lt_files
        rc                      = lv_subrc
      EXCEPTIONS
        file_open_dialog_failed = 1
        cntl_error              = 2
        error_no_gui            = 3
        not_supported_by_gui    = 4
        OTHERS                  = 5
    ).
    IF sy-subrc <> 0.

    ENDIF.

    READ TABLE lt_files INTO ls_file INDEX 1.
    ev_filename = ls_file-filename.
  ENDMETHOD.