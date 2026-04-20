*&---------------------------------------------------------------------*
*& Report ZZ0433_ALVGTREE_001
*&---------------------------------------------------------------------*
*& ALV Tree Grid : Toolbar & Menu & Selected Node
*&---------------------------------------------------------------------*
report zz0433_alvgtree_004.

include zz0433_alv_common_01.

include zz0433_alvgtree_004_top.
include zz0433_alvgtree_004_c01.
include zz0433_alvgtree_004_pbo.
include zz0433_alvgtree_004_pai.
include zz0433_alvgtree_004_f01.
include zz0433_alvgtree_004_f02.



initialization.
  perform set_init.


start-of-selection.

  select * from scarr into corresponding fields of table @gt_scarr.


  call screen '9000'.
