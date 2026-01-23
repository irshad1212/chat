import 'dart:async';
import 'dart:io';

import 'package:chat/core/constants/strings.dart';

Future<bool> isInternetAvailable() async {
  try {
    final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 5));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } on SocketException catch (_) {
    return false;
  } on TimeoutException catch (_) {
    return false;
  }
  return false;
}

String formatTimeAgo(DateTime? dateTime, {bool history = false}) {
  if (dateTime == null) return '';

  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inSeconds < 60) {
    return Strings.justNow;
  } else if (difference.inMinutes < 60) {
    final mins = difference.inMinutes;
    return mins == 1 ? Strings.minAgo : Strings.minsAgo(mins);
  } else if (difference.inHours < 24) {
    final hours = difference.inHours;
    return hours == 1 ? Strings.hourAgo : Strings.hoursAgo(hours);
  } else {
    final days = difference.inDays;
    if (history && days == 1) {
      return Strings.yesterday;
    }
    return days == 1 ? Strings.dayAgo : Strings.daysAgo(days);
  }
}
