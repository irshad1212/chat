// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sembast_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$sembastServiceHash() => r'1ba4861331631a55cf3a73dcd0fa61cd4c698a22';

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
///
/// Copied from [sembastService].
@ProviderFor(sembastService)
final sembastServiceProvider = Provider<SembastOperations>.internal(
  sembastService,
  name: r'sembastServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$sembastServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SembastServiceRef = ProviderRef<SembastOperations>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
