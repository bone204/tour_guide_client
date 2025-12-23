import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';

class VerifyCitizenIdPage extends StatelessWidget {
  const VerifyCitizenIdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Verify Citizen ID',
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: Center(
        child: Text('Verify Citizen ID'),
      ),
    );
  }
}