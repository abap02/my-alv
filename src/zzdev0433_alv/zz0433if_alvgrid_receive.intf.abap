interface ZZ0433IF_ALVGRID_RECEIVE
  public .


  methods HANDLE_BEFORE_USER_COMMAND
    for event BEFORE_USER_COMMAND of CL_GUI_ALV_GRID
    importing
      !SENDER
      !E_UCOMM .
  methods HANDLE_USER_COMMAND
    for event USER_COMMAND of CL_GUI_ALV_GRID
    importing
      !SENDER
      !E_UCOMM .
  methods HANDLE_AFTER_USER_COMMAND
    for event AFTER_USER_COMMAND of CL_GUI_ALV_GRID
    importing
      !SENDER
      !E_UCOMM
      !E_SAVED
      !E_NOT_PROCESSED .
  methods HANDLE_TOOLBAR
    for event TOOLBAR of CL_GUI_ALV_GRID
    importing
      !SENDER
      !E_OBJECT
      !E_INTERACTIVE .
  methods HANDLE_DOUBLE_CLICK
    for event DOUBLE_CLICK of CL_GUI_ALV_GRID
    importing
      !SENDER
      !E_ROW
      !E_COLUMN
      !ES_ROW_NO .
  methods HANDLE_HOTSPOT_CLICK
    for event HOTSPOT_CLICK of CL_GUI_ALV_GRID
    importing
      !SENDER
      !E_ROW_ID
      !E_COLUMN_ID
      !ES_ROW_NO .
  methods HANDLE_DATA_CHANGED
    for event DATA_CHANGED of CL_GUI_ALV_GRID
    importing
      !SENDER
      !ER_DATA_CHANGED
      !E_ONF4
      !E_ONF4_BEFORE
      !E_ONF4_AFTER
      !E_UCOMM .
  methods HANDLE_DATA_CHANGED_FINISHED
    for event DATA_CHANGED_FINISHED of CL_GUI_ALV_GRID
    importing
      !SENDER
      !E_MODIFIED
      !ET_GOOD_CELLS .
  methods HANDLE_ON_F4
    for event ONF4 of CL_GUI_ALV_GRID
    importing
      !SENDER
      !E_FIELDNAME
      !E_FIELDVALUE
      !ES_ROW_NO
      !ER_EVENT_DATA
      !ET_BAD_CELLS
      !E_DISPLAY .
  methods HANDLE_TOP_OF_PAGE
    for event TOP_OF_PAGE of CL_GUI_ALV_GRID
    importing
      !SENDER
      !E_DYNDOC_ID
      !TABLE_INDEX .
  methods HANDLE_BUTTON_CLICK
    for event BUTTON_CLICK of CL_GUI_ALV_GRID
    importing
      !SENDER
      !ES_COL_ID
      !ES_ROW_NO .
endinterface.
