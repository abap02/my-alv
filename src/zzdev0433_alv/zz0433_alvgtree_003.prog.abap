*&---------------------------------------------------------------------*
*& Report ZZ0433_ALVGTREE_001
*&---------------------------------------------------------------------*
*& ALV Tree Grid : Aggregations
*&---------------------------------------------------------------------*
report zz0433_alvgtree_003.

include zz0433_alv_common_01.

include zz0433_alvgtree_003_top.
include zz0433_alvgtree_003_c01.
include zz0433_alvgtree_003_pbo.
include zz0433_alvgtree_003_pai.
include zz0433_alvgtree_003_f01.
include zz0433_alvgtree_003_f02.



initialization.
  perform set_init.


start-of-selection.

  select * from scarr into corresponding fields of table @gt_scarr.


  call screen '9000'.
