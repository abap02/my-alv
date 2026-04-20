*&---------------------------------------------------------------------*
*& Report ZZ0433_ALVGRID_001
*&---------------------------------------------------------------------*
*& ALV Grid : Double Click & Hotspot Click
*&---------------------------------------------------------------------*
report zz0433_alvgrid_005.

include zz0433_alv_common_01.

include zz0433_alvgrid_005_top.
include zz0433_alvgrid_005_c01.
include zz0433_alvgrid_005_pbo.
include zz0433_alvgrid_005_pai.
include zz0433_alvgrid_005_f01.
include zz0433_alvgrid_005_f02.


initialization.
  perform set_init.


start-of-selection.

  select * from spfli into corresponding fields of table @gt_spfli.




  call screen '9000'.
