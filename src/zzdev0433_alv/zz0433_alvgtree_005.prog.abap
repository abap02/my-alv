*&---------------------------------------------------------------------*
*& Report ZZ0433_ALVGTREE_001
*&---------------------------------------------------------------------*
*& ALV Tree Grid : CheckBox
*&---------------------------------------------------------------------*
report zz0433_alvgtree_005.

include zz0433_alv_common_01.

include zz0433_alvgtree_005_top.
include zz0433_alvgtree_005_c01.
include zz0433_alvgtree_005_pbo.
include zz0433_alvgtree_005_pai.
include zz0433_alvgtree_005_f01.
include zz0433_alvgtree_005_f02.



initialization.
  perform set_init.


start-of-selection.

  select * from scarr into corresponding fields of table @gt_scarr.


  call screen '9000'.
