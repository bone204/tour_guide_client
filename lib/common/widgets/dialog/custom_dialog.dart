import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String? title;
  final String? content;
  final IconData? icon;
  final Color? iconColor;
  final List<Widget>? actions;
  final double borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final TextStyle? titleStyle;
  final TextStyle? contentStyle;
  final Color? backgroundColor;
  final Widget? titleWidget;
  final Widget? contentWidget;
  final Widget? iconWidget;
  final CrossAxisAlignment actionsAlignment;
  final double actionsSpacing;

  const CustomDialog({
    Key? key,
    this.title,
    this.content,
    this.icon,
    this.iconColor,
    this.actions,
    this.borderRadius = 24,
    this.contentPadding,
    this.titleStyle,
    this.contentStyle,
    this.backgroundColor,
    this.titleWidget,
    this.contentWidget,
    this.iconWidget,
    this.actionsAlignment = CrossAxisAlignment.stretch,
    this.actionsSpacing = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;

    final Widget? resolvedIcon =
        iconWidget ??
        (icon != null
            ? Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: (iconColor ?? primaryColor).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor ?? primaryColor, size: 48),
            )
            : null);

    final Widget? resolvedTitle =
        titleWidget ??
        (title != null
            ? Text(
              title!,
              style:
                  titleStyle ??
                  theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            )
            : null);

    final Widget? resolvedContent =
        contentWidget ??
        (content != null
            ? Text(
              content!,
              style:
                  contentStyle ??
                  theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.black54,
                    height: 1.5,
                  ),
              textAlign: TextAlign.center,
            )
            : null);

    final children = <Widget>[];

    if (resolvedIcon != null) {
      children.add(Center(child: resolvedIcon));
    }

    if (resolvedIcon != null &&
        (resolvedTitle != null || resolvedContent != null)) {
      children.add(SizedBox(height: 24));
    }

    if (resolvedTitle != null) {
      children.add(resolvedTitle);
    }

    if (resolvedTitle != null && resolvedContent != null) {
      children.add(SizedBox(height: 12));
    }

    if (resolvedTitle == null &&
        resolvedIcon != null &&
        resolvedContent != null) {
      children.add(const SizedBox(height: 16));
    }

    if (resolvedContent != null) {
      children.add(resolvedContent);
    }

    if (actions != null && actions!.isNotEmpty) {
      if (children.isNotEmpty) {
        children.add(const SizedBox(height: 32));
      }
      children.add(
        Column(
          crossAxisAlignment: actionsAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            for (int i = 0; i < actions!.length; i++) ...[
              actions![i],
              if (i != actions!.length - 1) SizedBox(height: actionsSpacing),
            ],
          ],
        ),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      backgroundColor: backgroundColor ?? Colors.white,
      elevation: 0,
      child: Container(
        padding: contentPadding ?? const EdgeInsets.all(32),
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}

Future<T?> showAppDialog<T>({
  required BuildContext context,
  String? title,
  String? content,
  IconData? icon,
  Color? iconColor,
  List<Widget>? actions,
  double borderRadius = 20,
  EdgeInsetsGeometry? contentPadding,
  TextStyle? titleStyle,
  TextStyle? contentStyle,
  Color? backgroundColor,
  Widget? titleWidget,
  Widget? contentWidget,
  Widget? iconWidget,
  bool barrierDismissible = true,
  bool useRootNavigator = true,
  CrossAxisAlignment actionsAlignment = CrossAxisAlignment.stretch,
  double actionsSpacing = 12,
}) {
  return showDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    useRootNavigator: useRootNavigator,
    builder:
        (context) => CustomDialog(
          title: title,
          content: content,
          icon: icon,
          iconColor: iconColor,
          actions: actions,
          borderRadius: borderRadius,
          contentPadding: contentPadding,
          titleStyle: titleStyle,
          contentStyle: contentStyle,
          backgroundColor: backgroundColor,
          titleWidget: titleWidget,
          contentWidget: contentWidget,
          iconWidget: iconWidget,
          actionsAlignment: actionsAlignment,
          actionsSpacing: actionsSpacing,
        ),
  );
}
