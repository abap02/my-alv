*&---------------------------------------------------------------------*
*& Report ZZ0433_ALVGRID_001
*&---------------------------------------------------------------------*
*& ALV Grid : Data Changed & Data Changed Finish (202306)
*&---------------------------------------------------------------------*
report zz0433_alvgrid_006_02.

include zz0433_alv_common_01.

include zz0433_alvgrid_006_02_top.
include zz0433_alvgrid_006_02_c01.
include zz0433_alvgrid_006_02_pbo.
include zz0433_alvgrid_006_02_pai.
include zz0433_alvgrid_006_02_f01.
include zz0433_alvgrid_006_02_f02.


initialization.
  perform set_init.


start-of-selection.

  select * from spfli into corresponding fields of table @gt_spfli.




  call screen '9000'.
