*&---------------------------------------------------------------------*
*& Report ZZ0433_SALV_IDA_001
*&---------------------------------------------------------------------*
*& SALV IDA : Event
*&---------------------------------------------------------------------*
report zz0433_salv_ida_004.

tables sflight.

select-options: s_carrid for sflight-carrid,
                s_connid for sflight-connid,
                s_fldate for sflight-fldate.



data: lo_salv_ida type ref to if_salv_gui_table_ida.



data: lt_fieldname type if_salv_gui_types_ida=>yts_field_name,
      lt_sortable  type if_salv_gui_types_ida=>yt_sort_rule.



class lcl_event definition.
  public section.



    methods:
      constructor
        importing
          io_salv_ida type ref to if_salv_gui_table_ida,

      handle_double_click
        for event double_click of if_salv_gui_table_display_opt
        importing ev_field_name
                  eo_row_data,

      handle_toolbar
        for event function_selected of if_salv_gui_toolbar_ida
        importing ev_fcode.

    data: mo_salv_ida type ref to if_salv_gui_table_ida.

endclass.

class lcl_event implementation.

  method constructor.
    mo_salv_ida = io_salv_ida.
  endmethod.

  method handle_double_click.

    data ls_airline type zz0433cds0001.

    try.
        eo_row_data->get_row_data(
          importing
            es_row               = ls_airline
        ).
      catch cx_salv_ida_contract_violation. " IDA API contract violated by caller
      catch cx_salv_ida_sel_row_deleted.    " Selected Row at UI does no longer exist

    endtry.

*     Single Mode.
*    check lo_salv_ida->selection( )->is_row_selected( ).
*
*    try.
*        lo_salv_ida->selection( )->get_selected_row(
*          importing
*            es_row               = ls_airline
*        ).
*
*      catch cx_salv_ida_row_key_invalid.    " Key leads to more than one return row
*      catch cx_salv_ida_contract_violation. " IDA API contract violated by caller
*      catch cx_salv_ida_sel_row_deleted.    " Selected Row at UI does no longer exist.
*
*    endtry.
*


  endmethod.


  method handle_toolbar.

    case ev_fcode.
      when `TOOLBAR_DELETE`.
      when others.
    endcase.

  endmethod.


endclass.


class lcl_calculate_fields definition.
  public section.
    interfaces if_salv_ida_calc_field_handler.

    types: begin of mty_custom_fields,
             amount  type netwr,
             average type netwr,
           end of mty_custom_fields.
endclass.

class lcl_calculate_fields implementation.


*   Redefine.
  method if_salv_ida_calc_field_handler~get_calc_field_structure.

    ro_calc_field_structure ?= cl_abap_typedescr=>describe_by_name( `MTY_CUSTOM_FIELDS` ).

  endmethod.

  method if_salv_ida_calc_field_handler~get_requested_fields.

    rts_db_field_name = value #( ( conv string( `PRICE` ) ) ).
    rts_db_field_name = value #( ( conv string( `PRICE` ) ) ).

  endmethod.

  method if_salv_ida_calc_field_handler~calculate_line.

    data: ls_airline    type zz0433cds0001,
          ls_cai_fields type mty_custom_fields.

    ls_airline = is_data_base_line.
    ls_cai_fields-amount = ls_airline-price * ls_airline-seatsocc.
    try.
        ls_cai_fields-average = ls_airline-paymentsum / ls_airline-seatsocc.
      catch cx_sy_zerodivide.
        ls_cai_fields-average = 0.
    endtry.

    es_calculated_fields = ls_cai_fields.

  endmethod.

  method if_salv_ida_calc_field_handler~end_page.
  endmethod.

  method if_salv_ida_calc_field_handler~start_page.
  endmethod.


endclass.


start-of-selection.

  try.

      lo_salv_ida = cl_salv_gui_table_ida=>create_for_cds_view(
        exporting
          iv_cds_view_name      = `ZZ0433CDS0001`
          io_calc_field_handler = new lcl_calculate_fields( )
      ).

    catch cx_salv_db_connection.          " Error connecting to database
    catch cx_salv_db_table_not_supported. " DB table / view is not supported
    catch cx_salv_ida_contract_violation. " IDA API contract violated by caller
    catch cx_salv_function_not_supported. " Funcionality is not supported

  endtry.

*  Select Condition.
  data(lo_ranges) = new cl_salv_range_tab_collector( ).

  lo_ranges->add_ranges_for_name( exporting iv_name = `CARRID` it_ranges = s_carrid[] ).
  lo_ranges->add_ranges_for_name( exporting iv_name = `CONNID` it_ranges = s_connid[] ).
  lo_ranges->add_ranges_for_name( exporting iv_name = `FLDATE` it_ranges = s_fldate[] ).

  lo_ranges->get_collected_ranges( importing et_named_ranges = data(lt_named_ranges) ).

  lo_salv_ida->set_select_options( exporting it_ranges = lt_named_ranges ).


  lo_salv_ida->field_catalog( )->set_field_header_texts(
    exporting
      iv_field_name        = `AMOUNT`
      iv_header_text       = `Amount`
      iv_tooltip_text      = `Amount`
      iv_tooltip_text_long = `Amount`
  ).

  lo_salv_ida->field_catalog( )->set_field_header_texts(
    exporting
      iv_field_name        = `AVERAGE`
      iv_header_text       = `Average`
      iv_tooltip_text      = `Average`
      iv_tooltip_text_long = `Average`
  ).

*   Sortable.
  append value #(
    field_name = `CARRID`
    is_grouped = abap_true
   ) to lt_sortable.

  append value #(
    field_name = `CONNID`
    descending = space
   ) to lt_sortable.


  append value #(
    field_name = `FLDATE`
    descending = space
   ) to lt_sortable.

  try.
      lo_salv_ida->default_layout( )->set_sort_order( it_sort_order = lt_sortable ).
    catch cx_salv_ida_unknown_name.   " Unknown name: FieldName,DataElementName,...
    catch cx_salv_ida_duplicate_name. " Duplicate name: FieldName,DataElementName,....
  endtry.

*   Display Options.
  lo_salv_ida->display_options( )->set_empty_table_text( iv_empty_table_text = conv #( `No Data 122344` ) ).
  lo_salv_ida->display_options( )->enable_alternating_row_pattern( )."Zebra.
  lo_salv_ida->display_options( )->set_title( iv_title = `SAL IDA Fight` ).
  lo_salv_ida->display_options( )->enable_double_click( ).

  try.
      lo_salv_ida->selection( )->set_selection_mode(
          iv_mode = if_salv_gui_selection_ida=>cs_selection_mode-multi
*          iv_mode = if_salv_gui_selection_ida=>cs_selection_mode-single
      ).
    catch cx_salv_ida_contract_violation. " IDA API contract violated by caller.

  endtry.

*   Toolbar.
  lo_salv_ida->toolbar( )->add_separator( ).

  try.
      lo_salv_ida->toolbar( )->add_button(
        exporting
          iv_fcode                     = `TOOLBAR_DELETE`
          iv_icon                      = icon_delete_row                 " Name of an Icon
          iv_text                      = `Delete`
          iv_quickinfo                 = `Delete`
      ).
    catch cx_salv_ida_gui_fcode_reserved. " FunctionCode not defined
  endtry.

*   Events.
  data(lo_event) = new lcl_event( io_salv_ida = lo_salv_ida ).

  set handler lo_event->handle_double_click for lo_salv_ida->display_options( ).
  set handler lo_event->handle_toolbar for lo_salv_ida->toolbar( ).

  data(lo_fcat) = lo_salv_ida->field_catalog( ).

*   Display.
  lo_salv_ida->fullscreen( )->display( ).
