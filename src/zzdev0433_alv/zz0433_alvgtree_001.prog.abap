*&---------------------------------------------------------------------*
*& Report ZZ0433_ALVGTREE_001
*&---------------------------------------------------------------------*
*& ALV Tree Grid : Base
*&---------------------------------------------------------------------*
report zz0433_alvgtree_001.

include zz0433_alv_common_01.

include zz0433_alvgtree_001_top.
include zz0433_alvgtree_001_c01.
include zz0433_alvgtree_001_pbo.
include zz0433_alvgtree_001_pai.
include zz0433_alvgtree_001_f01.
include zz0433_alvgtree_001_f02.



initialization.
  perform set_init.


start-of-selection.

  select * from scarr into corresponding fields of table @gt_scarr.


  call screen '9000'.
