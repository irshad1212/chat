import 'package:chat/core/constants/strings.dart';
import 'package:chat/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoInternetSnackbar extends SnackBar {
  NoInternetSnackbar({super.key, required Function(BuildContext context) onRetry})
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
                    Strings.noInternet,
                    style: TextStyle(fontSize: 14.sp, color: AppColors.white, fontWeight: .w500),
                  ),
                ),
              ),
              Builder(
                builder: (context) => InkWell(
                  onTap: () => onRetry(context),
                  child: const Padding(
                    padding: .all(8.0),
                    child: Icon(Icons.refresh_rounded, size: 20, color: AppColors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        duration: const Duration(days: 1),
        backgroundColor: AppColors.primaryBlue,
        elevation: 0,
      );
}
