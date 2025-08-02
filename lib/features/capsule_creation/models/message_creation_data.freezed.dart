// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message_creation_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

MessageCreationData _$MessageCreationDataFromJson(Map<String, dynamic> json) {
  return _MessageCreationData.fromJson(json);
}

/// @nodoc
mixin _$MessageCreationData {
  /// Current text content of the message
  String get textContent => throw _privateConstructorUsedError;

  /// List of voice recordings
  List<VoiceRecording> get voiceRecordings =>
      throw _privateConstructorUsedError;

  /// Current writing mode (text or voice)
  MessageMode get mode => throw _privateConstructorUsedError;

  /// Selected font family
  MessageFont get selectedFont => throw _privateConstructorUsedError;

  /// Current font size (12-24)
  double get fontSize => throw _privateConstructorUsedError;

  /// Word count of text content
  int get wordCount => throw _privateConstructorUsedError;

  /// Character count of text content
  int get characterCount => throw _privateConstructorUsedError;

  /// Whether currently recording voice
  bool get isRecording => throw _privateConstructorUsedError;

  /// Current recording duration in seconds
  int get recordingDuration => throw _privateConstructorUsedError;

  /// Loading state for saving/processing
  bool get isLoading => throw _privateConstructorUsedError;

  /// Last auto-save timestamp
  DateTime? get lastAutoSave => throw _privateConstructorUsedError;

  /// Draft ID for persistence
  String? get draftId => throw _privateConstructorUsedError;

  /// Whether content has unsaved changes
  bool get hasUnsavedChanges => throw _privateConstructorUsedError;

  /// Writing session start time
  DateTime? get sessionStartTime => throw _privateConstructorUsedError;

  /// Total writing time in seconds
  int get totalWritingTime => throw _privateConstructorUsedError;

  /// Serializes this MessageCreationData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of MessageCreationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MessageCreationDataCopyWith<MessageCreationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MessageCreationDataCopyWith<$Res> {
  factory $MessageCreationDataCopyWith(
    MessageCreationData value,
    $Res Function(MessageCreationData) then,
  ) = _$MessageCreationDataCopyWithImpl<$Res, MessageCreationData>;
  @useResult
  $Res call({
    String textContent,
    List<VoiceRecording> voiceRecordings,
    MessageMode mode,
    MessageFont selectedFont,
    double fontSize,
    int wordCount,
    int characterCount,
    bool isRecording,
    int recordingDuration,
    bool isLoading,
    DateTime? lastAutoSave,
    String? draftId,
    bool hasUnsavedChanges,
    DateTime? sessionStartTime,
    int totalWritingTime,
  });
}

/// @nodoc
class _$MessageCreationDataCopyWithImpl<$Res, $Val extends MessageCreationData>
    implements $MessageCreationDataCopyWith<$Res> {
  _$MessageCreationDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MessageCreationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? textContent = null,
    Object? voiceRecordings = null,
    Object? mode = null,
    Object? selectedFont = null,
    Object? fontSize = null,
    Object? wordCount = null,
    Object? characterCount = null,
    Object? isRecording = null,
    Object? recordingDuration = null,
    Object? isLoading = null,
    Object? lastAutoSave = freezed,
    Object? draftId = freezed,
    Object? hasUnsavedChanges = null,
    Object? sessionStartTime = freezed,
    Object? totalWritingTime = null,
  }) {
    return _then(
      _value.copyWith(
            textContent: null == textContent
                ? _value.textContent
                : textContent // ignore: cast_nullable_to_non_nullable
                      as String,
            voiceRecordings: null == voiceRecordings
                ? _value.voiceRecordings
                : voiceRecordings // ignore: cast_nullable_to_non_nullable
                      as List<VoiceRecording>,
            mode: null == mode
                ? _value.mode
                : mode // ignore: cast_nullable_to_non_nullable
                      as MessageMode,
            selectedFont: null == selectedFont
                ? _value.selectedFont
                : selectedFont // ignore: cast_nullable_to_non_nullable
                      as MessageFont,
            fontSize: null == fontSize
                ? _value.fontSize
                : fontSize // ignore: cast_nullable_to_non_nullable
                      as double,
            wordCount: null == wordCount
                ? _value.wordCount
                : wordCount // ignore: cast_nullable_to_non_nullable
                      as int,
            characterCount: null == characterCount
                ? _value.characterCount
                : characterCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isRecording: null == isRecording
                ? _value.isRecording
                : isRecording // ignore: cast_nullable_to_non_nullable
                      as bool,
            recordingDuration: null == recordingDuration
                ? _value.recordingDuration
                : recordingDuration // ignore: cast_nullable_to_non_nullable
                      as int,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastAutoSave: freezed == lastAutoSave
                ? _value.lastAutoSave
                : lastAutoSave // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            draftId: freezed == draftId
                ? _value.draftId
                : draftId // ignore: cast_nullable_to_non_nullable
                      as String?,
            hasUnsavedChanges: null == hasUnsavedChanges
                ? _value.hasUnsavedChanges
                : hasUnsavedChanges // ignore: cast_nullable_to_non_nullable
                      as bool,
            sessionStartTime: freezed == sessionStartTime
                ? _value.sessionStartTime
                : sessionStartTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            totalWritingTime: null == totalWritingTime
                ? _value.totalWritingTime
                : totalWritingTime // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$MessageCreationDataImplCopyWith<$Res>
    implements $MessageCreationDataCopyWith<$Res> {
  factory _$$MessageCreationDataImplCopyWith(
    _$MessageCreationDataImpl value,
    $Res Function(_$MessageCreationDataImpl) then,
  ) = __$$MessageCreationDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String textContent,
    List<VoiceRecording> voiceRecordings,
    MessageMode mode,
    MessageFont selectedFont,
    double fontSize,
    int wordCount,
    int characterCount,
    bool isRecording,
    int recordingDuration,
    bool isLoading,
    DateTime? lastAutoSave,
    String? draftId,
    bool hasUnsavedChanges,
    DateTime? sessionStartTime,
    int totalWritingTime,
  });
}

/// @nodoc
class __$$MessageCreationDataImplCopyWithImpl<$Res>
    extends _$MessageCreationDataCopyWithImpl<$Res, _$MessageCreationDataImpl>
    implements _$$MessageCreationDataImplCopyWith<$Res> {
  __$$MessageCreationDataImplCopyWithImpl(
    _$MessageCreationDataImpl _value,
    $Res Function(_$MessageCreationDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of MessageCreationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? textContent = null,
    Object? voiceRecordings = null,
    Object? mode = null,
    Object? selectedFont = null,
    Object? fontSize = null,
    Object? wordCount = null,
    Object? characterCount = null,
    Object? isRecording = null,
    Object? recordingDuration = null,
    Object? isLoading = null,
    Object? lastAutoSave = freezed,
    Object? draftId = freezed,
    Object? hasUnsavedChanges = null,
    Object? sessionStartTime = freezed,
    Object? totalWritingTime = null,
  }) {
    return _then(
      _$MessageCreationDataImpl(
        textContent: null == textContent
            ? _value.textContent
            : textContent // ignore: cast_nullable_to_non_nullable
                  as String,
        voiceRecordings: null == voiceRecordings
            ? _value._voiceRecordings
            : voiceRecordings // ignore: cast_nullable_to_non_nullable
                  as List<VoiceRecording>,
        mode: null == mode
            ? _value.mode
            : mode // ignore: cast_nullable_to_non_nullable
                  as MessageMode,
        selectedFont: null == selectedFont
            ? _value.selectedFont
            : selectedFont // ignore: cast_nullable_to_non_nullable
                  as MessageFont,
        fontSize: null == fontSize
            ? _value.fontSize
            : fontSize // ignore: cast_nullable_to_non_nullable
                  as double,
        wordCount: null == wordCount
            ? _value.wordCount
            : wordCount // ignore: cast_nullable_to_non_nullable
                  as int,
        characterCount: null == characterCount
            ? _value.characterCount
            : characterCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isRecording: null == isRecording
            ? _value.isRecording
            : isRecording // ignore: cast_nullable_to_non_nullable
                  as bool,
        recordingDuration: null == recordingDuration
            ? _value.recordingDuration
            : recordingDuration // ignore: cast_nullable_to_non_nullable
                  as int,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastAutoSave: freezed == lastAutoSave
            ? _value.lastAutoSave
            : lastAutoSave // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        draftId: freezed == draftId
            ? _value.draftId
            : draftId // ignore: cast_nullable_to_non_nullable
                  as String?,
        hasUnsavedChanges: null == hasUnsavedChanges
            ? _value.hasUnsavedChanges
            : hasUnsavedChanges // ignore: cast_nullable_to_non_nullable
                  as bool,
        sessionStartTime: freezed == sessionStartTime
            ? _value.sessionStartTime
            : sessionStartTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        totalWritingTime: null == totalWritingTime
            ? _value.totalWritingTime
            : totalWritingTime // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$MessageCreationDataImpl implements _MessageCreationData {
  const _$MessageCreationDataImpl({
    this.textContent = '',
    final List<VoiceRecording> voiceRecordings = const [],
    this.mode = MessageMode.write,
    this.selectedFont = MessageFont.crimsonPro,
    this.fontSize = 16.0,
    this.wordCount = 0,
    this.characterCount = 0,
    this.isRecording = false,
    this.recordingDuration = 0,
    this.isLoading = false,
    this.lastAutoSave,
    this.draftId,
    this.hasUnsavedChanges = false,
    this.sessionStartTime,
    this.totalWritingTime = 0,
  }) : _voiceRecordings = voiceRecordings;

  factory _$MessageCreationDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$MessageCreationDataImplFromJson(json);

  /// Current text content of the message
  @override
  @JsonKey()
  final String textContent;

  /// List of voice recordings
  final List<VoiceRecording> _voiceRecordings;

  /// List of voice recordings
  @override
  @JsonKey()
  List<VoiceRecording> get voiceRecordings {
    if (_voiceRecordings is EqualUnmodifiableListView) return _voiceRecordings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_voiceRecordings);
  }

  /// Current writing mode (text or voice)
  @override
  @JsonKey()
  final MessageMode mode;

  /// Selected font family
  @override
  @JsonKey()
  final MessageFont selectedFont;

  /// Current font size (12-24)
  @override
  @JsonKey()
  final double fontSize;

  /// Word count of text content
  @override
  @JsonKey()
  final int wordCount;

  /// Character count of text content
  @override
  @JsonKey()
  final int characterCount;

  /// Whether currently recording voice
  @override
  @JsonKey()
  final bool isRecording;

  /// Current recording duration in seconds
  @override
  @JsonKey()
  final int recordingDuration;

  /// Loading state for saving/processing
  @override
  @JsonKey()
  final bool isLoading;

  /// Last auto-save timestamp
  @override
  final DateTime? lastAutoSave;

  /// Draft ID for persistence
  @override
  final String? draftId;

  /// Whether content has unsaved changes
  @override
  @JsonKey()
  final bool hasUnsavedChanges;

  /// Writing session start time
  @override
  final DateTime? sessionStartTime;

  /// Total writing time in seconds
  @override
  @JsonKey()
  final int totalWritingTime;

  @override
  String toString() {
    return 'MessageCreationData(textContent: $textContent, voiceRecordings: $voiceRecordings, mode: $mode, selectedFont: $selectedFont, fontSize: $fontSize, wordCount: $wordCount, characterCount: $characterCount, isRecording: $isRecording, recordingDuration: $recordingDuration, isLoading: $isLoading, lastAutoSave: $lastAutoSave, draftId: $draftId, hasUnsavedChanges: $hasUnsavedChanges, sessionStartTime: $sessionStartTime, totalWritingTime: $totalWritingTime)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MessageCreationDataImpl &&
            (identical(other.textContent, textContent) ||
                other.textContent == textContent) &&
            const DeepCollectionEquality().equals(
              other._voiceRecordings,
              _voiceRecordings,
            ) &&
            (identical(other.mode, mode) || other.mode == mode) &&
            (identical(other.selectedFont, selectedFont) ||
                other.selectedFont == selectedFont) &&
            (identical(other.fontSize, fontSize) ||
                other.fontSize == fontSize) &&
            (identical(other.wordCount, wordCount) ||
                other.wordCount == wordCount) &&
            (identical(other.characterCount, characterCount) ||
                other.characterCount == characterCount) &&
            (identical(other.isRecording, isRecording) ||
                other.isRecording == isRecording) &&
            (identical(other.recordingDuration, recordingDuration) ||
                other.recordingDuration == recordingDuration) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.lastAutoSave, lastAutoSave) ||
                other.lastAutoSave == lastAutoSave) &&
            (identical(other.draftId, draftId) || other.draftId == draftId) &&
            (identical(other.hasUnsavedChanges, hasUnsavedChanges) ||
                other.hasUnsavedChanges == hasUnsavedChanges) &&
            (identical(other.sessionStartTime, sessionStartTime) ||
                other.sessionStartTime == sessionStartTime) &&
            (identical(other.totalWritingTime, totalWritingTime) ||
                other.totalWritingTime == totalWritingTime));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    textContent,
    const DeepCollectionEquality().hash(_voiceRecordings),
    mode,
    selectedFont,
    fontSize,
    wordCount,
    characterCount,
    isRecording,
    recordingDuration,
    isLoading,
    lastAutoSave,
    draftId,
    hasUnsavedChanges,
    sessionStartTime,
    totalWritingTime,
  );

  /// Create a copy of MessageCreationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MessageCreationDataImplCopyWith<_$MessageCreationDataImpl> get copyWith =>
      __$$MessageCreationDataImplCopyWithImpl<_$MessageCreationDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$MessageCreationDataImplToJson(this);
  }
}

abstract class _MessageCreationData implements MessageCreationData {
  const factory _MessageCreationData({
    final String textContent,
    final List<VoiceRecording> voiceRecordings,
    final MessageMode mode,
    final MessageFont selectedFont,
    final double fontSize,
    final int wordCount,
    final int characterCount,
    final bool isRecording,
    final int recordingDuration,
    final bool isLoading,
    final DateTime? lastAutoSave,
    final String? draftId,
    final bool hasUnsavedChanges,
    final DateTime? sessionStartTime,
    final int totalWritingTime,
  }) = _$MessageCreationDataImpl;

  factory _MessageCreationData.fromJson(Map<String, dynamic> json) =
      _$MessageCreationDataImpl.fromJson;

  /// Current text content of the message
  @override
  String get textContent;

  /// List of voice recordings
  @override
  List<VoiceRecording> get voiceRecordings;

  /// Current writing mode (text or voice)
  @override
  MessageMode get mode;

  /// Selected font family
  @override
  MessageFont get selectedFont;

  /// Current font size (12-24)
  @override
  double get fontSize;

  /// Word count of text content
  @override
  int get wordCount;

  /// Character count of text content
  @override
  int get characterCount;

  /// Whether currently recording voice
  @override
  bool get isRecording;

  /// Current recording duration in seconds
  @override
  int get recordingDuration;

  /// Loading state for saving/processing
  @override
  bool get isLoading;

  /// Last auto-save timestamp
  @override
  DateTime? get lastAutoSave;

  /// Draft ID for persistence
  @override
  String? get draftId;

  /// Whether content has unsaved changes
  @override
  bool get hasUnsavedChanges;

  /// Writing session start time
  @override
  DateTime? get sessionStartTime;

  /// Total writing time in seconds
  @override
  int get totalWritingTime;

  /// Create a copy of MessageCreationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MessageCreationDataImplCopyWith<_$MessageCreationDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VoiceRecording _$VoiceRecordingFromJson(Map<String, dynamic> json) {
  return _VoiceRecording.fromJson(json);
}

/// @nodoc
mixin _$VoiceRecording {
  /// Unique identifier for the recording
  String get id => throw _privateConstructorUsedError;

  /// File path or URL to the audio file
  String get filePath => throw _privateConstructorUsedError;

  /// Duration of the recording in seconds
  int get duration => throw _privateConstructorUsedError;

  /// Recording timestamp
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Waveform data for visualization (optional)
  List<double>? get waveformData => throw _privateConstructorUsedError;

  /// Recording quality/bitrate info
  RecordingQuality? get quality => throw _privateConstructorUsedError;

  /// Whether this recording is embedded in text
  bool get isEmbedded => throw _privateConstructorUsedError;

  /// Position in text where this recording is embedded
  int? get textPosition => throw _privateConstructorUsedError;

  /// Display name for the recording
  String? get displayName => throw _privateConstructorUsedError;

  /// Serializes this VoiceRecording to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VoiceRecording
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VoiceRecordingCopyWith<VoiceRecording> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VoiceRecordingCopyWith<$Res> {
  factory $VoiceRecordingCopyWith(
    VoiceRecording value,
    $Res Function(VoiceRecording) then,
  ) = _$VoiceRecordingCopyWithImpl<$Res, VoiceRecording>;
  @useResult
  $Res call({
    String id,
    String filePath,
    int duration,
    DateTime createdAt,
    List<double>? waveformData,
    RecordingQuality? quality,
    bool isEmbedded,
    int? textPosition,
    String? displayName,
  });
}

/// @nodoc
class _$VoiceRecordingCopyWithImpl<$Res, $Val extends VoiceRecording>
    implements $VoiceRecordingCopyWith<$Res> {
  _$VoiceRecordingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VoiceRecording
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? filePath = null,
    Object? duration = null,
    Object? createdAt = null,
    Object? waveformData = freezed,
    Object? quality = freezed,
    Object? isEmbedded = null,
    Object? textPosition = freezed,
    Object? displayName = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            filePath: null == filePath
                ? _value.filePath
                : filePath // ignore: cast_nullable_to_non_nullable
                      as String,
            duration: null == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            waveformData: freezed == waveformData
                ? _value.waveformData
                : waveformData // ignore: cast_nullable_to_non_nullable
                      as List<double>?,
            quality: freezed == quality
                ? _value.quality
                : quality // ignore: cast_nullable_to_non_nullable
                      as RecordingQuality?,
            isEmbedded: null == isEmbedded
                ? _value.isEmbedded
                : isEmbedded // ignore: cast_nullable_to_non_nullable
                      as bool,
            textPosition: freezed == textPosition
                ? _value.textPosition
                : textPosition // ignore: cast_nullable_to_non_nullable
                      as int?,
            displayName: freezed == displayName
                ? _value.displayName
                : displayName // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$VoiceRecordingImplCopyWith<$Res>
    implements $VoiceRecordingCopyWith<$Res> {
  factory _$$VoiceRecordingImplCopyWith(
    _$VoiceRecordingImpl value,
    $Res Function(_$VoiceRecordingImpl) then,
  ) = __$$VoiceRecordingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String filePath,
    int duration,
    DateTime createdAt,
    List<double>? waveformData,
    RecordingQuality? quality,
    bool isEmbedded,
    int? textPosition,
    String? displayName,
  });
}

/// @nodoc
class __$$VoiceRecordingImplCopyWithImpl<$Res>
    extends _$VoiceRecordingCopyWithImpl<$Res, _$VoiceRecordingImpl>
    implements _$$VoiceRecordingImplCopyWith<$Res> {
  __$$VoiceRecordingImplCopyWithImpl(
    _$VoiceRecordingImpl _value,
    $Res Function(_$VoiceRecordingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of VoiceRecording
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? filePath = null,
    Object? duration = null,
    Object? createdAt = null,
    Object? waveformData = freezed,
    Object? quality = freezed,
    Object? isEmbedded = null,
    Object? textPosition = freezed,
    Object? displayName = freezed,
  }) {
    return _then(
      _$VoiceRecordingImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        filePath: null == filePath
            ? _value.filePath
            : filePath // ignore: cast_nullable_to_non_nullable
                  as String,
        duration: null == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        waveformData: freezed == waveformData
            ? _value._waveformData
            : waveformData // ignore: cast_nullable_to_non_nullable
                  as List<double>?,
        quality: freezed == quality
            ? _value.quality
            : quality // ignore: cast_nullable_to_non_nullable
                  as RecordingQuality?,
        isEmbedded: null == isEmbedded
            ? _value.isEmbedded
            : isEmbedded // ignore: cast_nullable_to_non_nullable
                  as bool,
        textPosition: freezed == textPosition
            ? _value.textPosition
            : textPosition // ignore: cast_nullable_to_non_nullable
                  as int?,
        displayName: freezed == displayName
            ? _value.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$VoiceRecordingImpl implements _VoiceRecording {
  const _$VoiceRecordingImpl({
    required this.id,
    required this.filePath,
    required this.duration,
    required this.createdAt,
    final List<double>? waveformData,
    this.quality,
    this.isEmbedded = false,
    this.textPosition,
    this.displayName,
  }) : _waveformData = waveformData;

  factory _$VoiceRecordingImpl.fromJson(Map<String, dynamic> json) =>
      _$$VoiceRecordingImplFromJson(json);

  /// Unique identifier for the recording
  @override
  final String id;

  /// File path or URL to the audio file
  @override
  final String filePath;

  /// Duration of the recording in seconds
  @override
  final int duration;

  /// Recording timestamp
  @override
  final DateTime createdAt;

  /// Waveform data for visualization (optional)
  final List<double>? _waveformData;

  /// Waveform data for visualization (optional)
  @override
  List<double>? get waveformData {
    final value = _waveformData;
    if (value == null) return null;
    if (_waveformData is EqualUnmodifiableListView) return _waveformData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Recording quality/bitrate info
  @override
  final RecordingQuality? quality;

  /// Whether this recording is embedded in text
  @override
  @JsonKey()
  final bool isEmbedded;

  /// Position in text where this recording is embedded
  @override
  final int? textPosition;

  /// Display name for the recording
  @override
  final String? displayName;

  @override
  String toString() {
    return 'VoiceRecording(id: $id, filePath: $filePath, duration: $duration, createdAt: $createdAt, waveformData: $waveformData, quality: $quality, isEmbedded: $isEmbedded, textPosition: $textPosition, displayName: $displayName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VoiceRecordingImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.filePath, filePath) ||
                other.filePath == filePath) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(
              other._waveformData,
              _waveformData,
            ) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.isEmbedded, isEmbedded) ||
                other.isEmbedded == isEmbedded) &&
            (identical(other.textPosition, textPosition) ||
                other.textPosition == textPosition) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    filePath,
    duration,
    createdAt,
    const DeepCollectionEquality().hash(_waveformData),
    quality,
    isEmbedded,
    textPosition,
    displayName,
  );

  /// Create a copy of VoiceRecording
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VoiceRecordingImplCopyWith<_$VoiceRecordingImpl> get copyWith =>
      __$$VoiceRecordingImplCopyWithImpl<_$VoiceRecordingImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$VoiceRecordingImplToJson(this);
  }
}

abstract class _VoiceRecording implements VoiceRecording {
  const factory _VoiceRecording({
    required final String id,
    required final String filePath,
    required final int duration,
    required final DateTime createdAt,
    final List<double>? waveformData,
    final RecordingQuality? quality,
    final bool isEmbedded,
    final int? textPosition,
    final String? displayName,
  }) = _$VoiceRecordingImpl;

  factory _VoiceRecording.fromJson(Map<String, dynamic> json) =
      _$VoiceRecordingImpl.fromJson;

  /// Unique identifier for the recording
  @override
  String get id;

  /// File path or URL to the audio file
  @override
  String get filePath;

  /// Duration of the recording in seconds
  @override
  int get duration;

  /// Recording timestamp
  @override
  DateTime get createdAt;

  /// Waveform data for visualization (optional)
  @override
  List<double>? get waveformData;

  /// Recording quality/bitrate info
  @override
  RecordingQuality? get quality;

  /// Whether this recording is embedded in text
  @override
  bool get isEmbedded;

  /// Position in text where this recording is embedded
  @override
  int? get textPosition;

  /// Display name for the recording
  @override
  String? get displayName;

  /// Create a copy of VoiceRecording
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VoiceRecordingImplCopyWith<_$VoiceRecordingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WritingPrompt _$WritingPromptFromJson(Map<String, dynamic> json) {
  return _WritingPrompt.fromJson(json);
}

/// @nodoc
mixin _$WritingPrompt {
  String get id => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  PromptCategory get category => throw _privateConstructorUsedError;
  String? get subtitle => throw _privateConstructorUsedError;
  String? get inspiration => throw _privateConstructorUsedError;

  /// Serializes this WritingPrompt to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WritingPrompt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WritingPromptCopyWith<WritingPrompt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WritingPromptCopyWith<$Res> {
  factory $WritingPromptCopyWith(
    WritingPrompt value,
    $Res Function(WritingPrompt) then,
  ) = _$WritingPromptCopyWithImpl<$Res, WritingPrompt>;
  @useResult
  $Res call({
    String id,
    String text,
    PromptCategory category,
    String? subtitle,
    String? inspiration,
  });
}

/// @nodoc
class _$WritingPromptCopyWithImpl<$Res, $Val extends WritingPrompt>
    implements $WritingPromptCopyWith<$Res> {
  _$WritingPromptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WritingPrompt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? category = null,
    Object? subtitle = freezed,
    Object? inspiration = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            text: null == text
                ? _value.text
                : text // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as PromptCategory,
            subtitle: freezed == subtitle
                ? _value.subtitle
                : subtitle // ignore: cast_nullable_to_non_nullable
                      as String?,
            inspiration: freezed == inspiration
                ? _value.inspiration
                : inspiration // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WritingPromptImplCopyWith<$Res>
    implements $WritingPromptCopyWith<$Res> {
  factory _$$WritingPromptImplCopyWith(
    _$WritingPromptImpl value,
    $Res Function(_$WritingPromptImpl) then,
  ) = __$$WritingPromptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String text,
    PromptCategory category,
    String? subtitle,
    String? inspiration,
  });
}

/// @nodoc
class __$$WritingPromptImplCopyWithImpl<$Res>
    extends _$WritingPromptCopyWithImpl<$Res, _$WritingPromptImpl>
    implements _$$WritingPromptImplCopyWith<$Res> {
  __$$WritingPromptImplCopyWithImpl(
    _$WritingPromptImpl _value,
    $Res Function(_$WritingPromptImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WritingPrompt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? category = null,
    Object? subtitle = freezed,
    Object? inspiration = freezed,
  }) {
    return _then(
      _$WritingPromptImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        text: null == text
            ? _value.text
            : text // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as PromptCategory,
        subtitle: freezed == subtitle
            ? _value.subtitle
            : subtitle // ignore: cast_nullable_to_non_nullable
                  as String?,
        inspiration: freezed == inspiration
            ? _value.inspiration
            : inspiration // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$WritingPromptImpl implements _WritingPrompt {
  const _$WritingPromptImpl({
    required this.id,
    required this.text,
    required this.category,
    this.subtitle,
    this.inspiration,
  });

  factory _$WritingPromptImpl.fromJson(Map<String, dynamic> json) =>
      _$$WritingPromptImplFromJson(json);

  @override
  final String id;
  @override
  final String text;
  @override
  final PromptCategory category;
  @override
  final String? subtitle;
  @override
  final String? inspiration;

  @override
  String toString() {
    return 'WritingPrompt(id: $id, text: $text, category: $category, subtitle: $subtitle, inspiration: $inspiration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WritingPromptImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.subtitle, subtitle) ||
                other.subtitle == subtitle) &&
            (identical(other.inspiration, inspiration) ||
                other.inspiration == inspiration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, text, category, subtitle, inspiration);

  /// Create a copy of WritingPrompt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WritingPromptImplCopyWith<_$WritingPromptImpl> get copyWith =>
      __$$WritingPromptImplCopyWithImpl<_$WritingPromptImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WritingPromptImplToJson(this);
  }
}

abstract class _WritingPrompt implements WritingPrompt {
  const factory _WritingPrompt({
    required final String id,
    required final String text,
    required final PromptCategory category,
    final String? subtitle,
    final String? inspiration,
  }) = _$WritingPromptImpl;

  factory _WritingPrompt.fromJson(Map<String, dynamic> json) =
      _$WritingPromptImpl.fromJson;

  @override
  String get id;
  @override
  String get text;
  @override
  PromptCategory get category;
  @override
  String? get subtitle;
  @override
  String? get inspiration;

  /// Create a copy of WritingPrompt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WritingPromptImplCopyWith<_$WritingPromptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
