import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common_libs.dart';

class MappingAddressPage extends StatelessWidget {
  const MappingAddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.mappingAddress,
        onBackPressed: () => Navigator.pop(context),
      ),  
      body: Center(
        child: Text('Mapping Address'),
      ),
    );
  }
}