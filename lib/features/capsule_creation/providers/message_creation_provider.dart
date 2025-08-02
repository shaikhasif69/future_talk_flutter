import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uuid/uuid.dart';
import '../models/message_creation_data.dart';
import '../models/time_capsule_creation_data.dart';

part 'message_creation_provider.g.dart';

/// Provider for managing message creation state and logic
/// Handles text editing, voice recording, font selection, and auto-save
@riverpod
class MessageCreationNotifier extends _$MessageCreationNotifier {
  Timer? _autoSaveTimer;
  Timer? _recordingTimer;
  Timer? _writingTimeTimer;
  
  @override
  MessageCreationData build() {
    // Initialize with empty state
    final initialState = MessageCreationData(
      sessionStartTime: DateTime.now(),
      draftId: 'draft_${DateTime.now().millisecondsSinceEpoch}',
    );
    
    // Start writing time tracker
    _startWritingTimeTracker();
    
    // Load saved draft if available
    _loadSavedDraft();
    
    return initialState;
  }
  
  /// Start tracking writing time
  void _startWritingTimeTracker() {
    _writingTimeTimer?.cancel();
    _writingTimeTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.sessionStartTime != null) {
        final currentTime = DateTime.now().difference(state.sessionStartTime!).inSeconds;
        state = state.copyWith(totalWritingTime: currentTime);
      }
    });
  }
  
  /// Load saved draft from local storage
  Future<void> _loadSavedDraft() async {
    // TODO: Implement with shared_preferences when available
    // For now, just initialize with empty state
    debugPrint('Draft loading not implemented yet');
  }
  
  /// Save draft to local storage
  Future<void> saveDraft() async {
    // TODO: Implement with shared_preferences when available
    // For now, just update the auto-save timestamp
    state = state.copyWith(
      lastAutoSave: DateTime.now(),
      hasUnsavedChanges: false,
    );
  }
  
  /// Update text content with auto-save
  void updateTextContent(String content) {
    final wordCount = _calculateWordCount(content);
    final characterCount = content.length;
    
    state = state.copyWith(
      textContent: content,
      wordCount: wordCount,
      characterCount: characterCount,
      hasUnsavedChanges: true,
    );
    
    // Schedule auto-save
    _scheduleAutoSave();
  }
  
  /// Switch between write and record modes
  void switchMode(MessageMode mode) {
    HapticFeedback.selectionClick();
    
    state = state.copyWith(mode: mode);
    
    // Save current progress when switching modes
    saveDraft();
  }
  
  /// Update selected font
  void updateFont(MessageFont font) {
    HapticFeedback.selectionClick();
    
    state = state.copyWith(
      selectedFont: font,
      hasUnsavedChanges: true,
    );
    
    _scheduleAutoSave();
  }
  
  /// Update font size
  void updateFontSize(double size) {
    // Clamp size to reasonable bounds
    final clampedSize = size.clamp(12.0, 28.0);
    
    HapticFeedback.selectionClick();
    
    state = state.copyWith(
      fontSize: clampedSize,
      hasUnsavedChanges: true,
    );
    
    _scheduleAutoSave();
  }
  
  /// Increase font size
  void increaseFontSize() {
    final newSize = (state.fontSize + 1.0).clamp(12.0, 28.0);
    updateFontSize(newSize);
  }
  
  /// Decrease font size
  void decreaseFontSize() {
    final newSize = (state.fontSize - 1.0).clamp(12.0, 28.0);
    updateFontSize(newSize);
  }
  
  /// Start voice recording
  Future<void> startRecording() async {
    try {
      HapticFeedback.mediumImpact();
      
      state = state.copyWith(
        isRecording: true,
        recordingDuration: 0,
      );
      
      // Start recording timer
      _recordingTimer?.cancel();
      _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        state = state.copyWith(
          recordingDuration: state.recordingDuration + 1,
        );
      });
      
      // TODO: Implement actual voice recording logic
      // This would integrate with audio recording packages
      
    } catch (e) {
      debugPrint('Error starting recording: $e');
      state = state.copyWith(isRecording: false);
    }
  }
  
  /// Stop voice recording
  Future<void> stopRecording() async {
    try {
      HapticFeedback.heavyImpact();
      
      _recordingTimer?.cancel();
      
      // TODO: Implement actual recording stop and file save logic
      
      // Create voice recording entry
      final recording = VoiceRecording(
        id: 'voice_${DateTime.now().millisecondsSinceEpoch}',
        filePath: 'path/to/recording.m4a', // TODO: Real file path
        duration: state.recordingDuration,
        createdAt: DateTime.now(),
        quality: RecordingQuality.medium,
        displayName: 'Audio ${state.voiceRecordings.length + 1}',
      );
      
      final updatedRecordings = [...state.voiceRecordings, recording];
      
      state = state.copyWith(
        isRecording: false,
        recordingDuration: 0,
        voiceRecordings: updatedRecordings,
        hasUnsavedChanges: true,
      );
      
      _scheduleAutoSave();
      
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      state = state.copyWith(
        isRecording: false,
        recordingDuration: 0,
      );
    }
  }
  
  /// Delete a voice recording
  void deleteRecording(int index) {
    if (index >= 0 && index < state.voiceRecordings.length) {
      HapticFeedback.selectionClick();
      
      final updatedRecordings = [...state.voiceRecordings];
      updatedRecordings.removeAt(index);
      
      state = state.copyWith(
        voiceRecordings: updatedRecordings,
        hasUnsavedChanges: true,
      );
      
      _scheduleAutoSave();
    }
  }
  
  /// Insert voice marker into text
  void insertVoiceMarker(int recordingIndex, TextEditingController textController) {
    if (recordingIndex >= 0 && recordingIndex < state.voiceRecordings.length) {
      final recording = state.voiceRecordings[recordingIndex];
      final marker = VoiceMarker(
        recordingId: recording.id,
        position: textController.selection.baseOffset,
        displayText: recording.displayName ?? 'Audio ${recordingIndex + 1}',
      );
      
      // Insert marker at cursor position
      final currentText = textController.text;
      final cursorPosition = textController.selection.baseOffset;
      final markerText = marker.toMarker();
      
      final newText = currentText.substring(0, cursorPosition) +
          markerText +
          currentText.substring(cursorPosition);
      
      textController.text = newText;
      textController.selection = TextSelection.collapsed(
        offset: cursorPosition + markerText.length,
      );
      
      // Update state
      updateTextContent(newText);
      
      HapticFeedback.selectionClick();
    }
  }
  
  /// Schedule auto-save
  void _scheduleAutoSave() {
    _autoSaveTimer?.cancel();
    
    // Only auto-save if we have meaningful content
    if (state.textContent.length >= AutoSaveConfig.minimumCharsForSave) {
      _autoSaveTimer = Timer(
        const Duration(seconds: AutoSaveConfig.autoSaveInterval),
        () => saveDraft(),
      );
    }
  }
  
  /// Calculate word count from text
  int _calculateWordCount(String text) {
    if (text.trim().isEmpty) return 0;
    
    // Remove voice markers for accurate word count
    final cleanText = text.replaceAll(RegExp(r'\[🎙️[^\]]+\]'), '');
    final words = cleanText.trim().split(RegExp(r'\s+'));
    return words.where((word) => word.isNotEmpty).length;
  }
  
  /// Get text statistics
  TextStatistics get textStatistics {
    return TextStatistics.fromText(state.textContent);
  }
  
  /// Check if content has meaningful data
  bool get hasContent {
    return state.textContent.trim().isNotEmpty || state.voiceRecordings.isNotEmpty;
  }
  
  /// Get greeting text based on purpose
  String getGreetingText(TimeCapsulePurpose? purpose) {
    switch (purpose) {
      case TimeCapsulePurpose.futureMe:
        return 'Dear Future Me,';
      case TimeCapsulePurpose.someoneSpecial:
        return 'Dear Friend,';
      case TimeCapsulePurpose.anonymous:
        return 'Dear Someone,';
      case null:
        return 'Dear Friend,';
    }
  }
  
  /// Get placeholder text based on purpose
  String getPlaceholderText(TimeCapsulePurpose? purpose) {
    switch (purpose) {
      case TimeCapsulePurpose.futureMe:
        return 'What would you like to tell your future self? Share your thoughts, dreams, challenges, or wisdom...';
      case TimeCapsulePurpose.someoneSpecial:
        return 'Write a heartfelt message to someone special. What do you want them to know?';
      case TimeCapsulePurpose.anonymous:
        return 'Share words of encouragement, hope, or wisdom. Your message will touch someone\'s heart...';
      case null:
        return 'Start writing your message here...';
    }
  }
  
  /// Reset the message creation state
  void reset() {
    _autoSaveTimer?.cancel();
    _recordingTimer?.cancel();
    _writingTimeTimer?.cancel();
    
    state = MessageCreationData(
      sessionStartTime: DateTime.now(),
      draftId: 'draft_${DateTime.now().millisecondsSinceEpoch}',
    );
    
    _startWritingTimeTracker();
  }
  
  @override
  void onDispose() {
    _autoSaveTimer?.cancel();
    _recordingTimer?.cancel();
    _writingTimeTimer?.cancel();
  }
}

// ==================== CONVENIENCE PROVIDERS ====================

/// Provider for checking if there's meaningful content
@riverpod
bool hasMessageContent(Ref ref) {
  final notifier = ref.read(messageCreationNotifierProvider.notifier);
  return notifier.hasContent;
}

/// Provider for text statistics
@riverpod
TextStatistics messageTextStatistics(Ref ref) {
  final notifier = ref.read(messageCreationNotifierProvider.notifier);
  return notifier.textStatistics;
}

/// Provider for current writing session duration
@riverpod
Duration writingSessionDuration(Ref ref) {
  final state = ref.watch(messageCreationNotifierProvider);
  if (state.sessionStartTime == null) return Duration.zero;
  return Duration(seconds: state.totalWritingTime);
}

/// Provider for checking unsaved changes
@riverpod
bool hasUnsavedMessageChanges(Ref ref) {
  return ref.watch(messageCreationNotifierProvider).hasUnsavedChanges;
}

/// Provider for current recording status
@riverpod
bool isCurrentlyRecording(Ref ref) {
  return ref.watch(messageCreationNotifierProvider).isRecording;
}

// ==================== WRITING PROMPTS DATA ====================

/// Static writing prompts for inspiration
class WritingPromptsData {
  static const List<WritingPrompt> prompts = [
    WritingPrompt(
      id: 'gratitude_1',
      text: 'What I\'m grateful for today',
      category: PromptCategory.gratitude,
      subtitle: 'Appreciation',
      inspiration: 'Gratitude turns what we have into enough',
    ),
    WritingPrompt(
      id: 'growth_1',
      text: 'How I\'m growing as a person',
      category: PromptCategory.growth,
      subtitle: 'Personal Development',
      inspiration: 'Growth begins at the end of your comfort zone',
    ),
    WritingPrompt(
      id: 'hopes_1',
      text: 'My hopes and dreams',
      category: PromptCategory.hopes,
      subtitle: 'Future Aspirations',
      inspiration: 'Hope is the thing with feathers that perches in the soul',
    ),
    WritingPrompt(
      id: 'memories_1',
      text: 'A cherished memory',
      category: PromptCategory.memories,
      subtitle: 'Looking Back',
      inspiration: 'Memory is the diary we all carry about with us',
    ),
    WritingPrompt(
      id: 'advice_1',
      text: 'Advice I wish I had known',
      category: PromptCategory.advice,
      subtitle: 'Wisdom Shared',
      inspiration: 'The best advice is found not in words, but in experience',
    ),
    WritingPrompt(
      id: 'encouragement_1',
      text: 'Words of encouragement',
      category: PromptCategory.encouragement,
      subtitle: 'Motivation',
      inspiration: 'Believe you can and you\'re halfway there',
    ),
  ];
  
  /// Get prompts by category
  static List<WritingPrompt> getPromptsByCategory(PromptCategory category) {
    return prompts.where((prompt) => prompt.category == category).toList();
  }
  
  /// Get random prompt
  static WritingPrompt getRandomPrompt() {
    return prompts[(DateTime.now().millisecondsSinceEpoch ~/ 1000) % prompts.length];
  }
  
  /// Get prompts for purpose
  static List<WritingPrompt> getPromptsForPurpose(TimeCapsulePurpose purpose) {
    switch (purpose) {
      case TimeCapsulePurpose.futureMe:
        return prompts.where((p) => [
          PromptCategory.growth,
          PromptCategory.advice,
          PromptCategory.hopes,
        ].contains(p.category)).toList();
      case TimeCapsulePurpose.someoneSpecial:
        return prompts.where((p) => [
          PromptCategory.gratitude,
          PromptCategory.memories,
          PromptCategory.encouragement,
        ].contains(p.category)).toList();
      case TimeCapsulePurpose.anonymous:
        return prompts.where((p) => [
          PromptCategory.encouragement,
          PromptCategory.advice,
          PromptCategory.hopes,
        ].contains(p.category)).toList();
    }
  }
}

// ==================== INSPIRATIONAL QUOTES ====================

/// Rotating inspirational quotes for writing
class WritingQuotes {
  static const List<String> quotes = [
    "The secret to getting ahead is getting started. — Mark Twain",
    "Words have no single fixed meaning. Like wayward electrons, they can spin away from their initial orbit and enter a wider magnetic field. — David Lehman",
    "There is no greater agony than bearing an untold story inside you. — Maya Angelou",
    "The first draft of anything is shit. — Ernest Hemingway",
    "You don't start out writing good stuff. You start out writing crap and thinking it's good stuff, and then gradually you get better at it. — Octavia E. Butler",
    "Writing is thinking on paper. — William Zinsser",
    "The scariest moment is always just before you start. — Stephen King",
    "I can shake off everything as I write; my sorrows disappear, my courage is reborn. — Anne Frank",
    "Fill your paper with the breathings of your heart. — William Wordsworth",
    "Writing is the only way I have to explain my own life to myself. — Pat Conroy",
  ];
  
  /// Get quote by index (cycles through)
  static String getQuote(int index) {
    return quotes[index % quotes.length];
  }
  
  /// Get current quote based on time
  static String getCurrentQuote() {
    final now = DateTime.now();
    final index = (now.hour + now.minute) % quotes.length;
    return quotes[index];
  }
}