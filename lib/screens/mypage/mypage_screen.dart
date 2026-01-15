import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:dduduk_app/layouts/home_layout.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/screens/survey/survey_step1_basic_info_screen.dart';
import 'package:dduduk_app/screens/survey/survey_step2_pain_location_screen.dart';
import 'package:dduduk_app/widgets/exercise/rest_exit_modal.dart';
import 'package:dduduk_app/repositories/pain_survey_repository.dart';
import 'package:dduduk_app/services/token_service.dart';
import 'package:dduduk_app/providers/user_provider.dart';

/// 마이페이지 화면
class MypageScreen extends ConsumerStatefulWidget {
  const MypageScreen({super.key});

  @override
  ConsumerState<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends ConsumerState<MypageScreen> {
  final int _currentNavIndex = 2; // 마이페이지 탭 선택
  final _painSurveyRepository = PainSurveyRepository();

  // 진단 결과 데이터
  int _diagnosisPercentage = 0;
  String _painArea = '';
  String _diagnosisType = '';

  @override
  void initState() {
    super.initState();
    // Provider 수정은 build 이후에 수행해야 함
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    // Provider를 통해 프로필 로드
    ref.read(userProvider.notifier).fetchProfile();

    // 진단 결과 로드
    await _loadDiagnosis();
  }

  Future<void> _loadDiagnosis() async {
    try {
      final painSurvey = await _painSurveyRepository.getPainSurvey();

      if (mounted && painSurvey != null) {
        setState(() {
          _diagnosisPercentage = painSurvey.diagnosisPercentage;
          _painArea = painSurvey.painArea ?? '';
          _diagnosisType = _getDiagnosisTypeName(painSurvey.diagnosisType);
        });
      }
    } catch (e) {
      debugPrint('진단 결과 로딩 오류: $e');
    }
  }

  /// 진단 유형 코드를 한글 이름으로 변환
  String _getDiagnosisTypeName(String type) {
    switch (type) {
      case 'DEG': return '퇴행성 유형';
      case 'INF': return '염증형 유형';
      case 'TRM': return '외상형 유형';
      case 'OVU': return '과사용성 유형';
      default: return type;
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

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final userName = userState.isLoading ? '로딩 중...' : userState.nickname;

    // 프로필 이미지 URL 처리
    String? profileImageUrl;
    final imageUrl = userState.profileImageUrl;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('/')) {
        profileImageUrl = 'http://43.201.28.83:8080$imageUrl';
      } else {
        profileImageUrl = imageUrl;
      }
    }

    return HomeLayout(
      title: '마이페이지',
      currentNavIndex: _currentNavIndex,
      onNavTap: _onNavTap,
      child: Column(
        children: [
          const SizedBox(height: AppDimens.space16),
          // 프로필 카드
          _ProfileCard(
            userName: userName,
            profileImageUrl: profileImageUrl,
            recoveryPercent: _diagnosisPercentage,
            painArea: _painArea,
            conditionType: _diagnosisType.isNotEmpty ? _diagnosisType : '진단 정보 없음',
            onEditPressed: () async {
              // 프로필 편집 화면으로 이동하고 돌아오면 새로고침
              await context.push('/mypage/profile-edit');
              ref.read(userProvider.notifier).fetchProfile();
            },
          ),
          const SizedBox(height: AppDimens.space16),
          // 메뉴 항목들
          _MenuItemCard(
            icon: Icons.schedule_outlined,
            title: '다음 운동 일정 변경',
            onTap: () {
              context.push('/exercise/reservation');
            },
          ),
          const SizedBox(height: AppDimens.space12),
          _MenuItemCard(
            icon: Icons.description_outlined,
            title: '셀프 설문 응답 확인',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const SurveyStep1BasicInfoScreen(
                    readOnly: true,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: AppDimens.space12),
          _MenuItemCard(
            svgIconPath: 'assets/icons/ic_profile.svg',
            title: '운동 부위 변경하기',
            onTap: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (_) => const RestExitModal(
                  title: '부위 변경 시 통증 설문을 다시 진행하며,\n운동 루틴이 새로 설정돼요.',
                  cancelText: '취소하기',
                  confirmText: '변경하기',
                ),
              );
              if (result == true && context.mounted) {
                try {
                  // Provider를 통해 설문 초기화
                  await ref.read(userProvider.notifier).resetSurveys();

                  // 설문 화면으로 이동하고 완료를 기다림
                  if (context.mounted) {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const SurveyStep2PainLocationScreen(
                          isChangePart: true,
                        ),
                      ),
                    );

                    // 설문 완료 후 프로필 새로고침
                    ref.read(userProvider.notifier).fetchProfile();
                    _loadDiagnosis();
                  }
                } catch (e) {
                  // 에러 처리
                  debugPrint('설문 초기화 오류: $e');
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('설문 초기화 중 오류가 발생했습니다.'),
                      ),
                    );
                  }
                }
              }
            },
          ),
          const SizedBox(height: AppDimens.space24),
        ],
      ),
    );
  }
}


/// 프로필 카드 위젯
class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.userName,
    this.profileImageUrl,
    required this.recoveryPercent,
    required this.painArea,
    required this.conditionType,
    this.onEditPressed,
  });

  final String userName;
  final String? profileImageUrl;
  final int recoveryPercent;
  final String painArea;
  final String conditionType;
  final VoidCallback? onEditPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.space20),
      decoration: BoxDecoration(
        color: AppColors.fillBoxDefault,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // 프로필 이미지
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.linePrimary,
              shape: BoxShape.circle,
              image: profileImageUrl != null && profileImageUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(profileImageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: profileImageUrl == null || profileImageUrl!.isEmpty
                ? const Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.textDisabled,
                  )
                : null,
          ),
          const SizedBox(width: AppDimens.space16),
          // 사용자 정보
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 이름 + 편집 버튼
                Row(
                  children: [
                    Text(
                      '$userName님',
                      style: AppTextStyles.body20SemiBold.copyWith(
                        color: AppColors.textStrong,
                      ),
                    ),
                    const SizedBox(width: AppDimens.space8),
                    GestureDetector(
                      onTap: onEditPressed,
                      child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: SvgPicture.asset(
                          'assets/icons/ic_pencil.svg',
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppDimens.space8),
                // 상태 배지
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.space12,
                    vertical: AppDimens.space6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$recoveryPercent% $painArea $conditionType',
                    style: AppTextStyles.body14Medium.copyWith(
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 메뉴 항목 카드 위젯
class _MenuItemCard extends StatelessWidget {
  const _MenuItemCard({
    this.icon,
    this.svgIconPath,
    required this.title,
    required this.onTap,
  }) : assert(
         icon != null || svgIconPath != null,
         'icon 또는 svgIconPath 중 하나는 필수입니다',
       );

  final IconData? icon;
  final String? svgIconPath;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimens.space16,
          vertical: AppDimens.space20,
        ),
        decoration: BoxDecoration(
          color: AppColors.fillBoxDefault,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // 아이콘
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.fillDefault,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: svgIconPath != null
                    ? SvgPicture.asset(
                        svgIconPath!,
                        width: 22,
                        height: 22,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary,
                          BlendMode.srcIn,
                        ),
                      )
                    : Icon(icon, size: 22, color: AppColors.primary),
              ),
            ),
            const SizedBox(width: AppDimens.space12),
            // 제목
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.body16Medium.copyWith(
                  color: AppColors.textStrong,
                ),
              ),
            ),
            // 화살표
            const Icon(
              Icons.chevron_right,
              size: 24,
              color: AppColors.textAssistive,
            ),
          ],
        ),
      ),
    );
  }
}
