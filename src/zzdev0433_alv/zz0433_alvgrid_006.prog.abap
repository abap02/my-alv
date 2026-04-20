*&---------------------------------------------------------------------*
*& Report ZZ0433_ALVGRID_001
*&---------------------------------------------------------------------*
*& ALV Grid : Data Changed & Data Changed Finish
*&---------------------------------------------------------------------*
report zz0433_alvgrid_006.

include zz0433_alv_common_01.

include zz0433_alvgrid_006_top.
include zz0433_alvgrid_006_c01.
include zz0433_alvgrid_006_pbo.
include zz0433_alvgrid_006_pai.
include zz0433_alvgrid_006_f01.
include zz0433_alvgrid_006_f02.


initialization.
  perform set_init.


start-of-selection.

  select * from spfli into corresponding fields of table @gt_spfli.




  call screen '9000'.
