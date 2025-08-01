// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'book_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Book _$BookFromJson(Map<String, dynamic> json) {
  return _Book.fromJson(json);
}

/// @nodoc
mixin _$Book {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  String get coverEmoji => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get durationHours => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  bool get isPremium => throw _privateConstructorUsedError;
  BookComfortLevel get comfortLevel => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  bool get isAvailableForParallel => throw _privateConstructorUsedError;
  String? get partnerReadingWith => throw _privateConstructorUsedError;
  List<String> get genres => throw _privateConstructorUsedError;

  /// Serializes this Book to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookCopyWith<Book> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookCopyWith<$Res> {
  factory $BookCopyWith(Book value, $Res Function(Book) then) =
      _$BookCopyWithImpl<$Res, Book>;
  @useResult
  $Res call({
    String id,
    String title,
    String author,
    String coverEmoji,
    double rating,
    int durationHours,
    List<String> tags,
    bool isPremium,
    BookComfortLevel comfortLevel,
    String description,
    int totalPages,
    int currentPage,
    bool isAvailableForParallel,
    String? partnerReadingWith,
    List<String> genres,
  });
}

/// @nodoc
class _$BookCopyWithImpl<$Res, $Val extends Book>
    implements $BookCopyWith<$Res> {
  _$BookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? author = null,
    Object? coverEmoji = null,
    Object? rating = null,
    Object? durationHours = null,
    Object? tags = null,
    Object? isPremium = null,
    Object? comfortLevel = null,
    Object? description = null,
    Object? totalPages = null,
    Object? currentPage = null,
    Object? isAvailableForParallel = null,
    Object? partnerReadingWith = freezed,
    Object? genres = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            author: null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as String,
            coverEmoji: null == coverEmoji
                ? _value.coverEmoji
                : coverEmoji // ignore: cast_nullable_to_non_nullable
                      as String,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            durationHours: null == durationHours
                ? _value.durationHours
                : durationHours // ignore: cast_nullable_to_non_nullable
                      as int,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isPremium: null == isPremium
                ? _value.isPremium
                : isPremium // ignore: cast_nullable_to_non_nullable
                      as bool,
            comfortLevel: null == comfortLevel
                ? _value.comfortLevel
                : comfortLevel // ignore: cast_nullable_to_non_nullable
                      as BookComfortLevel,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            isAvailableForParallel: null == isAvailableForParallel
                ? _value.isAvailableForParallel
                : isAvailableForParallel // ignore: cast_nullable_to_non_nullable
                      as bool,
            partnerReadingWith: freezed == partnerReadingWith
                ? _value.partnerReadingWith
                : partnerReadingWith // ignore: cast_nullable_to_non_nullable
                      as String?,
            genres: null == genres
                ? _value.genres
                : genres // ignore: cast_nullable_to_non_nullable
                      as List<String>,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookImplCopyWith<$Res> implements $BookCopyWith<$Res> {
  factory _$$BookImplCopyWith(
    _$BookImpl value,
    $Res Function(_$BookImpl) then,
  ) = __$$BookImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String author,
    String coverEmoji,
    double rating,
    int durationHours,
    List<String> tags,
    bool isPremium,
    BookComfortLevel comfortLevel,
    String description,
    int totalPages,
    int currentPage,
    bool isAvailableForParallel,
    String? partnerReadingWith,
    List<String> genres,
  });
}

/// @nodoc
class __$$BookImplCopyWithImpl<$Res>
    extends _$BookCopyWithImpl<$Res, _$BookImpl>
    implements _$$BookImplCopyWith<$Res> {
  __$$BookImplCopyWithImpl(_$BookImpl _value, $Res Function(_$BookImpl) _then)
    : super(_value, _then);

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? author = null,
    Object? coverEmoji = null,
    Object? rating = null,
    Object? durationHours = null,
    Object? tags = null,
    Object? isPremium = null,
    Object? comfortLevel = null,
    Object? description = null,
    Object? totalPages = null,
    Object? currentPage = null,
    Object? isAvailableForParallel = null,
    Object? partnerReadingWith = freezed,
    Object? genres = null,
  }) {
    return _then(
      _$BookImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as String,
        coverEmoji: null == coverEmoji
            ? _value.coverEmoji
            : coverEmoji // ignore: cast_nullable_to_non_nullable
                  as String,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        durationHours: null == durationHours
            ? _value.durationHours
            : durationHours // ignore: cast_nullable_to_non_nullable
                  as int,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isPremium: null == isPremium
            ? _value.isPremium
            : isPremium // ignore: cast_nullable_to_non_nullable
                  as bool,
        comfortLevel: null == comfortLevel
            ? _value.comfortLevel
            : comfortLevel // ignore: cast_nullable_to_non_nullable
                  as BookComfortLevel,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        isAvailableForParallel: null == isAvailableForParallel
            ? _value.isAvailableForParallel
            : isAvailableForParallel // ignore: cast_nullable_to_non_nullable
                  as bool,
        partnerReadingWith: freezed == partnerReadingWith
            ? _value.partnerReadingWith
            : partnerReadingWith // ignore: cast_nullable_to_non_nullable
                  as String?,
        genres: null == genres
            ? _value._genres
            : genres // ignore: cast_nullable_to_non_nullable
                  as List<String>,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookImpl implements _Book {
  const _$BookImpl({
    required this.id,
    required this.title,
    required this.author,
    required this.coverEmoji,
    required this.rating,
    required this.durationHours,
    required final List<String> tags,
    required this.isPremium,
    required this.comfortLevel,
    this.description = '',
    this.totalPages = 0,
    this.currentPage = 0,
    this.isAvailableForParallel = false,
    this.partnerReadingWith = null,
    final List<String> genres = const [],
  }) : _tags = tags,
       _genres = genres;

  factory _$BookImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String author;
  @override
  final String coverEmoji;
  @override
  final double rating;
  @override
  final int durationHours;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final bool isPremium;
  @override
  final BookComfortLevel comfortLevel;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final int totalPages;
  @override
  @JsonKey()
  final int currentPage;
  @override
  @JsonKey()
  final bool isAvailableForParallel;
  @override
  @JsonKey()
  final String? partnerReadingWith;
  final List<String> _genres;
  @override
  @JsonKey()
  List<String> get genres {
    if (_genres is EqualUnmodifiableListView) return _genres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genres);
  }

  @override
  String toString() {
    return 'Book(id: $id, title: $title, author: $author, coverEmoji: $coverEmoji, rating: $rating, durationHours: $durationHours, tags: $tags, isPremium: $isPremium, comfortLevel: $comfortLevel, description: $description, totalPages: $totalPages, currentPage: $currentPage, isAvailableForParallel: $isAvailableForParallel, partnerReadingWith: $partnerReadingWith, genres: $genres)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.coverEmoji, coverEmoji) ||
                other.coverEmoji == coverEmoji) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.durationHours, durationHours) ||
                other.durationHours == durationHours) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.isPremium, isPremium) ||
                other.isPremium == isPremium) &&
            (identical(other.comfortLevel, comfortLevel) ||
                other.comfortLevel == comfortLevel) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.isAvailableForParallel, isAvailableForParallel) ||
                other.isAvailableForParallel == isAvailableForParallel) &&
            (identical(other.partnerReadingWith, partnerReadingWith) ||
                other.partnerReadingWith == partnerReadingWith) &&
            const DeepCollectionEquality().equals(other._genres, _genres));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    author,
    coverEmoji,
    rating,
    durationHours,
    const DeepCollectionEquality().hash(_tags),
    isPremium,
    comfortLevel,
    description,
    totalPages,
    currentPage,
    isAvailableForParallel,
    partnerReadingWith,
    const DeepCollectionEquality().hash(_genres),
  );

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookImplCopyWith<_$BookImpl> get copyWith =>
      __$$BookImplCopyWithImpl<_$BookImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BookImplToJson(this);
  }
}

abstract class _Book implements Book {
  const factory _Book({
    required final String id,
    required final String title,
    required final String author,
    required final String coverEmoji,
    required final double rating,
    required final int durationHours,
    required final List<String> tags,
    required final bool isPremium,
    required final BookComfortLevel comfortLevel,
    final String description,
    final int totalPages,
    final int currentPage,
    final bool isAvailableForParallel,
    final String? partnerReadingWith,
    final List<String> genres,
  }) = _$BookImpl;

  factory _Book.fromJson(Map<String, dynamic> json) = _$BookImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get author;
  @override
  String get coverEmoji;
  @override
  double get rating;
  @override
  int get durationHours;
  @override
  List<String> get tags;
  @override
  bool get isPremium;
  @override
  BookComfortLevel get comfortLevel;
  @override
  String get description;
  @override
  int get totalPages;
  @override
  int get currentPage;
  @override
  bool get isAvailableForParallel;
  @override
  String? get partnerReadingWith;
  @override
  List<String> get genres;

  /// Create a copy of Book
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookImplCopyWith<_$BookImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReadingProgress _$ReadingProgressFromJson(Map<String, dynamic> json) {
  return _ReadingProgress.fromJson(json);
}

/// @nodoc
mixin _$ReadingProgress {
  String get bookId => throw _privateConstructorUsedError;
  String get bookTitle => throw _privateConstructorUsedError;
  String get bookAuthor => throw _privateConstructorUsedError;
  String get coverEmoji => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  int get totalPages => throw _privateConstructorUsedError;
  int get currentChapter => throw _privateConstructorUsedError;
  int get totalChapters => throw _privateConstructorUsedError;
  ReadingMood get mood => throw _privateConstructorUsedError;
  int get minutesLeft => throw _privateConstructorUsedError;
  int get readingStreak => throw _privateConstructorUsedError;
  ReadingPartner? get partner => throw _privateConstructorUsedError;
  bool get isSynced => throw _privateConstructorUsedError;
  String get lastReadAt => throw _privateConstructorUsedError;

  /// Serializes this ReadingProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReadingProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReadingProgressCopyWith<ReadingProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadingProgressCopyWith<$Res> {
  factory $ReadingProgressCopyWith(
    ReadingProgress value,
    $Res Function(ReadingProgress) then,
  ) = _$ReadingProgressCopyWithImpl<$Res, ReadingProgress>;
  @useResult
  $Res call({
    String bookId,
    String bookTitle,
    String bookAuthor,
    String coverEmoji,
    int currentPage,
    int totalPages,
    int currentChapter,
    int totalChapters,
    ReadingMood mood,
    int minutesLeft,
    int readingStreak,
    ReadingPartner? partner,
    bool isSynced,
    String lastReadAt,
  });

  $ReadingPartnerCopyWith<$Res>? get partner;
}

/// @nodoc
class _$ReadingProgressCopyWithImpl<$Res, $Val extends ReadingProgress>
    implements $ReadingProgressCopyWith<$Res> {
  _$ReadingProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReadingProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookId = null,
    Object? bookTitle = null,
    Object? bookAuthor = null,
    Object? coverEmoji = null,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? currentChapter = null,
    Object? totalChapters = null,
    Object? mood = null,
    Object? minutesLeft = null,
    Object? readingStreak = null,
    Object? partner = freezed,
    Object? isSynced = null,
    Object? lastReadAt = null,
  }) {
    return _then(
      _value.copyWith(
            bookId: null == bookId
                ? _value.bookId
                : bookId // ignore: cast_nullable_to_non_nullable
                      as String,
            bookTitle: null == bookTitle
                ? _value.bookTitle
                : bookTitle // ignore: cast_nullable_to_non_nullable
                      as String,
            bookAuthor: null == bookAuthor
                ? _value.bookAuthor
                : bookAuthor // ignore: cast_nullable_to_non_nullable
                      as String,
            coverEmoji: null == coverEmoji
                ? _value.coverEmoji
                : coverEmoji // ignore: cast_nullable_to_non_nullable
                      as String,
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            totalPages: null == totalPages
                ? _value.totalPages
                : totalPages // ignore: cast_nullable_to_non_nullable
                      as int,
            currentChapter: null == currentChapter
                ? _value.currentChapter
                : currentChapter // ignore: cast_nullable_to_non_nullable
                      as int,
            totalChapters: null == totalChapters
                ? _value.totalChapters
                : totalChapters // ignore: cast_nullable_to_non_nullable
                      as int,
            mood: null == mood
                ? _value.mood
                : mood // ignore: cast_nullable_to_non_nullable
                      as ReadingMood,
            minutesLeft: null == minutesLeft
                ? _value.minutesLeft
                : minutesLeft // ignore: cast_nullable_to_non_nullable
                      as int,
            readingStreak: null == readingStreak
                ? _value.readingStreak
                : readingStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            partner: freezed == partner
                ? _value.partner
                : partner // ignore: cast_nullable_to_non_nullable
                      as ReadingPartner?,
            isSynced: null == isSynced
                ? _value.isSynced
                : isSynced // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastReadAt: null == lastReadAt
                ? _value.lastReadAt
                : lastReadAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }

  /// Create a copy of ReadingProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ReadingPartnerCopyWith<$Res>? get partner {
    if (_value.partner == null) {
      return null;
    }

    return $ReadingPartnerCopyWith<$Res>(_value.partner!, (value) {
      return _then(_value.copyWith(partner: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ReadingProgressImplCopyWith<$Res>
    implements $ReadingProgressCopyWith<$Res> {
  factory _$$ReadingProgressImplCopyWith(
    _$ReadingProgressImpl value,
    $Res Function(_$ReadingProgressImpl) then,
  ) = __$$ReadingProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String bookId,
    String bookTitle,
    String bookAuthor,
    String coverEmoji,
    int currentPage,
    int totalPages,
    int currentChapter,
    int totalChapters,
    ReadingMood mood,
    int minutesLeft,
    int readingStreak,
    ReadingPartner? partner,
    bool isSynced,
    String lastReadAt,
  });

  @override
  $ReadingPartnerCopyWith<$Res>? get partner;
}

/// @nodoc
class __$$ReadingProgressImplCopyWithImpl<$Res>
    extends _$ReadingProgressCopyWithImpl<$Res, _$ReadingProgressImpl>
    implements _$$ReadingProgressImplCopyWith<$Res> {
  __$$ReadingProgressImplCopyWithImpl(
    _$ReadingProgressImpl _value,
    $Res Function(_$ReadingProgressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReadingProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookId = null,
    Object? bookTitle = null,
    Object? bookAuthor = null,
    Object? coverEmoji = null,
    Object? currentPage = null,
    Object? totalPages = null,
    Object? currentChapter = null,
    Object? totalChapters = null,
    Object? mood = null,
    Object? minutesLeft = null,
    Object? readingStreak = null,
    Object? partner = freezed,
    Object? isSynced = null,
    Object? lastReadAt = null,
  }) {
    return _then(
      _$ReadingProgressImpl(
        bookId: null == bookId
            ? _value.bookId
            : bookId // ignore: cast_nullable_to_non_nullable
                  as String,
        bookTitle: null == bookTitle
            ? _value.bookTitle
            : bookTitle // ignore: cast_nullable_to_non_nullable
                  as String,
        bookAuthor: null == bookAuthor
            ? _value.bookAuthor
            : bookAuthor // ignore: cast_nullable_to_non_nullable
                  as String,
        coverEmoji: null == coverEmoji
            ? _value.coverEmoji
            : coverEmoji // ignore: cast_nullable_to_non_nullable
                  as String,
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        totalPages: null == totalPages
            ? _value.totalPages
            : totalPages // ignore: cast_nullable_to_non_nullable
                  as int,
        currentChapter: null == currentChapter
            ? _value.currentChapter
            : currentChapter // ignore: cast_nullable_to_non_nullable
                  as int,
        totalChapters: null == totalChapters
            ? _value.totalChapters
            : totalChapters // ignore: cast_nullable_to_non_nullable
                  as int,
        mood: null == mood
            ? _value.mood
            : mood // ignore: cast_nullable_to_non_nullable
                  as ReadingMood,
        minutesLeft: null == minutesLeft
            ? _value.minutesLeft
            : minutesLeft // ignore: cast_nullable_to_non_nullable
                  as int,
        readingStreak: null == readingStreak
            ? _value.readingStreak
            : readingStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        partner: freezed == partner
            ? _value.partner
            : partner // ignore: cast_nullable_to_non_nullable
                  as ReadingPartner?,
        isSynced: null == isSynced
            ? _value.isSynced
            : isSynced // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastReadAt: null == lastReadAt
            ? _value.lastReadAt
            : lastReadAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReadingProgressImpl implements _ReadingProgress {
  const _$ReadingProgressImpl({
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
    required this.coverEmoji,
    required this.currentPage,
    required this.totalPages,
    required this.currentChapter,
    required this.totalChapters,
    required this.mood,
    required this.minutesLeft,
    required this.readingStreak,
    this.partner = null,
    this.isSynced = true,
    this.lastReadAt = '',
  });

  factory _$ReadingProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReadingProgressImplFromJson(json);

  @override
  final String bookId;
  @override
  final String bookTitle;
  @override
  final String bookAuthor;
  @override
  final String coverEmoji;
  @override
  final int currentPage;
  @override
  final int totalPages;
  @override
  final int currentChapter;
  @override
  final int totalChapters;
  @override
  final ReadingMood mood;
  @override
  final int minutesLeft;
  @override
  final int readingStreak;
  @override
  @JsonKey()
  final ReadingPartner? partner;
  @override
  @JsonKey()
  final bool isSynced;
  @override
  @JsonKey()
  final String lastReadAt;

  @override
  String toString() {
    return 'ReadingProgress(bookId: $bookId, bookTitle: $bookTitle, bookAuthor: $bookAuthor, coverEmoji: $coverEmoji, currentPage: $currentPage, totalPages: $totalPages, currentChapter: $currentChapter, totalChapters: $totalChapters, mood: $mood, minutesLeft: $minutesLeft, readingStreak: $readingStreak, partner: $partner, isSynced: $isSynced, lastReadAt: $lastReadAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadingProgressImpl &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.bookAuthor, bookAuthor) ||
                other.bookAuthor == bookAuthor) &&
            (identical(other.coverEmoji, coverEmoji) ||
                other.coverEmoji == coverEmoji) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.totalPages, totalPages) ||
                other.totalPages == totalPages) &&
            (identical(other.currentChapter, currentChapter) ||
                other.currentChapter == currentChapter) &&
            (identical(other.totalChapters, totalChapters) ||
                other.totalChapters == totalChapters) &&
            (identical(other.mood, mood) || other.mood == mood) &&
            (identical(other.minutesLeft, minutesLeft) ||
                other.minutesLeft == minutesLeft) &&
            (identical(other.readingStreak, readingStreak) ||
                other.readingStreak == readingStreak) &&
            (identical(other.partner, partner) || other.partner == partner) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced) &&
            (identical(other.lastReadAt, lastReadAt) ||
                other.lastReadAt == lastReadAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    bookId,
    bookTitle,
    bookAuthor,
    coverEmoji,
    currentPage,
    totalPages,
    currentChapter,
    totalChapters,
    mood,
    minutesLeft,
    readingStreak,
    partner,
    isSynced,
    lastReadAt,
  );

  /// Create a copy of ReadingProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadingProgressImplCopyWith<_$ReadingProgressImpl> get copyWith =>
      __$$ReadingProgressImplCopyWithImpl<_$ReadingProgressImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReadingProgressImplToJson(this);
  }
}

abstract class _ReadingProgress implements ReadingProgress {
  const factory _ReadingProgress({
    required final String bookId,
    required final String bookTitle,
    required final String bookAuthor,
    required final String coverEmoji,
    required final int currentPage,
    required final int totalPages,
    required final int currentChapter,
    required final int totalChapters,
    required final ReadingMood mood,
    required final int minutesLeft,
    required final int readingStreak,
    final ReadingPartner? partner,
    final bool isSynced,
    final String lastReadAt,
  }) = _$ReadingProgressImpl;

  factory _ReadingProgress.fromJson(Map<String, dynamic> json) =
      _$ReadingProgressImpl.fromJson;

  @override
  String get bookId;
  @override
  String get bookTitle;
  @override
  String get bookAuthor;
  @override
  String get coverEmoji;
  @override
  int get currentPage;
  @override
  int get totalPages;
  @override
  int get currentChapter;
  @override
  int get totalChapters;
  @override
  ReadingMood get mood;
  @override
  int get minutesLeft;
  @override
  int get readingStreak;
  @override
  ReadingPartner? get partner;
  @override
  bool get isSynced;
  @override
  String get lastReadAt;

  /// Create a copy of ReadingProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadingProgressImplCopyWith<_$ReadingProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReadingPartner _$ReadingPartnerFromJson(Map<String, dynamic> json) {
  return _ReadingPartner.fromJson(json);
}

/// @nodoc
mixin _$ReadingPartner {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get avatarInitial => throw _privateConstructorUsedError;
  int get currentPage => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  String get lastActiveAt => throw _privateConstructorUsedError;

  /// Serializes this ReadingPartner to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReadingPartner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReadingPartnerCopyWith<ReadingPartner> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadingPartnerCopyWith<$Res> {
  factory $ReadingPartnerCopyWith(
    ReadingPartner value,
    $Res Function(ReadingPartner) then,
  ) = _$ReadingPartnerCopyWithImpl<$Res, ReadingPartner>;
  @useResult
  $Res call({
    String id,
    String name,
    String avatarInitial,
    int currentPage,
    bool isOnline,
    String lastActiveAt,
  });
}

/// @nodoc
class _$ReadingPartnerCopyWithImpl<$Res, $Val extends ReadingPartner>
    implements $ReadingPartnerCopyWith<$Res> {
  _$ReadingPartnerCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReadingPartner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarInitial = null,
    Object? currentPage = null,
    Object? isOnline = null,
    Object? lastActiveAt = null,
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
            avatarInitial: null == avatarInitial
                ? _value.avatarInitial
                : avatarInitial // ignore: cast_nullable_to_non_nullable
                      as String,
            currentPage: null == currentPage
                ? _value.currentPage
                : currentPage // ignore: cast_nullable_to_non_nullable
                      as int,
            isOnline: null == isOnline
                ? _value.isOnline
                : isOnline // ignore: cast_nullable_to_non_nullable
                      as bool,
            lastActiveAt: null == lastActiveAt
                ? _value.lastActiveAt
                : lastActiveAt // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReadingPartnerImplCopyWith<$Res>
    implements $ReadingPartnerCopyWith<$Res> {
  factory _$$ReadingPartnerImplCopyWith(
    _$ReadingPartnerImpl value,
    $Res Function(_$ReadingPartnerImpl) then,
  ) = __$$ReadingPartnerImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String avatarInitial,
    int currentPage,
    bool isOnline,
    String lastActiveAt,
  });
}

/// @nodoc
class __$$ReadingPartnerImplCopyWithImpl<$Res>
    extends _$ReadingPartnerCopyWithImpl<$Res, _$ReadingPartnerImpl>
    implements _$$ReadingPartnerImplCopyWith<$Res> {
  __$$ReadingPartnerImplCopyWithImpl(
    _$ReadingPartnerImpl _value,
    $Res Function(_$ReadingPartnerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReadingPartner
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? avatarInitial = null,
    Object? currentPage = null,
    Object? isOnline = null,
    Object? lastActiveAt = null,
  }) {
    return _then(
      _$ReadingPartnerImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarInitial: null == avatarInitial
            ? _value.avatarInitial
            : avatarInitial // ignore: cast_nullable_to_non_nullable
                  as String,
        currentPage: null == currentPage
            ? _value.currentPage
            : currentPage // ignore: cast_nullable_to_non_nullable
                  as int,
        isOnline: null == isOnline
            ? _value.isOnline
            : isOnline // ignore: cast_nullable_to_non_nullable
                  as bool,
        lastActiveAt: null == lastActiveAt
            ? _value.lastActiveAt
            : lastActiveAt // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReadingPartnerImpl implements _ReadingPartner {
  const _$ReadingPartnerImpl({
    required this.id,
    required this.name,
    required this.avatarInitial,
    required this.currentPage,
    required this.isOnline,
    this.lastActiveAt = '',
  });

  factory _$ReadingPartnerImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReadingPartnerImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String avatarInitial;
  @override
  final int currentPage;
  @override
  final bool isOnline;
  @override
  @JsonKey()
  final String lastActiveAt;

  @override
  String toString() {
    return 'ReadingPartner(id: $id, name: $name, avatarInitial: $avatarInitial, currentPage: $currentPage, isOnline: $isOnline, lastActiveAt: $lastActiveAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadingPartnerImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.avatarInitial, avatarInitial) ||
                other.avatarInitial == avatarInitial) &&
            (identical(other.currentPage, currentPage) ||
                other.currentPage == currentPage) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.lastActiveAt, lastActiveAt) ||
                other.lastActiveAt == lastActiveAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    avatarInitial,
    currentPage,
    isOnline,
    lastActiveAt,
  );

  /// Create a copy of ReadingPartner
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadingPartnerImplCopyWith<_$ReadingPartnerImpl> get copyWith =>
      __$$ReadingPartnerImplCopyWithImpl<_$ReadingPartnerImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReadingPartnerImplToJson(this);
  }
}

abstract class _ReadingPartner implements ReadingPartner {
  const factory _ReadingPartner({
    required final String id,
    required final String name,
    required final String avatarInitial,
    required final int currentPage,
    required final bool isOnline,
    final String lastActiveAt,
  }) = _$ReadingPartnerImpl;

  factory _ReadingPartner.fromJson(Map<String, dynamic> json) =
      _$ReadingPartnerImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get avatarInitial;
  @override
  int get currentPage;
  @override
  bool get isOnline;
  @override
  String get lastActiveAt;

  /// Create a copy of ReadingPartner
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadingPartnerImplCopyWith<_$ReadingPartnerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

FriendReading _$FriendReadingFromJson(Map<String, dynamic> json) {
  return _FriendReading.fromJson(json);
}

/// @nodoc
mixin _$FriendReading {
  String get friendId => throw _privateConstructorUsedError;
  String get friendName => throw _privateConstructorUsedError;
  String get avatarInitial => throw _privateConstructorUsedError;
  String get bookTitle => throw _privateConstructorUsedError;
  String get bookAuthor => throw _privateConstructorUsedError;
  String get currentChapter => throw _privateConstructorUsedError;
  FriendActivityStatus get status => throw _privateConstructorUsedError;
  String get timeAgo => throw _privateConstructorUsedError;
  bool get isOpenForPartners => throw _privateConstructorUsedError;
  bool get canJoin => throw _privateConstructorUsedError;

  /// Serializes this FriendReading to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FriendReading
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FriendReadingCopyWith<FriendReading> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendReadingCopyWith<$Res> {
  factory $FriendReadingCopyWith(
    FriendReading value,
    $Res Function(FriendReading) then,
  ) = _$FriendReadingCopyWithImpl<$Res, FriendReading>;
  @useResult
  $Res call({
    String friendId,
    String friendName,
    String avatarInitial,
    String bookTitle,
    String bookAuthor,
    String currentChapter,
    FriendActivityStatus status,
    String timeAgo,
    bool isOpenForPartners,
    bool canJoin,
  });
}

/// @nodoc
class _$FriendReadingCopyWithImpl<$Res, $Val extends FriendReading>
    implements $FriendReadingCopyWith<$Res> {
  _$FriendReadingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FriendReading
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friendId = null,
    Object? friendName = null,
    Object? avatarInitial = null,
    Object? bookTitle = null,
    Object? bookAuthor = null,
    Object? currentChapter = null,
    Object? status = null,
    Object? timeAgo = null,
    Object? isOpenForPartners = null,
    Object? canJoin = null,
  }) {
    return _then(
      _value.copyWith(
            friendId: null == friendId
                ? _value.friendId
                : friendId // ignore: cast_nullable_to_non_nullable
                      as String,
            friendName: null == friendName
                ? _value.friendName
                : friendName // ignore: cast_nullable_to_non_nullable
                      as String,
            avatarInitial: null == avatarInitial
                ? _value.avatarInitial
                : avatarInitial // ignore: cast_nullable_to_non_nullable
                      as String,
            bookTitle: null == bookTitle
                ? _value.bookTitle
                : bookTitle // ignore: cast_nullable_to_non_nullable
                      as String,
            bookAuthor: null == bookAuthor
                ? _value.bookAuthor
                : bookAuthor // ignore: cast_nullable_to_non_nullable
                      as String,
            currentChapter: null == currentChapter
                ? _value.currentChapter
                : currentChapter // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as FriendActivityStatus,
            timeAgo: null == timeAgo
                ? _value.timeAgo
                : timeAgo // ignore: cast_nullable_to_non_nullable
                      as String,
            isOpenForPartners: null == isOpenForPartners
                ? _value.isOpenForPartners
                : isOpenForPartners // ignore: cast_nullable_to_non_nullable
                      as bool,
            canJoin: null == canJoin
                ? _value.canJoin
                : canJoin // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$FriendReadingImplCopyWith<$Res>
    implements $FriendReadingCopyWith<$Res> {
  factory _$$FriendReadingImplCopyWith(
    _$FriendReadingImpl value,
    $Res Function(_$FriendReadingImpl) then,
  ) = __$$FriendReadingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String friendId,
    String friendName,
    String avatarInitial,
    String bookTitle,
    String bookAuthor,
    String currentChapter,
    FriendActivityStatus status,
    String timeAgo,
    bool isOpenForPartners,
    bool canJoin,
  });
}

/// @nodoc
class __$$FriendReadingImplCopyWithImpl<$Res>
    extends _$FriendReadingCopyWithImpl<$Res, _$FriendReadingImpl>
    implements _$$FriendReadingImplCopyWith<$Res> {
  __$$FriendReadingImplCopyWithImpl(
    _$FriendReadingImpl _value,
    $Res Function(_$FriendReadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of FriendReading
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? friendId = null,
    Object? friendName = null,
    Object? avatarInitial = null,
    Object? bookTitle = null,
    Object? bookAuthor = null,
    Object? currentChapter = null,
    Object? status = null,
    Object? timeAgo = null,
    Object? isOpenForPartners = null,
    Object? canJoin = null,
  }) {
    return _then(
      _$FriendReadingImpl(
        friendId: null == friendId
            ? _value.friendId
            : friendId // ignore: cast_nullable_to_non_nullable
                  as String,
        friendName: null == friendName
            ? _value.friendName
            : friendName // ignore: cast_nullable_to_non_nullable
                  as String,
        avatarInitial: null == avatarInitial
            ? _value.avatarInitial
            : avatarInitial // ignore: cast_nullable_to_non_nullable
                  as String,
        bookTitle: null == bookTitle
            ? _value.bookTitle
            : bookTitle // ignore: cast_nullable_to_non_nullable
                  as String,
        bookAuthor: null == bookAuthor
            ? _value.bookAuthor
            : bookAuthor // ignore: cast_nullable_to_non_nullable
                  as String,
        currentChapter: null == currentChapter
            ? _value.currentChapter
            : currentChapter // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as FriendActivityStatus,
        timeAgo: null == timeAgo
            ? _value.timeAgo
            : timeAgo // ignore: cast_nullable_to_non_nullable
                  as String,
        isOpenForPartners: null == isOpenForPartners
            ? _value.isOpenForPartners
            : isOpenForPartners // ignore: cast_nullable_to_non_nullable
                  as bool,
        canJoin: null == canJoin
            ? _value.canJoin
            : canJoin // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FriendReadingImpl implements _FriendReading {
  const _$FriendReadingImpl({
    required this.friendId,
    required this.friendName,
    required this.avatarInitial,
    required this.bookTitle,
    required this.bookAuthor,
    required this.currentChapter,
    required this.status,
    required this.timeAgo,
    required this.isOpenForPartners,
    this.canJoin = false,
  });

  factory _$FriendReadingImpl.fromJson(Map<String, dynamic> json) =>
      _$$FriendReadingImplFromJson(json);

  @override
  final String friendId;
  @override
  final String friendName;
  @override
  final String avatarInitial;
  @override
  final String bookTitle;
  @override
  final String bookAuthor;
  @override
  final String currentChapter;
  @override
  final FriendActivityStatus status;
  @override
  final String timeAgo;
  @override
  final bool isOpenForPartners;
  @override
  @JsonKey()
  final bool canJoin;

  @override
  String toString() {
    return 'FriendReading(friendId: $friendId, friendName: $friendName, avatarInitial: $avatarInitial, bookTitle: $bookTitle, bookAuthor: $bookAuthor, currentChapter: $currentChapter, status: $status, timeAgo: $timeAgo, isOpenForPartners: $isOpenForPartners, canJoin: $canJoin)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FriendReadingImpl &&
            (identical(other.friendId, friendId) ||
                other.friendId == friendId) &&
            (identical(other.friendName, friendName) ||
                other.friendName == friendName) &&
            (identical(other.avatarInitial, avatarInitial) ||
                other.avatarInitial == avatarInitial) &&
            (identical(other.bookTitle, bookTitle) ||
                other.bookTitle == bookTitle) &&
            (identical(other.bookAuthor, bookAuthor) ||
                other.bookAuthor == bookAuthor) &&
            (identical(other.currentChapter, currentChapter) ||
                other.currentChapter == currentChapter) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.timeAgo, timeAgo) || other.timeAgo == timeAgo) &&
            (identical(other.isOpenForPartners, isOpenForPartners) ||
                other.isOpenForPartners == isOpenForPartners) &&
            (identical(other.canJoin, canJoin) || other.canJoin == canJoin));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    friendId,
    friendName,
    avatarInitial,
    bookTitle,
    bookAuthor,
    currentChapter,
    status,
    timeAgo,
    isOpenForPartners,
    canJoin,
  );

  /// Create a copy of FriendReading
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FriendReadingImplCopyWith<_$FriendReadingImpl> get copyWith =>
      __$$FriendReadingImplCopyWithImpl<_$FriendReadingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FriendReadingImplToJson(this);
  }
}

abstract class _FriendReading implements FriendReading {
  const factory _FriendReading({
    required final String friendId,
    required final String friendName,
    required final String avatarInitial,
    required final String bookTitle,
    required final String bookAuthor,
    required final String currentChapter,
    required final FriendActivityStatus status,
    required final String timeAgo,
    required final bool isOpenForPartners,
    final bool canJoin,
  }) = _$FriendReadingImpl;

  factory _FriendReading.fromJson(Map<String, dynamic> json) =
      _$FriendReadingImpl.fromJson;

  @override
  String get friendId;
  @override
  String get friendName;
  @override
  String get avatarInitial;
  @override
  String get bookTitle;
  @override
  String get bookAuthor;
  @override
  String get currentChapter;
  @override
  FriendActivityStatus get status;
  @override
  String get timeAgo;
  @override
  bool get isOpenForPartners;
  @override
  bool get canJoin;

  /// Create a copy of FriendReading
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FriendReadingImplCopyWith<_$FriendReadingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BookRecommendation _$BookRecommendationFromJson(Map<String, dynamic> json) {
  return _BookRecommendation.fromJson(json);
}

/// @nodoc
mixin _$BookRecommendation {
  String get bookId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get author => throw _privateConstructorUsedError;
  String get reason => throw _privateConstructorUsedError;
  double get confidenceScore => throw _privateConstructorUsedError;
  String get basedOn => throw _privateConstructorUsedError;
  String get coverEmoji => throw _privateConstructorUsedError;

  /// Serializes this BookRecommendation to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BookRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BookRecommendationCopyWith<BookRecommendation> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BookRecommendationCopyWith<$Res> {
  factory $BookRecommendationCopyWith(
    BookRecommendation value,
    $Res Function(BookRecommendation) then,
  ) = _$BookRecommendationCopyWithImpl<$Res, BookRecommendation>;
  @useResult
  $Res call({
    String bookId,
    String title,
    String author,
    String reason,
    double confidenceScore,
    String basedOn,
    String coverEmoji,
  });
}

/// @nodoc
class _$BookRecommendationCopyWithImpl<$Res, $Val extends BookRecommendation>
    implements $BookRecommendationCopyWith<$Res> {
  _$BookRecommendationCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BookRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookId = null,
    Object? title = null,
    Object? author = null,
    Object? reason = null,
    Object? confidenceScore = null,
    Object? basedOn = null,
    Object? coverEmoji = null,
  }) {
    return _then(
      _value.copyWith(
            bookId: null == bookId
                ? _value.bookId
                : bookId // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            author: null == author
                ? _value.author
                : author // ignore: cast_nullable_to_non_nullable
                      as String,
            reason: null == reason
                ? _value.reason
                : reason // ignore: cast_nullable_to_non_nullable
                      as String,
            confidenceScore: null == confidenceScore
                ? _value.confidenceScore
                : confidenceScore // ignore: cast_nullable_to_non_nullable
                      as double,
            basedOn: null == basedOn
                ? _value.basedOn
                : basedOn // ignore: cast_nullable_to_non_nullable
                      as String,
            coverEmoji: null == coverEmoji
                ? _value.coverEmoji
                : coverEmoji // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BookRecommendationImplCopyWith<$Res>
    implements $BookRecommendationCopyWith<$Res> {
  factory _$$BookRecommendationImplCopyWith(
    _$BookRecommendationImpl value,
    $Res Function(_$BookRecommendationImpl) then,
  ) = __$$BookRecommendationImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String bookId,
    String title,
    String author,
    String reason,
    double confidenceScore,
    String basedOn,
    String coverEmoji,
  });
}

/// @nodoc
class __$$BookRecommendationImplCopyWithImpl<$Res>
    extends _$BookRecommendationCopyWithImpl<$Res, _$BookRecommendationImpl>
    implements _$$BookRecommendationImplCopyWith<$Res> {
  __$$BookRecommendationImplCopyWithImpl(
    _$BookRecommendationImpl _value,
    $Res Function(_$BookRecommendationImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BookRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? bookId = null,
    Object? title = null,
    Object? author = null,
    Object? reason = null,
    Object? confidenceScore = null,
    Object? basedOn = null,
    Object? coverEmoji = null,
  }) {
    return _then(
      _$BookRecommendationImpl(
        bookId: null == bookId
            ? _value.bookId
            : bookId // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        author: null == author
            ? _value.author
            : author // ignore: cast_nullable_to_non_nullable
                  as String,
        reason: null == reason
            ? _value.reason
            : reason // ignore: cast_nullable_to_non_nullable
                  as String,
        confidenceScore: null == confidenceScore
            ? _value.confidenceScore
            : confidenceScore // ignore: cast_nullable_to_non_nullable
                  as double,
        basedOn: null == basedOn
            ? _value.basedOn
            : basedOn // ignore: cast_nullable_to_non_nullable
                  as String,
        coverEmoji: null == coverEmoji
            ? _value.coverEmoji
            : coverEmoji // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BookRecommendationImpl implements _BookRecommendation {
  const _$BookRecommendationImpl({
    required this.bookId,
    required this.title,
    required this.author,
    required this.reason,
    required this.confidenceScore,
    required this.basedOn,
    this.coverEmoji = '',
  });

  factory _$BookRecommendationImpl.fromJson(Map<String, dynamic> json) =>
      _$$BookRecommendationImplFromJson(json);

  @override
  final String bookId;
  @override
  final String title;
  @override
  final String author;
  @override
  final String reason;
  @override
  final double confidenceScore;
  @override
  final String basedOn;
  @override
  @JsonKey()
  final String coverEmoji;

  @override
  String toString() {
    return 'BookRecommendation(bookId: $bookId, title: $title, author: $author, reason: $reason, confidenceScore: $confidenceScore, basedOn: $basedOn, coverEmoji: $coverEmoji)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BookRecommendationImpl &&
            (identical(other.bookId, bookId) || other.bookId == bookId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.author, author) || other.author == author) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            (identical(other.basedOn, basedOn) || other.basedOn == basedOn) &&
            (identical(other.coverEmoji, coverEmoji) ||
                other.coverEmoji == coverEmoji));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    bookId,
    title,
    author,
    reason,
    confidenceScore,
    basedOn,
    coverEmoji,
  );

  /// Create a copy of BookRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BookRecommendationImplCopyWith<_$BookRecommendationImpl> get copyWith =>
      __$$BookRecommendationImplCopyWithImpl<_$BookRecommendationImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$BookRecommendationImplToJson(this);
  }
}

abstract class _BookRecommendation implements BookRecommendation {
  const factory _BookRecommendation({
    required final String bookId,
    required final String title,
    required final String author,
    required final String reason,
    required final double confidenceScore,
    required final String basedOn,
    final String coverEmoji,
  }) = _$BookRecommendationImpl;

  factory _BookRecommendation.fromJson(Map<String, dynamic> json) =
      _$BookRecommendationImpl.fromJson;

  @override
  String get bookId;
  @override
  String get title;
  @override
  String get author;
  @override
  String get reason;
  @override
  double get confidenceScore;
  @override
  String get basedOn;
  @override
  String get coverEmoji;

  /// Create a copy of BookRecommendation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BookRecommendationImplCopyWith<_$BookRecommendationImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReadingStats _$ReadingStatsFromJson(Map<String, dynamic> json) {
  return _ReadingStats.fromJson(json);
}

/// @nodoc
mixin _$ReadingStats {
  int get booksRead => throw _privateConstructorUsedError;
  int get currentStreak => throw _privateConstructorUsedError;
  int get friendsReading => throw _privateConstructorUsedError;
  int get hoursThisMonth => throw _privateConstructorUsedError;
  int get totalHours => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  int get favoriteGenreCount => throw _privateConstructorUsedError;

  /// Serializes this ReadingStats to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReadingStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReadingStatsCopyWith<ReadingStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReadingStatsCopyWith<$Res> {
  factory $ReadingStatsCopyWith(
    ReadingStats value,
    $Res Function(ReadingStats) then,
  ) = _$ReadingStatsCopyWithImpl<$Res, ReadingStats>;
  @useResult
  $Res call({
    int booksRead,
    int currentStreak,
    int friendsReading,
    int hoursThisMonth,
    int totalHours,
    int longestStreak,
    int favoriteGenreCount,
  });
}

/// @nodoc
class _$ReadingStatsCopyWithImpl<$Res, $Val extends ReadingStats>
    implements $ReadingStatsCopyWith<$Res> {
  _$ReadingStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReadingStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? booksRead = null,
    Object? currentStreak = null,
    Object? friendsReading = null,
    Object? hoursThisMonth = null,
    Object? totalHours = null,
    Object? longestStreak = null,
    Object? favoriteGenreCount = null,
  }) {
    return _then(
      _value.copyWith(
            booksRead: null == booksRead
                ? _value.booksRead
                : booksRead // ignore: cast_nullable_to_non_nullable
                      as int,
            currentStreak: null == currentStreak
                ? _value.currentStreak
                : currentStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            friendsReading: null == friendsReading
                ? _value.friendsReading
                : friendsReading // ignore: cast_nullable_to_non_nullable
                      as int,
            hoursThisMonth: null == hoursThisMonth
                ? _value.hoursThisMonth
                : hoursThisMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            totalHours: null == totalHours
                ? _value.totalHours
                : totalHours // ignore: cast_nullable_to_non_nullable
                      as int,
            longestStreak: null == longestStreak
                ? _value.longestStreak
                : longestStreak // ignore: cast_nullable_to_non_nullable
                      as int,
            favoriteGenreCount: null == favoriteGenreCount
                ? _value.favoriteGenreCount
                : favoriteGenreCount // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReadingStatsImplCopyWith<$Res>
    implements $ReadingStatsCopyWith<$Res> {
  factory _$$ReadingStatsImplCopyWith(
    _$ReadingStatsImpl value,
    $Res Function(_$ReadingStatsImpl) then,
  ) = __$$ReadingStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int booksRead,
    int currentStreak,
    int friendsReading,
    int hoursThisMonth,
    int totalHours,
    int longestStreak,
    int favoriteGenreCount,
  });
}

/// @nodoc
class __$$ReadingStatsImplCopyWithImpl<$Res>
    extends _$ReadingStatsCopyWithImpl<$Res, _$ReadingStatsImpl>
    implements _$$ReadingStatsImplCopyWith<$Res> {
  __$$ReadingStatsImplCopyWithImpl(
    _$ReadingStatsImpl _value,
    $Res Function(_$ReadingStatsImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReadingStats
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? booksRead = null,
    Object? currentStreak = null,
    Object? friendsReading = null,
    Object? hoursThisMonth = null,
    Object? totalHours = null,
    Object? longestStreak = null,
    Object? favoriteGenreCount = null,
  }) {
    return _then(
      _$ReadingStatsImpl(
        booksRead: null == booksRead
            ? _value.booksRead
            : booksRead // ignore: cast_nullable_to_non_nullable
                  as int,
        currentStreak: null == currentStreak
            ? _value.currentStreak
            : currentStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        friendsReading: null == friendsReading
            ? _value.friendsReading
            : friendsReading // ignore: cast_nullable_to_non_nullable
                  as int,
        hoursThisMonth: null == hoursThisMonth
            ? _value.hoursThisMonth
            : hoursThisMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        totalHours: null == totalHours
            ? _value.totalHours
            : totalHours // ignore: cast_nullable_to_non_nullable
                  as int,
        longestStreak: null == longestStreak
            ? _value.longestStreak
            : longestStreak // ignore: cast_nullable_to_non_nullable
                  as int,
        favoriteGenreCount: null == favoriteGenreCount
            ? _value.favoriteGenreCount
            : favoriteGenreCount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReadingStatsImpl implements _ReadingStats {
  const _$ReadingStatsImpl({
    required this.booksRead,
    required this.currentStreak,
    required this.friendsReading,
    required this.hoursThisMonth,
    this.totalHours = 0,
    this.longestStreak = 0,
    this.favoriteGenreCount = 0,
  });

  factory _$ReadingStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReadingStatsImplFromJson(json);

  @override
  final int booksRead;
  @override
  final int currentStreak;
  @override
  final int friendsReading;
  @override
  final int hoursThisMonth;
  @override
  @JsonKey()
  final int totalHours;
  @override
  @JsonKey()
  final int longestStreak;
  @override
  @JsonKey()
  final int favoriteGenreCount;

  @override
  String toString() {
    return 'ReadingStats(booksRead: $booksRead, currentStreak: $currentStreak, friendsReading: $friendsReading, hoursThisMonth: $hoursThisMonth, totalHours: $totalHours, longestStreak: $longestStreak, favoriteGenreCount: $favoriteGenreCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReadingStatsImpl &&
            (identical(other.booksRead, booksRead) ||
                other.booksRead == booksRead) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.friendsReading, friendsReading) ||
                other.friendsReading == friendsReading) &&
            (identical(other.hoursThisMonth, hoursThisMonth) ||
                other.hoursThisMonth == hoursThisMonth) &&
            (identical(other.totalHours, totalHours) ||
                other.totalHours == totalHours) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.favoriteGenreCount, favoriteGenreCount) ||
                other.favoriteGenreCount == favoriteGenreCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    booksRead,
    currentStreak,
    friendsReading,
    hoursThisMonth,
    totalHours,
    longestStreak,
    favoriteGenreCount,
  );

  /// Create a copy of ReadingStats
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReadingStatsImplCopyWith<_$ReadingStatsImpl> get copyWith =>
      __$$ReadingStatsImplCopyWithImpl<_$ReadingStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReadingStatsImplToJson(this);
  }
}

abstract class _ReadingStats implements ReadingStats {
  const factory _ReadingStats({
    required final int booksRead,
    required final int currentStreak,
    required final int friendsReading,
    required final int hoursThisMonth,
    final int totalHours,
    final int longestStreak,
    final int favoriteGenreCount,
  }) = _$ReadingStatsImpl;

  factory _ReadingStats.fromJson(Map<String, dynamic> json) =
      _$ReadingStatsImpl.fromJson;

  @override
  int get booksRead;
  @override
  int get currentStreak;
  @override
  int get friendsReading;
  @override
  int get hoursThisMonth;
  @override
  int get totalHours;
  @override
  int get longestStreak;
  @override
  int get favoriteGenreCount;

  /// Create a copy of ReadingStats
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReadingStatsImplCopyWith<_$ReadingStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
