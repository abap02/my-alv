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

  if go_salv_tree_spfli is initial.

    if cl_salv_tree=>is_offline( ) eq if_salv_c_bool_sap=>false.
      go_cont_docking = new #( side = cl_gui_docking_container=>dock_at_left extension = 2000 ).
    endif.
    "creat salv.
    try.
        cl_salv_tree=>factory(
          exporting
            r_container = conv #( go_cont_docking )
          importing
            r_salv_tree = go_salv_tree_spfli
          changing
            t_table = gt_spfli )."Internal Table 반드시 초기화.

      catch cx_salv_no_new_data_allowed cx_salv_error into data(msg).
        data(r_msg) = msg->get_message( ).
        cl_demo_output=>display( r_msg ).
        exit.
    endtry.

*   Functions
    go_salv_tree_spfli->get_functions( )->set_all( abap_true ).

    go_salv_tree_spfli->get_columns( )->get_column( `MANDT` )->set_technical( abap_true ).
    go_salv_tree_spfli->get_columns( )->get_column( `CARRID` )->set_technical( abap_true ).
    go_salv_tree_spfli->get_columns( )->get_column( `CONNID` )->set_technical( abap_true ).

    "   Tree Header.
    go_salv_tree_spfli->get_tree_settings( )->set_hierarchy_header( `Airline/Schedule` ).
    go_salv_tree_spfli->get_tree_settings( )->set_hierarchy_tooltip( `Airline/Schedule` ).
    go_salv_tree_spfli->get_tree_settings( )->set_hierarchy_size( 20 ).

    perform add_spfli_nodes.

  endif.

  go_salv_tree_spfli->display( ).

endform.
