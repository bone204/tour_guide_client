import 'package:flutter/material.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';

class RentalProcessPage extends StatelessWidget {
  const RentalProcessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Rental Process", 
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: const Center(child: Text("Rental Process Tracking")),
    );
  }
}
