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
endform.
*&---------------------------------------------------------------------*
*& Form set_on_f4_material
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_ON_F4
*&---------------------------------------------------------------------*
form set_on_f4_material  using ps_on_f4 type ty_on_f4.

  if go_grid_sflight->is_ready_for_input( ) eq 0.
    ps_on_f4-po_event_data->m_event_handled = 'X'.
    exit.
  endif.

  select from makt
    fields matnr as material,
           maktx as description
    where spras eq @sy-langu
    into table @data(lt_mat) up to 20 rows.


  clear gt_return.

  call function 'F4IF_INT_TABLE_VALUE_REQUEST'
    exporting
      retfield        = 'MATERIAL' " 필드 이름
      value_org       = 'S'
      display         = ps_on_f4-p_display
    tables
      value_tab       = lt_mat
      return_tab      = gt_return
    exceptions
      parameter_error = 1
      no_values_found = 2
      others          = 3.

  if go_grid_sflight->is_ready_for_input( ) eq 0.
    ps_on_f4-po_event_data->m_event_handled = 'X'.
    exit.
  endif.

  assign ps_on_f4-po_event_data->m_data->* to <ft_f4>.

  if gt_return is not initial.

    append value #( fieldname = ps_on_f4-p_fieldname
                    row_id = ps_on_f4-ps_row_no-row_id
                    value = gt_return[ 1 ]-fieldval ) to <ft_f4>.

    append value #( fieldname = `DESCRIPTION`
                    row_id = ps_on_f4-ps_row_no-row_id
                    value = lt_mat[ material = gt_return[ 1 ]-fieldval ]-description ) to <ft_f4>.

  endif.

  ps_on_f4-po_event_data->m_event_handled = 'X'. "스탠다드 F4를 타지 말라는 의미

endform.
