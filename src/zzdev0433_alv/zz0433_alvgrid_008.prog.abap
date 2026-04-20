*&---------------------------------------------------------------------*
*& Report ZZ0433_ALVGRID_001
*&---------------------------------------------------------------------*
*& ALV Grid : Dropdown
*&---------------------------------------------------------------------*
report zz0433_alvgrid_008.

include zz0433_alv_common_01.

include zz0433_alvgrid_008_top.
include zz0433_alvgrid_008_c01.
include zz0433_alvgrid_008_pbo.
include zz0433_alvgrid_008_pai.
include zz0433_alvgrid_008_f01.
include zz0433_alvgrid_008_f02.


initialization.
  perform set_init.
  perform set_dropdown_list_data.


start-of-selection.

  select * from spfli into corresponding fields of table @gt_spfli.


  call screen '9000'.""
