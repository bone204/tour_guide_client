import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_appbar.dart';
import 'package:tour_guide_app/common/widgets/button/primary_button.dart';
import 'package:tour_guide_app/features/profile/data/models/user.dart';
import 'dart:io';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/get_my_profile/get_my_profile_state.dart';
import 'package:tour_guide_app/features/profile/data/models/update_initial_profile_model.dart';
import 'package:tour_guide_app/features/profile/data/models/update_verification_info_model.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/edit_profile/edit_profile_cubit.dart';
import 'package:tour_guide_app/features/profile/presentation/bloc/edit_profile/edit_profile_state.dart';
import 'package:tour_guide_app/features/profile/presentation/widgets/profile_avatar.dart';
import 'package:tour_guide_app/features/profile/presentation/widgets/profile_verification_badge.dart';
import 'package:tour_guide_app/features/profile/presentation/widgets/profile_text_field.dart';
import 'package:tour_guide_app/features/profile/presentation/widgets/citizen_images_section.dart';
import 'package:tour_guide_app/service_locator.dart';
import 'package:tour_guide_app/core/events/app_events.dart';

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
  File? _avatarFile;

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

  bool _isValidEmail(String email) {
    if (email.isEmpty) return false;
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    if (phone.isEmpty) return false;
    final phoneRegex = RegExp(r'^\d{10}$');
    return phoneRegex.hasMatch(phone);
  }

  bool _isValidCitizenId(String id) {
    if (id.isEmpty) return false;
    // Assuming citizen ID is 9 or 12 digits
    final idRegex = RegExp(r'^\d{9}$|^\d{12}$');
    return idRegex.hasMatch(id);
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
              eventBus.fire(ProfileUpdatedEvent());
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
                        _avatarFile = null; // Reset avatar file after success
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
          // Avatar
          ProfileAvatarWidget(
            avatarUrl: _currentUser?.avatarUrl,
            fullName: _currentUser?.fullName ?? _currentUser?.username,
            imageFile: _avatarFile,
            onImagePicked: (file) {
              setState(() {
                _avatarFile = file;
              });
            },
          ),
          SizedBox(height: 20.h),

          ProfileTextField(
            label: AppLocalizations.of(context)!.username,
            controller: _usernameController,
          ),
          ProfileTextField(
            label: AppLocalizations.of(context)!.email,
            controller: _emailController,
            validator: (value) {
              if (value != null && value.isNotEmpty && !_isValidEmail(value)) {
                return AppLocalizations.of(context)!.pleaseEnterValidEmail;
              }
              return null;
            },
            suffixIcon:
                (_currentUser?.email != null && _currentUser!.email!.isNotEmpty)
                    ? ProfileVerificationBadge(
                      isVerified: _currentUser?.isEmailVerified ?? false,
                      onTap: () {
                        if (!(_currentUser?.isEmailVerified ?? false)) {
                          Navigator.pushNamed(
                            context,
                            AppRouteConstant.verifyEmail,
                          );
                        }
                      },
                    )
                    : null,
          ),
          ProfileTextField(
            label: AppLocalizations.of(context)!.phone,
            controller: _phoneController,
            validator: (value) {
              if (value != null && value.isNotEmpty && !_isValidPhone(value)) {
                return AppLocalizations.of(context)!.phoneNumberInvalid;
              }
              return null;
            },
            suffixIcon:
                (_currentUser?.phone != null && _currentUser!.phone!.isNotEmpty)
                    ? ProfileVerificationBadge(
                      isVerified: _currentUser?.isPhoneVerified ?? false,
                      onTap: () {
                        if (!(_currentUser?.isPhoneVerified ?? false)) {
                          Navigator.pushNamed(
                            context,
                            AppRouteConstant.verifyPhone,
                          );
                        }
                      },
                    )
                    : null,
          ),

          ProfileTextField(
            label: AppLocalizations.of(context)!.fullName,
            controller: _fullNameController,
          ),
          ProfileTextField(
            label: AppLocalizations.of(context)!.dateOfBirth,
            controller: _dateOfBirthController,
          ),
          ProfileTextField(
            label: AppLocalizations.of(context)!.gender,
            controller: _genderController,
          ),
          ProfileTextField(
            label: AppLocalizations.of(context)!.address,
            controller: _addressController,
          ),
          ProfileTextField(
            label: AppLocalizations.of(context)!.nationality,
            controller: _nationalityController,
          ),
          ProfileTextField(
            label: AppLocalizations.of(context)!.citizenId,
            controller: _citizenIdController,
            validator: (value) {
              if (value != null &&
                  value.isNotEmpty &&
                  !_isValidCitizenId(value)) {
                // You might need a key for Citizen ID Invalid, using generic error or adding one
                return 'Invalid Citizen ID';
              }
              return null;
            },
            suffixIcon:
                (_currentUser?.citizenId != null &&
                        _currentUser!.citizenId!.isNotEmpty)
                    ? ProfileVerificationBadge(
                      isVerified: _currentUser?.isCitizenIdVerified ?? false,
                      onTap: () {
                        if (!(_currentUser?.isCitizenIdVerified ?? false)) {
                          Navigator.pushNamed(
                            context,
                            AppRouteConstant.verifyCitizenId,
                          );
                        }
                      },
                    )
                    : null,
          ),

          SizedBox(height: 10.h),
          CitizenImagesSection(
            frontImageUrl: _currentUser?.citizenFrontImageUrl,
            backImageUrl: _currentUser?.citizenBackImageUrl,
          ),
          SizedBox(height: 120.h),
        ],
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
        _citizenIdController.text != (_currentUser?.citizenId ?? '') ||
        _avatarFile != null;
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
      child: BlocBuilder<EditProfileCubit, EditProfileState>(
        builder: (context, state) {
          return PrimaryButton(
            title: AppLocalizations.of(context)!.update,
            onPressed: () => _onUpdatePressed(context),
            isLoading: state is EditProfileLoading,
          );
        },
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
        avatarFile: _avatarFile,
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
