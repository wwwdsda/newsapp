# 풀스택 뉴스 서비스 애플리케이션 (오늘의 뉴스)

Flutter와 Dart Frog를 활용하여 개발된 풀스택 뉴스 서비스 애플리케이션입니다. 먼저 제미나이 api를 통해서 뉴스사의 수많은 뉴스들 중 볼 필요 없는 뉴스들을 걸러낸 후, 사용자는 키워드 및 뉴스 성향을 등록하여 관심 뉴스를 타겟 할 수 있으며, 원하는 뉴스를 스크랩(북마크)하고 개인화된 뉴스 피드를 이용할 수 있습니다. 또한 제미나이 api를 통해서 해당 뉴스를 읽게 한 후 간단한 요약본까지 제공합니다.

---

## 프로젝트 개요

- **프로젝트명**: 오늘의 뉴스
- **기술 스택**:
  - 프론트엔드: Flutter (Dart)
  - 백엔드: Dart Frog (Dart 기반 RESTful API 서버)
  - 통신: HTTP (JSON 기반)
- **주요 기능**:
  - 사용자 로그인/회원가입
  - 키워드 등록/삭제
  - 뉴스 성향 설정
  - 날짜별 뉴스 리스트 제공
  - 스크랩(북마크) 기능
  - AI 뉴스 필터링, 뉴스 내용 요약

---

## 클라이언트 (Flutter)

### 디렉토리 구조

lib/
├── routes/
│ ├── model/
│ │ ├── news_item.dart # 다루는 뉴스의 class
│ ├── screens/ # 화면 UI 구성
│ │ ├── login_screen. dart
│ │ ├──register_screen.dart
│ │ ├──home_screen.dart
│ │ ├── scrap_screen.dart
│ │ ├── keyword_screen.dart
│ │ ├──company_screen.dart
│ ├── service/
│ │ ├── api_service.dart # 서버 API 통신 담당
│ └── utils/
│ │ ├── global.dart # 서버에서 쓰는 전역변수 관리
│ ├── widget/ # 화면 widget 구성
│ │ ├── keyword_section. dart # 설정창 키워드 관리 위젯
│ │ ├── news_bias_section.dart # 설정창 뉴스 성향 관리 위젯
│ │ ├── news_block_widget.dart # 홈,스크랩 화면에 뜨는 뉴스 블럭들 
│ │ ├── news_topic_section.dart # 뉴스 주제 관리 위젯
│ │ ├── summary.popup.dart # 뉴스 블락 클릭하면 나오는 요약본 팝업


### 주요 기능
- 로그인 및 회원가입
- 키워드 및 뉴스 회사 추가/삭제
- 날짜별 뉴스 기사 리스트 뷰
- 기사 스크랩 및 스크랩 해제
- 스크랩된 뉴스 보기
- API 통신을 통한 실시간 데이터 반영
- 제미나이 API를 통한 중요한 뉴스만 필터 & 선택한 뉴스 요약 

### 관리 정보
- 홈 화면에 띄울 뉴스의 날짜 
- 유저 로그인 정보, 회원가입 정보
- 필터링된 뉴스 결과 리스트
- 여러가지 설정 정보들 (키워드, 성향 등)
- 스크랩된 뉴스 ID 목록
