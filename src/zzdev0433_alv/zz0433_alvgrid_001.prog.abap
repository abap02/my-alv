*&---------------------------------------------------------------------*
*& Report ZZ0433_ALVGRID_001
*&---------------------------------------------------------------------*
*& ALV Grid : Base
*&---------------------------------------------------------------------*
report zz0433_alvgrid_001.

include zz0433_alv_common_01.

include zz0433_alvgrid_001_top.
include zz0433_alvgrid_001_c01.
include zz0433_alvgrid_001_pbo.
include zz0433_alvgrid_001_pai.
include zz0433_alvgrid_001_f01.
include zz0433_alvgrid_001_f02.


initialization.
  perform set_init.


start-of-selection.

  select * from spfli into corresponding fields of table @gt_spfli.




  call screen '9000'.
