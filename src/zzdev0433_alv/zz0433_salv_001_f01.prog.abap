*&---------------------------------------------------------------------*
*& Include          ZZ0433_SALV_001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_salv_display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_salv_display .

  if go_salv_spfli is initial.

    go_cont_docking = new #( side = cl_gui_docking_container=>dock_at_left extension = 2000 ).

    "creat salv.
    try.
        call method cl_salv_table=>factory
          exporting
            r_container  = go_cont_docking
          importing
            r_salv_table = go_salv_spfli
          changing
            t_table      = gt_spfli.

      catch cx_salv_msg.
        exit.
    endtry.

*   Layout.
    go_salv_spfli->get_layout( )->set_key( value #( report = sy-repid ) ).
    go_salv_spfli->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    go_salv_spfli->get_layout( )->set_default( abap_true ).

*   Functions
    go_salv_spfli->get_functions( )->set_default( abap_true ).

*   ALV Title.
    go_salv_spfli->get_display_settings( )->set_list_header( `Airline Information` ).
    go_salv_spfli->get_display_settings( )->set_list_header_size( 2 ).
    go_salv_spfli->get_display_settings( )->set_striped_pattern( abap_true ).

*   Selection Mode.
    go_salv_spfli->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column )."has Rowmark.
*    go_alv_scarr->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>multiple )."No Rowmark

*   Column Optimize.
    go_salv_spfli->get_columns( )->set_optimize( abap_true ).

  endif.

  go_salv_spfli->display( ).

endform.
