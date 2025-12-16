import 'package:flutter/material.dart';
import 'dart:math';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';

// Province style map (icon, color) for known provinces
const Map<String, Map<String, dynamic>> _provinceStyles = {
  'Đà Nẵng': {'icon': Icons.beach_access, 'color': Color(0xFF007BFF)},
  'Hà Nội': {'icon': Icons.account_balance, 'color': Color(0xFFFF7029)},
  'Thành phố Hồ Chí Minh': {
    'icon': Icons.location_city,
    'color': Color(0xFF800080),
  },
  'Hồ Chí Minh': {'icon': Icons.location_city, 'color': Color(0xFF800080)},
  'Nha Trang': {'icon': Icons.pool, 'color': Color(0xFF4DA6FF)},
  'Hội An': {'icon': Icons.lightbulb, 'color': Color(0xFFFFD336)},
  'Huế': {'icon': Icons.castle, 'color': Color(0xFF77CC00)},
  'Phú Quốc': {'icon': Icons.wb_sunny, 'color': Color(0xFF007BFF)},
  'Đà Lạt': {'icon': Icons.local_florist, 'color': Color(0xFFFF69B4)},
  'Sa Pa': {'icon': Icons.terrain, 'color': Color(0xFF77CC00)},
  'Vũng Tàu': {'icon': Icons.sailing, 'color': Color(0xFF4DA6FF)},
  'Hạ Long': {'icon': Icons.directions_boat, 'color': Color(0xFF007BFF)},
  'Ninh Bình': {'icon': Icons.landscape, 'color': Color(0xFF77CC00)},
  'Quy Nhơn': {'icon': Icons.surfing, 'color': Color(0xFF4DA6FF)},
  'Cần Thơ': {'icon': Icons.agriculture, 'color': Color(0xFF77CC00)},
};

class ProvinceCard extends StatelessWidget {
  final Province province;
  final VoidCallback onTap;
  const ProvinceCard({required this.province, required this.onTap, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = _provinceStyles[province.name];
    final icon = style != null ? style['icon'] as IconData : Icons.location_on;
     final locale = Localizations.localeOf(context).languageCode;
        final displayName =
            (locale == 'vi' ||
                    province.nameEn == null ||
                    province.nameEn!.isEmpty)
                ? province.name
                : province.nameEn!;
                
    LinearGradient _randomGradient() {
      final random = Random(province.name.hashCode);
      Color randomColor() => Color.fromARGB(
        255,
        100 + random.nextInt(156),
        100 + random.nextInt(156),
        100 + random.nextInt(156),
      );
      return LinearGradient(
        colors: [randomColor(), randomColor()],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Gradient ngẫu nhiên thay cho ảnh
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: _randomGradient(),
                ),
                child: _ProvinceIconBg(icon: icon, color: Colors.transparent),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  color: Colors.black.withOpacity(0.25),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    displayName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.primaryWhite,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProvinceIconBg extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _ProvinceIconBg({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Center(
        child: Icon(icon, color: Colors.white.withOpacity(0.85), size: 48.sp),
      ),
    );
  }
}
