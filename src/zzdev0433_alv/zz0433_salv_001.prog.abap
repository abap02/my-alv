*&---------------------------------------------------------------------*
*& Report ZZ0433_SALV_001
*&---------------------------------------------------------------------*
*& SALV : Base
*&---------------------------------------------------------------------*
report zz0433_salv_001.


include zz0433_alv_common_01.

include zz0433_salv_001_top.
include zz0433_salv_001_c01.
include zz0433_salv_001_pbo.
include zz0433_salv_001_pai.
include zz0433_salv_001_f01.
include zz0433_salv_001_f02.

initialization.
  perform set_init.


start-of-selection.

  select * from spfli into corresponding fields of table @gt_spfli.




  call screen '9000'.
