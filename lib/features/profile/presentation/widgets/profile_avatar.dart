import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:tour_guide_app/common_libs.dart';

class ProfileAvatarWidget extends StatefulWidget {
  final String? avatarUrl;
  final String? fullName;
  final File? imageFile;
  final Function(File)? onImagePicked;

  const ProfileAvatarWidget({
    Key? key,
    required this.avatarUrl,
    required this.fullName,
    this.imageFile,
    this.onImagePicked,
  }) : super(key: key);

  @override
  State<ProfileAvatarWidget> createState() => _ProfileAvatarWidgetState();
}

class _ProfileAvatarWidgetState extends State<ProfileAvatarWidget> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    ImageProvider? imageProvider;
    if (widget.imageFile != null) {
      imageProvider = FileImage(widget.imageFile!);
    } else if (widget.avatarUrl != null) {
      imageProvider = NetworkImage(widget.avatarUrl!);
    }

    return Center(
      child: GestureDetector(
        onTap: () {
          _showAvatarOptions(context);
        },
        child: Container(
          width: 150.w,
          height: 150.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryBlue.withOpacity(0.1),
            border: Border.all(color: AppColors.primaryBlue, width: 2.w),
          ),
          child: ClipOval(
            child:
                imageProvider != null
                    ? Image(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) =>
                              _buildFallbackAvatar(widget.fullName ?? ''),
                    )
                    : _buildFallbackAvatar(widget.fullName ?? ''),
          ),
        ),
      ),
    );
  }

  Widget _buildFallbackAvatar(String text) {
    return Container(
      color: AppColors.primaryBlue.withOpacity(0.2),
      alignment: Alignment.center,
      child: Text(
        text.isNotEmpty ? text[0].toUpperCase() : '?',
        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
          color: AppColors.primaryBlue,
          fontSize: 40.sp,
        ),
      ),
    );
  }

  void _showAvatarOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.avatarUrl != null || widget.imageFile != null)
                ListTile(
                  leading: const Icon(Icons.visibility),
                  title: Text(AppLocalizations.of(context)!.viewImage),
                  onTap: () {
                    Navigator.pop(context);
                    if (widget.imageFile != null) {
                      _showLocalImageDialog(context, widget.imageFile!);
                    } else if (widget.avatarUrl != null) {
                      _showImageDialog(context, widget.avatarUrl!);
                    }
                  },
                ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context)!.selectFromGallery),
                onTap: () {
                  Navigator.pop(context);
                  _pickAvatar(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(AppLocalizations.of(context)!.takePhoto),
                onTap: () {
                  Navigator.pop(context);
                  _pickAvatar(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickAvatar(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        widget.onImagePicked?.call(File(pickedFile.path));
      }
    } catch (e) {
      // Handle error
    }
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder:
          (context) => Container(
            color: Colors.black.withOpacity(0.8),
            child: Stack(
              children: [
                Center(
                  child: InteractiveViewer(child: Image.network(imageUrl)),
                ),
                _buildCloseButton(context),
              ],
            ),
          ),
    );
  }

  void _showLocalImageDialog(BuildContext context, File file) {
    showDialog(
      context: context,
      builder:
          (context) => Container(
            color: Colors.black.withOpacity(0.8),
            child: Stack(
              children: [
                Center(child: InteractiveViewer(child: Image.file(file))),
                _buildCloseButton(context),
              ],
            ),
          ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Positioned(
      top: 40.h,
      right: 20.w,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          padding: EdgeInsets.all(8.w),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, color: Colors.black),
        ),
      ),
    );
  }
}
