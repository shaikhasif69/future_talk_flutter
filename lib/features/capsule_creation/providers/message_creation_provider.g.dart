// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_creation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hasMessageContentHash() => r'47ae1d4401edcf2f024768c659a12c8ae112766c';

/// Provider for checking if there's meaningful content
///
/// Copied from [hasMessageContent].
@ProviderFor(hasMessageContent)
final hasMessageContentProvider = AutoDisposeProvider<bool>.internal(
  hasMessageContent,
  name: r'hasMessageContentProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasMessageContentHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasMessageContentRef = AutoDisposeProviderRef<bool>;
String _$messageTextStatisticsHash() =>
    r'4883d6512cac0eba7a80e2b669be6847eed10fff';

/// Provider for text statistics
///
/// Copied from [messageTextStatistics].
@ProviderFor(messageTextStatistics)
final messageTextStatisticsProvider =
    AutoDisposeProvider<TextStatistics>.internal(
      messageTextStatistics,
      name: r'messageTextStatisticsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$messageTextStatisticsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MessageTextStatisticsRef = AutoDisposeProviderRef<TextStatistics>;
String _$writingSessionDurationHash() =>
    r'679deb845be5169eb0c2834ffe554f493e24640e';

/// Provider for current writing session duration
///
/// Copied from [writingSessionDuration].
@ProviderFor(writingSessionDuration)
final writingSessionDurationProvider = AutoDisposeProvider<Duration>.internal(
  writingSessionDuration,
  name: r'writingSessionDurationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$writingSessionDurationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef WritingSessionDurationRef = AutoDisposeProviderRef<Duration>;
String _$hasUnsavedMessageChangesHash() =>
    r'c98a564d1f6781eeecef1d58cbd2ee5769b3cd12';

/// Provider for checking unsaved changes
///
/// Copied from [hasUnsavedMessageChanges].
@ProviderFor(hasUnsavedMessageChanges)
final hasUnsavedMessageChangesProvider = AutoDisposeProvider<bool>.internal(
  hasUnsavedMessageChanges,
  name: r'hasUnsavedMessageChangesProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hasUnsavedMessageChangesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HasUnsavedMessageChangesRef = AutoDisposeProviderRef<bool>;
String _$isCurrentlyRecordingHash() =>
    r'cc541533aba483b1cc6e3839b0ddba6a62e6b5bf';

/// Provider for current recording status
///
/// Copied from [isCurrentlyRecording].
@ProviderFor(isCurrentlyRecording)
final isCurrentlyRecordingProvider = AutoDisposeProvider<bool>.internal(
  isCurrentlyRecording,
  name: r'isCurrentlyRecordingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isCurrentlyRecordingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsCurrentlyRecordingRef = AutoDisposeProviderRef<bool>;
String _$messageCreationNotifierHash() =>
    r'1984e08460498e038eaa1c23af987f19f6e74abd';

/// Provider for managing message creation state and logic
/// Handles text editing, voice recording, font selection, and auto-save
///
/// Copied from [MessageCreationNotifier].
@ProviderFor(MessageCreationNotifier)
final messageCreationNotifierProvider =
    AutoDisposeNotifierProvider<
      MessageCreationNotifier,
      MessageCreationData
    >.internal(
      MessageCreationNotifier.new,
      name: r'messageCreationNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$messageCreationNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MessageCreationNotifier = AutoDisposeNotifier<MessageCreationData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
