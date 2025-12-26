import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/common/bottom_nav_bar.dart';
import 'package:go_router/go_router.dart';

/// 운동 메인 화면 (데이터 있음)
class ExerciseMainScreen extends StatefulWidget {
  const ExerciseMainScreen({super.key});

  @override
  State<ExerciseMainScreen> createState() => _ExerciseMainScreenState();
}

class _ExerciseMainScreenState extends State<ExerciseMainScreen> {
  int _currentNavIndex = 1; // 운동 탭 선택됨

  void _onNavTap(int index) {
    setState(() {
      _currentNavIndex = index;
    });
    // TODO: 각 탭에 맞는 화면으로 라우팅
  }

  void _onStartExercise() {
    context.push('/exercise/survey1');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.fillDefault,
      appBar: AppBar(
        title: const Text('운동하기'),
        backgroundColor: AppColors.fillDefault,
        foregroundColor: AppColors.textStrong,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTextStyles.titleHeader.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 그린 카드
            _buildStartCard(),
            const SizedBox(height: AppDimens.space24),

            // 이번 주 진행 상황
            _buildWeeklyProgress(),
            const SizedBox(height: AppDimens.space24),

            // 다음 운동 루틴
            _buildNextRoutineSection(),
            const SizedBox(height: AppDimens.space24),

            // 운동 루틴 보기
            _buildRoutineHistorySection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: _onNavTap,
      ),
    );
  }

  Widget _buildStartCard() {
    final today = DateTime.now();
    final dateString =
        '${today.year}.${today.month.toString().padLeft(2, '0')}.${today.day.toString().padLeft(2, '0')}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.space20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryLight, AppColors.primarySecondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateString,
                  style: AppTextStyles.body14Medium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppDimens.space8),
                Text(
                  '황두현님',
                  style: AppTextStyles.body16Regular.copyWith(
                    color: AppColors.textStrong,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '오늘 운동 시작해볼까요?',
                  style: AppTextStyles.body18SemiBold.copyWith(
                    color: AppColors.textStrong,
                  ),
                ),
                const SizedBox(height: AppDimens.space16),
                // 시작하기 버튼
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _onStartExercise,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '시작하기',
                          style: AppTextStyles.body16Regular.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimens.space12),
          // 아령 아이콘
          SvgPicture.asset(
            'assets/icons/ic_fitness.svg',
            width: 64,
            height: 64,
            colorFilter: const ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
          ),
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
              style: AppTextStyles.body18SemiBold.copyWith(
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
                changeLabel: '지난 주 대비',
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
                changeLabel: '지난 주 대비',
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
                  style: AppTextStyles.body18SemiBold.copyWith(
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
        const SizedBox(height: AppDimens.space12),
        // 운동 카드 리스트
        _ExerciseCard(name: '스쿼트', duration: '20분', sets: '3세트', difficulty: 1),
        const SizedBox(height: AppDimens.space8),
        _ExerciseCard(name: '스쿼트', duration: '20분', sets: '3세트', difficulty: 2),
        const SizedBox(height: AppDimens.space8),
        _ExerciseCard(name: '스쿼트', duration: '20분', sets: '3세트', difficulty: 3),
      ],
    );
  }

  Widget _buildRoutineHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/ic_content.svg',
                  width: 20,
                  height: 20,
                  colorFilter: const ColorFilter.mode(
                    AppColors.primary,
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '운동 루틴 보기',
                  style: AppTextStyles.body18SemiBold.copyWith(
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
        const SizedBox(height: AppDimens.space12),
        // 히스토리 리스트
        _RoutineHistoryCard(
          date: '2025년 11월 11일',
          description: '무릎 강화운동 · 70분',
        ),
        const SizedBox(height: AppDimens.space8),
        _RoutineHistoryCard(
          date: '2025년 11월 10일',
          description: '하체근력 강화운동 · 40분',
        ),
        const SizedBox(height: AppDimens.space8),
        _RoutineHistoryCard(
          date: '2025년 11월 9일',
          description: '하체근력 강화운동 · 50분',
        ),
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
                '$change $changeLabel',
                style: AppTextStyles.body12Regular.copyWith(
                  color: AppColors.primary,
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
  final int difficulty; // 1-3

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
                        ...List.generate(3, (index) {
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
                    SvgPicture.asset(
                      'assets/icons/ic_set.svg',
                      width: 14,
                      height: 14,
                      colorFilter: const ColorFilter.mode(
                        AppColors.textAssistive,
                        BlendMode.srcIn,
                      ),
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

/// 루틴 히스토리 카드 위젯
class _RoutineHistoryCard extends StatelessWidget {
  const _RoutineHistoryCard({required this.date, required this.description});

  final String date;
  final String description;

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                date,
                style: AppTextStyles.body16Regular.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textStrong,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: AppTextStyles.body12Regular.copyWith(
                  color: AppColors.textAssistive,
                ),
              ),
            ],
          ),
          const Icon(Icons.chevron_right, color: AppColors.textAssistive),
        ],
      ),
    );
  }
}
