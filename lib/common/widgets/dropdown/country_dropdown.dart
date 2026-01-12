import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:tour_guide_app/common_libs.dart';
import 'package:tour_guide_app/features/auth/data/models/country.dart';
import 'package:tour_guide_app/common/services/country_service.dart';

class CountryDropdown extends StatefulWidget {
  final String? label;
  final ValueChanged<Country?> onChanged;
  final String? validatorMessage;
  final String? initialValue;

  const CountryDropdown({
    super.key,
    this.label,
    required this.onChanged,
    this.validatorMessage,
    this.initialValue,
  });

  @override
  State<CountryDropdown> createState() => _CountryDropdownState();
}

class _CountryDropdownState extends State<CountryDropdown> {
  final CountryService _countryService = CountryService();
  List<Country> _countries = [];
  bool _isLoading = true;
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  Future<void> _fetchCountries() async {
    try {
      final countries = await _countryService.fetchCountries();
      if (mounted) {
        Country? initialCountry;
        if (widget.initialValue != null) {
          try {
            initialCountry = countries.firstWhere(
              (c) =>
                  c.commonName.toLowerCase() ==
                      widget.initialValue!.toLowerCase() ||
                  c.getvietnameseName().toLowerCase() ==
                      widget.initialValue!.toLowerCase(),
            );
          } catch (_) {}
        }

        setState(() {
          _countries = countries;
          _isLoading = false;
          if (initialCountry != null) {
            _selectedCountry = initialCountry;
          }
        });
        _sortCountries();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      debugPrint('Error fetching countries: $e');
    }
  }

  void _sortCountries() {
    final isVietnamese = Localizations.localeOf(context).languageCode == 'vi';
    _countries.sort((a, b) {
      final nameA = isVietnamese ? a.getvietnameseName() : a.commonName;
      final nameB = isVietnamese ? b.getvietnameseName() : b.commonName;
      return nameA.compareTo(nameB);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isVietnamese = Localizations.localeOf(context).languageCode == 'vi';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: Theme.of(context).textTheme.displayLarge),
          SizedBox(height: 6.h),
        ],
        DropdownButtonHideUnderline(
          child: DropdownButton2<Country>(
            isExpanded: true,
            hint:
                _isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : Text(
                      isVietnamese ? 'Chọn quốc gia' : 'Select Country',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSubtitle,
                      ),
                    ),
            items:
                _countries.map((Country country) {
                  return DropdownMenuItem<Country>(
                    value: country,
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: Image.network(
                            country.flagUrl,
                            width: 24.w,
                            height: 16.h,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.flag, size: 20),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            isVietnamese
                                ? country.getvietnameseName()
                                : country.commonName,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
            value: _selectedCountry,
            onChanged: (Country? newValue) {
              setState(() {
                _selectedCountry = newValue;
              });
              widget.onChanged(newValue);
            },
            buttonStyleData: ButtonStyleData(
              height: 48.h,
              padding: EdgeInsets.only(left: 0.w, right: 12.w),
              decoration: BoxDecoration(
                color: AppColors.primaryWhite,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: AppColors.secondaryGrey, width: 1.w),
              ),
            ),
            iconStyleData: IconStyleData(
              icon: Icon(Icons.arrow_drop_down_sharp),
              iconSize: 24.w,
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: 300.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.r),
                color: AppColors.primaryWhite,
              ),
            ),
            menuItemStyleData: MenuItemStyleData(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
            ),
          ),
        ),
        if (widget.validatorMessage != null && _selectedCountry == null)
          Padding(
            padding: EdgeInsets.only(top: 8.h, left: 12.w),
            child: Text(
              widget.validatorMessage!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.primaryRed),
            ),
          ),
      ],
    );
  }
}
