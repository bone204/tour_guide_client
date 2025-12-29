import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/cooperations/presentation/widgets/cooperation_comment.widget.dart';

class CooperationReviewsTab extends StatelessWidget {
  final int id;

  const CooperationReviewsTab({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: CooperationCommentWidget(cooperationId: id),
      ),
    );
  }
}
