*&---------------------------------------------------------------------*
*& Report ZZ0433_SALV_IDA_001
*&---------------------------------------------------------------------*
*& SALV IDA : Field Name & Sortable
*&---------------------------------------------------------------------*
report zz0433_salv_ida_002.

tables sflight.

select-options: s_carrid for sflight-carrid,
                s_connid for sflight-connid,
                s_fldate for sflight-fldate.

data: lt_fieldname type if_salv_gui_types_ida=>yts_field_name,
      lt_sortable  type if_salv_gui_types_ida=>yt_sort_rule.

start-of-selection.

  try.

      data(lo_salv_ida) = cl_salv_gui_table_ida=>create_for_cds_view(
        exporting
          iv_cds_view_name      = `ZZ0433CDS0001`
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


*   Filed Setting.
*  lt_fieldname = value #(
*    ( conv string('CARRID') )
*    ( conv string('CONNID') )
*    ( conv string('FLDATE') )
*    ( conv string('PLANETYPE') )
*    ( conv string('PRICE') )
*    ( conv string('CURRENCY') )
**    ( conv string('_SCHEDULE-CITYFROM') )
*   ).
*
*
*  try.
*      if lt_fieldname is not initial.
*        lo_salv_ida->field_catalog( )->set_available_fields( its_field_names = lt_fieldname ).
*      endif.
*
*      lo_salv_ida->field_catalog( )->get_all_fields(
*        importing
*          ets_field_names = data(lt_all_fieldname)
*      ).
*
*    catch cx_salv_ida_unknown_name. " Unknown name: FieldName,DataElementName,....
*
*  endtry.

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

  try.
      lo_salv_ida->selection( )->set_selection_mode(
          iv_mode = if_salv_gui_selection_ida=>cs_selection_mode-multi
      ).
    catch cx_salv_ida_contract_violation. " IDA API contract violated by caller.

  endtry.


*   Display.
  lo_salv_ida->fullscreen( )->display( ).
