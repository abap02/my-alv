*&---------------------------------------------------------------------*
*& Report ZZ0433_ALVGRID_001
*&---------------------------------------------------------------------*
*& ALV Grid : Data Changed & Data Changed Finish (Paste)
*&---------------------------------------------------------------------*
report zz0433_alvgrid_006_01.

include zz0433_alv_common_01.

include zz0433_alvgrid_006_01_top.
include zz0433_alvgrid_006_01_c01.
include zz0433_alvgrid_006_01_pbo.
include zz0433_alvgrid_006_01_pai.
include zz0433_alvgrid_006_01_f01.
include zz0433_alvgrid_006_01_f02.


initialization.
  perform set_init.


start-of-selection.

*  select * from zz0433tb1001 into corresponding fields of table @gt_list.
*  if sy-subrc ne 0.
*    append initial line to gt_save assigning field-symbol(<fs_list>).
*    <fs_list>-db_key = cl_system_uuid=>if_system_uuid_static~create_uuid_x16( ).
*    <fs_list>-budat = sy-datum.
*    <fs_list>-ebeln = `4500010000`.
*    <fs_list>-ebelp = 10.
*    <fs_list>-menge = 10.
*    <fs_list>-meins = `KG`.
*
*    <fs_list>-netpr  = 10000.
*    <fs_list>-waers  = `KRW`.
*    <fs_list>-netwr  = 10000.
*
*
*    <fs_list>-reason_id  = 99.
*    <fs_list>-reason_txt  = `raw data...`.
*    <fs_list>-bukrs  = `0001`.
*
*    insert zz0433tb1001 from table gt_save.
*
*    select * from zz0433tb1001 into corresponding fields of table @gt_list.
*  endif.

  append initial line to gt_list.




  call screen '9000'.
