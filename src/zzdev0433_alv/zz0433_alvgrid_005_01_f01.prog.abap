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
    go_grid_spfli->ms_variant = value #(
      report      = sy-repid
      handle      = `A1`
      log_group   = `GR1`
      username    = sy-uname
      text   = `SPFLI`
    ).

    go_grid_sflight->ms_variant = value #(
      report      = sy-repid
      handle      = `A1`
      log_group   = `GR1`
      username    = sy-uname
      text   = `SFLIGHT`
    ).
* Layout.
    go_grid_spfli->ms_layout = value #(
                 cwidth_opt  = abap_true
                 zebra       = abap_true
                 box_fname   = space
                 no_rowmark  = space
                 sel_mode    = `A`
                 stylefname  = space
                 grid_title  = `Schedule`
                 smalltitle  = abap_true
                 no_toolbar  = space
                 info_fname  = space
                 ctab_fname  = space ).

    go_grid_sflight->ms_layout = value #(
                 cwidth_opt  = abap_true
                 zebra       = abap_true
                 box_fname   = space
                 no_rowmark  = space
                 sel_mode    = `A`
                 stylefname  = space
                 grid_title  = `Flighs`
                 smalltitle  = abap_true
                 no_toolbar  = space
                 info_fname  = space
                 ctab_fname  = space ).
* FieldCat.
    perform set_fieldcat_spfli using go_grid_spfli->mt_fieldcat.
    perform set_fieldcat_sflight using go_grid_sflight->mt_fieldcat.

* Toolbar Excluding.
    go_grid_spfli->set_init_toolbar( changing ct_toolbar_excluding = go_grid_spfli->mt_ui_exclude ).
    go_grid_sflight->set_init_toolbar( changing ct_toolbar_excluding = go_grid_sflight->mt_ui_exclude ).

* Event.
    data(ls_events_spfli) = go_grid_spfli->get_registed_events( ).

    ls_events_spfli = value #(
        user_command = abap_true
        toolbar = abap_true
        double_click = abap_true
        hotspot_click = abap_true
    ).

    go_grid_spfli->set_registor_events( is_register_events = ls_events_spfli ).

*   Display ALV.
    go_grid_spfli->set_table_for_first_display(
      exporting
        i_buffer_active      = 'X'
        i_bypassing_buffer   = 'X'
        i_save               = 'A'    "  'A': Both, 'U': Only user-specifiC, 'X': Only global
        is_variant           = go_grid_spfli->ms_variant
        is_layout            = go_grid_spfli->ms_layout
        it_toolbar_excluding = go_grid_spfli->mt_ui_exclude
      changing
        it_outtab                     = gt_spfli                 " Output Table
        it_fieldcatalog               = go_grid_spfli->mt_fieldcat                 " Field Catalog
        it_sort                       = go_grid_spfli->mt_sort                 " Sort Criteria
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
        is_variant           = go_grid_sflight->ms_variant
        is_layout            = go_grid_sflight->ms_layout
        it_toolbar_excluding = go_grid_sflight->mt_ui_exclude
      changing
        it_outtab                     = gt_sflight                 " Output Table
        it_fieldcatalog               = go_grid_sflight->mt_fieldcat                 " Field Catalog
        it_sort                       = go_grid_sflight->mt_sort                 " Sort Criteria
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
*        <fs_fieldcat>-tech = abap_true.
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
      when `CURRENCY`.
      when `PLANETYPE`.
      when `SEATSMAX`.
      when `SEATSOCC`.
      when `PAYMENTSUM`.
      when `SEATSMAX_B`.
      when `SEATSOCC_B`.
      when `SEATSMAX_F`.
      when `SEATSOCC_F`.
      when others.
*        <fs_fieldcat>-tech = abap_true.
    endcase.
  endloop.

endform.
