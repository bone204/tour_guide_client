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
import 'package:tour_guide_app/common/widgets/picker/date_picker.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
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
  final _addressController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _citizenIdController = TextEditingController();

  User? _currentUser;
  File? _avatarFile;
  DateTime? _selectedDateOfBirth;
  String? _selectedGender;

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
    _isCitizenIdVerifiedController.text = user.isCitizenIdVerified.toString();
    if (user.dateOfBirth != null && user.dateOfBirth!.isNotEmpty) {
      try {
        _selectedDateOfBirth = DateTime.parse(user.dateOfBirth!);
      } catch (e) {
        debugPrint('Error parsing date: $e');
      }
    }
    _dateOfBirthController.text = user.dateOfBirth ?? '';
    _fullNameController.text = user.fullName ?? '';
    final gender = user.gender?.toLowerCase();
    if (gender != null && ['male', 'female', 'other'].contains(gender)) {
      _selectedGender = gender;
    } else {
      _selectedGender = null;
    }
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
            readOnly: true,
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
                      onTap: () async {
                        if (!(_currentUser?.isEmailVerified ?? false)) {
                          final result = await Navigator.pushNamed(
                            context,
                            AppRouteConstant.verifyEmail,
                            arguments: _currentUser?.email,
                          );
                          if (result == true && context.mounted) {
                            context.read<GetMyProfileCubit>().getMyProfile();
                          }
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
                      onTap: () async {
                        if (!(_currentUser?.isPhoneVerified ?? false)) {
                          final result = await Navigator.pushNamed(
                            context,
                            AppRouteConstant.verifyPhone,
                            arguments: _currentUser?.phone,
                          );
                          if (result == true && context.mounted) {
                            context.read<GetMyProfileCubit>().getMyProfile();
                          }
                        }
                      },
                    )
                    : null,
          ),

          ProfileTextField(
            label: AppLocalizations.of(context)!.fullName,
            controller: _fullNameController,
          ),
          DatePickerField(
            label: AppLocalizations.of(context)!.dateOfBirth,
            placeholder: AppLocalizations.of(context)!.selectDate,
            initialDate: _selectedDateOfBirth,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            onChanged: (date) {
              setState(() {
                _selectedDateOfBirth = date;
                // Format: YYYY-MM-DD
                final formatted =
                    "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                _dateOfBirthController.text = formatted;
              });
            },
          ),
          SizedBox(height: 16.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.gender,
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 8.h),
              Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: AppColors.primaryWhite,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: AppColors.secondaryGrey,
                    width: 1.w,
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    isExpanded: true,
                    value: _selectedGender,
                    hint: Text(
                      AppLocalizations.of(context)!.genderOther,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                    ),
                    items:
                        ['male', 'female', 'other'].map((String gender) {
                          String label;
                          if (gender == 'male') {
                            label = AppLocalizations.of(context)!.genderMale;
                          } else if (gender == 'female') {
                            label = AppLocalizations.of(context)!.genderFemale;
                          } else {
                            label = AppLocalizations.of(context)!.genderOther;
                          }
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(
                              label,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.primaryBlack),
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                    buttonStyleData: ButtonStyleData(
                      padding: EdgeInsets.symmetric(horizontal: 0.w),
                      height: 48.h,
                    ),
                    iconStyleData: IconStyleData(
                      icon: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: Icon(Icons.arrow_drop_down_sharp),
                      ),
                      iconSize: 24.w,
                    ),
                    dropdownStyleData: DropdownStyleData(
                      decoration: BoxDecoration(
                        color: AppColors.primaryWhite,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
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
                      onTap: () async {
                        if (!(_currentUser?.isCitizenIdVerified ?? false)) {
                          final result = await Navigator.pushNamed(
                            context,
                            AppRouteConstant.verifyCitizenId,
                          );
                          if (result == true && context.mounted) {
                            context.read<GetMyProfileCubit>().getMyProfile();
                          }
                        }
                      },
                    )
                    : null,
          ),

          SizedBox(height: 10.h),
          CitizenImagesSection(
            frontImageUrl: _currentUser?.citizenFrontImageUrl,
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
        _selectedGender != (_currentUser!.gender?.toLowerCase()) ||
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
                    ? "${int.parse(_dateOfBirthController.text.split('-')[2]).toString().padLeft(2, '0')}/${int.parse(_dateOfBirthController.text.split('-')[1]).toString().padLeft(2, '0')}/${_dateOfBirthController.text.split('-')[0]}"
                    : null
                : null,
        gender:
            _selectedGender != (_currentUser?.gender?.toLowerCase())
                ? _selectedGender
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
