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
form set_on_f4_material.

  field-symbols: <ft_f4> type lvc_t_modi.

  if go_grid_sflight->is_ready_for_input( ) eq 0.
    go_grid_sflight->ms_on_f4-po_event_data->m_event_handled = 'X'.
    exit.
  endif.

  select from makt
    fields matnr as material,
           maktx as description
    where spras eq @sy-langu
    into table @data(lt_mat) up to 20 rows.


  clear go_grid_spfli->ms_on_f4-pt_f4_return.

  call function 'F4IF_INT_TABLE_VALUE_REQUEST'
    exporting
      retfield        = 'MATERIAL' " 필드 이름
      value_org       = 'S'
      display         = go_grid_sflight->ms_on_f4-p_display
    tables
      value_tab       = lt_mat
      return_tab      = go_grid_spfli->ms_on_f4-pt_f4_return
    exceptions
      parameter_error = 1
      no_values_found = 2
      others          = 3.

  if go_grid_sflight->is_ready_for_input( ) eq 0.
    go_grid_sflight->ms_on_f4-po_event_data->m_event_handled = 'X'.
    exit.
  endif.

  assign go_grid_sflight->ms_on_f4-po_event_data->m_data->* to <ft_f4>.

  if go_grid_spfli->ms_on_f4-pt_f4_return is not initial.

    append value #( fieldname = go_grid_sflight->ms_on_f4-p_fieldname
                    row_id = go_grid_sflight->ms_on_f4-ps_row_no-row_id
                    value = go_grid_spfli->ms_on_f4-pt_f4_return[ 1 ]-fieldval ) to <ft_f4>.

    append value #( fieldname = `DESCRIPTION`
                    row_id = go_grid_sflight->ms_on_f4-ps_row_no-row_id
                    value = lt_mat[ material = go_grid_spfli->ms_on_f4-pt_f4_return[ 1 ]-fieldval ]-description ) to <ft_f4>.

  endif.

  go_grid_sflight->ms_on_f4-po_event_data->m_event_handled = 'X'. "스탠다드 F4를 타지 말라는 의미

endform.
*&---------------------------------------------------------------------*
*& Form set_on_f4_partner
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_on_f4_partner .

  field-symbols: <ft_f4> type lvc_t_modi.

  if go_grid_sflight->is_ready_for_input( ) eq 0.
    go_grid_sflight->ms_on_f4-po_event_data->m_event_handled = 'X'.
    exit.
  endif.

  select from but000
    fields partner,
           name_org1
    where name_org1 ne @space
    into table @data(lt_bp) up to 20 rows.



  clear go_grid_spfli->ms_on_f4-pt_f4_return.

  call function 'F4IF_INT_TABLE_VALUE_REQUEST'
    exporting
      retfield        = 'PARTNER' " 필드 이름
      value_org       = 'S'
      display         = go_grid_sflight->ms_on_f4-p_display
    tables
      value_tab       = lt_bp
      return_tab      = go_grid_spfli->ms_on_f4-pt_f4_return
    exceptions
      parameter_error = 1
      no_values_found = 2
      others          = 3.

  if go_grid_sflight->is_ready_for_input( ) eq 0.
    go_grid_sflight->ms_on_f4-po_event_data->m_event_handled = 'X'.
    exit.
  endif.

  assign go_grid_sflight->ms_on_f4-po_event_data->m_data->* to <ft_f4>.

  if go_grid_spfli->ms_on_f4-pt_f4_return is not initial.

    append value #( fieldname = go_grid_sflight->ms_on_f4-p_fieldname
                    row_id = go_grid_sflight->ms_on_f4-ps_row_no-row_id
                    value = go_grid_spfli->ms_on_f4-pt_f4_return[ 1 ]-fieldval ) to <ft_f4>.

    append value #( fieldname = `NAME_ORG1`
                    row_id = go_grid_sflight->ms_on_f4-ps_row_no-row_id
                    value = lt_bp[ partner = go_grid_spfli->ms_on_f4-pt_f4_return[ 1 ]-fieldval ]-name_org1 ) to <ft_f4>.

  endif.

  go_grid_sflight->ms_on_f4-po_event_data->m_event_handled = 'X'. "스탠다드 F4를 타지 말라는 의미


endform.
