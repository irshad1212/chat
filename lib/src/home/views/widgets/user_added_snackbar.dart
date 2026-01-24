import 'package:chat/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserAddedSnackbar extends SnackBar {
  UserAddedSnackbar({super.key, required String username})
    : super(
        behavior: SnackBarBehavior.floating,
        padding: .zero,
        content: SizedBox(
          height: 40.h,
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const .symmetric(horizontal: 12.0),
                  child: Text(
                    'User added $username',
                    style: TextStyle(fontSize: 14.sp, color: AppColors.white, fontWeight: .w500),
                  ),
                ),
              ),
              const Padding(
                padding: .all(8.0),
                child: Icon(Icons.check_circle, size: 20, color: AppColors.white),
              ),
            ],
          ),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
      );
}
