  PROTECTED SECTION.
    METHODS open_file_dialog
      IMPORTING
        !iv_window_title TYPE string
        !iv_file_filter TYPE string
      EXPORTING
        !ev_filename TYPE dirname_al11 .
    METHODS import_data
        REDEFINITION .
    METHODS map_raw_to_object
        REDEFINITION
    .