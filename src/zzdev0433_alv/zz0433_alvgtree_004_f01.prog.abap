*&---------------------------------------------------------------------*
*& Include          ZZ0433_ALVGTREE_001_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form set_alvtree_display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_alvtree_display .

  if go_alvtree_sflight is initial.

    go_cont_docking = new #( side = cl_gui_docking_container=>dock_at_left extension = 2000 ).

    go_alvtree_sflight = new #(
      parent = go_cont_docking
      node_selection_mode = cl_gui_column_tree=>node_sel_mode_multiple
      item_selection = space
      no_html_header = abap_true
      i_model_mode = abap_true
    ).


    gs_treev_hhdr = value #(
     heading = `Airline/Schedule`
     tooltip = `Airline/Schedule`
     width = 30
    ).

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

*--------- Make Fieldcatalog -------------
    try.
        cl_salv_table=>factory(
        exporting
          list_display = abap_false
        importing
          r_salv_table = data(lo_salv_table)
        changing
          t_table      = gt_sflight ).
      catch cx_salv_msg.                                "#EC NO_HANDLER
    endtry.


*   Field Catalog.
    perform set_fieldcat_sflight using lo_salv_table.

    go_alvtree_sflight->set_table_for_first_display(
      exporting
        is_hierarchy_header  = gs_treev_hhdr                 " Hierarchy Fields

      changing
        it_outtab            = gt_sflight               " Output Table
        it_fieldcatalog      =  gt_fieldcat_sflight                " Field Catalog
    ).

*   add nodes.
    select * from spfli order by carrid, connid into corresponding fields of table @gt_spfli.

    select * from sflight into table @data(lt_sflight).


    loop at gt_scarr into data(ls_data).

      go_alvtree_sflight->add_node(
        exporting
          i_relat_node_key     = ``                  " Node Already in Tree Hierarchy
          i_relationship       = cl_gui_column_tree=>relat_last_child                  " How to Insert Node
          is_outtab_line       = space                 " Attributes of Inserted Node
          i_node_text          = conv #( |{ ls_data-carrid } ({ ls_data-carrname })| )                 " Hierarchy Node Text
        importing
          e_new_node_key       = data(lv_node_carrid)                  " Key of New Node Key
      ).

      loop at gt_spfli into data(ls_spfli) where carrid eq ls_data-carrid.

        go_alvtree_sflight->add_node(
          exporting
            i_relat_node_key     = lv_node_carrid                  " Node Already in Tree Hierarchy
            i_relationship       = cl_gui_column_tree=>relat_last_child                  " How to Insert Node
            is_outtab_line       = space                 " Attributes of Inserted Node
            i_node_text          = conv #( |{ ls_spfli-connid } ({ ls_spfli-cityfrom } --> { ls_spfli-cityto })|  )                  " Hierarchy Node Text
          importing
            e_new_node_key       = data(lv_node_connid)                  " Key of New Node Key
        ).

        loop at lt_sflight into data(ls_sflight) where carrid eq ls_spfli-carrid and
                                                       connid eq ls_spfli-connid.

          go_alvtree_sflight->add_node(
             exporting
               i_relat_node_key     = lv_node_connid                  " Node Already in Tree Hierarchy
               i_relationship       = cl_gui_column_tree=>relat_last_child                  " How to Insert Node
               is_outtab_line       = ls_sflight                 " Attributes of Inserted Node
               i_node_text          = conv #( |{ ls_sflight-fldate date = iso }|  )                  " Hierarchy Node Text
           ).

        endloop.

      endloop.

    endloop.


*   Toolbar add.
    go_alvtree_sflight->get_toolbar_object(
      importing
        er_toolbar = data(lo_toolbar)                 " Toolbar Object
    ).

    lo_toolbar->add_button(
      exporting
        fcode     = ''
        icon      = ''
        butn_type = cntb_btype_sep
    ).

    lo_toolbar->add_button(
      exporting
        fcode            = `DELETE`                  " Function Code Associated with Button
        icon             = icon_delete                 " Icon Name Defined Like "@0a@"
        butn_type        = cntb_btype_button                 " Button Types Defined in CNTB
        text             = `Delete`                  " Text Shown to the Right of the Image
        quickinfo        = `Delete`                 " Purpose of Button Text
    ).

    lo_toolbar->add_button(
      exporting
        fcode            = `MENU`                  " Function Code Associated with Button
        icon             = icon_information                 " Icon Name Defined Like "@0a@"
        butn_type        = cntb_btype_menu                 " Button Types Defined in CNTB
        text             = `Information`                  " Text Shown to the Right of the Image
        quickinfo        = `Information`                 " Purpose of Button Text
    ).

    set handler go_alvtree_sflight->on_function_selected for lo_toolbar.
    set handler go_alvtree_sflight->on_dropdown_clicked for lo_toolbar.


  endif.

  go_alvtree_sflight->update_calculations( )."Aggregations 적용시 필요.

  go_alvtree_sflight->column_optimize( ).
  go_alvtree_sflight->frontend_update( ).


endform.
*&---------------------------------------------------------------------*
*& Form set_fieldcat_spfli
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_fieldcat_sflight using po_salv_table type ref to cl_salv_table.

  gt_fieldcat_sflight = cl_salv_controller_metadata=>get_lvc_fieldcatalog(
                        r_columns      = po_salv_table->get_columns( )
                        r_aggregations = po_salv_table->get_aggregations( )
                      ).

  loop at gt_fieldcat_sflight assigning field-symbol(<fs_fieldcat_sflight>).
    <fs_fieldcat_sflight>-col_opt = abap_true.
    case <fs_fieldcat_sflight>-fieldname.
      when `PRICE`.
        <fs_fieldcat_sflight>-do_sum = abap_true.
        <fs_fieldcat_sflight>-h_ftype = `SUM`.
      when `SEATSMAX`.
        <fs_fieldcat_sflight>-do_sum = abap_true.
        <fs_fieldcat_sflight>-h_ftype = `MAX`.
      when `SEATSOCC`.
        <fs_fieldcat_sflight>-do_sum = abap_true.
        <fs_fieldcat_sflight>-h_ftype = `AVG`.
      when `PAYMENTSUM`.
        <fs_fieldcat_sflight>-do_sum = abap_true.
        <fs_fieldcat_sflight>-h_ftype = `MIN`.
      when `MANDT` or `CARRID` or `CONNID` or `FLDATE`.
        <fs_fieldcat_sflight>-tech = abap_true.
      when others.
    endcase.
  endloop.

endform.
