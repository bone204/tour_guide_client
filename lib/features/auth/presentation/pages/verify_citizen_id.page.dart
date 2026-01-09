import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/pages/cccd_camera.page.dart';
import 'package:tour_guide_app/common/pages/selfie_camera.page.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/verify_citizen_id/verify_citizen_id_cubit.dart';
import 'package:tour_guide_app/features/auth/presentation/bloc/verify_citizen_id/verify_citizen_id_state.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:camera/camera.dart';

class VerifyCitizenIdPage extends StatelessWidget {
  const VerifyCitizenIdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<VerifyCitizenIdCubit>(),
      child: const _VerifyCitizenIdView(),
    );
  }
}

class _VerifyCitizenIdView extends StatelessWidget {
  const _VerifyCitizenIdView();

  Future<void> _pickCitizenImage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CccdCameraPage()),
    );

    if (result is XFile && context.mounted) {
      context.read<VerifyCitizenIdCubit>().setCitizenFront(File(result.path));
    }
  }

  Future<void> _pickSelfieImage(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelfieCameraPage()),
    );

    if (result is XFile && context.mounted) {
      context.read<VerifyCitizenIdCubit>().setSelfie(File(result.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.verifyCitizenId,
        showBackButton: true,
        onBackPressed: () => Navigator.pop(context),
      ),
      body: BlocConsumer<VerifyCitizenIdCubit, VerifyCitizenIdState>(
        listener: (context, state) {
          if (state.status == VerifyCitizenIdStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(AppLocalizations.of(context)!.verifySuccess),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state.status == VerifyCitizenIdStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.errorMessage ?? AppLocalizations.of(context)!.error,
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildImagePicker(
                  context,
                  title: AppLocalizations.of(context)!.citizenId,
                  instruction: AppLocalizations.of(context)!.captureCitizenId,
                  image: state.citizenFront,
                  onTap: () => _pickCitizenImage(context),
                ),
                SizedBox(height: 20.h),
                _buildImagePicker(
                  context,
                  title: AppLocalizations.of(context)!.selfiePhoto,
                  instruction: AppLocalizations.of(context)!.capturePortrait,
                  image: state.selfie,
                  onTap: () => _pickSelfieImage(context),
                ),
                SizedBox(height: 30.h),
                PrimaryButton(
                  title: AppLocalizations.of(context)!.verify,
                  isLoading: state.status == VerifyCitizenIdStatus.loading,
                  onPressed:
                      (state.citizenFront != null && state.selfie != null)
                          ? () => context.read<VerifyCitizenIdCubit>().submit()
                          : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImagePicker(
    BuildContext context, {
    required String title,
    required String instruction,
    required File? image,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[300]!),
              image:
                  image != null
                      ? DecorationImage(
                        image: FileImage(image),
                        fit: BoxFit.cover,
                      )
                      : null,
            ),
            child:
                image == null
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          size: 40.sp,
                          color: Colors.grey[600],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          instruction,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                    : Container(
                      alignment: Alignment.center,
                      color: Colors.black26,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 16.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              AppLocalizations.of(context)!.retake,
                              style: Theme.of(context).textTheme.labelLarge
                                  ?.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
          ),
        ),
      ],
    );
  }
}
