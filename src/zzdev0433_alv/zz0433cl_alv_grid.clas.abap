class zz0433cl_alv_grid definition
  public
  inheriting from cl_gui_alv_grid
  create public .

  public section.

    interfaces zz0433if_alvgrid_receive .

    aliases handle_after_user_command
      for zz0433if_alvgrid_receive~handle_after_user_command .
    aliases handle_before_user_command
      for zz0433if_alvgrid_receive~handle_before_user_command .
    aliases handle_button_click
      for zz0433if_alvgrid_receive~handle_button_click .
    aliases handle_data_changed
      for zz0433if_alvgrid_receive~handle_data_changed .
    aliases handle_data_changed_finished
      for zz0433if_alvgrid_receive~handle_data_changed_finished .
    aliases handle_double_click
      for zz0433if_alvgrid_receive~handle_double_click .
    aliases handle_hotspot_click
      for zz0433if_alvgrid_receive~handle_hotspot_click .
    aliases handle_on_f4
      for zz0433if_alvgrid_receive~handle_on_f4 .
    aliases handle_toolbar
      for zz0433if_alvgrid_receive~handle_toolbar .
    aliases handle_top_of_page
      for zz0433if_alvgrid_receive~handle_top_of_page .
    aliases handle_user_command
      for zz0433if_alvgrid_receive~handle_user_command .

    types:
      begin of ts_register_event,
*          onf1                         type abap_bool,
        onf4                  type abap_bool,
        data_changed          type abap_bool,
*          ondropgetflavor              type abap_bool,
*          ondrag                       type abap_bool,...
*          ondrop                       type abap_bool,
*          ondropcomplete               type abap_bool,
*          subtotal_text                type abap_bool,
        before_user_command   type abap_bool,
        user_command          type abap_bool,
        after_user_command    type abap_bool,
        double_click          type abap_bool,
*          delayed_callback             type abap_bool,
*          delayed_changed_sel_callback type abap_bool,
*          print_top_of_page            type abap_bool,
*          print_top_of_list            type abap_bool,
*          print_end_of_page            type abap_bool,
*          print_end_of_list            type abap_bool,
        top_of_page           type abap_bool,
*          context_menu_request         type abap_bool,
*          menu_button                  type abap_bool,
        toolbar               type abap_bool,
        hotspot_click         type abap_bool,
*          end_of_list                  type abap_bool,
*          after_refresh                type abap_bool,
        button_click          type abap_bool,
        data_changed_finished type abap_bool,
*          drop_external_files   type abap_bool,
*          _before_refresh              type abap_bool,

      end of ts_register_event .

    methods display_alv_values
      importing
        !sender        type ref to cl_gui_alv_grid
        !e_row         type lvc_s_row
        !e_column      type lvc_s_col
        !es_row_no     type lvc_s_roid
      returning
        value(rs_data) type ref to data .
    methods get_double_click_fieldname
      returning
        value(rv_fieldname) type fieldname .
    methods get_double_click_rowid
      returning
        value(rv_rowid) type int4 .
    methods get_grid_ucomm_status
      returning
        value(rv_status) type char1 .
    methods get_hotspot_click_rowid
      returning
        value(rv_rowid) type int4 .
    methods get_hotspot_fieldname
      returning
        value(rv_fieldname) type fieldname .
    methods get_registed_events
      returning
        value(rs_events) type ts_register_event .
    methods is_grid_event
      returning
        value(rv_event_bool) type abap_bool .
    methods make_fieldcat_by_itab
      importing
        !iv_no_mant        type abap_bool optional
        !it_itab           type standard table
      changing
        value(ct_fieldcat) type lvc_t_fcat .
    methods refresh_alv_grid
      importing
        !iv_opt type abap_bool optional .
    methods set_fieldname_for_color
      importing
        !iv_fieldname       type lvc_fname
        !iv_color_code      type char3
      returning
        value(ct_cellcolor) type lvc_t_scol .
    methods set_fieldname_for_input
      importing
        !iv_fieldname     type lvc_fname
        !is_input         type abap_bool
      returning
        value(ct_celltab) type lvc_t_styl .
    methods set_grid_ucomm_status
      importing
        !iv_status type char1 .
    methods set_init_toolbar
      changing
        !ct_toolbar_excluding type ui_functions .
    methods set_line_color
      importing
        !iv_grid_row_id type int4
        !lv_color_code  type char4 default 'C700' .
    methods set_registor_events
      importing
        !is_register_events type ts_register_event .
protected section.

  data MS_REGISTER_EVENTS type TS_REGISTER_EVENT .
  data MS_STABLE type LVC_S_STBL value 'XX' ##NO_TEXT.
  data MV_DOUBLE_CLICK_FIELDNAME type FIELDNAME .
  data MV_DOUBLE_CLICK_ROWID type INT4 .
  data MV_GRID_EVENT type ABAP_BOOL .
  data MV_GRID_UCOMM_STATUS type CHAR1 value 'D' ##NO_TEXT.
  data MV_HOTSPOT_FIELDNAME type FIELDNAME .
  data MV_HOTSPOT_ROWID type INT4 .
private section.

  methods SET_ALV_GRID_OPTIMIZE .
  methods SET_GRID_EVENTS .
ENDCLASS.



CLASS ZZ0433CL_ALV_GRID IMPLEMENTATION.


  method get_double_click_fieldname.

    rv_fieldname = mv_double_click_fieldname.
    clear mv_double_click_fieldname.

  endmethod.


  method get_double_click_rowid.
    rv_rowid = mv_double_click_rowid.
    clear mv_double_click_rowid.
  endmethod.


  method get_grid_ucomm_status.
    " N = New mode.
    " D = Display mode.
    " M = Change/Modify mode.
    rv_status = mv_grid_ucomm_status.
*    clear mv_grid_ucomm_status.
  endmethod.


  method get_hotspot_click_rowid.
    rv_rowid = mv_hotspot_rowid.
    clear mv_hotspot_rowid.
  endmethod.


  method get_hotspot_fieldname.
    rv_fieldname = mv_hotspot_fieldname.
    clear mv_hotspot_fieldname.
  endmethod.


  method get_registed_events.
    rs_events = corresponding #( ms_register_events ).
  endmethod.


  method is_grid_event.
    rv_event_bool = mv_grid_event.
  endmethod.


  method make_fieldcat_by_itab.

    data: s_fcat type lvc_s_fcat.

*  Returning  VALUE( RT_FCAT )  TYPE LVC_T_FCAT
    data: lo_columns      type ref to cl_salv_columns_table,
          lo_aggregations type ref to cl_salv_aggregations,
          lo_salv_table   type ref to cl_salv_table,
          lr_table        type ref to data.

    field-symbols <table> type standard table.

*   create unprotected table from import data
    create data lr_table like it_itab[].
    assign lr_table->* to <table>.

*  ...New SALV Instance ...............................................
    try.
        cl_salv_table=>factory(
        exporting
          list_display = abap_false
        importing
          r_salv_table = lo_salv_table
        changing
          t_table      = <table> ).
      catch cx_salv_msg.                                "#EC NO_HANDLER
    endtry.

*   get columns object (raw fieldcatalog)
    lo_columns  = lo_salv_table->get_columns( ).

*   get aggregationss object (sorts)
    lo_aggregations = lo_salv_table->get_aggregations( ).

    ct_fieldcat =
    cl_salv_controller_metadata=>get_lvc_fieldcatalog(
    r_columns      = lo_columns
    r_aggregations = lo_aggregations ).

*   Delete Mandt
    if iv_no_mant is not initial.
      delete ct_fieldcat where fieldname = 'MANDT'.
    endif.

*   Set column position



    loop at ct_fieldcat assigning field-symbol(<fs_fieldcat>).
      <fs_fieldcat>-col_pos = sy-tabix.
    endloop.


  endmethod.


  method refresh_alv_grid.

    me->refresh_table_display( is_stable = ms_stable ).

    if iv_opt eq abap_true.
      me->set_alv_grid_optimize( ).
    endif.

  endmethod.


  method set_alv_grid_optimize.

    me->optimize_all_cols( 1 ).
  endmethod.


  method set_fieldname_for_color.

    data: ls_cellcolor type lvc_s_scol,
          ls_color     type lvc_s_colo.

    clear ct_cellcolor.

    ls_cellcolor = value #(
      fname = iv_fieldname
      color-col = conv i( iv_color_code+0(1)  )
      color-int = conv i( iv_color_code+1(1)  )
      color-inv = conv i( iv_color_code+2(1)  )
    ).

    insert ls_cellcolor into table ct_cellcolor.
  endmethod.


  method set_fieldname_for_input.
    data ls_celltab type lvc_s_styl.

*    clear c_celltab." 복수개 필드 적용시 주석 필요.

    ls_celltab = value #(
      fieldname = iv_fieldname
      style = cond #(
               when is_input eq abap_true then cl_gui_alv_grid=>mc_style_enabled
               when is_input eq abap_false then cl_gui_alv_grid=>mc_style_disabled )
    ).

    insert ls_celltab into table ct_celltab.
  endmethod.


  method set_grid_events.

    me->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_modified ).

    if ms_register_events-onf4 eq abap_true.
      set handler me->handle_on_f4 for me.
    endif.

    if ms_register_events-user_command eq abap_true.
      set handler me->handle_user_command for me.
    endif.

    if ms_register_events-double_click eq abap_true.
      set handler me->handle_double_click for me.
    endif.

    if ms_register_events-top_of_page eq abap_true.
      set handler me->handle_top_of_page for me.
    endif.

    if ms_register_events-toolbar eq abap_true.
      set handler me->handle_toolbar for me.
    endif.

    if ms_register_events-hotspot_click eq abap_true.
      set handler me->handle_hotspot_click for me.
    endif.

    if ms_register_events-button_click eq abap_true.
      set handler me->handle_button_click for me.
    endif.

    if ms_register_events-data_changed eq abap_true.
      set handler me->handle_data_changed for me.
    endif.

    if ms_register_events-data_changed_finished eq abap_true.
      set handler me->handle_data_changed_finished for me.
    endif.

  endmethod.


  method set_grid_ucomm_status.
    " N = New mode.
    " D = Display mode.
    " M = Change/Modify mode.

    mv_grid_ucomm_status = iv_status.
  endmethod.


  method set_init_toolbar.

    clear ct_toolbar_excluding.

    define _append_exclude.
      append cl_gui_alv_grid=>&1 to ct_toolbar_excluding.
    end-of-definition.


    _append_exclude:  mc_fc_loc_undo,           "Undo
*                    mc_fc_detail,             "Choose Detail
*                    mc_fc_deselect_all,
*                    mc_fc_select_all,
                    mc_fc_check,              "Check Entries
                    mc_fc_graph,              "Graphic
                    mc_fc_help,               "Help
                    mc_fc_info,               "Information
                    mc_fc_loc_copy,           "Local: Copy
                    mc_fc_html,               "HTML Download
                    mc_fc_loc_copy_row,       "Local: Copy Row
                    mc_fc_loc_cut,            "Local: Cut
                    mc_fc_loc_delete_row,     "Local: Delete Row
                    mc_fc_loc_insert_row,     "Local: Insert Row
                    mc_fc_loc_move_row,       "Local: Move Row
                    mc_fc_loc_append_row,     "Local: Append Row
                    mc_fc_loc_paste,          "Local: Paste
                    mc_fc_loc_paste_new_row,   "Locally: Paste new Row
                    mc_fc_print_prev,          "Print Preview
                    mc_fc_print,          "Print
                    mc_fc_views,          "Views.
                    mc_fc_refresh.             "Refresh
*                  mc_fc_excl_all.           " Exclude All

  endmethod.


  method set_line_color.

    data: lo_table_descr type ref to cl_abap_tabledescr,
          lo_struc_descr type ref to cl_abap_structdescr.

    "===================
    data(linecolor) = 'LINECOLOR'.
    data(cellcolor) = 'CELLCOLOR'.

    field-symbols  <lt_table> type standard table.
    field-symbols <fs_field> type any.

    assign me->mt_outtab->* to <lt_table>.
    if <lt_table> is not assigned.
      exit.
    endif.

    lo_table_descr ?= cl_abap_tabledescr=>describe_by_data( <lt_table> ).
    lo_struc_descr ?= lo_table_descr->get_table_line_type( ).

    if line_exists( lo_struc_descr->components[ name = linecolor ] )." LINECOLOR 필드 존재여부 확인.

      assign (linecolor) to <fs_field>.

      "기존 선택된 라인 색상 지우기.
      read table <lt_table> with key (<fs_field>) = lv_color_code assigning field-symbol(<ls_outtab>).
      if sy-subrc eq 0.
        assign component linecolor of structure <ls_outtab> to field-symbol(<linecolor>).
        if <linecolor> is assigned.
          clear <linecolor>.
        endif.
      endif.

      "새로 선택된 라인 색상 값 부여.
      read table <lt_table> index iv_grid_row_id assigning <ls_outtab>.
      if sy-subrc eq 0.
        assign component linecolor of structure <ls_outtab> to <linecolor>.
        if <linecolor> is assigned.
          <linecolor> = lv_color_code.
        endif.

        assign component cellcolor of structure <ls_outtab> to field-symbol(<cellcolor>).
        if <cellcolor> is assigned.
          clear <cellcolor>.
        endif.
      endif.

    endif.
  endmethod.


  method set_registor_events.
    ms_register_events = is_register_events.

    me->set_grid_events(  ).
  endmethod.


  method display_alv_values.

    data lo_struct type ref to cl_abap_structdescr.

    field-symbols <lt_outtab> type standard table.

    check e_row-index is not initial.

    assign me->mt_outtab->* to <lt_outtab>.

    check <lt_outtab> is assigned.

    read table <lt_outtab> assigning field-symbol(<ls_outtab>) index e_row-index.
    if sy-subrc eq 0.

      lo_struct ?= cl_abap_typedescr=>describe_by_data( <ls_outtab> ).

      create data rs_data type handle lo_struct.

      assign rs_data->* to field-symbol(<fs_data>).

      <fs_data> = corresponding #( <ls_outtab> ).

    endif.


  endmethod.
ENDCLASS.
