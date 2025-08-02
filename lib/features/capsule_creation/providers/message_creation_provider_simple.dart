import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/message_creation_data.dart';

/// Simple provider for message creation without complex state management
class MessageCreationNotifier extends StateNotifier<MessageCreationData> {
  MessageCreationNotifier() : super(const MessageCreationData());

  /// Update text content and recalculate stats
  void updateTextContent(String content) {
    final stats = TextStatistics.fromText(content);
    state = state.copyWith(
      textContent: content,
      wordCount: stats.wordCount,
      characterCount: stats.characterCount,
      hasUnsavedChanges: true,
      lastAutoSave: null,
    );
  }

  /// Switch between write and record modes
  void setMode(MessageMode mode) {
    state = state.copyWith(mode: mode);
  }

  /// Switch mode (alias for compatibility)
  void switchMode(MessageMode mode) {
    setMode(mode);
  }

  /// Update selected font
  void setFont(MessageFont font) {
    state = state.copyWith(selectedFont: font);
  }

  /// Update selected font (alias for compatibility)
  void updateFont(MessageFont font) {
    setFont(font);
  }

  /// Update font size
  void setFontSize(double size) {
    final clampedSize = size.clamp(12.0, 24.0);
    state = state.copyWith(fontSize: clampedSize);
  }

  /// Update font size (alias for compatibility)
  void updateFontSize(double size) {
    setFontSize(size);
  }

  /// Start recording
  void startRecording() {
    state = state.copyWith(
      isRecording: true,
      recordingDuration: 0,
    );
  }

  /// Stop recording
  void stopRecording() {
    state = state.copyWith(
      isRecording: false,
    );
  }

  /// Update recording duration
  void updateRecordingDuration(int duration) {
    if (state.isRecording) {
      state = state.copyWith(recordingDuration: duration);
    }
  }

  /// Add voice recording
  void addVoiceRecording(VoiceRecording recording) {
    final recordings = List<VoiceRecording>.from(state.voiceRecordings);
    recordings.add(recording);
    state = state.copyWith(
      voiceRecordings: recordings,
      hasUnsavedChanges: true,
    );
  }

  /// Remove voice recording
  void removeVoiceRecording(String recordingId) {
    final recordings = state.voiceRecordings
        .where((r) => r.id != recordingId)
        .toList();
    state = state.copyWith(
      voiceRecordings: recordings,
      hasUnsavedChanges: true,
    );
  }

  /// Mark as saved
  void markAsSaved() {
    state = state.copyWith(
      hasUnsavedChanges: false,
      lastAutoSave: DateTime.now(),
    );
  }

  /// Set loading state
  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  /// Check if can continue (has content)
  bool get canContinue {
    return state.textContent.trim().isNotEmpty || 
           state.voiceRecordings.isNotEmpty;
  }

  /// Save draft (placeholder implementation)
  Future<void> saveDraft() async {
    // TODO: Implement actual draft saving
    state = state.copyWith(
      hasUnsavedChanges: false,
      lastAutoSave: DateTime.now(),
    );
  }

  /// Delete recording by ID or index
  void deleteRecording(dynamic identifier) {
    if (identifier is String) {
      removeVoiceRecording(identifier);
    } else if (identifier is int) {
      // Handle index-based deletion
      if (identifier >= 0 && identifier < state.voiceRecordings.length) {
        final recordings = List<VoiceRecording>.from(state.voiceRecordings);
        recordings.removeAt(identifier);
        state = state.copyWith(
          voiceRecordings: recordings,
          hasUnsavedChanges: true,
        );
      }
    }
  }

  /// Insert voice marker in text (flexible parameters)
  void insertVoiceMarker(dynamic identifier, [dynamic controller]) {
    // TODO: Implement voice marker insertion logic
    final currentText = state.textContent;
    final marker = ' [🎙️Audio] ';
    
    // For now, just append the marker
    final newText = currentText + marker;
    updateTextContent(newText);
  }

  /// Clear all data
  void clear() {
    state = const MessageCreationData();
  }
}

/// Main provider for message creation
final messageCreationNotifierProvider = 
    StateNotifierProvider<MessageCreationNotifier, MessageCreationData>(
  (ref) => MessageCreationNotifier(),
);

/// Convenience providers
final messageTextProvider = Provider<String>((ref) {
  return ref.watch(messageCreationNotifierProvider).textContent;
});

final messageWordCountProvider = Provider<int>((ref) {
  return ref.watch(messageCreationNotifierProvider).wordCount;
});

final messageModeProvider = Provider<MessageMode>((ref) {
  return ref.watch(messageCreationNotifierProvider).mode;
});

final messageSelectedFontProvider = Provider<MessageFont>((ref) {
  return ref.watch(messageCreationNotifierProvider).selectedFont;
});

final messageFontSizeProvider = Provider<double>((ref) {
  return ref.watch(messageCreationNotifierProvider).fontSize;
});

final messageIsRecordingProvider = Provider<bool>((ref) {
  return ref.watch(messageCreationNotifierProvider).isRecording;
});

final messageRecordingDurationProvider = Provider<int>((ref) {
  return ref.watch(messageCreationNotifierProvider).recordingDuration;
});

final messageVoiceRecordingsProvider = Provider<List<VoiceRecording>>((ref) {
  return ref.watch(messageCreationNotifierProvider).voiceRecordings;
});

final messageCanContinueProvider = Provider<bool>((ref) {
  return ref.read(messageCreationNotifierProvider.notifier).canContinue;
});

final messageIsLoadingProvider = Provider<bool>((ref) {
  return ref.watch(messageCreationNotifierProvider).isLoading;
});

final messageHasUnsavedChangesProvider = Provider<bool>((ref) {
  return ref.watch(messageCreationNotifierProvider).hasUnsavedChanges;
});