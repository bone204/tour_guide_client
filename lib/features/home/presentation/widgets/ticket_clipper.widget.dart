import 'package:flutter/material.dart';

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const radius = 12.0;
    final cutY = size.height * 0.6;

    final path = Path();

    path.moveTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0); 
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, cutY - radius);
    path.arcToPoint(
      Offset(size.width, cutY + radius),
      radius: const Radius.circular(radius),
      clockwise: false, 
    );

    path.lineTo(size.width, size.height - radius);
    path.quadraticBezierTo(size.width, size.height, size.width - radius, size.height);

    path.lineTo(radius, size.height);
    path.quadraticBezierTo(0, size.height, 0, size.height - radius); 

    path.lineTo(0, cutY + radius);
    path.arcToPoint(
      Offset(0, cutY - radius),
      radius: const Radius.circular(radius),
      clockwise: false, 
    );

    path.lineTo(0, radius);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
