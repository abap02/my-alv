*&---------------------------------------------------------------------*
*& Include          ZZ0433_ALVGTREE_001_F02
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_init
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_init .

  gv_title = sy-title.


endform.
*&---------------------------------------------------------------------*
*& Form set_alvtree_display
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_alvtree_display .

  if go_alvtree_spfli is initial.

    go_cont_docking = new #( side = cl_gui_docking_container=>dock_at_left extension = 2000 ).

    go_alvtree_spfli = new #(
      parent = go_cont_docking
      node_selection_mode = cl_gui_column_tree=>node_sel_mode_single
      item_selection = abap_true
      no_html_header = abap_true
    ).


    gs_treev_hhdr = value #(
     heading = `Airline/Schedule`
     tooltip = `Airline/Schedule`
     width = 20
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
          t_table      = gt_spfli ).
      catch cx_salv_msg.                                "#EC NO_HANDLER
    endtry.

*   Field Catalog.
    perform set_fieldcat_spfli using lo_salv_table.



    go_alvtree_spfli->set_table_for_first_display(
      exporting
        is_hierarchy_header  = gs_treev_hhdr                 " Hierarchy Fields

      changing
        it_outtab            = gt_spfli                " Output Table
         it_fieldcatalog      =  gt_fieldcat_spfli                " Field Catalog
    ).

*   add nodes.
    select * from spfli order by carrid, connid into table @data(lt_sfpli).

    loop at lt_sfpli into data(ls_sfpli) group by ( carrid = ls_sfpli-carrid ).

      go_alvtree_spfli->add_node(
        exporting
          i_relat_node_key     = ``                  " Node Already in Tree Hierarchy
          i_relationship       = cl_gui_column_tree=>relat_last_child                  " How to Insert Node
          is_outtab_line       = space                 " Attributes of Inserted Node
            i_node_text          = conv #( |{ ls_sfpli-carrid } ( { gt_scarr[ carrid = ls_sfpli-carrid ]-carrname } )| )                 " Hierarchy Node Text
          importing
            e_new_node_key       = data(lv_node_key)                  " Key of New Node Key
      ).

      loop at group ls_sfpli into data(ls_group).

        go_alvtree_spfli->add_node(
          exporting
            i_relat_node_key     = lv_node_key                  " Node Already in Tree Hierarchy
            i_relationship       = cl_gui_column_tree=>relat_last_child                  " How to Insert Node
            is_outtab_line       = ls_group                 " Attributes of Inserted Node
            i_node_text          = conv #( ls_group-connid )                  " Hierarchy Node Text
        ).

      endloop.

    endloop.

  endif.

  go_alvtree_spfli->frontend_update( ).

endform.
*&---------------------------------------------------------------------*
*& Form user_command_9000
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form user_command_9000 .

  save_ok = ok_code.
  clear ok_code.

  case save_ok.
    when ``.
    when ``.
    when others.
  endcase.



endform.
