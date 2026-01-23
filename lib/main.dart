import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:chat/src/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Update system UI overlay style for edge-to-edge and material tint
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: true,
      statusBarColor: Colors.transparent,
    ),
  );

  runApp(const ProviderScope(child: App()));
}
