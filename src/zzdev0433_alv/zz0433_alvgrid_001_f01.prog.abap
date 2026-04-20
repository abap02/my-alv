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

    go_grid_spfli = new #( i_parent = go_custom_container i_appl_events = space ).

* Variant.
    gs_variant = value #(
      report      = sy-repid
      handle      = `A1`
      log_group   = `GR1`
      username    = sy-uname
      text   = `SPFLI`
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

* FieldCat.
    perform set_fieldcat_spfli using gt_fieldcat_spfli.

* Toolbar Excluding.
    go_grid_spfli->set_init_toolbar( changing ct_toolbar_excluding = gt_exclude ).

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
