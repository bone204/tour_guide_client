import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/travel_itinerary/data/models/province.dart';
import 'dart:math';

class ProvinceCard extends StatelessWidget {
  final Province province;
  final VoidCallback onTap;
  const ProvinceCard({required this.province, required this.onTap, Key? key})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final displayName =
        (locale == 'vi' || province.nameEn == null || province.nameEn!.isEmpty)
            ? province.name
            : province.nameEn!;

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
              if (province.avatarUrl != null)
                Image.network(
                  province.avatarUrl!,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.r),
                          gradient: _randomGradient(province.name),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Colors.white.withOpacity(0.5),
                            size: 30.sp,
                          ),
                        ),
                      ),
                )
              else
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    gradient: _randomGradient(province.name),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.location_on, // improved fallback icon
                      color: Colors.white.withOpacity(0.85),
                      size: 48.sp,
                    ),
                  ),
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

  LinearGradient _randomGradient(String seed) {
    final random = Random(seed.hashCode);
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
}
