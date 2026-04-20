*&---------------------------------------------------------------------*
*& Include          ZZ0433_ALVGRID_001_TOP
*&---------------------------------------------------------------------*

types:begin of ty_spfli.
        include structure spfli.
types:  linecolor type lvc_cifnm,
        celltab   type  lvc_t_styl,
        cellcolor type lvc_t_scol, "Cell Color.
      end of ty_spfli.

data: gs_spfli type ty_spfli,
      gt_spfli type table of ty_spfli.

types:begin of ty_sflight.
        include structure sflight.
types:  linecolor type lvc_cifnm,
        celltab   type  lvc_t_styl,
        cellcolor type lvc_t_scol, "Cell Color.
      end of ty_sflight.

data: gs_sflight type ty_sflight,
      gt_sflight type table of ty_sflight.
