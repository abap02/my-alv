*&---------------------------------------------------------------------*
*& Report ZZ0433_ALVGRID_001
*&---------------------------------------------------------------------*
*& ALV Grid : Toolbar & UserCommand
*&---------------------------------------------------------------------*
report zz0433_alvgrid_004.

include zz0433_alv_common_01.

include zz0433_alvgrid_004_top.
include zz0433_alvgrid_004_c01.
include zz0433_alvgrid_004_pbo.
include zz0433_alvgrid_004_pai.
include zz0433_alvgrid_004_f01.
include zz0433_alvgrid_004_f02.


initialization.
  perform set_init.


start-of-selection.

  select * from spfli into corresponding fields of table @gt_spfli.




  call screen '9000'.
