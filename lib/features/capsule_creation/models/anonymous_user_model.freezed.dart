// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'anonymous_user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AnonymousUser _$AnonymousUserFromJson(Map<String, dynamic> json) {
  return _AnonymousUser.fromJson(json);
}

/// @nodoc
mixin _$AnonymousUser {
  /// Unique identifier for the user (privacy-safe)
  String get id => throw _privateConstructorUsedError;

  /// User's display name
  String get name => throw _privateConstructorUsedError;

  /// User's username for exact search matching
  String get username => throw _privateConstructorUsedError;

  /// User's email for exact search matching (privacy-protected)
  String get email => throw _privateConstructorUsedError;

  /// Avatar character or URL identifier
  String get avatar => throw _privateConstructorUsedError;

  /// Whether this user is currently online
  bool get isOnline => throw _privateConstructorUsedError;

  /// Privacy-safe status for anonymous recipients
  bool get acceptsAnonymousMessages => throw _privateConstructorUsedError;

  /// Serializes this AnonymousUser to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AnonymousUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AnonymousUserCopyWith<AnonymousUser> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AnonymousUserCopyWith<$Res> {
  factory $AnonymousUserCopyWith(
    AnonymousUser value,
    $Res Function(AnonymousUser) then,
  ) = _$AnonymousUserCopyWithImpl<$Res, AnonymousUser>;
  @useResult
  $Res call({
    String id,
    String name,
    String username,
    String email,
    String avatar,
    bool isOnline,
    bool acceptsAnonymousMessages,
  });
}

/// @nodoc
class _$AnonymousUserCopyWithImpl<$Res, $Val extends AnonymousUser>
    implements $AnonymousUserCopyWith<$Res> {
  _$AnonymousUserCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AnonymousUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? username = null,
    Object? email = null,
    Object? avatar = null,
    Object? isOnline = null,
    Object? acceptsAnonymousMessages = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            avatar: null == avatar
                ? _value.avatar
                : avatar // ignore: cast_nullable_to_non_nullable
                      as String,
            isOnline: null == isOnline
                ? _value.isOnline
                : isOnline // ignore: cast_nullable_to_non_nullable
                      as bool,
            acceptsAnonymousMessages: null == acceptsAnonymousMessages
                ? _value.acceptsAnonymousMessages
                : acceptsAnonymousMessages // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AnonymousUserImplCopyWith<$Res>
    implements $AnonymousUserCopyWith<$Res> {
  factory _$$AnonymousUserImplCopyWith(
    _$AnonymousUserImpl value,
    $Res Function(_$AnonymousUserImpl) then,
  ) = __$$AnonymousUserImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String username,
    String email,
    String avatar,
    bool isOnline,
    bool acceptsAnonymousMessages,
  });
}

/// @nodoc
class __$$AnonymousUserImplCopyWithImpl<$Res>
    extends _$AnonymousUserCopyWithImpl<$Res, _$AnonymousUserImpl>
    implements _$$AnonymousUserImplCopyWith<$Res> {
  __$$AnonymousUserImplCopyWithImpl(
    _$AnonymousUserImpl _value,
    $Res Function(_$AnonymousUserImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AnonymousUser
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? username = null,
    Object? email = null,
    Object? avatar = null,
    Object? isOnline = null,
    Object? acceptsAnonymousMessages = null,
  }) {
    return _then(
      _$AnonymousUserImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        avatar: null == avatar
            ? _value.avatar
            : avatar // ignore: cast_nullable_to_non_nullable
                  as String,
        isOnline: null == isOnline
            ? _value.isOnline
            : isOnline // ignore: cast_nullable_to_non_nullable
                  as bool,
        acceptsAnonymousMessages: null == acceptsAnonymousMessages
            ? _value.acceptsAnonymousMessages
            : acceptsAnonymousMessages // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AnonymousUserImpl implements _AnonymousUser {
  const _$AnonymousUserImpl({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
    required this.avatar,
    this.isOnline = false,
    this.acceptsAnonymousMessages = true,
  });

  factory _$AnonymousUserImpl.fromJson(Map<String, dynamic> json) =>
      _$$AnonymousUserImplFromJson(json);

  /// Unique identifier for the user (privacy-safe)
  @override
  final String id;

  /// User's display name
  @override
  final String name;

  /// User's username for exact search matching
  @override
  final String username;

  /// User's email for exact search matching (privacy-protected)
  @override
  final String email;

  /// Avatar character or URL identifier
  @override
  final String avatar;

  /// Whether this user is currently online
  @override
  @JsonKey()
  final bool isOnline;

  /// Privacy-safe status for anonymous recipients
  @override
  @JsonKey()
  final bool acceptsAnonymousMessages;

  @override
  String toString() {
    return 'AnonymousUser(id: $id, name: $name, username: $username, email: $email, avatar: $avatar, isOnline: $isOnline, acceptsAnonymousMessages: $acceptsAnonymousMessages)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AnonymousUserImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.avatar, avatar) || other.avatar == avatar) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(
                  other.acceptsAnonymousMessages,
                  acceptsAnonymousMessages,
                ) ||
                other.acceptsAnonymousMessages == acceptsAnonymousMessages));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    username,
    email,
    avatar,
    isOnline,
    acceptsAnonymousMessages,
  );

  /// Create a copy of AnonymousUser
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AnonymousUserImplCopyWith<_$AnonymousUserImpl> get copyWith =>
      __$$AnonymousUserImplCopyWithImpl<_$AnonymousUserImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AnonymousUserImplToJson(this);
  }
}

abstract class _AnonymousUser implements AnonymousUser {
  const factory _AnonymousUser({
    required final String id,
    required final String name,
    required final String username,
    required final String email,
    required final String avatar,
    final bool isOnline,
    final bool acceptsAnonymousMessages,
  }) = _$AnonymousUserImpl;

  factory _AnonymousUser.fromJson(Map<String, dynamic> json) =
      _$AnonymousUserImpl.fromJson;

  /// Unique identifier for the user (privacy-safe)
  @override
  String get id;

  /// User's display name
  @override
  String get name;

  /// User's username for exact search matching
  @override
  String get username;

  /// User's email for exact search matching (privacy-protected)
  @override
  String get email;

  /// Avatar character or URL identifier
  @override
  String get avatar;

  /// Whether this user is currently online
  @override
  bool get isOnline;

  /// Privacy-safe status for anonymous recipients
  @override
  bool get acceptsAnonymousMessages;

  /// Create a copy of AnonymousUser
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AnonymousUserImplCopyWith<_$AnonymousUserImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
