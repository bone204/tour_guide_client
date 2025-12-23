import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';

class ProfileImageThumbnail extends StatelessWidget {
  final String label;
  final String? imageUrl;
  final VoidCallback onTap;

  const ProfileImageThumbnail({
    Key? key,
    required this.label,
    required this.imageUrl,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        SizedBox(height: 5.h),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 200.h,
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
                        imageUrl!,
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
}
