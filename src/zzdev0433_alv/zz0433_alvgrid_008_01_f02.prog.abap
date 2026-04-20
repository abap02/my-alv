*&---------------------------------------------------------------------*
*& Include          ZZ0433_ALVGRID_001_F02
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
    when `DOUBLE_SPFLI`.
      perform set_double_click_spfli.
    when `HOTSPOT_CONNID`.
      perform set_hotspot_spfli_connid.
    when others.
  endcase.


endform.
*&---------------------------------------------------------------------*
*& Form set_double_click_spfli
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_double_click_spfli .
  perform get_sflight_data.
endform.
*&---------------------------------------------------------------------*
*& Form set_hotspot_spfli_connid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_hotspot_spfli_connid .
  perform get_sflight_data.

endform.
*&---------------------------------------------------------------------*
*& Form get_sflight_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form get_sflight_data .

  select * from sflight
    where carrid eq @gs_spfli-carrid
    and connid eq @gs_spfli-connid
    into corresponding fields of table @gt_sflight.
  if sy-subrc eq 0.

    perform clear_sflight_cellstyle.

    loop at gt_sflight assigning field-symbol(<fs_sflight>).

      if <fs_sflight>-seatsocc ge 100.

        go_grid_sflight->set_fieldname_for_color(
          exporting
            iv_fieldname  = `SEATSOCC`
            iv_color_code = `310`
          receiving
            ct_cellcolor  = <fs_sflight>-cellcolor
        ).

        go_grid_sflight->set_fieldname_for_input(
          exporting
            iv_fieldname = `SEATSOCC`
            is_input     = space
          receiving
            ct_celltab   = <fs_sflight>-celltab
        ).

      else.

        go_grid_sflight->set_fieldname_for_input(
          exporting
            iv_fieldname = `SEATSOCC`
            is_input     = abap_true
          receiving
            ct_celltab   = <fs_sflight>-celltab
        ).

      endif.

    endloop.

  endif.

  go_grid_sflight->refresh_alv_grid( ).

endform.
*&---------------------------------------------------------------------*
*& Form clear_sflight_cellcolor
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form clear_sflight_cellstyle.

  loop at gt_sflight assigning field-symbol(<fs_sflight>).
    if <fs_sflight>-cellcolor is not initial.
      clear <fs_sflight>-cellcolor.
    endif.

    if <fs_sflight>-celltab is not initial.
      clear <fs_sflight>-celltab.
    endif.
  endloop.

endform.
