*&---------------------------------------------------------------------*
*& Include          ZZ0433_SALV_001_TOP
*&---------------------------------------------------------------------*

data: gs_spfli type spfli,
      gt_spfli type table of spfli.



types: begin of ty_sflight.
         include structure sflight.
types:   fcolor type lvc_t_scol,
       end of ty_sflight.

data: gs_sflight type ty_sflight,
      gt_sflight type table of ty_sflight.

*       LVC_T_SCOL
