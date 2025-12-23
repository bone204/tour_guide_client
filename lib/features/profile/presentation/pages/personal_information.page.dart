import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/textfield/custom_textfield.dart';
import 'package:tour_guide_app/features/profile/data/models/user.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_state.dart';
import 'package:tour_guide_app/features/profile/data/models/update_initial_profile_model.dart';
import 'package:tour_guide_app/features/profile/data/models/update_verification_info_model.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/edit_profile/edit_profile_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/edit_profile/edit_profile_state.dart';
import 'package:tour_guide_app/service_locator.dart';

class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  // Controllers
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _isEmailVerifiedController = TextEditingController();
  final _isPhoneVerifiedController = TextEditingController();
  final _isCitizenIdVerifiedController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _genderController = TextEditingController();
  final _addressController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _citizenIdController = TextEditingController();

  User? _currentUser;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _isEmailVerifiedController.dispose();
    _isPhoneVerifiedController.dispose();
    _isCitizenIdVerifiedController.dispose();
    _dateOfBirthController.dispose();
    _fullNameController.dispose();
    _genderController.dispose();
    _addressController.dispose();
    _nationalityController.dispose();
    _citizenIdController.dispose();
    super.dispose();
  }

  void _updateControllers(User user) {
    _usernameController.text = user.username;
    _emailController.text = user.email ?? '';
    _phoneController.text = user.phone ?? '';
    _isEmailVerifiedController.text = user.isEmailVerified.toString();
    _isPhoneVerifiedController.text = user.isPhoneVerified.toString();
    _isCitizenIdVerifiedController.text = user.isCitizenIdVerified.toString();
    _dateOfBirthController.text = user.dateOfBirth ?? '';
    _fullNameController.text = user.fullName ?? '';
    _genderController.text = user.gender ?? '';
    _addressController.text = user.address ?? '';
    _nationalityController.text = user.nationality ?? '';
    _citizenIdController.text = user.citizenId ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<GetMyProfileCubit>()..getMyProfile()),
        BlocProvider(create: (_) => sl<EditProfileCubit>()),
      ],
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocListener<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state is EditProfileLoading) {
              // Show loading overlay or handled by button
            } else if (state is EditProfileSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context)!.profileUpdatedSuccessfully,
                  ),
                ),
              );
              context.read<GetMyProfileCubit>().getMyProfile();
            } else if (state is EditProfileFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${AppLocalizations.of(context)!.errorPrefix}${state.message}',
                  ),
                ),
              );
            }
          },
          child: Builder(
            builder: (context) {
              return WillPopScope(
                onWillPop: () async {
                  if (_hasChanges()) {
                    return await _showDiscardChangesDialog(context);
                  }
                  return true;
                },
                child: Scaffold(
                  appBar: CustomAppBar(
                    title: AppLocalizations.of(context)!.personalInfo,
                    showBackButton: true,
                    onBackPressed: () async {
                      if (_hasChanges()) {
                        final discard = await _showDiscardChangesDialog(
                          context,
                        );
                        if (discard && context.mounted) {
                          Navigator.pop(context);
                        }
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                  body: BlocConsumer<GetMyProfileCubit, GetMyProfileState>(
                    listener: (context, state) {
                      if (state is GetMyProfileSuccess) {
                        _currentUser = state.user;
                        _updateControllers(state.user);
                      }
                    },
                    builder: (context, state) {
                      if (state is GetMyProfileLoading) {
                        return _buildShimmerLoading();
                      } else if (state is GetMyProfileFailure) {
                        return Center(child: Text('Error: ${state.message}'));
                      } else if (state is GetMyProfileSuccess ||
                          _currentUser != null) {
                        return Stack(
                          children: [
                            _buildForm(context),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: _buildUpdateButton(context),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Center(child: _buildAvatar(context)),
          SizedBox(height: 20.h),

          _buildTextField(
            AppLocalizations.of(context)!.username,
            _usernameController,
          ),
          _buildTextField(
            AppLocalizations.of(context)!.email,
            _emailController,
            suffixIcon: _buildVerificationBadge(
              _currentUser?.isEmailVerified ?? false,
            ),
          ),
          _buildTextField(
            AppLocalizations.of(context)!.phone,
            _phoneController,
            suffixIcon: _buildVerificationBadge(
              _currentUser?.isPhoneVerified ?? false,
            ),
          ),

          _buildTextField(
            AppLocalizations.of(context)!.fullName,
            _fullNameController,
          ),
          _buildTextField(
            AppLocalizations.of(context)!.dateOfBirth,
            _dateOfBirthController,
          ),
          _buildTextField(
            AppLocalizations.of(context)!.gender,
            _genderController,
          ),
          _buildTextField(
            AppLocalizations.of(context)!.address,
            _addressController,
          ),
          _buildTextField(
            AppLocalizations.of(context)!.nationality,
            _nationalityController,
          ),
          _buildTextField(
            AppLocalizations.of(context)!.citizenId,
            _citizenIdController,
            suffixIcon: _buildVerificationBadge(
              _currentUser?.isCitizenIdVerified ?? false,
            ),
          ),

          SizedBox(height: 10.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.images,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 6.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite,
                  border: Border.all(
                    color: AppColors.secondaryGrey,
                    width: 1.w,
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildImageThumbnail(
                        context,
                        AppLocalizations.of(context)!.idCard,
                        _currentUser?.idCardImageUrl,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _buildImageThumbnail(
                        context,
                        AppLocalizations.of(context)!.citizenFront,
                        _currentUser?.citizenFrontImageUrl,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: _buildImageThumbnail(
                        context,
                        AppLocalizations.of(context)!.citizenBack,
                        _currentUser?.citizenBackImageUrl,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: CustomTextField(
        label: label,
        placeholder: '',
        controller: controller,
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildVerificationBadge(bool isVerified) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: 8.w),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color:
                isVerified ? AppColors.primaryGreen : AppColors.secondaryGrey,
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Text(
            isVerified
                ? AppLocalizations.of(context)!.verified
                : AppLocalizations.of(context)!.unverified,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final avatarUrl = _currentUser?.avatarUrl;
    final firstLetter =
        (_currentUser?.username.isNotEmpty ?? false)
            ? _currentUser!.username[0].toUpperCase()
            : '?';

    return GestureDetector(
      onTap: () {
        if (avatarUrl != null) {
          _showImageDialog(context, avatarUrl);
        }
      },
      child: Container(
        width: 100.w,
        height: 100.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryBlue, width: 2.w),
          color: AppColors.secondaryGrey.withOpacity(0.3),
        ),
        child: ClipOval(
          child:
              avatarUrl != null
                  ? Image.network(
                    avatarUrl,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) =>
                            _buildFallbackAvatar(firstLetter),
                  )
                  : _buildFallbackAvatar(firstLetter),
        ),
      ),
    );
  }

  Widget _buildFallbackAvatar(String text) {
    return Container(
      color: AppColors.primaryBlue.withOpacity(0.2),
      alignment: Alignment.center,
      child: Text(
        text,
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          color: AppColors.primaryBlue,
          fontSize: 40.sp,
        ),
      ),
    );
  }

  Widget _buildImageThumbnail(
    BuildContext context,
    String label,
    String? imageUrl,
  ) {
    return Column(
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        SizedBox(height: 4.h),
        GestureDetector(
          onTap: () {
            if (imageUrl != null) {
              _showImageDialog(context, imageUrl);
            }
          },
          child: Container(
            height: 80.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.secondaryGrey),
            ),
            child:
                imageUrl != null
                    ? ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder:
                            (_, __, ___) => const Icon(Icons.broken_image),
                      ),
                    )
                    : const Icon(Icons.image_not_supported, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                InteractiveViewer(
                  // Allow zooming
                  child: Image.network(imageUrl),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.separated(
        padding: EdgeInsets.all(20.w),
        itemBuilder:
            (_, __) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16.h, width: 100.w, color: Colors.white),
                SizedBox(height: 6.h),
                Container(
                  height: 48.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ],
            ),
        separatorBuilder: (_, __) => SizedBox(height: 16.h),
        itemCount: 10,
      ),
    );
  }

  bool _hasChanges() {
    if (_currentUser == null) return false;
    return _fullNameController.text != (_currentUser!.fullName ?? '') ||
        _dateOfBirthController.text != (_currentUser!.dateOfBirth ?? '') ||
        _genderController.text != (_currentUser!.gender ?? '') ||
        _addressController.text != (_currentUser!.address ?? '') ||
        _nationalityController.text != (_currentUser!.nationality ?? '') ||
        _emailController.text != (_currentUser!.email ?? '') ||
        _phoneController.text != (_currentUser!.phone ?? '') ||
        _citizenIdController.text != (_currentUser!.citizenId ?? '');
  }

  Future<bool> _showDiscardChangesDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.confirm),
              content: Text(
                AppLocalizations.of(context)!.unsavedChangesMessage,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(AppLocalizations.of(context)!.cancel),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(AppLocalizations.of(context)!.confirm),
                ),
              ],
            );
          },
        ) ??
        false;
  }

  Widget _buildUpdateButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => _onUpdatePressed(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            padding: EdgeInsets.symmetric(vertical: 16.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Text(
            AppLocalizations.of(context)!.update,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _onUpdatePressed(BuildContext context) {
    if (_hasChanges()) {
      final initialProfile = UpdateInitialProfileModel(
        fullName:
            _fullNameController.text != (_currentUser?.fullName ?? '')
                ? _fullNameController.text
                : null,
        dateOfBirth:
            _dateOfBirthController.text != (_currentUser?.dateOfBirth ?? '')
                ? _dateOfBirthController.text.isNotEmpty
                    ? _dateOfBirthController.text
                    : null
                : null,
        gender:
            _genderController.text != (_currentUser?.gender ?? '')
                ? _genderController.text.toLowerCase()
                : null,
        address:
            _addressController.text != (_currentUser?.address ?? '')
                ? _addressController.text
                : null,
        nationality:
            _nationalityController.text != (_currentUser?.nationality ?? '')
                ? _nationalityController.text
                : null,
      );

      final verificationInfo = UpdateVerificationInfoModel(
        email:
            _emailController.text != (_currentUser?.email ?? '')
                ? _emailController.text
                : null,
        phone:
            _phoneController.text != (_currentUser?.phone ?? '')
                ? _phoneController.text
                : null,
        citizenId:
            _citizenIdController.text != (_currentUser?.citizenId ?? '')
                ? _citizenIdController.text
                : null,
      );

      context.read<EditProfileCubit>().updateProfile(
        initialProfile: initialProfile,
        verificationInfo: verificationInfo,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.noChangesToUpdate),
        ),
      );
    }
  }
}
