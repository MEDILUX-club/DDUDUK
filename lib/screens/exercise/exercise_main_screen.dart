import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/layouts/home_layout.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/exercise/exercise_start_card.dart';
import 'package:go_router/go_router.dart';

/// 운동 메인 화면 (데이터 있음)
class ExerciseMainScreen extends StatefulWidget {
  const ExerciseMainScreen({super.key});

  @override
  State<ExerciseMainScreen> createState() => _ExerciseMainScreenState();
}

class _ExerciseMainScreenState extends State<ExerciseMainScreen> {
  int _currentNavIndex = 1; // 운동 탭 선택됨
  final String _userName = '황두현님'; // 사용자 이름 (추후 API 연동 시 변경)

  void _onNavTap(int index) {
    if (index == _currentNavIndex) return;

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        // 이미 운동 탭에 있으므로 유지
        break;
      case 2:
        context.go('/mypage');
        break;
    }
  }

  void _onStartExercise() {
    context.push('/exercise/survey1');
  }

  @override
  Widget build(BuildContext context) {
    return HomeLayout(
      title: '운동하기',
      currentNavIndex: _currentNavIndex,
      onNavTap: _onNavTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 그린 카드
          ExerciseStartCard(
            userName: _userName,
            onStartPressed: _onStartExercise,
          ),
          const SizedBox(height: AppDimens.space24),

          // 이번 주 진행 상황
          _buildWeeklyProgress(),
          const SizedBox(height: AppDimens.space24),

          // 다음 운동 루틴
          _buildNextRoutineSection(),
        ],
      ),
    );
  }



  Widget _buildWeeklyProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SvgPicture.asset(
              'assets/icons/ic_up.svg',
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.primary,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '이번 주 진행 상황',
              style: AppTextStyles.body16SemiBold.copyWith(
                color: AppColors.textStrong,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.space12),
        Row(
          children: [
            // 운동 횟수 카드
            Expanded(
              child: _StatCard(
                title: '운동 횟수',
                value: '3회',
                change: '+1',
                changeLabel: '저번 주 대비',
                isPositive: true,
              ),
            ),
            const SizedBox(width: AppDimens.itemSpacing),
            // 총 시간 카드
            Expanded(
              child: _StatCard(
                title: '총 시간',
                value: '65분',
                change: '+20분',
                changeLabel: '저번 주 대비',
                isPositive: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNextRoutineSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_clock.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '다음 운동 루틴',
                  style: AppTextStyles.body16SemiBold.copyWith(
                    color: AppColors.textStrong,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                '전체보기',
                style: AppTextStyles.body14Regular.copyWith(
                  color: AppColors.textAssistive,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimens.space12 ),
        // 운동 카드 리스트
        _ExerciseCard(name: '스쿼트', duration: '20분', sets: '3세트', difficulty: 1),
        const SizedBox(height: AppDimens.space8),
        _ExerciseCard(name: '스쿼트', duration: '20분', sets: '3세트', difficulty: 2),
        const SizedBox(height: AppDimens.space8),
        _ExerciseCard(name: '스쿼트', duration: '20분', sets: '3세트', difficulty: 3),
      ],
    );
  }
}

/// 통계 카드 위젯
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.title,
    required this.value,
    required this.change,
    required this.changeLabel,
    required this.isPositive,
  });

  final String title;
  final String value;
  final String change;
  final String changeLabel;
  final bool isPositive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lineNeutral),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.body12Regular.copyWith(
              color: AppColors.textAssistive,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTextStyles.titleHeader.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textStrong,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/ic_up.svg',
                width: 14,
                height: 14,
                colorFilter: const ColorFilter.mode(
                  AppColors.primary,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                change,
                style: AppTextStyles.body12Regular.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                changeLabel,
                style: AppTextStyles.body12Regular.copyWith(
                  color: AppColors.textAssistive,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 운동 카드 위젯
class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({
    required this.name,
    required this.duration,
    required this.sets,
    required this.difficulty,
  });

  final String name;
  final String duration;
  final String sets;
  final int difficulty; // 1-4

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lineNeutral),
      ),
      child: Row(
        children: [
          // 썸네일
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.fillDefault,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(width: AppDimens.space12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.body16Regular.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textStrong,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          '난이도',
                          style: AppTextStyles.body12Regular.copyWith(
                            color: AppColors.textAssistive,
                          ),
                        ),
                        const SizedBox(width: 4),
                        ...List.generate(4, (index) {
                          return Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(left: 2),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: index < difficulty
                                  ? AppColors.primary
                                  : AppColors.lineNeutral,
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: AppColors.textAssistive,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: AppTextStyles.body12Regular.copyWith(
                        color: AppColors.textAssistive,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.fitness_center,
                      size: 14,
                      color: AppColors.textAssistive,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      sets,
                      style: AppTextStyles.body12Regular.copyWith(
                        color: AppColors.textAssistive,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

