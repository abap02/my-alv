*&---------------------------------------------------------------------*
*& Include          ZZ0433_ALVGRID_001_TOP
*&---------------------------------------------------------------------*

tables: spfli, sflight.

data: gs_spfli type spfli,
      gt_spfli type table of spfli.

types:begin of ty_sflight.
        include structure sflight.
types:  material    type char40,
        description type string,
        partner     type but000-partner,
        name_org1   type but000-name_org1,
        linecolor   type lvc_cifnm,
        celltab     type  lvc_t_styl,
        cellcolor   type lvc_t_scol, "Cell Color.
      end of ty_sflight.

data: gs_sflight type ty_sflight,
      gt_sflight type table of ty_sflight.
