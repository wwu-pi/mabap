  METHOD map_raw_to_object.
    DATA: lt_import_structure TYPE lty_tt_beleg_asst_fi,
          lt_objects          TYPE zgsst_tt_objects,
          lv_objecttype       TYPE zgsst_de_objecttype.
    DATA: lv_percentage TYPE p,
          lv_text       TYPE c LENGTH 40.

    me->map_raw_to_import_structure(
      IMPORTING
        et_import_structure = lt_import_structure
    ).

    " CUSTOM_LOGIC: JOH removed check_import_values because this is custom logic not to be generated

    lv_percentage = 66.
    lv_text = TEXT-001.
    CALL FUNCTION 'SAPGUI_PROGRESS_INDICATOR'
      EXPORTING
        percentage = lv_percentage
        text       = lv_text.

    me->map_import_structure_to_object(
      EXPORTING
        it_import_structure = lt_import_structure
      IMPORTING
        et_objects          = et_objects
    ).

    READ TABLE et_objects INDEX 1 INTO DATA(ls_object).
    lv_objecttype = ls_object-objectref->get_av_objecttype( ).
    APPEND lv_objecttype TO et_objecttype.
    ev_runid = ls_object-objectref->get_av_runid( ).

  ENDMETHOD.