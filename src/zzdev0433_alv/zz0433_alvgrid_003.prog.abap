*&---------------------------------------------------------------------*
*& Report ZZ0433_ALVGRID_001
*&---------------------------------------------------------------------*
*& ALV Grid : Docking Container
*&---------------------------------------------------------------------*
report zz0433_alvgrid_003.

include zz0433_alv_common_01.

include zz0433_alvgrid_003_top.
include zz0433_alvgrid_003_c01.
include zz0433_alvgrid_003_pbo.
include zz0433_alvgrid_003_pai.
include zz0433_alvgrid_003_f01.
include zz0433_alvgrid_003_f02.


initialization.
  perform set_init.


start-of-selection.

  select * from spfli into corresponding fields of table @gt_spfli.




  call screen '9000'.
