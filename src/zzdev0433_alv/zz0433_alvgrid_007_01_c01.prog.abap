*&---------------------------------------------------------------------*
*& Include          ZZ0433_ALVGRID_001_C01
*&---------------------------------------------------------------------*

include <cl_alv_control>.

class lcl_gui_alv_grid definition deferred.


* ALV Grid Object.
data: go_grid_spfli   type ref to lcl_gui_alv_grid,
      go_grid_sflight type ref to lcl_gui_alv_grid.

data: go_custom_container type ref to cl_gui_custom_container,
      go_splitter         type ref to cl_gui_splitter_container,
      go_cont_spfli       type ref to cl_gui_container,
      go_cont_sflight     type ref to cl_gui_container,
      go_cont_docking     type ref to cl_gui_docking_container.

* Custom Container.
constants:
  c_cont_spfli type scrfname value 'CONT_SPFLI'.


class lcl_gui_alv_grid definition inheriting from zz0433cl_alv_grid_01.

  public section.
    methods display_alv_values redefinition.

    methods handle_toolbar redefinition.
    methods handle_user_command redefinition.
    methods handle_double_click redefinition.
    methods handle_hotspot_click redefinition.

    methods handle_data_changed redefinition.
    methods handle_data_changed_finished redefinition.


endclass.

class lcl_gui_alv_grid implementation.

  method display_alv_values.

    data(lo_data) = super->display_alv_values(
       exporting
         sender    = sender                 " ALV GRID
         e_row     = e_row                 " ALV control: Line description
         e_column  = e_column                 " ALV Control: Column ID
         es_row_no = es_row_no                 " Assignment of Row Number to Row ID
     ).

    assign lo_data->* to field-symbol(<fs_data>).


    case sender.
      when go_grid_spfli.

        gs_spfli = corresponding #( <fs_data> ).

        data(lv_hotspot_fieldname) = go_grid_spfli->get_hotspot_fieldname( ).

        if go_grid_spfli->get_hotspot_fieldname( ) is not initial.
          cl_gui_cfw=>set_new_ok_code( |HOTSPOT_{ lv_hotspot_fieldname }| ).
        else.
          cl_gui_cfw=>set_new_ok_code( 'DOUBLE_SPFLI' ).
        endif.


      when others.
    endcase.


  endmethod.

  method handle_toolbar.

    define _add_toolbar.
      insert value #(
        butn_type = 0
        function  = &1
        icon      = &2
        text      = &3
        quickinfo = &3
        disabled  = &4
        ) into table e_object->mt_toolbar.
    end-of-definition.

    case sender.
      when go_grid_spfli.
        _add_toolbar: 'SPFLI_SELALL' c_select_all `Select All` space.
        _add_toolbar: 'SPFLI_DESELALL' c_deselect_all `Deselect All` space.
        insert value #( butn_type = 3 ) into table e_object->mt_toolbar.
        _add_toolbar: 'SPFLI_DELETE' c_delete `Delete` space.
        _add_toolbar: 'SPFLI_DISPLAY' c_display `Display` space.

    endcase.

  endmethod.

  method handle_user_command.
*  through to PAI Usercommand.
    cl_gui_cfw=>set_new_ok_code( conv #( e_ucomm ) ).

  endmethod.

  method handle_double_click.

    me->mv_double_click_fieldname = e_column.
    me->mv_double_click_rowid = es_row_no-row_id.

    me->display_alv_values(
      exporting
        sender    = sender
        e_row     = e_row
        e_column  = e_column
        es_row_no = es_row_no ).

    me->set_line_color( es_row_no-row_id ).

  endmethod.

  method handle_hotspot_click.

    me->mv_hotspot_fieldname = e_column_id-fieldname.
    me->mv_hotspot_rowid = es_row_no-row_id.

    me->display_alv_values(
      exporting
        sender    = sender
        e_row     = e_row_id
        e_column  = e_column_id
        es_row_no = es_row_no ).


  endmethod.

  method handle_data_changed.

    perform handle_data_changed using sender
                                      er_data_changed
                                      e_onf4
                                      e_onf4_before
                                      e_onf4_after
                                      e_ucomm.

  endmethod.


  method handle_data_changed_finished.

    perform handle_data_changed_finished using sender
                                                e_modified
                                                et_good_cells.

    check e_modified is not initial.

    me->refresh_alv_grid( iv_opt = abap_true ).

  endmethod.
endclass.
