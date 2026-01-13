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

/// 홈 화면
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final int _currentNavIndex = 0;
  final _userRepository = UserRepository();
  
  String _userName = '사용자';

  // 예시 데이터: 운동한 날짜 (8월)
  final List<int> _exerciseDays = [1, 4, 8, 9, 10, 12];

  // 예시 데이터: 운동 기록
  final Map<int, List<ExerciseRoutineData>> _exerciseRecords = {
    1: [
      const ExerciseRoutineData(
        name: '스쿼트',
        difficulty: 1,
        sets: 3,
        reps: 10,
        imagePath: 'assets/images/img_squat_10.png',
      ),
    ],
    4: [
      const ExerciseRoutineData(
        name: '플랭크',
        difficulty: 2,
        sets: 3,
        reps: 30,
        imagePath: 'assets/images/img_plank_30.png',
      ),
    ],
    8: [
      const ExerciseRoutineData(
        name: '스쿼트',
        difficulty: 1,
        sets: 3,
        reps: 10,
        imagePath: 'assets/images/img_squat_10.png',
      ),
      const ExerciseRoutineData(
        name: '푸쉬업',
        difficulty: 2,
        sets: 3,
        reps: 15,
        imagePath: 'assets/images/img_pushup_15.png',
      ),
    ],
    9: [
      const ExerciseRoutineData(
        name: '스쿼트',
        difficulty: 1,
        sets: 3,
        reps: 15,
        imagePath: 'assets/images/img_squat_15.png',
      ),
    ],
    10: [
      const ExerciseRoutineData(
        name: '스쿼트',
        difficulty: 1,
        sets: 3,
        reps: 10,
        imagePath: 'assets/images/img_squat_10.png',
      ),
      const ExerciseRoutineData(
        name: '스쿼트',
        difficulty: 1,
        sets: 3,
        reps: 10,
        imagePath: 'assets/images/img_squat_10.png',
      ),
      const ExerciseRoutineData(
        name: '스쿼트',
        difficulty: 1,
        sets: 3,
        reps: 10,
        imagePath: 'assets/images/img_squat_10.png',
      ),
    ],
    12: [
      const ExerciseRoutineData(
        name: '플랭크',
        difficulty: 3,
        sets: 3,
        reps: 60,
        imagePath: 'assets/images/img_plank_60up.png',
      ),
    ],
  };

  @override
  void initState() {
    super.initState();
    _loadUserName();
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

  void _onDateSelected(DateTime date) {
    debugPrint('선택된 날짜: $date');

    // 운동한 날인 경우에만 모달 표시
    if (_exerciseDays.contains(date.day)) {
      final records = _exerciseRecords[date.day] ?? [];
      showExerciseRecordModal(context: context, date: date, records: records);
    }
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
          RecoveryStatusCard(userName: _userName, recoveryPercent: 72),
          const SizedBox(height: AppDimens.space24),
          // 운동 캘린더
          ExerciseCalendar(
            exerciseDays: _exerciseDays,
            onDateSelected: _onDateSelected,
          ),
          const SizedBox(height: AppDimens.space24),
        ],
      ),
    );
  }
}
