*&---------------------------------------------------------------------*
*& Report ZZ0433_ALVGRID_001
*&---------------------------------------------------------------------*
*& ALV Grid : LineColor & Cell Color & Cell Style
*&---------------------------------------------------------------------*
report zz0433_alvgrid_007.

include zz0433_alv_common_01.

include zz0433_alvgrid_007_top.
include zz0433_alvgrid_007_c01.
include zz0433_alvgrid_007_pbo.
include zz0433_alvgrid_007_pai.
include zz0433_alvgrid_007_f01.
include zz0433_alvgrid_007_f02.


initialization.
  perform set_init.


start-of-selection.

  select * from spfli into corresponding fields of table @gt_spfli.




  call screen '9000'.
