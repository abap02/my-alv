*&---------------------------------------------------------------------*
*& Report ZZ0433_SALV_IDA_001
*&---------------------------------------------------------------------*
*& SALV IDA : Select Option
*&---------------------------------------------------------------------*
report zz0433_salv_ida_001.

tables scarr.

select-options s_carrid for scarr-carrid.


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
  data(lo_cond_factory) = lo_salv_ida->condition_factory( ).

  data(lo_ranges) = new cl_salv_range_tab_collector( ).

  lo_ranges->add_ranges_for_name(
    exporting
      iv_name   = `CARRID`
      it_ranges = s_carrid[]
  ).

  lo_ranges->get_collected_ranges(
    importing
      et_named_ranges = data(lt_named_ranges)
  ).

  lo_salv_ida->set_select_options(
    exporting
      it_ranges    = lt_named_ranges
  ).




*   Display.
  lo_salv_ida->fullscreen( )->display( ).
