네, 물론입니다! 실무에서 바로 복사하여 `SE38`에 붙여넣기만 하면 실행할 수 있도록, **순수 ABAP 소스 코드 블록** 형태로 깔끔하게 정리해 드리겠습니다.

아래 코드를 복사하여 SAP GUI의 **SE38** 트랜잭션에서 새 프로그램을 생성한 후 붙여넣으시면 됩니다.

```abap
*&---------------------------------------------------------------------*
*& Report Z_ALV_TREE_DEMO
*&---------------------------------------------------------------------*
*& Description: CL_GUI_ALV_TREE를 사용한 트리 구조 ALV 데모 프로그램
*&---------------------------------------------------------------------*
REPORT z_alv_tree_demo.

*----------------------------------------------------------------------*
* TYPES & DATA DECLARATIONS
*----------------------------------------------------------------------*
* 트리 구조를 표현하기 위한 내부 테이블 및 구조체 정의
TYPES: BEGIN OF ty_tree_node,
         key       TYPE i,        " 노드의 고유 키 (예: ID)
         parent_key TYPE i,        " 부모 노드의 키 (루트 노드는 0)
         text      TYPE string,    " 노드에 표시될 텍스트
         level     TYPE i,        " 계층 레벨 (시각적 표현용)
       END OF ty_tree_node.

DATA: gt_tree_data TYPE STANDARD TABLE OF ty_tree_node,
      gs_tree_node TYPE ty_tree_node.

* ALV 관련 객체 선언
DATA: go_alv_tree TYPE REF TO cl_gui_alv_tree,
      go_container TYPE REF TO cl_gui_custom_container.

*----------------------------------------------------------------------*
* START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.

  " 1. 데모 데이터 준비 (계층 구조 시뮬레이션)
  PERFORM build_demo_data.

  " 2. ALV Tree 객체 생성 및 컨테이너 설정
  PERFORM create_alv_tree.

  " 3. ALV Tree에 데이터 표시
  PERFORM display_alv_tree.

*----------------------------------------------------------------------*
* FORM Routines
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      FORM build_demo_data
*&---------------------------------------------------------------------*
* 데모를 위한 계층 구조 데이터를 생성합니다.
*---------------------------------------------------------------------*
FORM build_demo_data.
  " 루트 노드 (Level 1)
  gs_tree_node-key = 1.
  gs_tree_node-parent_key = 0.
  gs_tree_node-text = 'Level 1: 부서 (Department)'.
  gs_tree_node-level = 1.
  APPEND gs_tree_node TO gt_tree_data.

  " Level 2 노드 (부서 아래 팀)
  gs_tree_node-key = 10.
  gs_tree_node-parent_key = 1.
  gs_tree_node-text = 'Level 2: 개발팀 (Development Team)'.
  gs_tree_node-level = 2.
  APPEND gs_tree_node TO gt_tree_data.

  gs_tree_node-key = 20.
  gs_tree_node-parent_key = 1.
  gs_tree_node-text = 'Level 2: 운영팀 (Operation Team)'.
  gs_tree_node-level = 2.
  APPEND gs_tree_node TO gt_tree_data.

  " Level 3 노드 (팀 아래 프로젝트)
  gs_tree_node-key = 101.
  gs_tree_node-parent_key = 10.
  gs_tree_node-text = 'Level 3: 프로젝트 A (Project A)'.
  gs_tree_node-level = 3.
  APPEND gs_tree_node TO gt_tree_data.

  gs_tree_node-key = 102.
  gs_tree_node-parent_key = 10.
  gs_tree_node-text = 'Level 3: 프로젝트 B (Project B)'.
  gs_tree_node-level = 3.
  APPEND gs_tree_node TO gt_tree_data.

  " Level 3 노드 (운영팀 아래 태스크)
  gs_tree_node-key = 201.
  gs_tree_node-parent_key = 20.
  gs_tree_node-text = 'Level 3: 서버 모니터링 (Server Monitoring)'.
  gs_tree_node-level = 3.
  APPEND gs_tree_node TO gt_tree_data.

  gs_tree_node-key = 202.
  gs_tree_node-parent_key = 20.
  gs_tree_node-text = 'Level 3: 백업 관리 (Backup Management)'.
  gs_tree_node-level = 3.
  APPEND gs_tree_node TO gt_tree_data.

ENDFORM. " build_demo_data

*&---------------------------------------------------------------------*
*&      FORM create_alv_tree
*&---------------------------------------------------------------------*
* ALV Tree를 표시할 컨테이너를 생성합니다.
*---------------------------------------------------------------------*
FORM create_alv_tree.
  " 1. Custom Container 생성 (화면에 ALV를 담을 영역)
  CREATE OBJECT go_container
    EXPORTING
      container_width  = 800
      container_height = 600.

  " 2. ALV Tree 객체 생성
  CREATE OBJECT go_alv_tree
    EXPORTING
      i_parent = go_container.

  " 3. ALV Tree 설정 (필요한 경우)
  " 이 예제에서는 기본 설정만 사용합니다.

ENDFORM. " create_alv_tree

*&---------------------------------------------------------------------*
*&      FORM display_alv_tree
*&---------------------------------------------------------------------*
* 데이터를 ALV Tree에 바인딩하고 화면에 표시합니다.
*---------------------------------------------------------------------*
FORM display_alv_tree.
  " 1. 데이터 바인딩 (트리 구조 데이터
