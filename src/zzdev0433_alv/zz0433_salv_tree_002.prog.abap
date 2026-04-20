*&---------------------------------------------------------------------*
*& Report ZZ0433_SALV_001
*&---------------------------------------------------------------------*
*& SALV Tree : Toolbar & UserCommand
*&---------------------------------------------------------------------*
report zz0433_salv_tree_002.


include zz0433_alv_common_01.

include zz0433_salv_tree_002_top.
include zz0433_salv_tree_002_c01.
include zz0433_salv_tree_002_pbo.
include zz0433_salv_tree_002_pai.
include zz0433_salv_tree_002_f01.
include zz0433_salv_tree_002_f02.

initialization.
  perform set_init.


start-of-selection.

  call screen '9000'.
