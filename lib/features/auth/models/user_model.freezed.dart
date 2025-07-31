// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  /// Unique user identifier
  String get id => throw _privateConstructorUsedError;

  /// User's email address
  String get email => throw _privateConstructorUsedError;

  /// User's display name
  String get username => throw _privateConstructorUsedError;

  /// User's first name (optional)
  String? get firstName => throw _privateConstructorUsedError;

  /// User's last name (optional)
  String? get lastName => throw _privateConstructorUsedError;

  /// User's profile picture URL (optional)
  String? get profilePictureUrl => throw _privateConstructorUsedError;

  /// User's social battery level (0-100)
  int get socialBattery => throw _privateConstructorUsedError;

  /// Whether user has completed onboarding
  bool get hasCompletedOnboarding => throw _privateConstructorUsedError;

  /// User's preferred communication style
  CommunicationStyle get communicationStyle =>
      throw _privateConstructorUsedError;

  /// User's availability status
  AvailabilityStatus get availability => throw _privateConstructorUsedError;

  /// When the user account was created
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// When the user account was last updated
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// User's timezone
  String? get timezone => throw _privateConstructorUsedError;

  /// User's preferred language
  String get preferredLanguage => throw _privateConstructorUsedError;

  /// Whether user has enabled push notifications
  bool get pushNotificationsEnabled => throw _privateConstructorUsedError;

  /// Whether user wants to be discoverable by friends
  bool get isDiscoverable => throw _privateConstructorUsedError;

  /// User's bio/about section
  String? get bio => throw _privateConstructorUsedError;

  /// User's current mood (optional)
  String? get currentMood => throw _privateConstructorUsedError;

  /// Tags that describe user's interests
  List<String> get interestTags => throw _privateConstructorUsedError;

  /// Serializes this User to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res, User>;
  @useResult
  $Res call({
    String id,
    String email,
    String username,
    String? firstName,
    String? lastName,
    String? profilePictureUrl,
    int socialBattery,
    bool hasCompletedOnboarding,
    CommunicationStyle communicationStyle,
    AvailabilityStatus availability,
    DateTime createdAt,
    DateTime updatedAt,
    String? timezone,
    String preferredLanguage,
    bool pushNotificationsEnabled,
    bool isDiscoverable,
    String? bio,
    String? currentMood,
    List<String> interestTags,
  });
}

/// @nodoc
class _$UserCopyWithImpl<$Res, $Val extends User>
    implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? profilePictureUrl = freezed,
    Object? socialBattery = null,
    Object? hasCompletedOnboarding = null,
    Object? communicationStyle = null,
    Object? availability = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? timezone = freezed,
    Object? preferredLanguage = null,
    Object? pushNotificationsEnabled = null,
    Object? isDiscoverable = null,
    Object? bio = freezed,
    Object? currentMood = freezed,
    Object? interestTags = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: freezed == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastName: freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String?,
            profilePictureUrl: freezed == profilePictureUrl
                ? _value.profilePictureUrl
                : profilePictureUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            socialBattery: null == socialBattery
                ? _value.socialBattery
                : socialBattery // ignore: cast_nullable_to_non_nullable
                      as int,
            hasCompletedOnboarding: null == hasCompletedOnboarding
                ? _value.hasCompletedOnboarding
                : hasCompletedOnboarding // ignore: cast_nullable_to_non_nullable
                      as bool,
            communicationStyle: null == communicationStyle
                ? _value.communicationStyle
                : communicationStyle // ignore: cast_nullable_to_non_nullable
                      as CommunicationStyle,
            availability: null == availability
                ? _value.availability
                : availability // ignore: cast_nullable_to_non_nullable
                      as AvailabilityStatus,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            timezone: freezed == timezone
                ? _value.timezone
                : timezone // ignore: cast_nullable_to_non_nullable
                      as String?,
            preferredLanguage: null == preferredLanguage
                ? _value.preferredLanguage
                : preferredLanguage // ignore: cast_nullable_to_non_nullable
                      as String,
            pushNotificationsEnabled: null == pushNotificationsEnabled
                ? _value.pushNotificationsEnabled
                : pushNotificationsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            isDiscoverable: null == isDiscoverable
                ? _value.isDiscoverable
                : isDiscoverable // ignore: cast_nullable_to_non_nullable
                      as bool,
            bio: freezed == bio
                ? _value.bio
                : bio // ignore: cast_nullable_to_non_nullable
                      as String?,
            currentMood: freezed == currentMood
                ? _value.currentMood
                : currentMood // ignore: cast_nullable_to_non_nullable
                      as String?,
            interestTags: null == interestTags
                ? _value.interestTags
                : interestTags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserImplCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$UserImplCopyWith(
    _$UserImpl value,
    $Res Function(_$UserImpl) then,
  ) = __$$UserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    String username,
    String? firstName,
    String? lastName,
    String? profilePictureUrl,
    int socialBattery,
    bool hasCompletedOnboarding,
    CommunicationStyle communicationStyle,
    AvailabilityStatus availability,
    DateTime createdAt,
    DateTime updatedAt,
    String? timezone,
    String preferredLanguage,
    bool pushNotificationsEnabled,
    bool isDiscoverable,
    String? bio,
    String? currentMood,
    List<String> interestTags,
  });
}

/// @nodoc
class __$$UserImplCopyWithImpl<$Res>
    extends _$UserCopyWithImpl<$Res, _$UserImpl>
    implements _$$UserImplCopyWith<$Res> {
  __$$UserImplCopyWithImpl(_$UserImpl _value, $Res Function(_$UserImpl) _then)
    : super(_value, _then);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? username = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? profilePictureUrl = freezed,
    Object? socialBattery = null,
    Object? hasCompletedOnboarding = null,
    Object? communicationStyle = null,
    Object? availability = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? timezone = freezed,
    Object? preferredLanguage = null,
    Object? pushNotificationsEnabled = null,
    Object? isDiscoverable = null,
    Object? bio = freezed,
    Object? currentMood = freezed,
    Object? interestTags = null,
  }) {
    return _then(
      _$UserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: freezed == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastName: freezed == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String?,
        profilePictureUrl: freezed == profilePictureUrl
            ? _value.profilePictureUrl
            : profilePictureUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        socialBattery: null == socialBattery
            ? _value.socialBattery
            : socialBattery // ignore: cast_nullable_to_non_nullable
                  as int,
        hasCompletedOnboarding: null == hasCompletedOnboarding
            ? _value.hasCompletedOnboarding
            : hasCompletedOnboarding // ignore: cast_nullable_to_non_nullable
                  as bool,
        communicationStyle: null == communicationStyle
            ? _value.communicationStyle
            : communicationStyle // ignore: cast_nullable_to_non_nullable
                  as CommunicationStyle,
        availability: null == availability
            ? _value.availability
            : availability // ignore: cast_nullable_to_non_nullable
                  as AvailabilityStatus,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        timezone: freezed == timezone
            ? _value.timezone
            : timezone // ignore: cast_nullable_to_non_nullable
                  as String?,
        preferredLanguage: null == preferredLanguage
            ? _value.preferredLanguage
            : preferredLanguage // ignore: cast_nullable_to_non_nullable
                  as String,
        pushNotificationsEnabled: null == pushNotificationsEnabled
            ? _value.pushNotificationsEnabled
            : pushNotificationsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        isDiscoverable: null == isDiscoverable
            ? _value.isDiscoverable
            : isDiscoverable // ignore: cast_nullable_to_non_nullable
                  as bool,
        bio: freezed == bio
            ? _value.bio
            : bio // ignore: cast_nullable_to_non_nullable
                  as String?,
        currentMood: freezed == currentMood
            ? _value.currentMood
            : currentMood // ignore: cast_nullable_to_non_nullable
                  as String?,
        interestTags: null == interestTags
            ? _value._interestTags
            : interestTags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserImpl extends _User {
  const _$UserImpl({
    required this.id,
    required this.email,
    required this.username,
    this.firstName,
    this.lastName,
    this.profilePictureUrl,
    this.socialBattery = 75,
    this.hasCompletedOnboarding = false,
    this.communicationStyle = CommunicationStyle.balanced,
    this.availability = AvailabilityStatus.available,
    required this.createdAt,
    required this.updatedAt,
    this.timezone,
    this.preferredLanguage = 'en',
    this.pushNotificationsEnabled = true,
    this.isDiscoverable = true,
    this.bio,
    this.currentMood,
    final List<String> interestTags = const [],
  }) : _interestTags = interestTags,
       super._();

  factory _$UserImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserImplFromJson(json);

  /// Unique user identifier
  @override
  final String id;

  /// User's email address
  @override
  final String email;

  /// User's display name
  @override
  final String username;

  /// User's first name (optional)
  @override
  final String? firstName;

  /// User's last name (optional)
  @override
  final String? lastName;

  /// User's profile picture URL (optional)
  @override
  final String? profilePictureUrl;

  /// User's social battery level (0-100)
  @override
  @JsonKey()
  final int socialBattery;

  /// Whether user has completed onboarding
  @override
  @JsonKey()
  final bool hasCompletedOnboarding;

  /// User's preferred communication style
  @override
  @JsonKey()
  final CommunicationStyle communicationStyle;

  /// User's availability status
  @override
  @JsonKey()
  final AvailabilityStatus availability;

  /// When the user account was created
  @override
  final DateTime createdAt;

  /// When the user account was last updated
  @override
  final DateTime updatedAt;

  /// User's timezone
  @override
  final String? timezone;

  /// User's preferred language
  @override
  @JsonKey()
  final String preferredLanguage;

  /// Whether user has enabled push notifications
  @override
  @JsonKey()
  final bool pushNotificationsEnabled;

  /// Whether user wants to be discoverable by friends
  @override
  @JsonKey()
  final bool isDiscoverable;

  /// User's bio/about section
  @override
  final String? bio;

  /// User's current mood (optional)
  @override
  final String? currentMood;

  /// Tags that describe user's interests
  final List<String> _interestTags;

  /// Tags that describe user's interests
  @override
  @JsonKey()
  List<String> get interestTags {
    if (_interestTags is EqualUnmodifiableListView) return _interestTags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interestTags);
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, username: $username, firstName: $firstName, lastName: $lastName, profilePictureUrl: $profilePictureUrl, socialBattery: $socialBattery, hasCompletedOnboarding: $hasCompletedOnboarding, communicationStyle: $communicationStyle, availability: $availability, createdAt: $createdAt, updatedAt: $updatedAt, timezone: $timezone, preferredLanguage: $preferredLanguage, pushNotificationsEnabled: $pushNotificationsEnabled, isDiscoverable: $isDiscoverable, bio: $bio, currentMood: $currentMood, interestTags: $interestTags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.profilePictureUrl, profilePictureUrl) ||
                other.profilePictureUrl == profilePictureUrl) &&
            (identical(other.socialBattery, socialBattery) ||
                other.socialBattery == socialBattery) &&
            (identical(other.hasCompletedOnboarding, hasCompletedOnboarding) ||
                other.hasCompletedOnboarding == hasCompletedOnboarding) &&
            (identical(other.communicationStyle, communicationStyle) ||
                other.communicationStyle == communicationStyle) &&
            (identical(other.availability, availability) ||
                other.availability == availability) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.preferredLanguage, preferredLanguage) ||
                other.preferredLanguage == preferredLanguage) &&
            (identical(
                  other.pushNotificationsEnabled,
                  pushNotificationsEnabled,
                ) ||
                other.pushNotificationsEnabled == pushNotificationsEnabled) &&
            (identical(other.isDiscoverable, isDiscoverable) ||
                other.isDiscoverable == isDiscoverable) &&
            (identical(other.bio, bio) || other.bio == bio) &&
            (identical(other.currentMood, currentMood) ||
                other.currentMood == currentMood) &&
            const DeepCollectionEquality().equals(
              other._interestTags,
              _interestTags,
            ));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    email,
    username,
    firstName,
    lastName,
    profilePictureUrl,
    socialBattery,
    hasCompletedOnboarding,
    communicationStyle,
    availability,
    createdAt,
    updatedAt,
    timezone,
    preferredLanguage,
    pushNotificationsEnabled,
    isDiscoverable,
    bio,
    currentMood,
    const DeepCollectionEquality().hash(_interestTags),
  ]);

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      __$$UserImplCopyWithImpl<_$UserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserImplToJson(this);
  }
}

abstract class _User extends User {
  const factory _User({
    required final String id,
    required final String email,
    required final String username,
    final String? firstName,
    final String? lastName,
    final String? profilePictureUrl,
    final int socialBattery,
    final bool hasCompletedOnboarding,
    final CommunicationStyle communicationStyle,
    final AvailabilityStatus availability,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final String? timezone,
    final String preferredLanguage,
    final bool pushNotificationsEnabled,
    final bool isDiscoverable,
    final String? bio,
    final String? currentMood,
    final List<String> interestTags,
  }) = _$UserImpl;
  const _User._() : super._();

  factory _User.fromJson(Map<String, dynamic> json) = _$UserImpl.fromJson;

  /// Unique user identifier
  @override
  String get id;

  /// User's email address
  @override
  String get email;

  /// User's display name
  @override
  String get username;

  /// User's first name (optional)
  @override
  String? get firstName;

  /// User's last name (optional)
  @override
  String? get lastName;

  /// User's profile picture URL (optional)
  @override
  String? get profilePictureUrl;

  /// User's social battery level (0-100)
  @override
  int get socialBattery;

  /// Whether user has completed onboarding
  @override
  bool get hasCompletedOnboarding;

  /// User's preferred communication style
  @override
  CommunicationStyle get communicationStyle;

  /// User's availability status
  @override
  AvailabilityStatus get availability;

  /// When the user account was created
  @override
  DateTime get createdAt;

  /// When the user account was last updated
  @override
  DateTime get updatedAt;

  /// User's timezone
  @override
  String? get timezone;

  /// User's preferred language
  @override
  String get preferredLanguage;

  /// Whether user has enabled push notifications
  @override
  bool get pushNotificationsEnabled;

  /// Whether user wants to be discoverable by friends
  @override
  bool get isDiscoverable;

  /// User's bio/about section
  @override
  String? get bio;

  /// User's current mood (optional)
  @override
  String? get currentMood;

  /// Tags that describe user's interests
  @override
  List<String> get interestTags;

  /// Create a copy of User
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserImplCopyWith<_$UserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

AuthState _$AuthStateFromJson(Map<String, dynamic> json) {
  return _AuthState.fromJson(json);
}

/// @nodoc
mixin _$AuthState {
  /// Currently authenticated user (null if not authenticated)
  User? get user => throw _privateConstructorUsedError;

  /// Whether authentication is in progress
  bool get isLoading => throw _privateConstructorUsedError;

  /// Authentication error message
  String? get error => throw _privateConstructorUsedError;

  /// Whether user is authenticated
  bool get isAuthenticated => throw _privateConstructorUsedError;

  /// Authentication token (for API calls)
  String? get token => throw _privateConstructorUsedError;

  /// Refresh token
  String? get refreshToken => throw _privateConstructorUsedError;

  /// Token expiration time
  DateTime? get tokenExpiresAt => throw _privateConstructorUsedError;

  /// Serializes this AuthState to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
  @useResult
  $Res call({
    User? user,
    bool isLoading,
    String? error,
    bool isAuthenticated,
    String? token,
    String? refreshToken,
    DateTime? tokenExpiresAt,
  });

  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? isAuthenticated = null,
    Object? token = freezed,
    Object? refreshToken = freezed,
    Object? tokenExpiresAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            user: freezed == user
                ? _value.user
                : user // ignore: cast_nullable_to_non_nullable
                      as User?,
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            error: freezed == error
                ? _value.error
                : error // ignore: cast_nullable_to_non_nullable
                      as String?,
            isAuthenticated: null == isAuthenticated
                ? _value.isAuthenticated
                : isAuthenticated // ignore: cast_nullable_to_non_nullable
                      as bool,
            token: freezed == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String?,
            refreshToken: freezed == refreshToken
                ? _value.refreshToken
                : refreshToken // ignore: cast_nullable_to_non_nullable
                      as String?,
            tokenExpiresAt: freezed == tokenExpiresAt
                ? _value.tokenExpiresAt
                : tokenExpiresAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserCopyWith<$Res>? get user {
    if (_value.user == null) {
      return null;
    }

    return $UserCopyWith<$Res>(_value.user!, (value) {
      return _then(_value.copyWith(user: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthStateImplCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$AuthStateImplCopyWith(
    _$AuthStateImpl value,
    $Res Function(_$AuthStateImpl) then,
  ) = __$$AuthStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    User? user,
    bool isLoading,
    String? error,
    bool isAuthenticated,
    String? token,
    String? refreshToken,
    DateTime? tokenExpiresAt,
  });

  @override
  $UserCopyWith<$Res>? get user;
}

/// @nodoc
class __$$AuthStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthStateImpl>
    implements _$$AuthStateImplCopyWith<$Res> {
  __$$AuthStateImplCopyWithImpl(
    _$AuthStateImpl _value,
    $Res Function(_$AuthStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? user = freezed,
    Object? isLoading = null,
    Object? error = freezed,
    Object? isAuthenticated = null,
    Object? token = freezed,
    Object? refreshToken = freezed,
    Object? tokenExpiresAt = freezed,
  }) {
    return _then(
      _$AuthStateImpl(
        user: freezed == user
            ? _value.user
            : user // ignore: cast_nullable_to_non_nullable
                  as User?,
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        error: freezed == error
            ? _value.error
            : error // ignore: cast_nullable_to_non_nullable
                  as String?,
        isAuthenticated: null == isAuthenticated
            ? _value.isAuthenticated
            : isAuthenticated // ignore: cast_nullable_to_non_nullable
                  as bool,
        token: freezed == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String?,
        refreshToken: freezed == refreshToken
            ? _value.refreshToken
            : refreshToken // ignore: cast_nullable_to_non_nullable
                  as String?,
        tokenExpiresAt: freezed == tokenExpiresAt
            ? _value.tokenExpiresAt
            : tokenExpiresAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AuthStateImpl extends _AuthState {
  const _$AuthStateImpl({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.token,
    this.refreshToken,
    this.tokenExpiresAt,
  }) : super._();

  factory _$AuthStateImpl.fromJson(Map<String, dynamic> json) =>
      _$$AuthStateImplFromJson(json);

  /// Currently authenticated user (null if not authenticated)
  @override
  final User? user;

  /// Whether authentication is in progress
  @override
  @JsonKey()
  final bool isLoading;

  /// Authentication error message
  @override
  final String? error;

  /// Whether user is authenticated
  @override
  @JsonKey()
  final bool isAuthenticated;

  /// Authentication token (for API calls)
  @override
  final String? token;

  /// Refresh token
  @override
  final String? refreshToken;

  /// Token expiration time
  @override
  final DateTime? tokenExpiresAt;

  @override
  String toString() {
    return 'AuthState(user: $user, isLoading: $isLoading, error: $error, isAuthenticated: $isAuthenticated, token: $token, refreshToken: $refreshToken, tokenExpiresAt: $tokenExpiresAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateImpl &&
            (identical(other.user, user) || other.user == user) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.isAuthenticated, isAuthenticated) ||
                other.isAuthenticated == isAuthenticated) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.refreshToken, refreshToken) ||
                other.refreshToken == refreshToken) &&
            (identical(other.tokenExpiresAt, tokenExpiresAt) ||
                other.tokenExpiresAt == tokenExpiresAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    user,
    isLoading,
    error,
    isAuthenticated,
    token,
    refreshToken,
    tokenExpiresAt,
  );

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      __$$AuthStateImplCopyWithImpl<_$AuthStateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AuthStateImplToJson(this);
  }
}

abstract class _AuthState extends AuthState {
  const factory _AuthState({
    final User? user,
    final bool isLoading,
    final String? error,
    final bool isAuthenticated,
    final String? token,
    final String? refreshToken,
    final DateTime? tokenExpiresAt,
  }) = _$AuthStateImpl;
  const _AuthState._() : super._();

  factory _AuthState.fromJson(Map<String, dynamic> json) =
      _$AuthStateImpl.fromJson;

  /// Currently authenticated user (null if not authenticated)
  @override
  User? get user;

  /// Whether authentication is in progress
  @override
  bool get isLoading;

  /// Authentication error message
  @override
  String? get error;

  /// Whether user is authenticated
  @override
  bool get isAuthenticated;

  /// Authentication token (for API calls)
  @override
  String? get token;

  /// Refresh token
  @override
  String? get refreshToken;

  /// Token expiration time
  @override
  DateTime? get tokenExpiresAt;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CreateUserData _$CreateUserDataFromJson(Map<String, dynamic> json) {
  return _CreateUserData.fromJson(json);
}

/// @nodoc
mixin _$CreateUserData {
  /// User's email
  String get email => throw _privateConstructorUsedError;

  /// User's chosen username
  String get username => throw _privateConstructorUsedError;

  /// User's password
  String get password => throw _privateConstructorUsedError;

  /// User's first name (optional)
  String? get firstName => throw _privateConstructorUsedError;

  /// User's last name (optional)
  String? get lastName => throw _privateConstructorUsedError;

  /// Whether user agreed to terms
  bool get agreedToTerms => throw _privateConstructorUsedError;

  /// Whether user wants marketing emails
  bool get allowMarketingEmails => throw _privateConstructorUsedError;

  /// Serializes this CreateUserData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CreateUserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreateUserDataCopyWith<CreateUserData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreateUserDataCopyWith<$Res> {
  factory $CreateUserDataCopyWith(
    CreateUserData value,
    $Res Function(CreateUserData) then,
  ) = _$CreateUserDataCopyWithImpl<$Res, CreateUserData>;
  @useResult
  $Res call({
    String email,
    String username,
    String password,
    String? firstName,
    String? lastName,
    bool agreedToTerms,
    bool allowMarketingEmails,
  });
}

/// @nodoc
class _$CreateUserDataCopyWithImpl<$Res, $Val extends CreateUserData>
    implements $CreateUserDataCopyWith<$Res> {
  _$CreateUserDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreateUserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? username = null,
    Object? password = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? agreedToTerms = null,
    Object? allowMarketingEmails = null,
  }) {
    return _then(
      _value.copyWith(
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            firstName: freezed == firstName
                ? _value.firstName
                : firstName // ignore: cast_nullable_to_non_nullable
                      as String?,
            lastName: freezed == lastName
                ? _value.lastName
                : lastName // ignore: cast_nullable_to_non_nullable
                      as String?,
            agreedToTerms: null == agreedToTerms
                ? _value.agreedToTerms
                : agreedToTerms // ignore: cast_nullable_to_non_nullable
                      as bool,
            allowMarketingEmails: null == allowMarketingEmails
                ? _value.allowMarketingEmails
                : allowMarketingEmails // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreateUserDataImplCopyWith<$Res>
    implements $CreateUserDataCopyWith<$Res> {
  factory _$$CreateUserDataImplCopyWith(
    _$CreateUserDataImpl value,
    $Res Function(_$CreateUserDataImpl) then,
  ) = __$$CreateUserDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String email,
    String username,
    String password,
    String? firstName,
    String? lastName,
    bool agreedToTerms,
    bool allowMarketingEmails,
  });
}

/// @nodoc
class __$$CreateUserDataImplCopyWithImpl<$Res>
    extends _$CreateUserDataCopyWithImpl<$Res, _$CreateUserDataImpl>
    implements _$$CreateUserDataImplCopyWith<$Res> {
  __$$CreateUserDataImplCopyWithImpl(
    _$CreateUserDataImpl _value,
    $Res Function(_$CreateUserDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreateUserData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? email = null,
    Object? username = null,
    Object? password = null,
    Object? firstName = freezed,
    Object? lastName = freezed,
    Object? agreedToTerms = null,
    Object? allowMarketingEmails = null,
  }) {
    return _then(
      _$CreateUserDataImpl(
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        firstName: freezed == firstName
            ? _value.firstName
            : firstName // ignore: cast_nullable_to_non_nullable
                  as String?,
        lastName: freezed == lastName
            ? _value.lastName
            : lastName // ignore: cast_nullable_to_non_nullable
                  as String?,
        agreedToTerms: null == agreedToTerms
            ? _value.agreedToTerms
            : agreedToTerms // ignore: cast_nullable_to_non_nullable
                  as bool,
        allowMarketingEmails: null == allowMarketingEmails
            ? _value.allowMarketingEmails
            : allowMarketingEmails // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CreateUserDataImpl implements _CreateUserData {
  const _$CreateUserDataImpl({
    required this.email,
    required this.username,
    required this.password,
    this.firstName,
    this.lastName,
    this.agreedToTerms = false,
    this.allowMarketingEmails = false,
  });

  factory _$CreateUserDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$CreateUserDataImplFromJson(json);

  /// User's email
  @override
  final String email;

  /// User's chosen username
  @override
  final String username;

  /// User's password
  @override
  final String password;

  /// User's first name (optional)
  @override
  final String? firstName;

  /// User's last name (optional)
  @override
  final String? lastName;

  /// Whether user agreed to terms
  @override
  @JsonKey()
  final bool agreedToTerms;

  /// Whether user wants marketing emails
  @override
  @JsonKey()
  final bool allowMarketingEmails;

  @override
  String toString() {
    return 'CreateUserData(email: $email, username: $username, password: $password, firstName: $firstName, lastName: $lastName, agreedToTerms: $agreedToTerms, allowMarketingEmails: $allowMarketingEmails)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreateUserDataImpl &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.firstName, firstName) ||
                other.firstName == firstName) &&
            (identical(other.lastName, lastName) ||
                other.lastName == lastName) &&
            (identical(other.agreedToTerms, agreedToTerms) ||
                other.agreedToTerms == agreedToTerms) &&
            (identical(other.allowMarketingEmails, allowMarketingEmails) ||
                other.allowMarketingEmails == allowMarketingEmails));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    email,
    username,
    password,
    firstName,
    lastName,
    agreedToTerms,
    allowMarketingEmails,
  );

  /// Create a copy of CreateUserData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreateUserDataImplCopyWith<_$CreateUserDataImpl> get copyWith =>
      __$$CreateUserDataImplCopyWithImpl<_$CreateUserDataImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CreateUserDataImplToJson(this);
  }
}

abstract class _CreateUserData implements CreateUserData {
  const factory _CreateUserData({
    required final String email,
    required final String username,
    required final String password,
    final String? firstName,
    final String? lastName,
    final bool agreedToTerms,
    final bool allowMarketingEmails,
  }) = _$CreateUserDataImpl;

  factory _CreateUserData.fromJson(Map<String, dynamic> json) =
      _$CreateUserDataImpl.fromJson;

  /// User's email
  @override
  String get email;

  /// User's chosen username
  @override
  String get username;

  /// User's password
  @override
  String get password;

  /// User's first name (optional)
  @override
  String? get firstName;

  /// User's last name (optional)
  @override
  String? get lastName;

  /// Whether user agreed to terms
  @override
  bool get agreedToTerms;

  /// Whether user wants marketing emails
  @override
  bool get allowMarketingEmails;

  /// Create a copy of CreateUserData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreateUserDataImplCopyWith<_$CreateUserDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LoginData _$LoginDataFromJson(Map<String, dynamic> json) {
  return _LoginData.fromJson(json);
}

/// @nodoc
mixin _$LoginData {
  /// Email or username
  String get emailOrUsername => throw _privateConstructorUsedError;

  /// User's password
  String get password => throw _privateConstructorUsedError;

  /// Whether to remember the user
  bool get rememberMe => throw _privateConstructorUsedError;

  /// Serializes this LoginData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LoginData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LoginDataCopyWith<LoginData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LoginDataCopyWith<$Res> {
  factory $LoginDataCopyWith(LoginData value, $Res Function(LoginData) then) =
      _$LoginDataCopyWithImpl<$Res, LoginData>;
  @useResult
  $Res call({String emailOrUsername, String password, bool rememberMe});
}

/// @nodoc
class _$LoginDataCopyWithImpl<$Res, $Val extends LoginData>
    implements $LoginDataCopyWith<$Res> {
  _$LoginDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LoginData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emailOrUsername = null,
    Object? password = null,
    Object? rememberMe = null,
  }) {
    return _then(
      _value.copyWith(
            emailOrUsername: null == emailOrUsername
                ? _value.emailOrUsername
                : emailOrUsername // ignore: cast_nullable_to_non_nullable
                      as String,
            password: null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                      as String,
            rememberMe: null == rememberMe
                ? _value.rememberMe
                : rememberMe // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$LoginDataImplCopyWith<$Res>
    implements $LoginDataCopyWith<$Res> {
  factory _$$LoginDataImplCopyWith(
    _$LoginDataImpl value,
    $Res Function(_$LoginDataImpl) then,
  ) = __$$LoginDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String emailOrUsername, String password, bool rememberMe});
}

/// @nodoc
class __$$LoginDataImplCopyWithImpl<$Res>
    extends _$LoginDataCopyWithImpl<$Res, _$LoginDataImpl>
    implements _$$LoginDataImplCopyWith<$Res> {
  __$$LoginDataImplCopyWithImpl(
    _$LoginDataImpl _value,
    $Res Function(_$LoginDataImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of LoginData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? emailOrUsername = null,
    Object? password = null,
    Object? rememberMe = null,
  }) {
    return _then(
      _$LoginDataImpl(
        emailOrUsername: null == emailOrUsername
            ? _value.emailOrUsername
            : emailOrUsername // ignore: cast_nullable_to_non_nullable
                  as String,
        password: null == password
            ? _value.password
            : password // ignore: cast_nullable_to_non_nullable
                  as String,
        rememberMe: null == rememberMe
            ? _value.rememberMe
            : rememberMe // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$LoginDataImpl implements _LoginData {
  const _$LoginDataImpl({
    required this.emailOrUsername,
    required this.password,
    this.rememberMe = false,
  });

  factory _$LoginDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$LoginDataImplFromJson(json);

  /// Email or username
  @override
  final String emailOrUsername;

  /// User's password
  @override
  final String password;

  /// Whether to remember the user
  @override
  @JsonKey()
  final bool rememberMe;

  @override
  String toString() {
    return 'LoginData(emailOrUsername: $emailOrUsername, password: $password, rememberMe: $rememberMe)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LoginDataImpl &&
            (identical(other.emailOrUsername, emailOrUsername) ||
                other.emailOrUsername == emailOrUsername) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.rememberMe, rememberMe) ||
                other.rememberMe == rememberMe));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, emailOrUsername, password, rememberMe);

  /// Create a copy of LoginData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LoginDataImplCopyWith<_$LoginDataImpl> get copyWith =>
      __$$LoginDataImplCopyWithImpl<_$LoginDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LoginDataImplToJson(this);
  }
}

abstract class _LoginData implements LoginData {
  const factory _LoginData({
    required final String emailOrUsername,
    required final String password,
    final bool rememberMe,
  }) = _$LoginDataImpl;

  factory _LoginData.fromJson(Map<String, dynamic> json) =
      _$LoginDataImpl.fromJson;

  /// Email or username
  @override
  String get emailOrUsername;

  /// User's password
  @override
  String get password;

  /// Whether to remember the user
  @override
  bool get rememberMe;

  /// Create a copy of LoginData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LoginDataImplCopyWith<_$LoginDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
