import 'package:flutter/material.dart';
import 'package:tour_guide_app/common/widgets/dialog/custom_dialog.dart';

class LoadingDialog {
  static void show(BuildContext context, {String message = 'Đang xử lý...'}) {
    showAppDialog<void>(
      context: context,
      barrierDismissible: false,
      useRootNavigator: true,
      contentWidget: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

