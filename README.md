# DDUDUK (뚜덕)

> 통증 관리 및 AI 맞춤 운동 추천 모바일 헬스케어 앱

## 1. 프로젝트 개요

통증 부위를 설문으로 입력하면 AI가 진단/분석하고, 맞춤 운동을 추천해주는 헬스케어 앱이다.

### 주요 기능

| 기능           | 설명                                                 |
| -------------- | ---------------------------------------------------- |
| 소셜 로그인    | 카카오 / 네이버 / 애플 로그인                        |
| 통증 설문      | 6단계 통증 설문 → AI 진단 결과 표시                  |
| 운동 능력 평가 | 스쿼트, 푸쉬업, 계단오르기, 플랭크 4종 평가          |
| 맞춤 운동 추천 | 서버 AI 기반 YouTube 운동 영상 추천 (Initial/Repeat) |
| 운동 기록/통계 | 주간 운동 기록 및 통계 대시보드                      |
| 운동 후 피드백 | RPE, 근육 자극, 발한 3단계 피드백 → 서버 전송        |
| 스케줄 예약    | 다음 운동 일정 예약 + 로컬 푸시 알림                 |
| 마이페이지     | 프로필 편집, 설문 리뷰, 운동 부위 변경               |

### 화면 흐름

```
스플래시 → 온보딩 → 로그인 → 약관동의 → 통증설문(6단계) → 설문완료 → 홈
                                                                    ↓
                                              마이페이지 ← 홈 → 운동능력평가 → 운동메인
                                                                              ↓
                                                          스케줄예약 ← 피드백(3단계) ← 운동완료 ← 운동플레이(영상)
```

### 기술 스택

- **프레임워크**: Flutter SDK ^3.10.0
- **상태 관리**: flutter_riverpod (StateNotifier 패턴)
- **라우팅**: go_router
- **HTTP**: dio (인터셉터 기반 JWT 자동 주입/갱신)
- **소셜 로그인**: kakao_flutter_sdk_user, flutter_naver_login, sign_in_with_apple
- **영상**: youtube_player_flutter
- **알림**: flutter_local_notifications

---

## 2. 로컬 세팅

### 환경 변수 (.env)

프로젝트 루트에 `.env` 파일을 생성하고 아래 키를 설정한다.

| 키                     | 설명                                               |
| ---------------------- | -------------------------------------------------- |
| `BASE_URL`             | 백엔드 API 서버 주소 (예: `http://localhost:8081`) |
| `KAKAO_NATIVE_APP_KEY` | 카카오 개발자 콘솔에서 발급받은 Native App Key     |

### 소셜 로그인 설정

코드는 카카오/네이버/애플 모두 구현되어 있으나, 인수 후 각 키를 발급받아 입력할 것.

---

## 3. 폴더 구조

```
lib/
├── main.dart              # 앱 진입점
├── router.dart            # GoRouter 라우팅 설정
├── api/                   # Dio 기반 API 통신 (ApiClient, 에러 처리, 엔드포인트)
├── models/                # 데이터 모델 (auth, exercise, survey, user)
├── providers/             # Riverpod StateNotifier (auth, user, survey, exercise 등)
├── repositories/          # Repository 레이어 (API 호출 캡슐화)
├── services/              # 소셜 로그인, 토큰 관리, 알림 서비스
├── screens/               # 화면 위젯 (auth, survey, exercise, home, mypage)
├── widgets/               # 재사용 UI 컴포넌트
├── layouts/               # 레이아웃 템플릿 (default, home, survey)
└── theme/                 # 디자인 시스템 (colors, text styles, dimens)
```

### 아키텍처

```
Screen (UI)  →  Provider (상태관리)  →  Repository (API 호출)  →  ApiClient (Dio)  →  Backend Server
```

---

## 4. API 엔드포인트

| 도메인      | 엔드포인트                                       | 설명                |
| ----------- | ------------------------------------------------ | ------------------- |
| 인증        | `POST /api/auth/login`                           | 소셜 로그인         |
|             | `POST /api/auth/refresh`                         | 토큰 갱신           |
| 사용자      | `GET/PUT /api/users/{userId}`                    | 프로필 조회/수정    |
|             | `GET /api/users/check-nickname`                  | 닉네임 중복 확인    |
|             | `POST /api/users/{userId}/reset-surveys`         | 설문 초기화         |
| 통증 설문   | `POST /api/users/{userId}/pain-survey`           | 통증 설문 제출      |
| 운동 능력   | `POST /api/users/{userId}/exercise-ability`      | 운동 능력 평가 제출 |
| 일일 통증   | `POST /api/users/{userId}/daily-pain`            | 일일 통증 기록      |
| 운동 루틴   | `GET /api/routines/date`                         | 날짜별 루틴 조회    |
|             | `POST /api/routines`                             | 루틴 저장           |
| 운동 추천   | `POST /api/exercise-recommendation/initial`      | 최초 운동 추천      |
|             | `POST /api/exercise-recommendation/repeat`       | 반복 운동 추천      |
| 운동 기록   | `POST /api/workout-records`                      | 운동 기록 저장      |
|             | `GET /api/workout-records/date`                  | 날짜별 기록 조회    |
|             | `GET /api/workout-records/dates`                 | 기록 날짜 목록      |
|             | `GET /api/workout-records/weekly-summary`        | 주간 요약           |
| 운동 피드백 | `POST /api/users/{userId}/workout-feedback`      | 운동 후 피드백      |
| 운동 스케줄 | `POST /api/users/{userId}/next-workout-schedule` | 다음 운동 예약      |

---

## 5. 남은 과제

- GoRouter 인증 리다이렉트(redirect guard) 미구현
- StateNotifier → Notifier 마이그레이션 (Riverpod 권장)
- JWT 토큰이 SharedPreferences에 평문 저장 → flutter_secure_storage 전환 권장
- 테스트 코드 부재
- FCM 푸시 알림 미연동 (엔드포인트만 존재, Firebase 연동 필요)
- 라우트 경로 하드코딩
- debugPrint 다수 잔존 (프로덕션 전 로깅 라이브러리 전환 권장)
- 운동 영상 시청, AI 연동 결과 등 화면 복귀 시 횟수/통계 반영 미검증 (코드 리팩토링 필요, 백엔드 인스턴스 삭제로 테스트 불가)
