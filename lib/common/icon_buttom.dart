import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavigationIconButton extends StatelessWidget {
  const BottomNavigationIconButton({
    super.key,
    required this.title,
    required this.svg,
    required this.iconColor,
    required this.titleColor, required this.callback,
  });

  final String title;
  final IconData svg;
  final Color iconColor, titleColor;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: 1.sp,
        children: [
          Icon(
            svg,
            weight: 32.w,
            size: 15,
            color: iconColor,
          ),
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontWeight: FontWeight.w600,
              fontSize: 16.sp,
            ),
          ),
        ],
      ),
    );
  }
}
