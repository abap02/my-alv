*&---------------------------------------------------------------------*
*& Include          ZZ0433_ALVGRID_001_C01
*&---------------------------------------------------------------------*

include <cl_alv_control>.

class lcl_gui_alv_grid definition deferred.

types:begin of ty_on_f4,
        po_sender     type ref to cl_gui_alv_grid,
        p_fieldname   type  lvc_fname,
        p_fieldvalue  type  lvc_value,
        ps_row_no     type  lvc_s_roid,
        po_event_data type ref to	cl_alv_event_data,
        pt_bad_cells  type  lvc_t_modi,
        p_display     type  char01,
      end of ty_on_f4.

data: gs_layout         type lvc_s_layo,
      gs_variant        type disvariant,
      gt_fieldcat_spfli type lvc_t_fcat,
      gt_sort           type lvc_t_sort,       "ALV Sort field
      gt_exclude        type ui_functions,     "ALV Exclude
      gv_alvtitle       type lvc_title,
      gt_dropdown       type lvc_t_dral.       "

*-----/// ALV F4
field-symbols: <ft_f4> type lvc_t_modi.
data: gs_f4_alv type lvc_s_modi,
      gt_return type table of ddshretval,
      gt_f4     type lvc_t_f4,
      gs_f4     type lvc_s_f4.


*   Dropdown.
types: begin of gty_s_alv_dropdown_list.
         include type lvc_s_dral.
types:   valpos   type valpos,
         mc_value type lvc_s_dral-value,
       end of gty_s_alv_dropdown_list.

types: gty_t_alv_dropdown_list type table of gty_s_alv_dropdown_list with non-unique sorted key skey components handle valpos
                                                                     with non-unique sorted key ikey components handle int_value
                                                                     with non-unique sorted key vkey components handle value.


* ALV Grid Object.
data: go_grid_spfli   type ref to lcl_gui_alv_grid.

data: go_custom_container type ref to cl_gui_custom_container,
      go_splitter         type ref to cl_gui_splitter_container,
      go_cont_spfli       type ref to cl_gui_container,
      go_cont_docking     type ref to cl_gui_docking_container.

* Custom Container.
constants:
  c_cont_spfli type scrfname value 'CONT_SPFLI'.


class lcl_gui_alv_grid definition inheriting from zz0433cl_alv_grid.

  public section.
    methods display_alv_values redefinition.

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
        cl_gui_cfw=>set_new_ok_code( 'DOUBLE_SPFLI' ).

      when others.
    endcase.


  endmethod.

endclass.
