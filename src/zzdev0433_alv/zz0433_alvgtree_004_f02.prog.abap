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

  data: lt_node_keys    type lvc_t_nkey.

  go_alvtree_sflight->get_selected_nodes(
    changing
      ct_selected_nodes = lt_node_keys ).

  loop at lt_node_keys into data(ls_node_keys).

    go_alvtree_sflight->delete_subtree(
      exporting
        i_node_key                = ls_node_keys                  " Node to be Deleted
        i_update_parents_expander = abap_true ).
  endloop.



endform.
