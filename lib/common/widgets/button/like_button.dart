import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';

typedef LikeButtonTapCallback = Future<bool> Function(bool isLiked);

class CustomLikeButton extends StatelessWidget {
  final bool isLiked;
  final LikeButtonTapCallback? onTap;
  final double size;
  final CircleColor circleColor;
  final BubblesColor bubblesColor;
  final Color? likedColor;
  final Color? unlikedColor;
  final EdgeInsetsGeometry padding;

  const CustomLikeButton({
    super.key,
    this.isLiked = false,
    this.onTap,
    this.size = 24,
    CircleColor? circleColor,
    BubblesColor? bubblesColor,
    this.likedColor,
    this.unlikedColor,
    this.padding = const EdgeInsets.only(left: 3),
  })  : circleColor = circleColor ??
            const CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)),
        bubblesColor = bubblesColor ??
            const BubblesColor(
              dotPrimaryColor: Colors.pink,
              dotSecondaryColor: Colors.white,
            );

  @override
  Widget build(BuildContext context) {
    final Color resolvedLikedColor =
        likedColor ?? Theme.of(context).colorScheme.error;
    final Color resolvedUnlikedColor =
        unlikedColor ?? Colors.grey.withOpacity(0.5);

    return LikeButton(
      size: size,
      isLiked: isLiked,
      onTap: onTap ?? (bool isLiked) async => !isLiked,
      circleColor: circleColor,
      bubblesColor: bubblesColor,
      padding: padding,
      likeBuilder: (bool isLiked) {
        return Icon(
          Icons.favorite,
          color: isLiked ? resolvedLikedColor : resolvedUnlikedColor,
          size: size,
        );
      },
    );
  }
}
