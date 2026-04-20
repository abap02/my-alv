*&---------------------------------------------------------------------*
*& Report ZZ0433_ALVGTREE_001
*&---------------------------------------------------------------------*
*& ALV Tree Grid : 3 Level
*&---------------------------------------------------------------------*
report zz0433_alvgtree_002.

include zz0433_alv_common_01.

include zz0433_alvgtree_002_top.
include zz0433_alvgtree_002_c01.
include zz0433_alvgtree_002_pbo.
include zz0433_alvgtree_002_pai.
include zz0433_alvgtree_002_f01.
include zz0433_alvgtree_002_f02.



initialization.
  perform set_init.


start-of-selection.

  select * from scarr into corresponding fields of table @gt_scarr.


  call screen '9000'.
