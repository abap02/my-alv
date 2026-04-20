*&---------------------------------------------------------------------*
*& Include          ZZ0433_SALV_001_F02
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
    when ``.
    when ``.
    when others.
  endcase.

endform.
*&---------------------------------------------------------------------*
*& Form add_spfli_nodes
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form add_spfli_nodes .

  select * from spfli order by carrid descending, connid ascending  into table @data(lt_spfli).

  loop at lt_spfli into data(ls_spfli) group by ( carrid = ls_spfli-carrid ).

    go_salv_tree_spfli->get_nodes( )->add_node(
      exporting
        related_node   = space                 " Key to Related Node
        relationship   = cl_gui_column_tree=>relat_first_child                  " Node Relation in Tree
        text           = conv #( ls_spfli-carrid )                  " ALV Control: Cell Content
      receiving
        node           = data(lo_top_node)                  " Node Key
    ).

    loop at group ls_spfli into data(ls_group).

      go_salv_tree_spfli->get_nodes( )->add_node(
        exporting
          related_node   = lo_top_node->get_key( )                 " Key to Related Node
          relationship   = cl_gui_column_tree=>relat_last_child                  " Node Relation in Tree
          data_row = ls_group
          text = conv #( ls_group-connid )                  " ALV Control: Cell Content

      ).

    endloop.

  endloop.

endform.
