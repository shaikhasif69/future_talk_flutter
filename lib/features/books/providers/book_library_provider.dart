import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book_model.dart';

/// Book library state management provider
class BookLibraryProvider extends StateNotifier<AsyncValue<BookLibraryData>> {
  BookLibraryProvider() : super(const AsyncValue.loading()) {
    _loadLibraryData();
  }

  ReadingMood _selectedMood = ReadingMood.peaceful;
  String _selectedCategory = 'For You';
  String _searchQuery = '';

  ReadingMood get selectedMood => _selectedMood;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  /// Load initial library data
  Future<void> _loadLibraryData() async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 800));
      
      final data = BookLibraryData(
        stats: _generateMockStats(),
        currentReading: _generateMockCurrentReading(),
        aiRecommendation: _generateMockAIRecommendation(),
        friendsReading: _generateMockFriendsReading(),
        books: _generateMockBooks(),
        categories: _getCategories(),
        userName: 'Asif',
        greeting: _generateGreeting(),
        moodSuggestion: _generateMoodSuggestion(),
      );
      
      state = AsyncValue.data(data);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Update selected mood and refresh recommendations
  void updateMood(ReadingMood mood) {
    _selectedMood = mood;
    _refreshBooksForMood();
  }

  /// Update selected category
  void updateCategory(String category) {
    _selectedCategory = category;
    _refreshBooksForCategory();
  }

  /// Update search query
  void updateSearchQuery(String query) {
    _searchQuery = query;
    _performSearch();
  }

  /// Refresh library data
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    await _loadLibraryData();
  }

  /// Mark book as started reading
  void startReading(String bookId) {
    state.whenData((data) {
      // Implementation would typically call API
      debugPrint('Starting to read book: $bookId');
    });
  }

  /// Join friend's reading session
  void joinFriendReading(String friendId, String bookId) {
    state.whenData((data) {
      debugPrint('Joining $friendId reading $bookId');
    });
  }

  /// Continue reading current book
  void continueReading() {
    state.whenData((data) {
      if (data.currentReading != null) {
        debugPrint('Continuing reading: ${data.currentReading!.bookTitle}');
      }
    });
  }

  void _refreshBooksForMood() {
    state.whenData((data) {
      // Filter and re-sort books based on mood
      final updatedBooks = _generateMockBooksForMood(_selectedMood);
      final updatedData = data.copyWith(books: updatedBooks);
      state = AsyncValue.data(updatedData);
    });
  }

  void _refreshBooksForCategory() {
    state.whenData((data) {
      final updatedBooks = _generateMockBooksForCategory(_selectedCategory);
      final updatedData = data.copyWith(books: updatedBooks);
      state = AsyncValue.data(updatedData);
    });
  }

  void _performSearch() {
    if (_searchQuery.isEmpty) {
      _loadLibraryData();
      return;
    }

    state.whenData((data) {
      final filteredBooks = data.books
          .where((book) =>
              book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              book.author.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              book.tags.any((tag) =>
                  tag.toLowerCase().contains(_searchQuery.toLowerCase())))
          .toList();

      final updatedData = data.copyWith(books: filteredBooks);
      state = AsyncValue.data(updatedData);
    });
  }

  // Mock data generators
  ReadingStats _generateMockStats() {
    return const ReadingStats(
      booksRead: 7,
      currentStreak: 12,
      friendsReading: 3,
      hoursThisMonth: 42,
    );
  }

  ReadingProgress? _generateMockCurrentReading() {
    return const ReadingProgress(
      bookId: '1',
      bookTitle: 'Pride and Prejudice',
      bookAuthor: 'Jane Austen',
      coverEmoji: '📖',
      currentPage: 142,
      totalPages: 400,
      currentChapter: 8,
      totalChapters: 24,
      mood: ReadingMood.romantic,
      minutesLeft: 25,
      readingStreak: 7,
      partner: ReadingPartner(
        id: 'sarah',
        name: 'Sarah',
        avatarInitial: 'S',
        currentPage: 142,
        isOnline: true,
      ),
      lastReadAt: '2 hours ago',
    );
  }

  BookRecommendation _generateMockAIRecommendation() {
    return const BookRecommendation(
      bookId: 'rec_1',
      title: 'The Seven Moons of Maali Almeida',
      author: 'Shehan Karunatilaka',
      reason: 'Magical realism for creative minds like yours',
      confidenceScore: 0.92,
      basedOn: 'your green energy and evening reading habits',
      coverEmoji: '🌙',
    );
  }

  List<FriendReading> _generateMockFriendsReading() {
    return [
      const FriendReading(
        friendId: 'alex',
        friendName: 'Alex',
        avatarInitial: 'A',
        bookTitle: 'The Alchemist',
        bookAuthor: 'Paulo Coelho',
        currentChapter: 'Chapter 3',
        status: FriendActivityStatus.reading,
        timeAgo: 'Reading now',
        isOpenForPartners: true,
        canJoin: true,
      ),
      const FriendReading(
        friendId: 'maya',
        friendName: 'Maya',
        avatarInitial: 'M',
        bookTitle: 'Atomic Habits',
        bookAuthor: 'James Clear',
        currentChapter: 'Chapter 7',
        status: FriendActivityStatus.recentlyActive,
        timeAgo: '2h ago',
        isOpenForPartners: true,
        canJoin: true,
      ),
      const FriendReading(
        friendId: 'riley',
        friendName: 'Riley',
        avatarInitial: 'R',
        bookTitle: 'The Secret Garden',
        bookAuthor: 'Frances Hodgson Burnett',
        currentChapter: 'Chapter 12',
        status: FriendActivityStatus.recharging,
        timeAgo: 'Recharging',
        isOpenForPartners: false,
        canJoin: false,
      ),
    ];
  }

  List<Book> _generateMockBooks() {
    return [
      const Book(
        id: '1',
        title: 'The Secret Garden',
        author: 'Frances Hodgson Burnett',
        coverEmoji: '📚',
        rating: 4.8,
        durationHours: 8,
        tags: ['Healing', 'Nature'],
        isPremium: false,
        comfortLevel: BookComfortLevel.comforting,
        isAvailableForParallel: true,
      ),
      const Book(
        id: '2',
        title: 'The Seven Husbands of Evelyn Hugo',
        author: 'Taylor Jenkins Reid',
        coverEmoji: '💭',
        rating: 4.9,
        durationHours: 12,
        tags: ['Drama', 'Love'],
        isPremium: true,
        comfortLevel: BookComfortLevel.emotional,
      ),
      const Book(
        id: '3',
        title: 'Little Women',
        author: 'Louisa May Alcott',
        coverEmoji: '🌸',
        rating: 4.7,
        durationHours: 15,
        tags: ['Family', 'Growth'],
        isPremium: false,
        comfortLevel: BookComfortLevel.gentle,
        isAvailableForParallel: true,
      ),
      const Book(
        id: '4',
        title: 'The Power of Now',
        author: 'Eckhart Tolle',
        coverEmoji: '🧘',
        rating: 4.6,
        durationHours: 6,
        tags: ['Peace', 'Present'],
        isPremium: true,
        comfortLevel: BookComfortLevel.mindful,
      ),
    ];
  }

  List<Book> _generateMockBooksForMood(ReadingMood mood) {
    // Return books filtered by mood
    return _generateMockBooks();
  }

  List<Book> _generateMockBooksForCategory(String category) {
    // Return books filtered by category
    return _generateMockBooks();
  }

  List<String> _getCategories() {
    return ['For You', 'Romance', 'Growth', 'Classics', 'Poetry', 'Mindful'];
  }

  String _generateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good morning, Asif! Ready for some inspiring reading?';
    } else if (hour < 17) {
      return 'Good afternoon, Asif! Time for a thoughtful break?';
    } else {
      return 'Good evening, Asif! Perfect time for thoughtful reading.';
    }
  }

  String _generateMoodSuggestion() {
    return 'Based on your energy, try something comforting tonight.';
  }
}

/// Combined data model for the library screen
@immutable
class BookLibraryData {
  final ReadingStats stats;
  final ReadingProgress? currentReading;
  final BookRecommendation aiRecommendation;
  final List<FriendReading> friendsReading;
  final List<Book> books;
  final List<String> categories;
  final String userName;
  final String greeting;
  final String moodSuggestion;

  const BookLibraryData({
    required this.stats,
    required this.aiRecommendation,
    required this.friendsReading,
    required this.books,
    required this.categories,
    required this.userName,
    required this.greeting,
    required this.moodSuggestion,
    this.currentReading,
  });

  BookLibraryData copyWith({
    ReadingStats? stats,
    ReadingProgress? currentReading,
    BookRecommendation? aiRecommendation,
    List<FriendReading>? friendsReading,
    List<Book>? books,
    List<String>? categories,
    String? userName,
    String? greeting,
    String? moodSuggestion,
  }) {
    return BookLibraryData(
      stats: stats ?? this.stats,
      currentReading: currentReading ?? this.currentReading,
      aiRecommendation: aiRecommendation ?? this.aiRecommendation,
      friendsReading: friendsReading ?? this.friendsReading,
      books: books ?? this.books,
      categories: categories ?? this.categories,
      userName: userName ?? this.userName,
      greeting: greeting ?? this.greeting,
      moodSuggestion: moodSuggestion ?? this.moodSuggestion,
    );
  }
}

/// Provider for the book library
final bookLibraryProvider =
    StateNotifierProvider<BookLibraryProvider, AsyncValue<BookLibraryData>>(
  (ref) => BookLibraryProvider(),
);