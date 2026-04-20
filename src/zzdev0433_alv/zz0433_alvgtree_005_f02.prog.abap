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
    when `DELETE`.
      perform set_delete.
    when `INFO`.
      message |information| type `I`.
    when `URL`.
      message |url| type `I`.
    when others.
  endcase.



endform.
*&---------------------------------------------------------------------*
*& Form set_delete
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_delete .

*--------Checkbox Event 적용된 경우 -------
  go_alvtree_sflight->get_checked_items(
    importing
      et_checked_items = data(lt_checked_nodes)                 " Item table
  ).

*--------Checkbox Event 적용된 경우 END-------

  loop at lt_checked_nodes into data(ls_node_keys).

    go_alvtree_sflight->delete_subtree(
      exporting
        i_node_key                = ls_node_keys-nodekey                  " Node to be Deleted
        i_update_parents_expander = abap_true
      exceptions
        node_key_not_in_model     = 1                " Node not Found in Model
        others                    = 2 ).

  endloop.

endform.
