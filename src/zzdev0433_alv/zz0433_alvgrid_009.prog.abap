*&---------------------------------------------------------------------*
*& Report ZZ0433_ALVGRID_001
*&---------------------------------------------------------------------*
*& ALV Grid : F4 Search Help
*&---------------------------------------------------------------------*
report zz0433_alvgrid_009.

include zz0433_alv_common_01.

include zz0433_alvgrid_009_top.
include zz0433_alvgrid_009_c01.
include zz0433_alvgrid_009_pbo.
include zz0433_alvgrid_009_pai.
include zz0433_alvgrid_009_f01.
include zz0433_alvgrid_009_f02.


initialization.
  perform set_init.


start-of-selection.

  select * from spfli into corresponding fields of table @gt_spfli.




  call screen '9000'.
