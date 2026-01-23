// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$chatRemoteClientHash() => r'5605c5eb1aa333da584a25101f62127efd556c9f';

/// Quoteable (Chat) API client - uses DirectResponseParser for APIs that return data directly
///
/// Copied from [chatRemoteClient].
@ProviderFor(chatRemoteClient)
final chatRemoteClientProvider = AutoDisposeProvider<RemoteClient>.internal(
  chatRemoteClient,
  name: r'chatRemoteClientProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$chatRemoteClientHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChatRemoteClientRef = AutoDisposeProviderRef<RemoteClient>;
String _$dictionaryRemoteClientHash() =>
    r'5d0be21f24359d25d8afb90200d3f1c847763a9c';

/// Dictionary API client
///
/// Copied from [dictionaryRemoteClient].
@ProviderFor(dictionaryRemoteClient)
final dictionaryRemoteClientProvider =
    AutoDisposeProvider<RemoteClient>.internal(
      dictionaryRemoteClient,
      name: r'dictionaryRemoteClientProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$dictionaryRemoteClientHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DictionaryRemoteClientRef = AutoDisposeProviderRef<RemoteClient>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
