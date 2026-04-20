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

    go_custom_container = new #( container_name = c_cont_spfli ).

    go_splitter = new #( parent = go_custom_container rows = 2 columns = 1 ).

    go_splitter->get_container(
      exporting
        row       = 1                  " Row
        column    = 1                 " Column
      receiving
        container = go_cont_scarr                 " Container
    ).

    go_splitter->get_container(
      exporting
        row       = 2                  " Row
        column    = 1                 " Column
      receiving
        container = go_cont_spfli                 " Container
    ).

    go_grid_spfli = new #( i_parent = go_cont_spfli i_appl_events = space ).
    go_grid_scarr = new #( i_parent = go_cont_scarr i_appl_events = space ).

* Variant.
    gs_variant = value #(
      report      = sy-repid
      handle      = `A1`
      log_group   = `GR1`
      username    = sy-uname
      text   = `SPFLI`
    ).

    gs_variant = value #(
      report      = sy-repid
      handle      = `A2`
      log_group   = `GR2`
      username    = sy-uname
      text   = `SCARR`
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
                 ctab_fname  = space ).

    gs_layout2 = value #(
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
                 ctab_fname  = space ).
* FieldCat.
    perform set_fieldcat_spfli using gt_fieldcat_spfli.
    perform set_fieldcat_scarr using gt_fieldcat_scarr.

* Toolbar Excluding.
    go_grid_spfli->set_init_toolbar( changing ct_toolbar_excluding = gt_exclude ).
    go_grid_scarr->set_init_toolbar( changing ct_toolbar_excluding = gt_exclude2 ).

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

    go_grid_scarr->set_table_for_first_display(
      exporting
        i_buffer_active      = 'X'
        i_bypassing_buffer   = 'X'
        i_save               = 'A'    "  'A': Both, 'U': Only user-specifiC, 'X': Only global
        is_variant           = gs_variant2
        is_layout            = gs_layout2
        it_toolbar_excluding = gt_exclude2
      changing
        it_outtab                     = gt_scarr                 " Output Table
        it_fieldcatalog               = gt_fieldcat_scarr                 " Field Catalog
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
*& Form set_fieldcat_scarr
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GT_FIELDCAT_SCARR
*&---------------------------------------------------------------------*
form set_fieldcat_scarr  using pt_fieldcat type lvc_t_fcat.

  clear pt_fieldcat.

  go_grid_scarr->make_fieldcat_by_itab(
    exporting
      it_itab     = gt_scarr
    changing
      ct_fieldcat = pt_fieldcat                 " Field Catalog for List Viewer Control
  ).

  loop at pt_fieldcat assigning field-symbol(<fs_fieldcat>).


    case <fs_fieldcat>-fieldname.
      when `CARRID`.
      when `CARRNAME`.
      when `CURRCODE`.
      when `URL`.
    endcase.

  endloop.

endform.
