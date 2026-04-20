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

  if go_grid_spfli is initial.

*    go_custom_container = new #( container_name = c_cont_spfli ).

    go_cont_docking = new #( side = cl_gui_docking_container=>dock_at_left extension = 2000 ).

    go_splitter = new #( parent = go_cont_docking rows = 2 columns = 1 ).

    go_splitter->get_container(
      exporting
        row       = 1                  " Row
        column    = 1                  " Column
      receiving
        container = go_cont_spfli                 " Container
    ).

    go_splitter->get_container(
      exporting
        row       = 2                  " Row
        column    = 1                  " Column
      receiving
        container = go_cont_sflight                 " Container
    ).

    go_grid_spfli = new #( i_parent = go_cont_spfli i_appl_events = space ).
    go_grid_sflight = new #( i_parent = go_cont_sflight i_appl_events = space ).

* Variant.
    gs_variant = value #(
      report      = sy-repid
      handle      = `A1`
      log_group   = `GR1`
      username    = sy-uname
      text   = `SPFLI`
    ).

    gs_variant2 = value #(
      report      = sy-repid
      handle      = `A1`
      log_group   = `GR1`
      username    = sy-uname
      text   = `SFLIGHT`
    ).
* Layout.
    gs_layout = value #(
                 cwidth_opt  = abap_true
                 zebra       = abap_true
                 box_fname   = space
                 no_rowmark  = space
                 sel_mode    = `A`
                 stylefname  = `CELLTAB`
                 grid_title  = `Schedule`
                 smalltitle  = abap_true
                 no_toolbar  = space
                 info_fname  = `LINECOLOR`
                 ctab_fname  = `CELLCOLOR` ).

    gs_layout2 = value #(
                 cwidth_opt  = abap_true
                 zebra       = abap_true
                 box_fname   = space
                 no_rowmark  = space
                 sel_mode    = `A`
                 stylefname  = `CELLTAB`
                 grid_title  = `Flighs`
                 smalltitle  = abap_true
                 no_toolbar  = space
                 info_fname  = `LINECOLOR`
                 ctab_fname  = `CELLCOLOR` ).
* FieldCat.
    perform set_fieldcat_spfli using gt_fieldcat_spfli.
    perform set_fieldcat_sflight using gt_fieldcat_sflight.

*   Dropdown List.
    perform set_grid_dropdown.

* Toolbar Excluding.
    go_grid_spfli->set_init_toolbar( changing ct_toolbar_excluding = gt_exclude ).
    go_grid_sflight->set_init_toolbar( changing ct_toolbar_excluding = gt_exclude2 ).

* Event.
    data(ls_events_spfli) = go_grid_spfli->get_registed_events( ).

    ls_events_spfli = value #(
        user_command = abap_true
        toolbar = abap_true
        double_click = abap_true
        hotspot_click = abap_true

        data_changed = abap_true
        data_changed_finished = abap_true
    ).

    go_grid_spfli->set_registor_events( is_register_events = ls_events_spfli ).

    data(ls_events_sflight) = go_grid_sflight->get_registed_events( ).

    ls_events_sflight = value #(
        data_changed = abap_true
        data_changed_finished = abap_true
    ).

    go_grid_sflight->set_registor_events( is_register_events = ls_events_sflight ).

*   Display ALV.
    go_grid_spfli->set_table_for_first_display(
      exporting
        i_buffer_active      = 'X'
        i_bypassing_buffer   = 'X'
        i_save               = 'A'    "  'A': Both, 'U': Only user-specifiC, 'X': Only global
        is_variant           = gs_variant
        is_layout            = gs_layout
        it_toolbar_excluding = gt_exclude
      changing
        it_outtab                     = gt_spfli                 " Output Table
        it_fieldcatalog               = gt_fieldcat_spfli                 " Field Catalog
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

    go_grid_sflight->set_table_for_first_display(
      exporting
        i_buffer_active      = 'X'
        i_bypassing_buffer   = 'X'
        i_save               = 'A'    "  'A': Both, 'U': Only user-specifiC, 'X': Only global
        is_variant           = gs_variant2
        is_layout            = gs_layout2
        it_toolbar_excluding = gt_exclude2
      changing
        it_outtab                     = gt_sflight                 " Output Table
        it_fieldcatalog               = gt_fieldcat_sflight                 " Field Catalog
        it_sort                       = gt_sort2                 " Sort Criteria
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

  else.

    go_grid_spfli->refresh_alv_grid( iv_opt = abap_true ).
    go_grid_sflight->refresh_alv_grid( iv_opt = abap_true ).

  endif.

endform.
*&---------------------------------------------------------------------*
*& Form set_fieldcat_spfli
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_FIELDCAT_SPFLI
*&---------------------------------------------------------------------*
form set_fieldcat_spfli using pt_fieldcat type lvc_t_fcat.

  clear pt_fieldcat.

  go_grid_spfli->make_fieldcat_by_itab(
    exporting
      it_itab     = gt_spfli
    changing
      ct_fieldcat = pt_fieldcat                 " Field Catalog for List Viewer Control
  ).

  loop at pt_fieldcat assigning field-symbol(<fs_fieldcat>).


    case <fs_fieldcat>-fieldname.
      when `CARRID`.
      when `CONNID`.
        <fs_fieldcat>-hotspot = abap_true.
      when `COUNTRYFR`.
      when `CITYFROM`.
      when `AIRPFROM`.
      when `COUNTRYTO`.
      when `CITYTO`.
      when `AIRPTO`.
      when `FLTIME`.
      when `DEPTIME`.
      when `ARRTIME`.
      when `DISTANCE`.
      when `DISTID`.
      when `FLTYPE`.
      when `PERIOD`.
      when others.
        <fs_fieldcat>-tech = abap_true.
    endcase.
  endloop.

endform.
*&---------------------------------------------------------------------*
*& Form set_fieldcat_sflight
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_FIELDCAT_SFLIGHT
*&---------------------------------------------------------------------*
form set_fieldcat_sflight  using pt_fieldcat type lvc_t_fcat.

  clear pt_fieldcat.

  go_grid_spfli->make_fieldcat_by_itab(
    exporting
      it_itab     = gt_sflight
    changing
      ct_fieldcat = pt_fieldcat                 " Field Catalog for List Viewer Control
  ).

  loop at pt_fieldcat assigning field-symbol(<fs_fieldcat>).


    case <fs_fieldcat>-fieldname.
      when `CARRID`.
      when `CONNID`.
      when `FLDATE`.
      when `PRICE`.
        <fs_fieldcat>-edit = abap_true.
        <fs_fieldcat>-outputlen = 20.
      when `CURRENCY`.
      when `PLANETYPE`.
        <fs_fieldcat>-tech = abap_true.
      when `PLANETYPE_TEXT`.
        <fs_fieldcat>-coltext = `Plane Type`.
        <fs_fieldcat>-edit = abap_true.
        <fs_fieldcat>-drdn_hndl = 1001.
        <fs_fieldcat>-drdn_alias = 'X'.
*        <fs_fieldcat>-drdn_field = ''."drdn_hndl 값 부여한 필드, 동적으로 구현시 사용.
      when `SEATSMAX`.
      when `SEATSOCC`.
        <fs_fieldcat>-edit = abap_true.
      when `PAYMENTSUM`.
      when `SEATSMAX_B`.
      when `SEATSOCC_B`.
      when `SEATSMAX_F`.
      when `SEATSOCC_F`.
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
form handle_data_changed  using po_sender type ref to cl_gui_alv_grid
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
      when go_grid_spfli.
      when go_grid_sflight.
        read table gt_sflight index ls_mod_cells-row_id assigning field-symbol(<fs_sflight>).
        if  sy-subrc eq 0.
          message |DataChanged Event handled ~| type `I`.

        endif.

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
form handle_data_changed_finished using po_sender type ref to cl_gui_alv_grid
                                        p_modified type char1
                                        pt_good_cells type lvc_t_modi.

  data lt_row_id type lvc_t_modi.

  check p_modified eq abap_true.

  lt_row_id = corresponding #( gt_data_changed_row_id ).
  clear gt_data_changed_row_id.

  loop at lt_row_id into data(ls_good_cells).
    case po_sender.
      when go_grid_sflight.
        read table gt_sflight index ls_good_cells-row_id assigning field-symbol(<fs_sflight>).
        if sy-subrc eq 0.

          read table gt_alv_dropdown into data(ls_alv_dropdown) with table key ikey components handle = 1001
                                                                               int_value = <fs_sflight>-planetype_text.
          if sy-subrc eq 0.
            <fs_sflight>-planetype = ls_alv_dropdown-int_value.
            <fs_sflight>-planetype_text = ls_alv_dropdown-value.
          else.
            clear: <fs_sflight>-planetype, <fs_sflight>-planetype_text.
          endif.

        endif.
    endcase.
  endloop.



endform.
*&---------------------------------------------------------------------*
*& Form set_dropdown_list_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_dropdown_list_data .

  select * from saplane into table @data(lt_saplane).

  gt_alv_dropdown = value #( for wa in lt_saplane (
                                       handle = 1001
                                       value = |{ wa-planetype } { wa-producer }|
                                       int_value = wa-planetype
                                       valpos = space
                                       mc_value = |{ wa-planetype } { wa-producer }|
  ) ).


endform.
*&---------------------------------------------------------------------*
*& Form set_grid_dropdown
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_grid_dropdown .

  data lt_dropdown type lvc_t_dral.

  loop at gt_alv_dropdown into data(ls_alv_dropdown_list) where handle eq 1001 or handle eq 1002.

    append initial line to lt_dropdown assigning field-symbol(<fs_dropdown>).

    <fs_dropdown> = corresponding #( ls_alv_dropdown_list ).

  endloop.

  lt_dropdown = corresponding #( gt_alv_dropdown ).

  check lt_dropdown is not initial.

  go_grid_sflight->set_drop_down_table(
    exporting
      it_drop_down_alias = lt_dropdown
  ).


endform.
