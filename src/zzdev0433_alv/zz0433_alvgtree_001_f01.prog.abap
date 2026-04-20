*&---------------------------------------------------------------------*
*& Include          ZZ0433_ALVGTREE_001_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_fieldcat_spfli
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
form set_fieldcat_spfli using po_salv_table type ref to cl_salv_table.

  gt_fieldcat_spfli = cl_salv_controller_metadata=>get_lvc_fieldcatalog(
                        r_columns      = po_salv_table->get_columns( )
                        r_aggregations = po_salv_table->get_aggregations( )
                      ).

  loop at gt_fieldcat_spfli assigning field-symbol(<fs_fieldcat_spfli>).
    <fs_fieldcat_spfli>-col_opt = abap_true.
    case <fs_fieldcat_spfli>-fieldname.
      when `MANDT` or `CARRID` or `CONNID`.
        <fs_fieldcat_spfli>-tech = abap_true.
      when others.
    endcase.
  endloop.

endform.
