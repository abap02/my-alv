*&---------------------------------------------------------------------*
*& Include          ZZ0433_ALVGRID_001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_alv_grid_display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_alv_grid_display .

  if go_grid_list is initial.

    go_custom_container = new #( container_name = c_cont_spfli ).

    go_grid_list = new #( i_parent = go_custom_container i_appl_events = space ).

* Variant.
    gs_variant = value #(
      report      = sy-repid
      handle      = `A1`
      log_group   = `GR1`
      username    = sy-uname
      text   = `EKPO`
    ).

* Layout.
    gs_layout = value #(
                 cwidth_opt  = abap_true
                 zebra       = abap_true
                 box_fname   = space
                 no_rowmark  = space
                 sel_mode    = `A`
                 stylefname  = space
                 grid_title  = space
                 smalltitle  = abap_true
                 no_toolbar  = space
                 info_fname  = space
                 ctab_fname  = space
                 no_rowins = space "Paste allowed
                  ).

* FieldCat.
    perform set_fieldcat_list using gt_fieldcat_list.

* Toolbar Excluding.
    go_grid_list->set_init_toolbar( changing ct_toolbar_excluding = gt_exclude ).


* Event.
    data(ls_events_list) = go_grid_list->get_registed_events( ).

    ls_events_list = value #(
        data_changed = abap_true
        data_changed_finished = abap_true
    ).

    go_grid_list->set_registor_events( is_register_events = ls_events_list ).

    go_grid_list->set_table_for_first_display(
      exporting
        i_buffer_active      = 'X'
        i_bypassing_buffer   = 'X'
        i_save               = 'A'    "  'A': Both, 'U': Only user-specifiC, 'X': Only global
        is_variant           = gs_variant
        is_layout            = gs_layout
        it_toolbar_excluding = gt_exclude
      changing
        it_outtab                     = gt_list                 " Output Table
        it_fieldcatalog               = gt_fieldcat_list                 " Field Catalog
        it_sort                       = gt_sort                 " Sort Criteria
*        it_filter                     =                  " Filter Criteria
      exceptions
        invalid_parameter_combination = 1                " Wrong Parameter
        program_error                 = 2                " Program Errors
        too_many_lines                = 3                " Too many Rows in Ready for Input Grid
        others                        = 4
    ).
    if sy-subrc <> 0.
      message id sy-msgid type sy-msgty number sy-msgno
        with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.



  endif.

endform.
*&---------------------------------------------------------------------*
*& Form set_fieldcat_list
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> gt_fieldcat_list
*&---------------------------------------------------------------------*
form set_fieldcat_list using pt_fieldcat type lvc_t_fcat.

  clear pt_fieldcat.

  go_grid_list->make_fieldcat_by_itab(
    exporting
      it_itab     = gt_list
    changing
      ct_fieldcat = pt_fieldcat                 " Field Catalog for List Viewer Control
  ).

  loop at pt_fieldcat assigning field-symbol(<fs_fieldcat>).


    case <fs_fieldcat>-fieldname.
      when `BUDAT`.
        <fs_fieldcat>-edit = abap_true.
      when `EBELN`.
        <fs_fieldcat>-edit = abap_true.
      when `EBELP`.
        <fs_fieldcat>-edit = abap_true.
      when `MATNR`.
        <fs_fieldcat>-edit = abap_true.
      when `MENGE`.
        <fs_fieldcat>-edit = abap_true.
      when `MEINS`.
        <fs_fieldcat>-edit = abap_true.
      when `NETPR`.
        <fs_fieldcat>-edit = abap_true.
      when `WAERS`.
        <fs_fieldcat>-edit = abap_true.
      when `MWSKZ`.
        <fs_fieldcat>-edit = abap_true.
      when `NETWR`.
      when `REASON_ID`.
        <fs_fieldcat>-edit = abap_true.
      when `REASON_TXT`.
        <fs_fieldcat>-edit = abap_true.
      when `BUKRS`.
        <fs_fieldcat>-edit = abap_true.
      when others.
        <fs_fieldcat>-tech = abap_true.
    endcase.
  endloop.

endform.
*&---------------------------------------------------------------------*
*& Form handle_data_changed
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SENDER
*&      --> ER_DATA_CHANGED
*&      --> E_ONF4
*&      --> E_ONF4_BEFORE
*&      --> E_ONF4_AFTER
*&      --> E_UCOMM
*&---------------------------------------------------------------------*
form handle_data_changed using po_sender type ref to cl_gui_alv_grid
                                po_data_changed type ref to cl_alv_changed_data_protocol
                                p_onf4 type char1
                                p_onf4_before type char1
                                p_onf4_after type char1
                                p_ucomm type sy-ucomm.

  define __get_cell_value.
    po_data_changed->get_cell_value( exporting i_row_id    = &1
                                               i_fieldname = &2
                                     importing e_value     = &3 ).
  end-of-definition.

  define __modify_cell.
    po_data_changed->modify_cell( i_row_id    = &1
                                  i_fieldname = &2
                                  i_value     = &3 ).
  end-of-definition.


  define _add_protocol_entry."add alv Message entry.
    po_data_changed->add_protocol_entry(
      i_msgid = ls_message-id
      i_msgty = ls_message-type
      i_msgno = ls_message-number
      i_msgv1 = ls_message-message_v1
      i_msgv2 = ls_message-message_v2
      i_msgv3 = ls_message-message_v3
      i_msgv4 = ls_message-message_v4
      i_fieldname = ls_mod_cells-fieldname
      i_row_id = ls_mod_cells-row_id
      i_tabix = ls_mod_cells-tabix
    ).
  end-of-definition.

  define __only_input_numeric.
    ls_message-type = 'E'.
    ls_message-id = 'ME'.
    ls_message-number = '043'.
    _add_protocol_entry.
  end-of-definition.



  loop at po_data_changed->mt_mod_cells into data(ls_mod_cells).

*   Use in DatachangedFinish Event.
    append value #( row_id = ls_mod_cells-row_id ) to gt_data_changed_row_id.

    case po_sender.
      when go_grid_list.
**        read table gt_list index ls_mod_cells-row_id assigning field-symbol(<fs_list>).
**        if  sy-subrc eq 0.
**
**        endif.

    endcase.

  endloop.

  po_data_changed->display_protocol( ).

  sort gt_data_changed_row_id by row_id.
  delete adjacent duplicates from gt_data_changed_row_id comparing row_id.

endform.
*&---------------------------------------------------------------------*
*& Form handle_data_changed_finished
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> SENDER
*&      --> E_MODIFIED
*&      --> ET_GOOD_CELLS
*&---------------------------------------------------------------------*
form handle_data_changed_finished  using po_sender type ref to cl_gui_alv_grid
                                        p_modified type char1
                                        pt_good_cells type lvc_t_modi.

  data lt_row_id type lvc_t_modi.

  check p_modified eq abap_true.

  lt_row_id = corresponding #( gt_data_changed_row_id ).
  clear gt_data_changed_row_id.

  loop at lt_row_id into data(ls_row_id).
    case po_sender.
      when go_grid_list.
        read table gt_list index ls_row_id-row_id assigning field-symbol(<fs_list>).
        if sy-subrc eq 0.

        endif.
    endcase.
  endloop.

endform.
