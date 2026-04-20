*&---------------------------------------------------------------------*
*& Report ZZ0433_SALV_001
*&---------------------------------------------------------------------*
*& SALV : User Command & Double Click & Hotspot Click
*&---------------------------------------------------------------------*
report zz0433_salv_002.


include zz0433_alv_common_01.

include zz0433_salv_002_top.
include zz0433_salv_002_c01.
include zz0433_salv_002_pbo.
include zz0433_salv_002_pai.
include zz0433_salv_002_f01.
include zz0433_salv_002_f02.

initialization.
  perform set_init.


start-of-selection.

  select * from spfli into corresponding fields of table @gt_spfli.




  call screen '9000'.
