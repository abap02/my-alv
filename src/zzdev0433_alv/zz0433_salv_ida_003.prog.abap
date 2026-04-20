*&---------------------------------------------------------------------*
*& Report ZZ0433_SALV_IDA_003
*&---------------------------------------------------------------------*
*& SALV IDA : in Screen
*&---------------------------------------------------------------------*
report zz0433_salv_ida_003.

tables sflight.

data: ok_code      type sy-ucomm,
      save_ok      type sy-ucomm,
      go_container type ref to cl_gui_custom_container.


data go_salv_ida type ref to if_salv_gui_table_ida.


selection-screen begin of screen 2000 as subscreen.
  select-options s_carrid for sflight-carrid .
selection-screen end of screen 2000.


start-of-selection.



  call screen '9000'.




*&---------------------------------------------------------------------*
*& Module STATUS_9000 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module status_9000 output.
  set pf-status 'S9000'.
* SET TITLEBAR 'xxx'.
endmodule.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
module user_command_9000 input.

  save_ok = ok_code.
  clear ok_code.

  case save_ok.
    when `BACK` or `EXIT` or `CANC`.
      leave to screen 0.

    when `EXEC`.
      perform get_data.

    when others.
  endcase.

endmodule.
*&---------------------------------------------------------------------*
*& Module SET_SALV_IDA OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
module set_salv_ida output.
  perform set_salv_ida.
endmodule.
*&---------------------------------------------------------------------*
*& Form set_salv_ida
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_salv_ida .

  if go_container is initial.

    try.

        go_container = new #( container_name = `C_CONT`  ).

        go_salv_ida = cl_salv_gui_table_ida=>create_for_cds_view(
          exporting
            io_gui_container = go_container
            iv_cds_view_name      = `ZZ0433CDS0001`
        ).

      catch cx_salv_db_connection.          " Error connecting to database
      catch cx_salv_db_table_not_supported. " DB table / view is not supported
      catch cx_salv_ida_contract_violation. " IDA API contract violated by caller
      catch cx_salv_function_not_supported. " Funcionality is not supported

    endtry.



*    go_salv_ida->refresh( ).
*    catch cx_salv_ida_contract_violation. " IDA API contract violated by caller

  endif.


endform.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form get_data .

  data(lo_ranges) = new cl_salv_range_tab_collector( ).

  lo_ranges->add_ranges_for_name( exporting iv_name = `CARRID` it_ranges = s_carrid[] ).
*  lo_ranges->add_ranges_for_name( exporting iv_name = `CONNID` it_ranges = s_carrid[] ).

  lo_ranges->get_collected_ranges( importing et_named_ranges = data(lt_named_ranges) ).

  try.
      go_salv_ida->set_select_options( exporting it_ranges = lt_named_ranges ).

    catch cx_salv_ida_associate_invalid. " Superclass for all dynamic ALV IDA exceptions
      break-point.
    catch cx_salv_db_connection.         " Error connecting to database
      break-point.
    catch cx_salv_ida_condition_invalid. " Superclass for all dynamic ALV IDA exceptions
      break-point.
    catch cx_salv_ida_unknown_name.      " Unknown name: FieldName,DataElementName,...
      break-point.

  endtry.


  go_salv_ida->refresh( ).

endform.
