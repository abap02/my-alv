*&---------------------------------------------------------------------*
*& Report ZZ0433_SALV_001
*&---------------------------------------------------------------------*
*& SALV Tree : Base
*&---------------------------------------------------------------------*
report zz0433_salv_tree_001.


include zz0433_alv_common_01.

include zz0433_salv_tree_001_top.
include zz0433_salv_tree_001_c01.
include zz0433_salv_tree_001_pbo.
include zz0433_salv_tree_001_pai.
include zz0433_salv_tree_001_f01.
include zz0433_salv_tree_001_f02.

initialization.
  perform set_init.


start-of-selection.

  call screen '9000'.
