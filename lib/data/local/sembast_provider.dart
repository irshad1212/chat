import 'package:chat/data/local/sembast.dart';
import 'package:chat/data/local/sembast_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sembast_provider.g.dart';

/// Riverpod provider for Sembast database service
///
/// This provider creates and manages a singleton instance of SembastServiceImpl.
/// Use this to inject the Sembast service throughout your application.
///
/// Example usage:
/// ```dart
/// final sembast = ref.watch(sembastServiceProvider);
/// await sembast.save('key', value);
/// ```
@Riverpod(keepAlive: true)
SembastOperations sembastService(Ref ref) {
  return SembastServiceImpl();
}
