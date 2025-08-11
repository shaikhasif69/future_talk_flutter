// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_search_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$friendSearchServiceHash() =>
    r'c13201d5f25f3f2082742e1c6f8dea5df39534f2';

/// Provider for friend search service
///
/// Copied from [friendSearchService].
@ProviderFor(friendSearchService)
final friendSearchServiceProvider = Provider<FriendSearchService>.internal(
  friendSearchService,
  name: r'friendSearchServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$friendSearchServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FriendSearchServiceRef = ProviderRef<FriendSearchService>;
String _$friendSearchNotifierHash() =>
    r'34275af979622e3a7da945aa9870ef7568e059fb';

/// Provider for friend search state management
///
/// Copied from [FriendSearchNotifier].
@ProviderFor(FriendSearchNotifier)
final friendSearchNotifierProvider = AutoDisposeNotifierProvider<
    FriendSearchNotifier, FriendSearchState>.internal(
  FriendSearchNotifier.new,
  name: r'friendSearchNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$friendSearchNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FriendSearchNotifier = AutoDisposeNotifier<FriendSearchState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
