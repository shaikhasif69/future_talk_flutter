// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'friend_search_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$FriendSearchState {
  /// Current search results
  List<UserSearchResult> get searchResults =>
      throw _privateConstructorUsedError;

  /// User suggestions
  List<UserSearchResult> get suggestions => throw _privateConstructorUsedError;

  /// Current search query
  String get searchQuery => throw _privateConstructorUsedError;

  /// Search type filter
  SearchType get searchType => throw _privateConstructorUsedError;

  /// Whether search is in progress
  bool get isSearching => throw _privateConstructorUsedError;

  /// Whether suggestions are loading
  bool get isLoadingSuggestions => throw _privateConstructorUsedError;

  /// Whether friend request is being sent
  bool get isSendingFriendRequest => throw _privateConstructorUsedError;

  /// Current search error message
  String? get searchError => throw _privateConstructorUsedError;

  /// Current suggestions error message
  String? get suggestionsError => throw _privateConstructorUsedError;

  /// Friend request operation error
  String? get friendRequestError => throw _privateConstructorUsedError;

  /// Recently looked up user
  UserLookupResult? get lookedUpUser => throw _privateConstructorUsedError;

  /// Whether user lookup is in progress
  bool get isLookingUpUser => throw _privateConstructorUsedError;

  /// User lookup error
  String? get lookupError => throw _privateConstructorUsedError;

  /// Create a copy of FriendSearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendSearchStateCopyWith<FriendSearchState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendSearchStateCopyWith<$Res> {
  factory $FriendSearchStateCopyWith(
          FriendSearchState value, $Res Function(FriendSearchState) then) =
      _$FriendSearchStateCopyWithImpl<$Res, FriendSearchState>;
  @useResult
  $Res call(
      {List<UserSearchResult> searchResults,
      List<UserSearchResult> suggestions,
      String searchQuery,
      SearchType searchType,
      bool isSearching,
      bool isLoadingSuggestions,
      bool isSendingFriendRequest,
      String? searchError,
      String? suggestionsError,
      String? friendRequestError,
      UserLookupResult? lookedUpUser,
      bool isLookingUpUser,
      String? lookupError});

  $UserLookupResultCopyWith<$Res>? get lookedUpUser;
}

/// @nodoc
class _$FriendSearchStateCopyWithImpl<$Res, $Val extends FriendSearchState>
    implements $FriendSearchStateCopyWith<$Res> {
  _$FriendSearchStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendSearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchResults = null,
    Object? suggestions = null,
    Object? searchQuery = null,
    Object? searchType = null,
    Object? isSearching = null,
    Object? isLoadingSuggestions = null,
    Object? isSendingFriendRequest = null,
    Object? searchError = freezed,
    Object? suggestionsError = freezed,
    Object? friendRequestError = freezed,
    Object? lookedUpUser = freezed,
    Object? isLookingUpUser = null,
    Object? lookupError = freezed,
  }) {
    return _then(_value.copyWith(
      searchResults: null == searchResults
          ? _value.searchResults
          : searchResults // ignore: cast_nullable_to_non_nullable
              as List<UserSearchResult>,
      suggestions: null == suggestions
          ? _value.suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<UserSearchResult>,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      searchType: null == searchType
          ? _value.searchType
          : searchType // ignore: cast_nullable_to_non_nullable
              as SearchType,
      isSearching: null == isSearching
          ? _value.isSearching
          : isSearching // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingSuggestions: null == isLoadingSuggestions
          ? _value.isLoadingSuggestions
          : isLoadingSuggestions // ignore: cast_nullable_to_non_nullable
              as bool,
      isSendingFriendRequest: null == isSendingFriendRequest
          ? _value.isSendingFriendRequest
          : isSendingFriendRequest // ignore: cast_nullable_to_non_nullable
              as bool,
      searchError: freezed == searchError
          ? _value.searchError
          : searchError // ignore: cast_nullable_to_non_nullable
              as String?,
      suggestionsError: freezed == suggestionsError
          ? _value.suggestionsError
          : suggestionsError // ignore: cast_nullable_to_non_nullable
              as String?,
      friendRequestError: freezed == friendRequestError
          ? _value.friendRequestError
          : friendRequestError // ignore: cast_nullable_to_non_nullable
              as String?,
      lookedUpUser: freezed == lookedUpUser
          ? _value.lookedUpUser
          : lookedUpUser // ignore: cast_nullable_to_non_nullable
              as UserLookupResult?,
      isLookingUpUser: null == isLookingUpUser
          ? _value.isLookingUpUser
          : isLookingUpUser // ignore: cast_nullable_to_non_nullable
              as bool,
      lookupError: freezed == lookupError
          ? _value.lookupError
          : lookupError // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of FriendSearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserLookupResultCopyWith<$Res>? get lookedUpUser {
    if (_value.lookedUpUser == null) {
      return null;
    }

    return $UserLookupResultCopyWith<$Res>(_value.lookedUpUser!, (value) {
      return _then(_value.copyWith(lookedUpUser: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FriendSearchStateImplCopyWith<$Res>
    implements $FriendSearchStateCopyWith<$Res> {
  factory _$$FriendSearchStateImplCopyWith(_$FriendSearchStateImpl value,
          $Res Function(_$FriendSearchStateImpl) then) =
      __$$FriendSearchStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<UserSearchResult> searchResults,
      List<UserSearchResult> suggestions,
      String searchQuery,
      SearchType searchType,
      bool isSearching,
      bool isLoadingSuggestions,
      bool isSendingFriendRequest,
      String? searchError,
      String? suggestionsError,
      String? friendRequestError,
      UserLookupResult? lookedUpUser,
      bool isLookingUpUser,
      String? lookupError});

  @override
  $UserLookupResultCopyWith<$Res>? get lookedUpUser;
}

/// @nodoc
class __$$FriendSearchStateImplCopyWithImpl<$Res>
    extends _$FriendSearchStateCopyWithImpl<$Res, _$FriendSearchStateImpl>
    implements _$$FriendSearchStateImplCopyWith<$Res> {
  __$$FriendSearchStateImplCopyWithImpl(_$FriendSearchStateImpl _value,
      $Res Function(_$FriendSearchStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of FriendSearchState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchResults = null,
    Object? suggestions = null,
    Object? searchQuery = null,
    Object? searchType = null,
    Object? isSearching = null,
    Object? isLoadingSuggestions = null,
    Object? isSendingFriendRequest = null,
    Object? searchError = freezed,
    Object? suggestionsError = freezed,
    Object? friendRequestError = freezed,
    Object? lookedUpUser = freezed,
    Object? isLookingUpUser = null,
    Object? lookupError = freezed,
  }) {
    return _then(_$FriendSearchStateImpl(
      searchResults: null == searchResults
          ? _value._searchResults
          : searchResults // ignore: cast_nullable_to_non_nullable
              as List<UserSearchResult>,
      suggestions: null == suggestions
          ? _value._suggestions
          : suggestions // ignore: cast_nullable_to_non_nullable
              as List<UserSearchResult>,
      searchQuery: null == searchQuery
          ? _value.searchQuery
          : searchQuery // ignore: cast_nullable_to_non_nullable
              as String,
      searchType: null == searchType
          ? _value.searchType
          : searchType // ignore: cast_nullable_to_non_nullable
              as SearchType,
      isSearching: null == isSearching
          ? _value.isSearching
          : isSearching // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoadingSuggestions: null == isLoadingSuggestions
          ? _value.isLoadingSuggestions
          : isLoadingSuggestions // ignore: cast_nullable_to_non_nullable
              as bool,
      isSendingFriendRequest: null == isSendingFriendRequest
          ? _value.isSendingFriendRequest
          : isSendingFriendRequest // ignore: cast_nullable_to_non_nullable
              as bool,
      searchError: freezed == searchError
          ? _value.searchError
          : searchError // ignore: cast_nullable_to_non_nullable
              as String?,
      suggestionsError: freezed == suggestionsError
          ? _value.suggestionsError
          : suggestionsError // ignore: cast_nullable_to_non_nullable
              as String?,
      friendRequestError: freezed == friendRequestError
          ? _value.friendRequestError
          : friendRequestError // ignore: cast_nullable_to_non_nullable
              as String?,
      lookedUpUser: freezed == lookedUpUser
          ? _value.lookedUpUser
          : lookedUpUser // ignore: cast_nullable_to_non_nullable
              as UserLookupResult?,
      isLookingUpUser: null == isLookingUpUser
          ? _value.isLookingUpUser
          : isLookingUpUser // ignore: cast_nullable_to_non_nullable
              as bool,
      lookupError: freezed == lookupError
          ? _value.lookupError
          : lookupError // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$FriendSearchStateImpl
    with DiagnosticableTreeMixin
    implements _FriendSearchState {
  const _$FriendSearchStateImpl(
      {final List<UserSearchResult> searchResults = const [],
      final List<UserSearchResult> suggestions = const [],
      this.searchQuery = '',
      this.searchType = SearchType.all,
      this.isSearching = false,
      this.isLoadingSuggestions = false,
      this.isSendingFriendRequest = false,
      this.searchError,
      this.suggestionsError,
      this.friendRequestError,
      this.lookedUpUser,
      this.isLookingUpUser = false,
      this.lookupError})
      : _searchResults = searchResults,
        _suggestions = suggestions;

  /// Current search results
  final List<UserSearchResult> _searchResults;

  /// Current search results
  @override
  @JsonKey()
  List<UserSearchResult> get searchResults {
    if (_searchResults is EqualUnmodifiableListView) return _searchResults;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_searchResults);
  }

  /// User suggestions
  final List<UserSearchResult> _suggestions;

  /// User suggestions
  @override
  @JsonKey()
  List<UserSearchResult> get suggestions {
    if (_suggestions is EqualUnmodifiableListView) return _suggestions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_suggestions);
  }

  /// Current search query
  @override
  @JsonKey()
  final String searchQuery;

  /// Search type filter
  @override
  @JsonKey()
  final SearchType searchType;

  /// Whether search is in progress
  @override
  @JsonKey()
  final bool isSearching;

  /// Whether suggestions are loading
  @override
  @JsonKey()
  final bool isLoadingSuggestions;

  /// Whether friend request is being sent
  @override
  @JsonKey()
  final bool isSendingFriendRequest;

  /// Current search error message
  @override
  final String? searchError;

  /// Current suggestions error message
  @override
  final String? suggestionsError;

  /// Friend request operation error
  @override
  final String? friendRequestError;

  /// Recently looked up user
  @override
  final UserLookupResult? lookedUpUser;

  /// Whether user lookup is in progress
  @override
  @JsonKey()
  final bool isLookingUpUser;

  /// User lookup error
  @override
  final String? lookupError;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'FriendSearchState(searchResults: $searchResults, suggestions: $suggestions, searchQuery: $searchQuery, searchType: $searchType, isSearching: $isSearching, isLoadingSuggestions: $isLoadingSuggestions, isSendingFriendRequest: $isSendingFriendRequest, searchError: $searchError, suggestionsError: $suggestionsError, friendRequestError: $friendRequestError, lookedUpUser: $lookedUpUser, isLookingUpUser: $isLookingUpUser, lookupError: $lookupError)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'FriendSearchState'))
      ..add(DiagnosticsProperty('searchResults', searchResults))
      ..add(DiagnosticsProperty('suggestions', suggestions))
      ..add(DiagnosticsProperty('searchQuery', searchQuery))
      ..add(DiagnosticsProperty('searchType', searchType))
      ..add(DiagnosticsProperty('isSearching', isSearching))
      ..add(DiagnosticsProperty('isLoadingSuggestions', isLoadingSuggestions))
      ..add(
          DiagnosticsProperty('isSendingFriendRequest', isSendingFriendRequest))
      ..add(DiagnosticsProperty('searchError', searchError))
      ..add(DiagnosticsProperty('suggestionsError', suggestionsError))
      ..add(DiagnosticsProperty('friendRequestError', friendRequestError))
      ..add(DiagnosticsProperty('lookedUpUser', lookedUpUser))
      ..add(DiagnosticsProperty('isLookingUpUser', isLookingUpUser))
      ..add(DiagnosticsProperty('lookupError', lookupError));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendSearchStateImpl &&
            const DeepCollectionEquality()
                .equals(other._searchResults, _searchResults) &&
            const DeepCollectionEquality()
                .equals(other._suggestions, _suggestions) &&
            (identical(other.searchQuery, searchQuery) ||
                other.searchQuery == searchQuery) &&
            (identical(other.searchType, searchType) ||
                other.searchType == searchType) &&
            (identical(other.isSearching, isSearching) ||
                other.isSearching == isSearching) &&
            (identical(other.isLoadingSuggestions, isLoadingSuggestions) ||
                other.isLoadingSuggestions == isLoadingSuggestions) &&
            (identical(other.isSendingFriendRequest, isSendingFriendRequest) ||
                other.isSendingFriendRequest == isSendingFriendRequest) &&
            (identical(other.searchError, searchError) ||
                other.searchError == searchError) &&
            (identical(other.suggestionsError, suggestionsError) ||
                other.suggestionsError == suggestionsError) &&
            (identical(other.friendRequestError, friendRequestError) ||
                other.friendRequestError == friendRequestError) &&
            (identical(other.lookedUpUser, lookedUpUser) ||
                other.lookedUpUser == lookedUpUser) &&
            (identical(other.isLookingUpUser, isLookingUpUser) ||
                other.isLookingUpUser == isLookingUpUser) &&
            (identical(other.lookupError, lookupError) ||
                other.lookupError == lookupError));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_searchResults),
      const DeepCollectionEquality().hash(_suggestions),
      searchQuery,
      searchType,
      isSearching,
      isLoadingSuggestions,
      isSendingFriendRequest,
      searchError,
      suggestionsError,
      friendRequestError,
      lookedUpUser,
      isLookingUpUser,
      lookupError);

  /// Create a copy of FriendSearchState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendSearchStateImplCopyWith<_$FriendSearchStateImpl> get copyWith =>
      __$$FriendSearchStateImplCopyWithImpl<_$FriendSearchStateImpl>(
          this, _$identity);
}

abstract class _FriendSearchState implements FriendSearchState {
  const factory _FriendSearchState(
      {final List<UserSearchResult> searchResults,
      final List<UserSearchResult> suggestions,
      final String searchQuery,
      final SearchType searchType,
      final bool isSearching,
      final bool isLoadingSuggestions,
      final bool isSendingFriendRequest,
      final String? searchError,
      final String? suggestionsError,
      final String? friendRequestError,
      final UserLookupResult? lookedUpUser,
      final bool isLookingUpUser,
      final String? lookupError}) = _$FriendSearchStateImpl;

  /// Current search results
  @override
  List<UserSearchResult> get searchResults;

  /// User suggestions
  @override
  List<UserSearchResult> get suggestions;

  /// Current search query
  @override
  String get searchQuery;

  /// Search type filter
  @override
  SearchType get searchType;

  /// Whether search is in progress
  @override
  bool get isSearching;

  /// Whether suggestions are loading
  @override
  bool get isLoadingSuggestions;

  /// Whether friend request is being sent
  @override
  bool get isSendingFriendRequest;

  /// Current search error message
  @override
  String? get searchError;

  /// Current suggestions error message
  @override
  String? get suggestionsError;

  /// Friend request operation error
  @override
  String? get friendRequestError;

  /// Recently looked up user
  @override
  UserLookupResult? get lookedUpUser;

  /// Whether user lookup is in progress
  @override
  bool get isLookingUpUser;

  /// User lookup error
  @override
  String? get lookupError;

  /// Create a copy of FriendSearchState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendSearchStateImplCopyWith<_$FriendSearchStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
