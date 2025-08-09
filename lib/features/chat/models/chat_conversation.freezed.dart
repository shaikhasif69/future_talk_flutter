// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Participant _$ParticipantFromJson(Map<String, dynamic> json) {
  return _Participant.fromJson(json);
}

/// @nodoc
mixin _$Participant {
  String get userId => throw _privateConstructorUsedError; // UUID
  String get username => throw _privateConstructorUsedError;
  ParticipantRole get role => throw _privateConstructorUsedError;
  DateTime get joinedAt => throw _privateConstructorUsedError;

  /// Serializes this Participant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Participant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ParticipantCopyWith<Participant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ParticipantCopyWith<$Res> {
  factory $ParticipantCopyWith(
    Participant value,
    $Res Function(Participant) then,
  ) = _$ParticipantCopyWithImpl<$Res, Participant>;
  @useResult
  $Res call({
    String userId,
    String username,
    ParticipantRole role,
    DateTime joinedAt,
  });
}

/// @nodoc
class _$ParticipantCopyWithImpl<$Res, $Val extends Participant>
    implements $ParticipantCopyWith<$Res> {
  _$ParticipantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Participant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? role = null,
    Object? joinedAt = null,
  }) {
    return _then(
      _value.copyWith(
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            username: null == username
                ? _value.username
                : username // ignore: cast_nullable_to_non_nullable
                      as String,
            role: null == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as ParticipantRole,
            joinedAt: null == joinedAt
                ? _value.joinedAt
                : joinedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ParticipantImplCopyWith<$Res>
    implements $ParticipantCopyWith<$Res> {
  factory _$$ParticipantImplCopyWith(
    _$ParticipantImpl value,
    $Res Function(_$ParticipantImpl) then,
  ) = __$$ParticipantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String userId,
    String username,
    ParticipantRole role,
    DateTime joinedAt,
  });
}

/// @nodoc
class __$$ParticipantImplCopyWithImpl<$Res>
    extends _$ParticipantCopyWithImpl<$Res, _$ParticipantImpl>
    implements _$$ParticipantImplCopyWith<$Res> {
  __$$ParticipantImplCopyWithImpl(
    _$ParticipantImpl _value,
    $Res Function(_$ParticipantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Participant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? username = null,
    Object? role = null,
    Object? joinedAt = null,
  }) {
    return _then(
      _$ParticipantImpl(
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        username: null == username
            ? _value.username
            : username // ignore: cast_nullable_to_non_nullable
                  as String,
        role: null == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as ParticipantRole,
        joinedAt: null == joinedAt
            ? _value.joinedAt
            : joinedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ParticipantImpl implements _Participant {
  const _$ParticipantImpl({
    required this.userId,
    required this.username,
    required this.role,
    required this.joinedAt,
  });

  factory _$ParticipantImpl.fromJson(Map<String, dynamic> json) =>
      _$$ParticipantImplFromJson(json);

  @override
  final String userId;
  // UUID
  @override
  final String username;
  @override
  final ParticipantRole role;
  @override
  final DateTime joinedAt;

  @override
  String toString() {
    return 'Participant(userId: $userId, username: $username, role: $role, joinedAt: $joinedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParticipantImpl &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.username, username) ||
                other.username == username) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.joinedAt, joinedAt) ||
                other.joinedAt == joinedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, userId, username, role, joinedAt);

  /// Create a copy of Participant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ParticipantImplCopyWith<_$ParticipantImpl> get copyWith =>
      __$$ParticipantImplCopyWithImpl<_$ParticipantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ParticipantImplToJson(this);
  }
}

abstract class _Participant implements Participant {
  const factory _Participant({
    required final String userId,
    required final String username,
    required final ParticipantRole role,
    required final DateTime joinedAt,
  }) = _$ParticipantImpl;

  factory _Participant.fromJson(Map<String, dynamic> json) =
      _$ParticipantImpl.fromJson;

  @override
  String get userId; // UUID
  @override
  String get username;
  @override
  ParticipantRole get role;
  @override
  DateTime get joinedAt;

  /// Create a copy of Participant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ParticipantImplCopyWith<_$ParticipantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Conversation _$ConversationFromJson(Map<String, dynamic> json) {
  return _Conversation.fromJson(json);
}

/// @nodoc
mixin _$Conversation {
  String get id => throw _privateConstructorUsedError; // UUID
  ConversationType get conversationType => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get lastMessageAt => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;
  List<Participant> get participants => throw _privateConstructorUsedError;
  ChatMessage? get lastMessage => throw _privateConstructorUsedError;
  int get unreadCount =>
      throw _privateConstructorUsedError; // Additional UI fields
  bool get isPinned => throw _privateConstructorUsedError;
  bool get isMuted => throw _privateConstructorUsedError;
  String? get avatarEmoji => throw _privateConstructorUsedError;
  @JsonKey(includeFromJson: false, includeToJson: false)
  Color? get avatarColor => throw _privateConstructorUsedError;
  bool get isQuietHours => throw _privateConstructorUsedError;

  /// Serializes this Conversation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ConversationCopyWith<Conversation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ConversationCopyWith<$Res> {
  factory $ConversationCopyWith(
    Conversation value,
    $Res Function(Conversation) then,
  ) = _$ConversationCopyWithImpl<$Res, Conversation>;
  @useResult
  $Res call({
    String id,
    ConversationType conversationType,
    DateTime createdAt,
    DateTime lastMessageAt,
    bool isArchived,
    List<Participant> participants,
    ChatMessage? lastMessage,
    int unreadCount,
    bool isPinned,
    bool isMuted,
    String? avatarEmoji,
    @JsonKey(includeFromJson: false, includeToJson: false) Color? avatarColor,
    bool isQuietHours,
  });

  $ChatMessageCopyWith<$Res>? get lastMessage;
}

/// @nodoc
class _$ConversationCopyWithImpl<$Res, $Val extends Conversation>
    implements $ConversationCopyWith<$Res> {
  _$ConversationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationType = null,
    Object? createdAt = null,
    Object? lastMessageAt = null,
    Object? isArchived = null,
    Object? participants = null,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
    Object? isPinned = null,
    Object? isMuted = null,
    Object? avatarEmoji = freezed,
    Object? avatarColor = freezed,
    Object? isQuietHours = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            conversationType: null == conversationType
                ? _value.conversationType
                : conversationType // ignore: cast_nullable_to_non_nullable
                      as ConversationType,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            lastMessageAt: null == lastMessageAt
                ? _value.lastMessageAt
                : lastMessageAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isArchived: null == isArchived
                ? _value.isArchived
                : isArchived // ignore: cast_nullable_to_non_nullable
                      as bool,
            participants: null == participants
                ? _value.participants
                : participants // ignore: cast_nullable_to_non_nullable
                      as List<Participant>,
            lastMessage: freezed == lastMessage
                ? _value.lastMessage
                : lastMessage // ignore: cast_nullable_to_non_nullable
                      as ChatMessage?,
            unreadCount: null == unreadCount
                ? _value.unreadCount
                : unreadCount // ignore: cast_nullable_to_non_nullable
                      as int,
            isPinned: null == isPinned
                ? _value.isPinned
                : isPinned // ignore: cast_nullable_to_non_nullable
                      as bool,
            isMuted: null == isMuted
                ? _value.isMuted
                : isMuted // ignore: cast_nullable_to_non_nullable
                      as bool,
            avatarEmoji: freezed == avatarEmoji
                ? _value.avatarEmoji
                : avatarEmoji // ignore: cast_nullable_to_non_nullable
                      as String?,
            avatarColor: freezed == avatarColor
                ? _value.avatarColor
                : avatarColor // ignore: cast_nullable_to_non_nullable
                      as Color?,
            isQuietHours: null == isQuietHours
                ? _value.isQuietHours
                : isQuietHours // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ChatMessageCopyWith<$Res>? get lastMessage {
    if (_value.lastMessage == null) {
      return null;
    }

    return $ChatMessageCopyWith<$Res>(_value.lastMessage!, (value) {
      return _then(_value.copyWith(lastMessage: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ConversationImplCopyWith<$Res>
    implements $ConversationCopyWith<$Res> {
  factory _$$ConversationImplCopyWith(
    _$ConversationImpl value,
    $Res Function(_$ConversationImpl) then,
  ) = __$$ConversationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    ConversationType conversationType,
    DateTime createdAt,
    DateTime lastMessageAt,
    bool isArchived,
    List<Participant> participants,
    ChatMessage? lastMessage,
    int unreadCount,
    bool isPinned,
    bool isMuted,
    String? avatarEmoji,
    @JsonKey(includeFromJson: false, includeToJson: false) Color? avatarColor,
    bool isQuietHours,
  });

  @override
  $ChatMessageCopyWith<$Res>? get lastMessage;
}

/// @nodoc
class __$$ConversationImplCopyWithImpl<$Res>
    extends _$ConversationCopyWithImpl<$Res, _$ConversationImpl>
    implements _$$ConversationImplCopyWith<$Res> {
  __$$ConversationImplCopyWithImpl(
    _$ConversationImpl _value,
    $Res Function(_$ConversationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? conversationType = null,
    Object? createdAt = null,
    Object? lastMessageAt = null,
    Object? isArchived = null,
    Object? participants = null,
    Object? lastMessage = freezed,
    Object? unreadCount = null,
    Object? isPinned = null,
    Object? isMuted = null,
    Object? avatarEmoji = freezed,
    Object? avatarColor = freezed,
    Object? isQuietHours = null,
  }) {
    return _then(
      _$ConversationImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        conversationType: null == conversationType
            ? _value.conversationType
            : conversationType // ignore: cast_nullable_to_non_nullable
                  as ConversationType,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        lastMessageAt: null == lastMessageAt
            ? _value.lastMessageAt
            : lastMessageAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isArchived: null == isArchived
            ? _value.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
        participants: null == participants
            ? _value._participants
            : participants // ignore: cast_nullable_to_non_nullable
                  as List<Participant>,
        lastMessage: freezed == lastMessage
            ? _value.lastMessage
            : lastMessage // ignore: cast_nullable_to_non_nullable
                  as ChatMessage?,
        unreadCount: null == unreadCount
            ? _value.unreadCount
            : unreadCount // ignore: cast_nullable_to_non_nullable
                  as int,
        isPinned: null == isPinned
            ? _value.isPinned
            : isPinned // ignore: cast_nullable_to_non_nullable
                  as bool,
        isMuted: null == isMuted
            ? _value.isMuted
            : isMuted // ignore: cast_nullable_to_non_nullable
                  as bool,
        avatarEmoji: freezed == avatarEmoji
            ? _value.avatarEmoji
            : avatarEmoji // ignore: cast_nullable_to_non_nullable
                  as String?,
        avatarColor: freezed == avatarColor
            ? _value.avatarColor
            : avatarColor // ignore: cast_nullable_to_non_nullable
                  as Color?,
        isQuietHours: null == isQuietHours
            ? _value.isQuietHours
            : isQuietHours // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ConversationImpl extends _Conversation {
  const _$ConversationImpl({
    required this.id,
    required this.conversationType,
    required this.createdAt,
    required this.lastMessageAt,
    this.isArchived = false,
    required final List<Participant> participants,
    this.lastMessage,
    this.unreadCount = 0,
    this.isPinned = false,
    this.isMuted = false,
    this.avatarEmoji,
    @JsonKey(includeFromJson: false, includeToJson: false) this.avatarColor,
    this.isQuietHours = false,
  }) : _participants = participants,
       super._();

  factory _$ConversationImpl.fromJson(Map<String, dynamic> json) =>
      _$$ConversationImplFromJson(json);

  @override
  final String id;
  // UUID
  @override
  final ConversationType conversationType;
  @override
  final DateTime createdAt;
  @override
  final DateTime lastMessageAt;
  @override
  @JsonKey()
  final bool isArchived;
  final List<Participant> _participants;
  @override
  List<Participant> get participants {
    if (_participants is EqualUnmodifiableListView) return _participants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participants);
  }

  @override
  final ChatMessage? lastMessage;
  @override
  @JsonKey()
  final int unreadCount;
  // Additional UI fields
  @override
  @JsonKey()
  final bool isPinned;
  @override
  @JsonKey()
  final bool isMuted;
  @override
  final String? avatarEmoji;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  final Color? avatarColor;
  @override
  @JsonKey()
  final bool isQuietHours;

  @override
  String toString() {
    return 'Conversation(id: $id, conversationType: $conversationType, createdAt: $createdAt, lastMessageAt: $lastMessageAt, isArchived: $isArchived, participants: $participants, lastMessage: $lastMessage, unreadCount: $unreadCount, isPinned: $isPinned, isMuted: $isMuted, avatarEmoji: $avatarEmoji, avatarColor: $avatarColor, isQuietHours: $isQuietHours)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConversationImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.conversationType, conversationType) ||
                other.conversationType == conversationType) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastMessageAt, lastMessageAt) ||
                other.lastMessageAt == lastMessageAt) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            const DeepCollectionEquality().equals(
              other._participants,
              _participants,
            ) &&
            (identical(other.lastMessage, lastMessage) ||
                other.lastMessage == lastMessage) &&
            (identical(other.unreadCount, unreadCount) ||
                other.unreadCount == unreadCount) &&
            (identical(other.isPinned, isPinned) ||
                other.isPinned == isPinned) &&
            (identical(other.isMuted, isMuted) || other.isMuted == isMuted) &&
            (identical(other.avatarEmoji, avatarEmoji) ||
                other.avatarEmoji == avatarEmoji) &&
            (identical(other.avatarColor, avatarColor) ||
                other.avatarColor == avatarColor) &&
            (identical(other.isQuietHours, isQuietHours) ||
                other.isQuietHours == isQuietHours));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    conversationType,
    createdAt,
    lastMessageAt,
    isArchived,
    const DeepCollectionEquality().hash(_participants),
    lastMessage,
    unreadCount,
    isPinned,
    isMuted,
    avatarEmoji,
    avatarColor,
    isQuietHours,
  );

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      __$$ConversationImplCopyWithImpl<_$ConversationImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ConversationImplToJson(this);
  }
}

abstract class _Conversation extends Conversation {
  const factory _Conversation({
    required final String id,
    required final ConversationType conversationType,
    required final DateTime createdAt,
    required final DateTime lastMessageAt,
    final bool isArchived,
    required final List<Participant> participants,
    final ChatMessage? lastMessage,
    final int unreadCount,
    final bool isPinned,
    final bool isMuted,
    final String? avatarEmoji,
    @JsonKey(includeFromJson: false, includeToJson: false)
    final Color? avatarColor,
    final bool isQuietHours,
  }) = _$ConversationImpl;
  const _Conversation._() : super._();

  factory _Conversation.fromJson(Map<String, dynamic> json) =
      _$ConversationImpl.fromJson;

  @override
  String get id; // UUID
  @override
  ConversationType get conversationType;
  @override
  DateTime get createdAt;
  @override
  DateTime get lastMessageAt;
  @override
  bool get isArchived;
  @override
  List<Participant> get participants;
  @override
  ChatMessage? get lastMessage;
  @override
  int get unreadCount; // Additional UI fields
  @override
  bool get isPinned;
  @override
  bool get isMuted;
  @override
  String? get avatarEmoji;
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  Color? get avatarColor;
  @override
  bool get isQuietHours;

  /// Create a copy of Conversation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ConversationImplCopyWith<_$ConversationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
