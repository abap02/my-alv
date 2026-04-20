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

*    Functions
    go_salv_spfli->get_functions( )->set_default( abap_true ).
*    go_salv_spfli->get_functions( )->set_all( abap_true ).

    "Add Function Keys.
    try.
        go_salv_spfli->get_functions( )->add_function(
          exporting
            name     = `SPFLI_COPY`                 " ALV Function
            icon     = conv #( icon_copy_object )
            text     = `Copy`
            tooltip  = `Copy`
            position = if_salv_c_function_position=>right_of_salv_functions                 " Positioning Function
        ).

        go_salv_spfli->get_functions( )->add_function(
          exporting
            name     = `SPFLI_ADD`                 " ALV Function
            icon     = conv #( icon_add_row )
            text     = `Add`
            tooltip  = `Add`
            position = if_salv_c_function_position=>right_of_salv_functions                 " Positioning Function
        ).
      catch cx_salv_existing.   " ALV: General Error Class (Checked in Syntax Check)
      catch cx_salv_wrong_call. " ALV: General Error Class (Checked in Syntax Check)

    endtry.

*   Layout.
    go_salv_spfli->get_layout( )->set_key( value #( report = sy-repid ) ).
    go_salv_spfli->get_layout( )->set_save_restriction( if_salv_c_layout=>restrict_none ).
    go_salv_spfli->get_layout( )->set_default( abap_true ).

*   ALV Title.
    go_salv_spfli->get_display_settings( )->set_list_header( `Airline Information` ).
    go_salv_spfli->get_display_settings( )->set_list_header_size( 2 ).
    go_salv_spfli->get_display_settings( )->set_striped_pattern( abap_true ).

*   Selection Mode.
    go_salv_spfli->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>row_column )."has Rowmark.
*    go_alv_scarr->get_selections( )->set_selection_mode( if_salv_c_selection_mode=>multiple )."No Rowmark

*   Column Optimize.
    go_salv_spfli->get_columns( )->set_optimize( abap_true ).

    "Event.
    data(lo_column_carrid) = cast cl_salv_column_table( go_salv_spfli->get_columns( )->get_column( 'CARRID' ) ).
    lo_column_carrid->set_cell_type( if_salv_c_cell_type=>hotspot ).
*    lo_column_carrid->set_cell_type( if_salv_c_cell_type=>button ).
    go_salv_event_handler = new #( ).

    go_events = go_salv_spfli->get_event( ).

    set handler go_salv_event_handler->on_added_function for go_events.
    set handler go_salv_event_handler->on_link_click for go_events."hotspot.
    set handler go_salv_event_handler->on_double_click for go_events."hotspot.


  endif.

  go_salv_spfli->display( ).

endform.
