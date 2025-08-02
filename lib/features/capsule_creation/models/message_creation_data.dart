import 'package:freezed_annotation/freezed_annotation.dart';

part 'message_creation_data.freezed.dart';
part 'message_creation_data.g.dart';

/// Data model for message creation flow
/// Tracks text content, voice recordings, fonts, and writing state
@freezed
class MessageCreationData with _$MessageCreationData {
  const factory MessageCreationData({
    /// Current text content of the message
    @Default('') String textContent,
    
    /// List of voice recordings
    @Default([]) List<VoiceRecording> voiceRecordings,
    
    /// Current writing mode (text or voice)
    @Default(MessageMode.write) MessageMode mode,
    
    /// Selected font family
    @Default(MessageFont.crimsonPro) MessageFont selectedFont,
    
    /// Current font size (12-24)
    @Default(16.0) double fontSize,
    
    /// Word count of text content
    @Default(0) int wordCount,
    
    /// Character count of text content
    @Default(0) int characterCount,
    
    /// Whether currently recording voice
    @Default(false) bool isRecording,
    
    /// Current recording duration in seconds
    @Default(0) int recordingDuration,
    
    /// Loading state for saving/processing
    @Default(false) bool isLoading,
    
    /// Last auto-save timestamp
    DateTime? lastAutoSave,
    
    /// Draft ID for persistence
    String? draftId,
    
    /// Whether content has unsaved changes
    @Default(false) bool hasUnsavedChanges,
    
    /// Writing session start time
    DateTime? sessionStartTime,
    
    /// Total writing time in seconds
    @Default(0) int totalWritingTime,
  }) = _MessageCreationData;

  factory MessageCreationData.fromJson(Map<String, dynamic> json) =>
      _$MessageCreationDataFromJson(json);
}

/// Message writing modes
enum MessageMode {
  @JsonValue('write')
  write,
  
  @JsonValue('record')
  record,
}

/// Extension for message mode properties
extension MessageModeExtension on MessageMode {
  /// Display name for the mode
  String get displayName {
    switch (this) {
      case MessageMode.write:
        return 'Write';
      case MessageMode.record:
        return 'Record';
    }
  }
  
  /// Icon for the mode
  String get icon {
    switch (this) {
      case MessageMode.write:
        return '✍️';
      case MessageMode.record:
        return '🎙️';
    }
  }
  
  /// Description for the mode
  String get description {
    switch (this) {
      case MessageMode.write:
        return 'Type your message';
      case MessageMode.record:
        return 'Record voice notes';
    }
  }
}

/// Available font families for message text
enum MessageFont {
  @JsonValue('crimson-pro')
  crimsonPro,
  
  @JsonValue('playfair-display')
  playfairDisplay,
  
  @JsonValue('dancing-script')
  dancingScript,
  
  @JsonValue('caveat')
  caveat,
  
  @JsonValue('kalam')
  kalam,
  
  @JsonValue('patrick-hand')
  patrickHand,
  
  @JsonValue('satisfy')
  satisfy,
  
  @JsonValue('system')
  system,
}

/// Extension for font properties
extension MessageFontExtension on MessageFont {
  /// Display name for the font
  String get displayName {
    switch (this) {
      case MessageFont.crimsonPro:
        return 'Crimson Pro';
      case MessageFont.playfairDisplay:
        return 'Playfair Display';
      case MessageFont.dancingScript:
        return 'Dancing Script';
      case MessageFont.caveat:
        return 'Caveat';
      case MessageFont.kalam:
        return 'Kalam';
      case MessageFont.patrickHand:
        return 'Patrick Hand';
      case MessageFont.satisfy:
        return 'Satisfy';
      case MessageFont.system:
        return 'System Default';
    }
  }
  
  /// Google Fonts family name
  String get fontFamily {
    switch (this) {
      case MessageFont.crimsonPro:
        return 'Crimson Pro';
      case MessageFont.playfairDisplay:
        return 'Playfair Display';
      case MessageFont.dancingScript:
        return 'Dancing Script';
      case MessageFont.caveat:
        return 'Caveat';
      case MessageFont.kalam:
        return 'Kalam';
      case MessageFont.patrickHand:
        return 'Patrick Hand';
      case MessageFont.satisfy:
        return 'Satisfy';
      case MessageFont.system:
        return 'System'; // Will use system default
    }
  }
  
  /// Font category for grouping
  FontCategory get category {
    switch (this) {
      case MessageFont.crimsonPro:
      case MessageFont.playfairDisplay:
        return FontCategory.serif;
      case MessageFont.dancingScript:
      case MessageFont.satisfy:
        return FontCategory.script;
      case MessageFont.caveat:
      case MessageFont.patrickHand:
      case MessageFont.kalam:
        return FontCategory.handwriting;
      case MessageFont.system:
        return FontCategory.system;
    }
  }
  
  /// Whether this font is decorative/script
  bool get isDecorative {
    return category == FontCategory.script || category == FontCategory.handwriting;
  }
  
  /// Recommended font size range
  FontSizeRange get recommendedSizeRange {
    switch (this) {
      case MessageFont.dancingScript:
      case MessageFont.satisfy:
        return const FontSizeRange(min: 18.0, max: 28.0);
      case MessageFont.caveat:
      case MessageFont.patrickHand:
      case MessageFont.kalam:
        return const FontSizeRange(min: 16.0, max: 24.0);
      case MessageFont.crimsonPro:
      case MessageFont.playfairDisplay:
      case MessageFont.system:
        return const FontSizeRange(min: 14.0, max: 22.0);
    }
  }
}

/// Font categories for organization
enum FontCategory {
  serif,
  script,
  handwriting,
  system,
}

/// Font size range helper
class FontSizeRange {
  final double min;
  final double max;
  
  const FontSizeRange({required this.min, required this.max});
}

/// Voice recording model
@freezed
class VoiceRecording with _$VoiceRecording {
  const factory VoiceRecording({
    /// Unique identifier for the recording
    required String id,
    
    /// File path or URL to the audio file
    required String filePath,
    
    /// Duration of the recording in seconds
    required int duration,
    
    /// Recording timestamp
    required DateTime createdAt,
    
    /// Waveform data for visualization (optional)
    List<double>? waveformData,
    
    /// Recording quality/bitrate info
    RecordingQuality? quality,
    
    /// Whether this recording is embedded in text
    @Default(false) bool isEmbedded,
    
    /// Position in text where this recording is embedded
    int? textPosition,
    
    /// Display name for the recording
    String? displayName,
  }) = _VoiceRecording;

  factory VoiceRecording.fromJson(Map<String, dynamic> json) =>
      _$VoiceRecordingFromJson(json);
}

/// Recording quality levels
enum RecordingQuality {
  @JsonValue('low')
  low,
  
  @JsonValue('medium')
  medium,
  
  @JsonValue('high')
  high,
}

/// Extension for recording quality
extension RecordingQualityExtension on RecordingQuality {
  /// Display name for quality
  String get displayName {
    switch (this) {
      case RecordingQuality.low:
        return 'Low Quality';
      case RecordingQuality.medium:
        return 'Medium Quality';
      case RecordingQuality.high:
        return 'High Quality';
    }
  }
  
  /// Bitrate for the quality level
  int get bitrate {
    switch (this) {
      case RecordingQuality.low:
        return 32000; // 32 kbps
      case RecordingQuality.medium:
        return 64000; // 64 kbps
      case RecordingQuality.high:
        return 128000; // 128 kbps
    }
  }
}

/// Writing prompt categories
enum PromptCategory {
  gratitude,
  growth,
  hopes,
  memories,
  advice,
  encouragement,
}

/// Writing prompt model
@freezed
class WritingPrompt with _$WritingPrompt {
  const factory WritingPrompt({
    required String id,
    required String text,
    required PromptCategory category,
    String? subtitle,
    String? inspiration,
  }) = _WritingPrompt;

  factory WritingPrompt.fromJson(Map<String, dynamic> json) =>
      _$WritingPromptFromJson(json);
}

/// Voice marker for inline audio notes in text
class VoiceMarker {
  final String recordingId;
  final int position;
  final String displayText;
  
  const VoiceMarker({
    required this.recordingId,
    required this.position,
    required this.displayText,
  });
  
  /// Convert to markdown-style marker for text
  String toMarker() {
    return '[🎙️ $displayText]';
  }
  
  /// Parse voice markers from text
  static List<VoiceMarker> parseFromText(String text) {
    final markers = <VoiceMarker>[];
    final regex = RegExp(r'\[🎙️\s+([^\]]+)\]');
    final matches = regex.allMatches(text);
    
    for (final match in matches) {
      final displayText = match.group(1) ?? 'Audio';
      markers.add(VoiceMarker(
        recordingId: displayText, // This would be mapped to actual ID
        position: match.start,
        displayText: displayText,
      ));
    }
    
    return markers;
  }
}

/// Auto-save configuration
class AutoSaveConfig {
  /// Auto-save interval in seconds
  static const int autoSaveInterval = 30;
  
  /// Minimum characters before auto-save
  static const int minimumCharsForSave = 10;
  
  /// Maximum draft age in days
  static const int maxDraftAgeDays = 30;
}

/// Text statistics helper
class TextStatistics {
  final int wordCount;
  final int characterCount;
  final int characterCountNoSpaces;
  final int paragraphCount;
  final int sentenceCount;
  final double readingTime; // in minutes
  
  const TextStatistics({
    required this.wordCount,
    required this.characterCount,
    required this.characterCountNoSpaces,
    required this.paragraphCount,
    required this.sentenceCount,
    required this.readingTime,
  });
  
  /// Calculate statistics from text
  factory TextStatistics.fromText(String text) {
    if (text.trim().isEmpty) {
      return const TextStatistics(
        wordCount: 0,
        characterCount: 0,
        characterCountNoSpaces: 0,
        paragraphCount: 0,
        sentenceCount: 0,
        readingTime: 0.0,
      );
    }
    
    final words = text.trim().split(RegExp(r'\s+'));
    final wordCount = words.where((word) => word.isNotEmpty).length;
    
    final characterCount = text.length;
    final characterCountNoSpaces = text.replaceAll(RegExp(r'\s'), '').length;
    
    final paragraphs = text.split(RegExp(r'\n\s*\n'));
    final paragraphCount = paragraphs.where((p) => p.trim().isNotEmpty).length;
    
    final sentences = text.split(RegExp(r'[.!?]+'));
    final sentenceCount = sentences.where((s) => s.trim().isNotEmpty).length;
    
    // Average reading speed: 200 words per minute
    final readingTime = wordCount / 200.0;
    
    return TextStatistics(
      wordCount: wordCount,
      characterCount: characterCount,
      characterCountNoSpaces: characterCountNoSpaces,
      paragraphCount: paragraphCount,
      sentenceCount: sentenceCount,
      readingTime: readingTime,
    );
  }
}