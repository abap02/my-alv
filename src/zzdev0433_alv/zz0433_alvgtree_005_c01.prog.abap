*&---------------------------------------------------------------------*
*& Include          ZZ0433_ALVGTREE_001_C01
*&---------------------------------------------------------------------*
include <cl_alv_control>.

class lcl_gui_alv_grid definition deferred.

data: gs_layout           type lvc_s_layo,
      gs_variant          type disvariant,
      gt_fieldcat_sflight type lvc_t_fcat,
      gt_sort             type lvc_t_sort,       "ALV Sort field
      gt_exclude          type ui_functions,     "ALV Exclude
      gv_alvtitle         type lvc_title,
      gt_dropdown         type lvc_t_dral.       "

*data: go_alvtree_sflight type ref to cl_gui_alv_tree.
data: go_alvtree_sflight type ref to lcl_gui_alv_grid.

data gs_treev_hhdr type treev_hhdr.

* Custom Container.
constants:
  c_cont_sflight type scrfname value 'CONT_SFLIGHT'.

data go_cont_docking type ref to cl_gui_docking_container.

class lcl_gui_alv_grid definition inheriting from cl_gui_alv_tree.

  public section.
    methods: on_function_selected "UserCommand.
      for event function_selected of cl_gui_toolbar
      importing sender fcode.

    methods: on_dropdown_clicked "menu.
      for event dropdown_clicked of cl_gui_toolbar
      importing sender fcode posx posy.

    methods handle_checkbox_change
      for event checkbox_change of cl_gui_alv_tree
      importing sender checked fieldname node_key.


endclass.

class lcl_gui_alv_grid implementation.

  method on_function_selected.

    case fcode.
      when `DELETE`.
        perform set_delete.
      when others.
    endcase.

  endmethod.


  method on_dropdown_clicked.

    data(lo_menus) = new cl_ctmenu( ).

    go_alvtree_sflight->get_toolbar_object(
      importing
        er_toolbar = data(lo_toolbar)                  " Toolbar Object
    ).

    lo_menus->add_function(
      exporting
        fcode             = `INFO`                  " Function code
        text              = `Information`                 " Function text
        icon              = icon_information                 " Icons
    ).

    lo_menus->add_function(
      exporting
        fcode             = `URL`                  " Function code
        text              = `Url`                 " Function text
        icon              = icon_url                 " Icons
    ).

    lo_toolbar->track_context_menu(
      exporting
        context_menu = lo_menus                 " Context Menu
        posx         = posx                  " X coordinate
        posy         = posy                 " Y Coordinate
*      exceptions
*        ctmenu_error = 1                " Error processing context menu
*        others       = 2
    ).
    if sy-subrc <> 0.
*     message id sy-msgid type sy-msgty number sy-msgno
*       with sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    endif.

  endmethod.


  method handle_checkbox_change.

    data: ls_outttab_line  type sflight,
          lt_outtab_layout type lvc_t_layi,
          ls_item_layout   type lvc_s_laci,
          lt_item_layout   type lvc_t_laci.


    case sender.
      when go_alvtree_sflight.

*   Get Checked Subtree node keys.
        go_alvtree_sflight->get_subtree(
          exporting
            i_node_key         = node_key                " Parent Node Key
        importing
          et_subtree_nodes   = data(lt_subtree_nodes)                 " Node Key Table of Children
        exceptions
          node_key_not_found = 1                " Node not Found in Model
          others             = 2
        ).

        if lt_subtree_nodes is not initial.

          loop at lt_subtree_nodes into data(ls_subtree_nodes).

            go_alvtree_sflight->get_outtab_line(
              exporting
                i_node_key     = ls_subtree_nodes                 " Node Key
              importing
                e_outtab_line  = ls_outttab_line                  " Line of Outtab
                et_item_layout = lt_outtab_layout
              exceptions
                node_not_found = 1                " Node does not exist
                others         = 2  ).

            read table lt_outtab_layout into data(ls_outtab_layout) index 1.
            if sy-subrc eq 0.

              ls_item_layout = corresponding #( ls_outtab_layout ).
              ls_item_layout-chosen = checked.
              ls_item_layout-u_chosen = abap_true.

              append ls_item_layout to lt_item_layout.

              go_alvtree_sflight->change_node(
                exporting
                  i_node_key     = ls_subtree_nodes                   " Key of Changed Line
                  i_outtab_line  = ls_outttab_line                 " Outtab Line to be Changed
                  it_item_layout = lt_item_layout                 " Item Layout
                exceptions
                  node_not_found = 1                " Node does not exist
                  others         = 2
              ).

              clear: lt_outtab_layout, lt_item_layout, ls_outttab_line.

            endif.

          endloop.

        else.




        endif.



      when others.
    endcase.

    cl_gui_cfw=>set_new_ok_code( 'DUMMY' ).

  endmethod.

endclass.
