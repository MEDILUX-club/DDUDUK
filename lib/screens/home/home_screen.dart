import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/layouts/home_layout.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/widgets/home/recovery_status_card.dart';
import 'package:dduduk_app/widgets/home/exercise_calendar.dart';
import 'package:dduduk_app/widgets/home/exercise_record_modal.dart';
import 'package:dduduk_app/widgets/exercise/exercise_routine_card.dart';
import 'package:dduduk_app/services/token_service.dart';
import 'package:dduduk_app/repositories/user_repository.dart';
import 'package:dduduk_app/repositories/daily_pain_repository.dart';
import 'package:dduduk_app/repositories/exercise_repository.dart';

/// 홈 화면
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentNavIndex = 0;
  final _userRepository = UserRepository();
  final _dailyPainRepository = DailyPainRepository();
  final _exerciseRepository = ExerciseRepository();

  String _userName = '사용자';
  int _recoveryPercent = 0;

  // 운동한 날짜 목록 (API에서 불러옴)
  List<int> _exerciseDays = [];
  List<String> _allExerciseDates = []; // API에서 받은 전체 날짜 리스트
  DateTime _currentDisplayMonth = DateTime.now(); // 현재 표시 중인 월

  // 캐시된 운동 기록 (날짜별)
  final Map<String, List<ExerciseRoutineData>> _cachedRecords = {};

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _loadRecoveryRate();
    _loadExerciseDates();
  }

  Future<void> _loadUserName() async {
    try {
      final profile = await _userRepository.getProfile();
      if (mounted) {
        setState(() {
          _userName = profile.nickname.isNotEmpty ? profile.nickname : '사용자';
        });
      }
    } catch (e) {
      debugPrint('닉네임 로딩 오류: $e');
    }
  }

  Future<void> _loadRecoveryRate() async {
    try {
      final rate = await _dailyPainRepository.getRecoveryRate();
      if (mounted) {
        setState(() {
          _recoveryPercent = rate;
        });
      }
    } catch (e) {
      debugPrint('회복률 로딩 오류: $e');
    }
  }

  Future<void> _loadExerciseDates() async {
    try {
      final dates = await _exerciseRepository.getWorkoutRecordDates();
      debugPrint(' API에서 받은 운동 날짜 목록: $dates');
      if (mounted) {
        setState(() {
          _allExerciseDates = dates;
          // 현재 월의 운동 날짜만 필터링
          _updateExerciseDaysForCurrentMonth();
          debugPrint(' 필터링된 운동 날짜 (일자만): $_exerciseDays');
        });
      }
    } catch (e) {
      debugPrint('운동 날짜 로딩 오류: $e');
    }
  }

  /// 특정 월의 운동 날짜만 필터링
  void _updateExerciseDaysForCurrentMonth() {
    _exerciseDays = _allExerciseDates
        .map((dateString) {
          try {
            final date = DateTime.parse(dateString);
            // 현재 표시 중인 년도와 월이 일치하는 날짜만 반환
            if (date.year == _currentDisplayMonth.year &&
                date.month == _currentDisplayMonth.month) {
              return date.day;
            }
          } catch (e) {
            debugPrint('날짜 파싱 오류: $dateString');
          }
          return null;
        })
        .whereType<int>()
        .toList();
  }

  /// 캘린더 월 변경 핸들러
  void _onMonthChanged(DateTime month) {
    setState(() {
      _currentDisplayMonth = month;
      _updateExerciseDaysForCurrentMonth();
      debugPrint(
        ' 월 변경: ${month.year}년 ${month.month}월, 필터링된 날짜: $_exerciseDays',
      );
    });
  }

  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        // 운동 시작 여부에 따라 다른 화면으로 이동
        final hasStarted = TokenService.instance.getHasStartedExercise();
        if (hasStarted) {
          context.go('/exercise/main');
        } else {
          context.go('/exercise/main-empty');
        }
        break;
      case 2:
        context.go('/mypage');
        break;
    }
  }

  Future<void> _onDateSelected(DateTime date) async {
    debugPrint('선택된 날짜: $date');

    // 운동한 날인 경우에만 모달 표시
    if (_exerciseDays.contains(date.day)) {
      // 날짜를 API 형식으로 변환 (YYYY-MM-DD)
      final dateString =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      // 캐시에서 확인
      if (_cachedRecords.containsKey(dateString)) {
        showExerciseRecordModal(
          context: context,
          date: date,
          records: _cachedRecords[dateString]!,
        );
        return;
      }

      // API에서 운동 기록 불러오기
      try {
        final workoutRecords = await _exerciseRepository
            .getWorkoutRecordsByDate(dateString);

        // WorkoutRecord를 ExerciseRoutineData로 변환
        final records = workoutRecords.map((record) {
          return ExerciseRoutineData(
            name: record.exerciseName,
            sets: record.actualSets,
            reps: record.actualReps,
            // API에는 난이도 정보가 없으므로 null로 설정
            difficulty: null,
            // 운동 이미지는 exerciseId로 매핑 필요 (임시로 null)
            imagePath: _getExerciseImagePath(record.exerciseId),
          );
        }).toList();

        // 캐시에 저장
        _cachedRecords[dateString] = records;

        if (mounted) {
          showExerciseRecordModal(
            context: context,
            date: date,
            records: records,
          );
        }
      } catch (e) {
        debugPrint('운동 기록 로딩 실패: $e');
        // 에러 발생 시 사용자에게 알림
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('운동 기록을 불러오는데 실패했습니다: $e'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    }
  }

  /// exerciseId에 따른 이미지 경로 반환
  String? _getExerciseImagePath(String exerciseId) {
    // exerciseId와 이미지 경로 매핑
    // 실제 운동 ID에 맞게 매핑 필요
    final imageMap = {
      'squat_10': 'assets/images/img_squat_10.png',
      'squat_15': 'assets/images/img_squat_15.png',
      'plank_30': 'assets/images/img_plank_30.png',
      'plank_60': 'assets/images/img_plank_60up.png',
      'pushup_15': 'assets/images/img_pushup_15.png',
    };
    return imageMap[exerciseId];
  }

  @override
  Widget build(BuildContext context) {
    return HomeLayout(
      title: 'DDUDUK',
      currentNavIndex: _currentNavIndex,
      onNavTap: _onNavTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppDimens.space16),
          // 회복상태 카드
          RecoveryStatusCard(
            userName: _userName,
            recoveryPercent: _recoveryPercent,
          ),
          const SizedBox(height: AppDimens.space24),
          // 운동 캘린더
          ExerciseCalendar(
            exerciseDays: _exerciseDays,
            onDateSelected: _onDateSelected,
            onMonthChanged: _onMonthChanged,
          ),
          const SizedBox(height: AppDimens.space24),
        ],
      ),
    );
  }
}
