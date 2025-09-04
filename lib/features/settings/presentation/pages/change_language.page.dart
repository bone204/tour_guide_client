import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tour_guide_app/common/bloc/lang/locale_cubit.dart';
import 'package:tour_guide_app/common/bloc/lang/locale_state.dart';
import 'package:tour_guide_app/common/widgets/app_bar/custom_app_bar.dart';
import 'package:tour_guide_app/common/widgets/loading/dialog_loading.dart';
import 'package:tour_guide_app/core/config/lang/arb/app_localizations.dart';
import 'package:tour_guide_app/features/settings/presentation/widgets/language_tile.widget.dart';

class ChangeLanguagePage extends StatelessWidget {
  const ChangeLanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppLocalizations.of(context)!.language,
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: BlocListener<LocaleCubit, LocaleState>(
        listener: (context, state) {
          if (state is LocaleLoading) {
            LoadingDialog.show(context);
          } else if (state is LocaleLoaded) {
            LoadingDialog.hide(context);
          }
        },
        child: BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, state) {
            String? currentValue;
            if (state is LocaleLoaded) {
              currentValue = state.locale.languageCode;
            }

            return Column(
              children: [
                LanguageTile(
                  code: "en",
                  label: AppLocalizations.of(context)!.english,
                  flag: "🇺🇸",
                  selected: currentValue == "en",
                ),
                LanguageTile(
                  code: "vi",
                  label: AppLocalizations.of(context)!.vietnamese,
                  flag: "🇻🇳",
                  selected: currentValue == "vi",
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
