import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:dduduk_app/theme/app_colors.dart';
import 'package:dduduk_app/theme/app_dimens.dart';
import 'package:dduduk_app/theme/app_text_styles.dart';
import 'package:dduduk_app/widgets/exercise/exercise_routine_card.dart';

/// 운동 기록 모달 표시 함수
void showExerciseRecordModal({
  required BuildContext context,
  required DateTime date,
  required List<ExerciseRoutineData> records,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => ExerciseRecordModal(date: date, records: records),
  );
}

/// 운동 기록 모달 위젯
class ExerciseRecordModal extends StatelessWidget {
  const ExerciseRecordModal({
    super.key,
    required this.date,
    required this.records,
  });

  final DateTime date;
  final List<ExerciseRoutineData> records;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.fillDefault,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // 드래그 핸들
              _buildDragHandle(),
              // 헤더
              _buildHeader(),
              // 운동 목록
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimens.space16,
                    vertical: AppDimens.space8,
                  ),
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    return ExerciseRoutineCard(exercise: records[index]);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Container(
      margin: const EdgeInsets.only(top: AppDimens.space12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.linePrimary,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(AppDimens.space16),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/icons/ic_dumbbell.svg',
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              AppColors.primary,
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: AppDimens.space8),
          Text(
            '${date.month}월 ${date.day}일 운동 기록',
            style: AppTextStyles.body18SemiBold.copyWith(
              color: AppColors.textStrong,
            ),
          ),
        ],
      ),
    );
  }
}
