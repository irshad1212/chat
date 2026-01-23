import 'package:chat/src/splash/views/widgets/no_internet_snackbar.dart';
import 'package:chat/utils/helpers/functions.dart';
import 'package:chat/utils/routes/app_routes.dart';
import 'package:flutter/material.dart';

class SplashHandler {
  Future<void> checkNetworkState(BuildContext context, bool mounted) async {
    final network = await isInternetAvailable();
    if (network) {
      if (!mounted) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onContinue(context);
      });
    } else {
      if (mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showNoInternetSnackbar(context);
        });
      }
    }
  }

  void showNoInternetSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(NoInternetSnackbar(onRetry: onContinue));
  }

  void onContinue(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    if (!context.mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.routeMain, (_) => false);
  }
}
