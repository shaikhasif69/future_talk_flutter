// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_capsule_creation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$selectedPurposeHash() => r'2457abd61ebcd6e8201c91a374e19eabe259b4ea';

/// Convenience provider for accessing creation state
///
/// Copied from [selectedPurpose].
@ProviderFor(selectedPurpose)
final selectedPurposeProvider =
    AutoDisposeProvider<TimeCapsulePurpose?>.internal(
      selectedPurpose,
      name: r'selectedPurposeProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedPurposeHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SelectedPurposeRef = AutoDisposeProviderRef<TimeCapsulePurpose?>;
String _$showContinueButtonHash() =>
    r'98dea160fbfbea37972b5a6a7520cac96ac8e110';

/// Convenience provider for continue button visibility
///
/// Copied from [showContinueButton].
@ProviderFor(showContinueButton)
final showContinueButtonProvider = AutoDisposeProvider<bool>.internal(
  showContinueButton,
  name: r'showContinueButtonProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$showContinueButtonHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShowContinueButtonRef = AutoDisposeProviderRef<bool>;
String _$isCreationLoadingHash() => r'9b23bc32b89cb5e42a81ec4bfc8b645867ba77ec';

/// Convenience provider for loading state
///
/// Copied from [isCreationLoading].
@ProviderFor(isCreationLoading)
final isCreationLoadingProvider = AutoDisposeProvider<bool>.internal(
  isCreationLoading,
  name: r'isCreationLoadingProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$isCreationLoadingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef IsCreationLoadingRef = AutoDisposeProviderRef<bool>;
String _$currentCreationStepHash() =>
    r'ca72cb369253590ae2951b26b52988492f077214';

/// Convenience provider for current step
///
/// Copied from [currentCreationStep].
@ProviderFor(currentCreationStep)
final currentCreationStepProvider = AutoDisposeProvider<int>.internal(
  currentCreationStep,
  name: r'currentCreationStepProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentCreationStepHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CurrentCreationStepRef = AutoDisposeProviderRef<int>;
String _$timeCapsuleCreationNotifierHash() =>
    r'594e13e5b526b61572aa8a90774179f6974c9b87';

/// Provider for managing time capsule creation state and logic
/// Handles purpose selection, quick start interactions, and navigation flow
///
/// Copied from [TimeCapsuleCreationNotifier].
@ProviderFor(TimeCapsuleCreationNotifier)
final timeCapsuleCreationNotifierProvider =
    AutoDisposeNotifierProvider<
      TimeCapsuleCreationNotifier,
      TimeCapsuleCreationData
    >.internal(
      TimeCapsuleCreationNotifier.new,
      name: r'timeCapsuleCreationNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$timeCapsuleCreationNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TimeCapsuleCreationNotifier =
    AutoDisposeNotifier<TimeCapsuleCreationData>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
