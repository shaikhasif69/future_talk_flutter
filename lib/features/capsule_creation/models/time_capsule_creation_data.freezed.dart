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
  DateTime? get creationStartedAt => throw _privateConstructorUsedError;

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
  });
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
          )
          as $Val,
    );
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
  });
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

  @override
  String toString() {
    return 'TimeCapsuleCreationData(selectedPurpose: $selectedPurpose, currentStep: $currentStep, showContinueButton: $showContinueButton, selectedQuickStart: $selectedQuickStart, isLoading: $isLoading, creationStartedAt: $creationStartedAt)';
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
                other.creationStartedAt == creationStartedAt));
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
  DateTime? get creationStartedAt;

  /// Create a copy of TimeCapsuleCreationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TimeCapsuleCreationDataImplCopyWith<_$TimeCapsuleCreationDataImpl>
  get copyWith => throw _privateConstructorUsedError;
}
