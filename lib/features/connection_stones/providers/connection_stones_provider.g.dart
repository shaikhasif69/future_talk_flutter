// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'connection_stones_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$comfortStatsHash() => r'30490b7bd2eaa5b383f980793fd7430160174880';

/// Provider for comfort statistics
///
/// Copied from [comfortStats].
@ProviderFor(comfortStats)
final comfortStatsProvider = AutoDisposeProvider<ComfortStats>.internal(
  comfortStats,
  name: r'comfortStatsProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$comfortStatsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ComfortStatsRef = AutoDisposeProviderRef<ComfortStats>;
String _$connectionStonesHash() => r'3fd4e1c0419906cdfe466c4ab52e987e5d876076';

/// Provider for managing the collection of connection stones
///
/// Copied from [ConnectionStones].
@ProviderFor(ConnectionStones)
final connectionStonesProvider = AutoDisposeNotifierProvider<ConnectionStones,
    List<ConnectionStone>>.internal(
  ConnectionStones.new,
  name: r'connectionStonesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$connectionStonesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConnectionStones = AutoDisposeNotifier<List<ConnectionStone>>;
String _$touchInteractionsHash() => r'ffc2e8e5bf3429c1978ec233ddd6a17648f14085';

/// Provider for touch interactions history
///
/// Copied from [TouchInteractions].
@ProviderFor(TouchInteractions)
final touchInteractionsProvider = AutoDisposeNotifierProvider<TouchInteractions,
    List<TouchInteraction>>.internal(
  TouchInteractions.new,
  name: r'touchInteractionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$touchInteractionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TouchInteractions = AutoDisposeNotifier<List<TouchInteraction>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
