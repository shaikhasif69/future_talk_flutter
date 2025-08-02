// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_capsule_creation_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TimeCapsuleCreationData _$TimeCapsuleCreationDataFromJson(
  Map<String, dynamic> json,
) {
  return _TimeCapsuleCreationData.fromJson(json);
}

/// @nodoc
mixin _$TimeCapsuleCreationData {
  /// Currently selected purpose for the time capsule
  TimeCapsulePurpose? get selectedPurpose => throw _privateConstructorUsedError;

  /// Current step in the creation flow (1-4)
  int get currentStep => throw _privateConstructorUsedError;

  /// Whether the continue button should be shown
  bool get showContinueButton => throw _privateConstructorUsedError;

  /// Selected quick start type (if any)
  QuickStartType? get selectedQuickStart => throw _privateConstructorUsedError;

  /// Loading state for navigation
  bool get isLoading => throw _privateConstructorUsedError;

  /// Creation timestamp for analytics
  DateTime? get creationStartedAt =>
      throw _privateConstructorUsedError; // ==================== TIME SELECTION PROPERTIES ====================
  /// Selected time option for delivery (1 hour, 1 day, etc.)
  TimeOption? get selectedTimeOption => throw _privateConstructorUsedError;

  /// Selected special occasion for delivery
  SpecialOccasion? get selectedOccasion => throw _privateConstructorUsedError;

  /// Custom date and time for delivery
  CustomDateTime? get customDateTime => throw _privateConstructorUsedError;

  /// Current visual metaphor for time selection
  String get timeMetaphor => throw _privateConstructorUsedError;

  /// Current time display text
  String get timeDisplay => throw _privateConstructorUsedError;

  /// Current time description
  String get timeDescription => throw _privateConstructorUsedError;

  /// Current growth stage text
  String get growthStage => throw _privateConstructorUsedError;

  /// Serializes this TimeCapsuleCreationData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TimeCapsuleCreationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TimeCapsuleCreationDataCopyWith<TimeCapsuleCreationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeCapsuleCreationDataCopyWith<$Res> {
  factory $TimeCapsuleCreationDataCopyWith(
    TimeCapsuleCreationData value,
    $Res Function(TimeCapsuleCreationData) then,
  ) = _$TimeCapsuleCreationDataCopyWithImpl<$Res, TimeCapsuleCreationData>;
  @useResult
  $Res call({
    TimeCapsulePurpose? selectedPurpose,
    int currentStep,
    bool showContinueButton,
    QuickStartType? selectedQuickStart,
    bool isLoading,
    DateTime? creationStartedAt,
    TimeOption? selectedTimeOption,
    SpecialOccasion? selectedOccasion,
    CustomDateTime? customDateTime,
    String timeMetaphor,
    String timeDisplay,
    String timeDescription,
    String growthStage,
  });

  $CustomDateTimeCopyWith<$Res>? get customDateTime;
}

/// @nodoc
class _$TimeCapsuleCreationDataCopyWithImpl<
  $Res,
  $Val extends TimeCapsuleCreationData
>
    implements $TimeCapsuleCreationDataCopyWith<$Res> {
  _$TimeCapsuleCreationDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TimeCapsuleCreationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedPurpose = freezed,
    Object? currentStep = null,
    Object? showContinueButton = null,
    Object? selectedQuickStart = freezed,
    Object? isLoading = null,
    Object? creationStartedAt = freezed,
    Object? selectedTimeOption = freezed,
    Object? selectedOccasion = freezed,
    Object? customDateTime = freezed,
    Object? timeMetaphor = null,
    Object? timeDisplay = null,
    Object? timeDescription = null,
    Object? growthStage = null,
  }) {
    return _then(
      _value.copyWith(
            selectedPurpose: freezed == selectedPurpose
                ? _value.selectedPurpose
                : selectedPurpose // ignore: cast_nullable_to_non_nullable
                      as TimeCapsulePurpose?,
            currentStep: null == currentStep
                ? _value.currentStep
                : currentStep // ignore: cast_nullable_to_non_nullable
                      as int,
            showContinueButton: null == showContinueButton
                ? _value.showContinueButton
                : showContinueButton // ignore: cast_nullable_to_non_nullable
                      as bool,
            selectedQuickStart: freezed == selectedQuickStart
                ? _value.selectedQuickStart
                : selectedQuickStart // ignore: cast_nullable_to_non_nullable
                      as QuickStartType?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            creationStartedAt: freezed == creationStartedAt
                ? _value.creationStartedAt
                : creationStartedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            selectedTimeOption: freezed == selectedTimeOption
                ? _value.selectedTimeOption
                : selectedTimeOption // ignore: cast_nullable_to_non_nullable
                      as TimeOption?,
            selectedOccasion: freezed == selectedOccasion
                ? _value.selectedOccasion
                : selectedOccasion // ignore: cast_nullable_to_non_nullable
                      as SpecialOccasion?,
            customDateTime: freezed == customDateTime
                ? _value.customDateTime
                : customDateTime // ignore: cast_nullable_to_non_nullable
                      as CustomDateTime?,
            timeMetaphor: null == timeMetaphor
                ? _value.timeMetaphor
                : timeMetaphor // ignore: cast_nullable_to_non_nullable
                      as String,
            timeDisplay: null == timeDisplay
                ? _value.timeDisplay
                : timeDisplay // ignore: cast_nullable_to_non_nullable
                      as String,
            timeDescription: null == timeDescription
                ? _value.timeDescription
                : timeDescription // ignore: cast_nullable_to_non_nullable
                      as String,
            growthStage: null == growthStage
                ? _value.growthStage
                : growthStage // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of TimeCapsuleCreationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CustomDateTimeCopyWith<$Res>? get customDateTime {
    if (_value.customDateTime == null) {
      return null;
    }

    return $CustomDateTimeCopyWith<$Res>(_value.customDateTime!, (value) {
      return _then(_value.copyWith(customDateTime: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TimeCapsuleCreationDataImplCopyWith<$Res>
    implements $TimeCapsuleCreationDataCopyWith<$Res> {
  factory _$$TimeCapsuleCreationDataImplCopyWith(
    _$TimeCapsuleCreationDataImpl value,
    $Res Function(_$TimeCapsuleCreationDataImpl) then,
  ) = __$$TimeCapsuleCreationDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    TimeCapsulePurpose? selectedPurpose,
    int currentStep,
    bool showContinueButton,
    QuickStartType? selectedQuickStart,
    bool isLoading,
    DateTime? creationStartedAt,
    TimeOption? selectedTimeOption,
    SpecialOccasion? selectedOccasion,
    CustomDateTime? customDateTime,
    String timeMetaphor,
    String timeDisplay,
    String timeDescription,
    String growthStage,
  });

  @override
  $CustomDateTimeCopyWith<$Res>? get customDateTime;
}

/// @nodoc
class __$$TimeCapsuleCreationDataImplCopyWithImpl<$Res>
    extends
        _$TimeCapsuleCreationDataCopyWithImpl<
          $Res,
          _$TimeCapsuleCreationDataImpl
        >
    implements _$$TimeCapsuleCreationDataImplCopyWith<$Res> {
  __$$TimeCapsuleCreationDataImplCopyWithImpl(
    _$TimeCapsuleCreationDataImpl _value,
    $Res Function(_$TimeCapsuleCreationDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TimeCapsuleCreationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedPurpose = freezed,
    Object? currentStep = null,
    Object? showContinueButton = null,
    Object? selectedQuickStart = freezed,
    Object? isLoading = null,
    Object? creationStartedAt = freezed,
    Object? selectedTimeOption = freezed,
    Object? selectedOccasion = freezed,
    Object? customDateTime = freezed,
    Object? timeMetaphor = null,
    Object? timeDisplay = null,
    Object? timeDescription = null,
    Object? growthStage = null,
  }) {
    return _then(
      _$TimeCapsuleCreationDataImpl(
        selectedPurpose: freezed == selectedPurpose
            ? _value.selectedPurpose
            : selectedPurpose // ignore: cast_nullable_to_non_nullable
                  as TimeCapsulePurpose?,
        currentStep: null == currentStep
            ? _value.currentStep
            : currentStep // ignore: cast_nullable_to_non_nullable
                  as int,
        showContinueButton: null == showContinueButton
            ? _value.showContinueButton
            : showContinueButton // ignore: cast_nullable_to_non_nullable
                  as bool,
        selectedQuickStart: freezed == selectedQuickStart
            ? _value.selectedQuickStart
            : selectedQuickStart // ignore: cast_nullable_to_non_nullable
                  as QuickStartType?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        creationStartedAt: freezed == creationStartedAt
            ? _value.creationStartedAt
            : creationStartedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        selectedTimeOption: freezed == selectedTimeOption
            ? _value.selectedTimeOption
            : selectedTimeOption // ignore: cast_nullable_to_non_nullable
                  as TimeOption?,
        selectedOccasion: freezed == selectedOccasion
            ? _value.selectedOccasion
            : selectedOccasion // ignore: cast_nullable_to_non_nullable
                  as SpecialOccasion?,
        customDateTime: freezed == customDateTime
            ? _value.customDateTime
            : customDateTime // ignore: cast_nullable_to_non_nullable
                  as CustomDateTime?,
        timeMetaphor: null == timeMetaphor
            ? _value.timeMetaphor
            : timeMetaphor // ignore: cast_nullable_to_non_nullable
                  as String,
        timeDisplay: null == timeDisplay
            ? _value.timeDisplay
            : timeDisplay // ignore: cast_nullable_to_non_nullable
                  as String,
        timeDescription: null == timeDescription
            ? _value.timeDescription
            : timeDescription // ignore: cast_nullable_to_non_nullable
                  as String,
        growthStage: null == growthStage
            ? _value.growthStage
            : growthStage // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeCapsuleCreationDataImpl implements _TimeCapsuleCreationData {
  const _$TimeCapsuleCreationDataImpl({
    this.selectedPurpose,
    this.currentStep = 1,
    this.showContinueButton = false,
    this.selectedQuickStart,
    this.isLoading = false,
    this.creationStartedAt,
    this.selectedTimeOption,
    this.selectedOccasion,
    this.customDateTime,
    this.timeMetaphor = '🌰',
    this.timeDisplay = 'Select Time',
    this.timeDescription = 'Choose when you\'d like to receive this message',
    this.growthStage = 'Ready to Plant',
  });

  factory _$TimeCapsuleCreationDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeCapsuleCreationDataImplFromJson(json);

  /// Currently selected purpose for the time capsule
  @override
  final TimeCapsulePurpose? selectedPurpose;

  /// Current step in the creation flow (1-4)
  @override
  @JsonKey()
  final int currentStep;

  /// Whether the continue button should be shown
  @override
  @JsonKey()
  final bool showContinueButton;

  /// Selected quick start type (if any)
  @override
  final QuickStartType? selectedQuickStart;

  /// Loading state for navigation
  @override
  @JsonKey()
  final bool isLoading;

  /// Creation timestamp for analytics
  @override
  final DateTime? creationStartedAt;
  // ==================== TIME SELECTION PROPERTIES ====================
  /// Selected time option for delivery (1 hour, 1 day, etc.)
  @override
  final TimeOption? selectedTimeOption;

  /// Selected special occasion for delivery
  @override
  final SpecialOccasion? selectedOccasion;

  /// Custom date and time for delivery
  @override
  final CustomDateTime? customDateTime;

  /// Current visual metaphor for time selection
  @override
  @JsonKey()
  final String timeMetaphor;

  /// Current time display text
  @override
  @JsonKey()
  final String timeDisplay;

  /// Current time description
  @override
  @JsonKey()
  final String timeDescription;

  /// Current growth stage text
  @override
  @JsonKey()
  final String growthStage;

  @override
  String toString() {
    return 'TimeCapsuleCreationData(selectedPurpose: $selectedPurpose, currentStep: $currentStep, showContinueButton: $showContinueButton, selectedQuickStart: $selectedQuickStart, isLoading: $isLoading, creationStartedAt: $creationStartedAt, selectedTimeOption: $selectedTimeOption, selectedOccasion: $selectedOccasion, customDateTime: $customDateTime, timeMetaphor: $timeMetaphor, timeDisplay: $timeDisplay, timeDescription: $timeDescription, growthStage: $growthStage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeCapsuleCreationDataImpl &&
            (identical(other.selectedPurpose, selectedPurpose) ||
                other.selectedPurpose == selectedPurpose) &&
            (identical(other.currentStep, currentStep) ||
                other.currentStep == currentStep) &&
            (identical(other.showContinueButton, showContinueButton) ||
                other.showContinueButton == showContinueButton) &&
            (identical(other.selectedQuickStart, selectedQuickStart) ||
                other.selectedQuickStart == selectedQuickStart) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.creationStartedAt, creationStartedAt) ||
                other.creationStartedAt == creationStartedAt) &&
            (identical(other.selectedTimeOption, selectedTimeOption) ||
                other.selectedTimeOption == selectedTimeOption) &&
            (identical(other.selectedOccasion, selectedOccasion) ||
                other.selectedOccasion == selectedOccasion) &&
            (identical(other.customDateTime, customDateTime) ||
                other.customDateTime == customDateTime) &&
            (identical(other.timeMetaphor, timeMetaphor) ||
                other.timeMetaphor == timeMetaphor) &&
            (identical(other.timeDisplay, timeDisplay) ||
                other.timeDisplay == timeDisplay) &&
            (identical(other.timeDescription, timeDescription) ||
                other.timeDescription == timeDescription) &&
            (identical(other.growthStage, growthStage) ||
                other.growthStage == growthStage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    selectedPurpose,
    currentStep,
    showContinueButton,
    selectedQuickStart,
    isLoading,
    creationStartedAt,
    selectedTimeOption,
    selectedOccasion,
    customDateTime,
    timeMetaphor,
    timeDisplay,
    timeDescription,
    growthStage,
  );

  /// Create a copy of TimeCapsuleCreationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeCapsuleCreationDataImplCopyWith<_$TimeCapsuleCreationDataImpl>
  get copyWith =>
      __$$TimeCapsuleCreationDataImplCopyWithImpl<
        _$TimeCapsuleCreationDataImpl
      >(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeCapsuleCreationDataImplToJson(this);
  }
}

abstract class _TimeCapsuleCreationData implements TimeCapsuleCreationData {
  const factory _TimeCapsuleCreationData({
    final TimeCapsulePurpose? selectedPurpose,
    final int currentStep,
    final bool showContinueButton,
    final QuickStartType? selectedQuickStart,
    final bool isLoading,
    final DateTime? creationStartedAt,
    final TimeOption? selectedTimeOption,
    final SpecialOccasion? selectedOccasion,
    final CustomDateTime? customDateTime,
    final String timeMetaphor,
    final String timeDisplay,
    final String timeDescription,
    final String growthStage,
  }) = _$TimeCapsuleCreationDataImpl;

  factory _TimeCapsuleCreationData.fromJson(Map<String, dynamic> json) =
      _$TimeCapsuleCreationDataImpl.fromJson;

  /// Currently selected purpose for the time capsule
  @override
  TimeCapsulePurpose? get selectedPurpose;

  /// Current step in the creation flow (1-4)
  @override
  int get currentStep;

  /// Whether the continue button should be shown
  @override
  bool get showContinueButton;

  /// Selected quick start type (if any)
  @override
  QuickStartType? get selectedQuickStart;

  /// Loading state for navigation
  @override
  bool get isLoading;

  /// Creation timestamp for analytics
  @override
  DateTime? get creationStartedAt; // ==================== TIME SELECTION PROPERTIES ====================
  /// Selected time option for delivery (1 hour, 1 day, etc.)
  @override
  TimeOption? get selectedTimeOption;

  /// Selected special occasion for delivery
  @override
  SpecialOccasion? get selectedOccasion;

  /// Custom date and time for delivery
  @override
  CustomDateTime? get customDateTime;

  /// Current visual metaphor for time selection
  @override
  String get timeMetaphor;

  /// Current time display text
  @override
  String get timeDisplay;

  /// Current time description
  @override
  String get timeDescription;

  /// Current growth stage text
  @override
  String get growthStage;

  /// Create a copy of TimeCapsuleCreationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeCapsuleCreationDataImplCopyWith<_$TimeCapsuleCreationDataImpl>
  get copyWith => throw _privateConstructorUsedError;
}

CustomDateTime _$CustomDateTimeFromJson(Map<String, dynamic> json) {
  return _CustomDateTime.fromJson(json);
}

/// @nodoc
mixin _$CustomDateTime {
  DateTime get dateTime => throw _privateConstructorUsedError;
  String get previewText => throw _privateConstructorUsedError;

  /// Serializes this CustomDateTime to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CustomDateTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomDateTimeCopyWith<CustomDateTime> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomDateTimeCopyWith<$Res> {
  factory $CustomDateTimeCopyWith(
    CustomDateTime value,
    $Res Function(CustomDateTime) then,
  ) = _$CustomDateTimeCopyWithImpl<$Res, CustomDateTime>;
  @useResult
  $Res call({DateTime dateTime, String previewText});
}

/// @nodoc
class _$CustomDateTimeCopyWithImpl<$Res, $Val extends CustomDateTime>
    implements $CustomDateTimeCopyWith<$Res> {
  _$CustomDateTimeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomDateTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dateTime = null, Object? previewText = null}) {
    return _then(
      _value.copyWith(
            dateTime: null == dateTime
                ? _value.dateTime
                : dateTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            previewText: null == previewText
                ? _value.previewText
                : previewText // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomDateTimeImplCopyWith<$Res>
    implements $CustomDateTimeCopyWith<$Res> {
  factory _$$CustomDateTimeImplCopyWith(
    _$CustomDateTimeImpl value,
    $Res Function(_$CustomDateTimeImpl) then,
  ) = __$$CustomDateTimeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime dateTime, String previewText});
}

/// @nodoc
class __$$CustomDateTimeImplCopyWithImpl<$Res>
    extends _$CustomDateTimeCopyWithImpl<$Res, _$CustomDateTimeImpl>
    implements _$$CustomDateTimeImplCopyWith<$Res> {
  __$$CustomDateTimeImplCopyWithImpl(
    _$CustomDateTimeImpl _value,
    $Res Function(_$CustomDateTimeImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomDateTime
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dateTime = null, Object? previewText = null}) {
    return _then(
      _$CustomDateTimeImpl(
        dateTime: null == dateTime
            ? _value.dateTime
            : dateTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        previewText: null == previewText
            ? _value.previewText
            : previewText // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CustomDateTimeImpl implements _CustomDateTime {
  const _$CustomDateTimeImpl({
    required this.dateTime,
    required this.previewText,
  });

  factory _$CustomDateTimeImpl.fromJson(Map<String, dynamic> json) =>
      _$$CustomDateTimeImplFromJson(json);

  @override
  final DateTime dateTime;
  @override
  final String previewText;

  @override
  String toString() {
    return 'CustomDateTime(dateTime: $dateTime, previewText: $previewText)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomDateTimeImpl &&
            (identical(other.dateTime, dateTime) ||
                other.dateTime == dateTime) &&
            (identical(other.previewText, previewText) ||
                other.previewText == previewText));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, dateTime, previewText);

  /// Create a copy of CustomDateTime
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomDateTimeImplCopyWith<_$CustomDateTimeImpl> get copyWith =>
      __$$CustomDateTimeImplCopyWithImpl<_$CustomDateTimeImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CustomDateTimeImplToJson(this);
  }
}

abstract class _CustomDateTime implements CustomDateTime {
  const factory _CustomDateTime({
    required final DateTime dateTime,
    required final String previewText,
  }) = _$CustomDateTimeImpl;

  factory _CustomDateTime.fromJson(Map<String, dynamic> json) =
      _$CustomDateTimeImpl.fromJson;

  @override
  DateTime get dateTime;
  @override
  String get previewText;

  /// Create a copy of CustomDateTime
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomDateTimeImplCopyWith<_$CustomDateTimeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
