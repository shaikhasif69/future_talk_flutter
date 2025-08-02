import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/time_capsule_creation_data.dart';

part 'time_capsule_creation_provider.g.dart';

/// Provider for managing time capsule creation state and logic
/// Handles purpose selection, quick start interactions, and navigation flow
@riverpod
class TimeCapsuleCreationNotifier extends _$TimeCapsuleCreationNotifier {
  @override
  TimeCapsuleCreationData build() {
    return TimeCapsuleCreationData(
      creationStartedAt: DateTime.now(),
    );
  }

  /// Select a purpose for the time capsule
  /// This will trigger the continue button to appear with smooth animation
  void selectPurpose(TimeCapsulePurpose purpose) {
    // Haptic feedback for premium feel
    HapticFeedback.selectionClick();
    
    state = state.copyWith(
      selectedPurpose: purpose,
      showContinueButton: true,
    );
  }

  /// Clear the current purpose selection
  void clearPurposeSelection() {
    state = state.copyWith(
      selectedPurpose: null,
      showContinueButton: false,
    );
  }

  /// Handle quick start option selection
  /// This will auto-select an appropriate purpose if none is selected
  void selectQuickStart(QuickStartType quickStartType) {
    // Enhanced haptic feedback for quick actions
    HapticFeedback.mediumImpact();
    
    // Auto-select purpose if none is currently selected
    TimeCapsulePurpose? newPurpose = state.selectedPurpose;
    bool shouldShowContinue = state.showContinueButton;
    
    if (newPurpose == null) {
      newPurpose = quickStartType.suggestedPurpose;
      shouldShowContinue = true;
    }
    
    state = state.copyWith(
      selectedQuickStart: quickStartType,
      selectedPurpose: newPurpose,
      showContinueButton: shouldShowContinue,
    );
  }

  /// Progress to the next step in the creation flow
  Future<void> continueToNextStep() async {
    if (state.selectedPurpose == null) return;
    
    // Strong haptic feedback for major actions
    HapticFeedback.heavyImpact();
    
    // Set loading state for smooth transition
    state = state.copyWith(isLoading: true);
    
    // Simulate network delay for premium feel
    await Future.delayed(const Duration(milliseconds: 1500));
    
    // Move to next step
    state = state.copyWith(
      currentStep: state.currentStep + 1,
      isLoading: false,
    );
  }

  /// Reset the creation flow to initial state
  void resetFlow() {
    state = TimeCapsuleCreationData(
      creationStartedAt: DateTime.now(),
    );
  }

  /// Go back to previous step
  void goToPreviousStep() {
    if (state.currentStep > 1) {
      HapticFeedback.selectionClick();
      state = state.copyWith(
        currentStep: state.currentStep - 1,
        isLoading: false,
      );
    }
  }

  /// Update the current step (for navigation)
  void setCurrentStep(int step) {
    if (step >= 1 && step <= 4) {
      state = state.copyWith(currentStep: step);
    }
  }

  /// Analytics helper - get creation duration
  Duration get creationDuration {
    if (state.creationStartedAt == null) return Duration.zero;
    return DateTime.now().difference(state.creationStartedAt!);
  }

  /// Check if the current state allows continuing
  bool get canContinue {
    return state.selectedPurpose != null && !state.isLoading;
  }

  // ==================== TIME SELECTION METHODS ====================

  /// Select a time option for delivery
  void selectTimeOption(TimeOption timeOption) {
    HapticFeedback.selectionClick();
    
    // Clear other selections
    state = state.copyWith(
      selectedTimeOption: timeOption,
      selectedOccasion: null,
      customDateTime: null,
      timeMetaphor: timeOption.metaphor,
      timeDisplay: timeOption.display,
      timeDescription: timeOption.description,
      growthStage: timeOption.growthStage,
      showContinueButton: true,
    );
  }

  /// Select a special occasion for delivery
  void selectSpecialOccasion(SpecialOccasion occasion) {
    HapticFeedback.selectionClick();
    
    // Clear other selections
    state = state.copyWith(
      selectedTimeOption: null,
      selectedOccasion: occasion,
      customDateTime: null,
      timeMetaphor: occasion.emoji,
      timeDisplay: occasion.display,
      timeDescription: occasion.description,
      growthStage: occasion.growthStage,
      showContinueButton: true,
    );
  }

  /// Set custom date and time for delivery
  void setCustomDateTime(DateTime dateTime) {
    HapticFeedback.selectionClick();
    
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    final days = difference.inDays;
    
    String previewText;
    if (days < 0) {
      previewText = 'Selected time is in the past. Please choose a future date.';
    } else if (days == 0) {
      previewText = 'Delivery today!';
    } else if (days == 1) {
      previewText = 'Delivery tomorrow!';
    } else {
      previewText = 'Delivery in $days days';
    }
    
    final customDateTime = CustomDateTime(
      dateTime: dateTime,
      previewText: previewText,
    );
    
    // Clear other selections and update visualization
    state = state.copyWith(
      selectedTimeOption: null,
      selectedOccasion: null,
      customDateTime: customDateTime,
      timeMetaphor: '📅',
      timeDisplay: 'Custom Time',
      timeDescription: 'Your message will arrive in $days days',
      growthStage: 'Custom Journey',
      showContinueButton: days > 0,
    );
  }

  /// Clear all time selections
  void clearTimeSelections() {
    state = state.copyWith(
      selectedTimeOption: null,
      selectedOccasion: null,
      customDateTime: null,
      timeMetaphor: '🌰',
      timeDisplay: 'Select Time',
      timeDescription: 'Choose when you\'d like to receive this message',
      growthStage: 'Ready to Plant',
      showContinueButton: state.selectedPurpose != null,
    );
  }

  /// Check if any time selection is made
  bool get hasTimeSelection {
    return state.selectedTimeOption != null || 
           state.selectedOccasion != null || 
           state.customDateTime != null;
  }

  /// Get the current animation class for metaphor
  String get currentAnimationClass {
    if (state.selectedTimeOption != null) {
      return state.selectedTimeOption!.animationClass;
    }
    return 'seed-growing'; // Default animation
  }

  /// Get the appropriate continue button text based on state
  String get continueButtonText {
    if (state.isLoading) {
      return 'Preparing...';
    }
    
    switch (state.currentStep) {
      case 1:
        return 'Continue';
      case 2:
        return 'Next Step';
      case 3:
        return 'Create Capsule';
      case 4:
        return 'Finish';
      default:
        return 'Continue';
    }
  }

  /// Get step completion status for step indicator
  List<bool> get stepCompletionStatus {
    return List.generate(4, (index) {
      final stepNumber = index + 1;
      return stepNumber < state.currentStep;
    });
  }

  /// Get current step status for step indicator
  List<bool> get stepActiveStatus {
    return List.generate(4, (index) {
      final stepNumber = index + 1;
      return stepNumber == state.currentStep;
    });
  }
}

/// Convenience provider for accessing creation state
@riverpod
TimeCapsulePurpose? selectedPurpose(Ref ref) {
  return ref.watch(timeCapsuleCreationNotifierProvider).selectedPurpose;
}

/// Convenience provider for continue button visibility
@riverpod
bool showContinueButton(Ref ref) {
  return ref.watch(timeCapsuleCreationNotifierProvider).showContinueButton;
}

/// Convenience provider for loading state
@riverpod
bool isCreationLoading(Ref ref) {
  return ref.watch(timeCapsuleCreationNotifierProvider).isLoading;
}

/// Convenience provider for current step
@riverpod
int currentCreationStep(Ref ref) {
  return ref.watch(timeCapsuleCreationNotifierProvider).currentStep;
}

// ==================== TIME SELECTION CONVENIENCE PROVIDERS ====================

/// Convenience provider for selected time option
@riverpod
TimeOption? selectedTimeOption(Ref ref) {
  return ref.watch(timeCapsuleCreationNotifierProvider).selectedTimeOption;
}

/// Convenience provider for selected special occasion
@riverpod
SpecialOccasion? selectedSpecialOccasion(Ref ref) {
  return ref.watch(timeCapsuleCreationNotifierProvider).selectedOccasion;
}

/// Convenience provider for custom date time
@riverpod
CustomDateTime? customDateTime(Ref ref) {
  return ref.watch(timeCapsuleCreationNotifierProvider).customDateTime;
}

/// Convenience provider for current time metaphor
@riverpod
String timeMetaphor(Ref ref) {
  return ref.watch(timeCapsuleCreationNotifierProvider).timeMetaphor;
}

/// Convenience provider for current time display text
@riverpod
String timeDisplay(Ref ref) {
  return ref.watch(timeCapsuleCreationNotifierProvider).timeDisplay;
}

/// Convenience provider for current time description
@riverpod
String timeDescription(Ref ref) {
  return ref.watch(timeCapsuleCreationNotifierProvider).timeDescription;
}

/// Convenience provider for current growth stage
@riverpod
String growthStage(Ref ref) {
  return ref.watch(timeCapsuleCreationNotifierProvider).growthStage;
}

/// Convenience provider for time selection status
@riverpod
bool hasTimeSelection(Ref ref) {
  final notifier = ref.read(timeCapsuleCreationNotifierProvider.notifier);
  return notifier.hasTimeSelection;
}

/// Convenience provider for current animation class
@riverpod
String currentAnimationClass(Ref ref) {
  final notifier = ref.read(timeCapsuleCreationNotifierProvider.notifier);
  return notifier.currentAnimationClass;
}