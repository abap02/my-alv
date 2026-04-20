*&---------------------------------------------------------------------*
*& Report ZZ0433_SALV_001
*&---------------------------------------------------------------------*
*& SALV : Color
*&---------------------------------------------------------------------*
report zz0433_salv_004.


include zz0433_alv_common_01.

include zz0433_salv_004_top.
include zz0433_salv_004_c01.
include zz0433_salv_004_pbo.
include zz0433_salv_004_pai.
include zz0433_salv_004_f01.
include zz0433_salv_004_f02.

initialization.
  perform set_init.


start-of-selection.

  select * from spfli into corresponding fields of table @gt_spfli.




  call screen '9000'.
