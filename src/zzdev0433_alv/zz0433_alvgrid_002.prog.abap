*&---------------------------------------------------------------------*
*& Report ZZ0433_ALVGRID_001
*&---------------------------------------------------------------------*
*& ALV Grid : Split Container
*&---------------------------------------------------------------------*
report zz0433_alvgrid_002.

include zz0433_alv_common_01.

include zz0433_alvgrid_002_top.
include zz0433_alvgrid_002_c01.
include zz0433_alvgrid_002_pbo.
include zz0433_alvgrid_002_pai.
include zz0433_alvgrid_002_f01.
include zz0433_alvgrid_002_f02.


initialization.
  perform set_init.


start-of-selection.

  select * from scarr into corresponding fields of table @gt_scarr.
  select * from spfli into corresponding fields of table @gt_spfli.




  call screen '9000'.
