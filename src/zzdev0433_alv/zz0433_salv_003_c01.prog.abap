*&---------------------------------------------------------------------*
*& Include          ZZ0433_SALV_001_C01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Include          ZZJHL_ALVTREE_TEMP_001_C01
*&---------------------------------------------------------------------*
include <cl_alv_control>.

class lcl_salv_event_receive definition deferred.

data: gs_layout           type lvc_s_layo,
      gs_variant          type disvariant,
      gt_fieldcat_spfli   type lvc_t_fcat,
      gt_fieldcat_sflight type lvc_t_fcat,
      gt_sort             type lvc_t_sort,       "ALV Sort field
      gt_exclude          type ui_functions,     "ALV Exclude
      gv_alvtitle         type lvc_title,
      gt_dropdown         type lvc_t_dral.       "

data: go_salv_spfli         type ref to cl_salv_table,
      go_salv_sflight       type ref to cl_salv_table,
      go_salv_event_handler type ref to lcl_salv_event_receive,
      go_events             type ref to cl_salv_events_table.

* Custom Container.
constants:
  c_cont_spfli type scrfname value 'CONT_SPFLI'.

data: go_cont_docking type ref to cl_gui_docking_container,
      go_splitter     type ref to cl_gui_splitter_container,
      go_cont_spfli   type ref to cl_gui_container,
      go_cont_sflight type ref to cl_gui_container.

class lcl_salv_event_receive definition.

  public section.

    methods on_added_function               " ADDED_FUNCTION
      for event if_salv_events_functions~added_function
      of cl_salv_events_table
      importing sender e_salv_function.

    methods on_double_click                 " DOUBLE_CLICK
      for event if_salv_events_actions_table~double_click
      of cl_salv_events_table
      importing sender row column.

    "hotspot & button click.
    methods on_link_click                   " LINK_CLICK
      for event if_salv_events_actions_table~link_click
      of cl_salv_events_table
      importing sender row column.

endclass.

class lcl_salv_event_receive implementation.

  method on_added_function.

    case sender.
      when go_salv_spfli.
      when go_events.




      when others.
    endcase.


  endmethod.

  method on_double_click.

    read table gt_spfli index row into data(ls_spfli).
    if sy-subrc eq 0.
      select * from sflight
        where carrid eq @ls_spfli-carrid
        and connid eq @ls_spfli-connid
        into corresponding fields of table @gt_sflight.
    endif.

    cl_gui_cfw=>set_new_ok_code( 'DUMMY' ).

  endmethod.

  method on_link_click.

    read table gt_spfli index row into data(ls_spfli).
    if sy-subrc eq 0.
      select * from sflight
        where carrid eq @ls_spfli-carrid
        and connid eq @ls_spfli-connid
        into corresponding fields of table @gt_sflight.
    endif.

    cl_gui_cfw=>set_new_ok_code( 'DUMMY' ).

  endmethod.

endclass.
