import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_durations.dart';
import '../../../shared/widgets/animations/ft_stagger_animation.dart';
import '../models/book_model.dart';
import '../providers/book_library_provider.dart';
import '../widgets/book_library_header.dart';
import '../widgets/reading_stats_bar.dart';
import '../widgets/ai_recommendation_banner.dart';
import '../widgets/continue_reading_card.dart';
import '../widgets/mood_selector.dart';
import '../widgets/category_tabs.dart';
import '../widgets/friends_reading_section.dart';
import '../widgets/book_grid.dart';
import '../widgets/book_library_fab.dart';

/// Premium Book Library Screen for Future Talk
/// Features personalized recommendations, social reading, and sanctuary-like design
class BookLibraryScreen extends ConsumerStatefulWidget {
  const BookLibraryScreen({super.key});

  @override
  ConsumerState<BookLibraryScreen> createState() => _BookLibraryScreenState();
}

class _BookLibraryScreenState extends ConsumerState<BookLibraryScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _refreshController;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _refreshController = AnimationController(
      duration: AppDurations.slow,
      vsync: this,
    );

    // Add scroll listener for header effects
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // Future: Implement parallax effects or header animations
  }

  Future<void> _refreshLibrary() async {
    _refreshController.forward();
    await ref.read(bookLibraryProvider.notifier).refresh();
    _refreshController.reverse();
    
    if (mounted) {
      HapticFeedback.lightImpact();
      _showSnackBar('Library refreshed', AppColors.sageGreen);
    }
  }

  void _onSearchChanged(String query) {
    ref.read(bookLibraryProvider.notifier).updateSearchQuery(query);
  }

  void _onMoodSelected(ReadingMood mood) {
    ref.read(bookLibraryProvider.notifier).updateMood(mood);
    HapticFeedback.selectionClick();
  }

  void _onCategorySelected(String category) {
    ref.read(bookLibraryProvider.notifier).updateCategory(category);
    HapticFeedback.selectionClick();
  }

  void _onBookTapped(Book book) {
    HapticFeedback.mediumImpact();
    _showSnackBar('Opening ${book.title}', AppColors.lavenderMist);
    // TODO: Navigate to book details
  }

  void _onContinueReading() {
    ref.read(bookLibraryProvider.notifier).continueReading();
    HapticFeedback.mediumImpact();
    _showSnackBar('Continuing your reading journey', AppColors.warmPeach);
  }

  void _onJoinFriendReading(String friendId, String bookTitle) {
    ref.read(bookLibraryProvider.notifier).joinFriendReading(friendId, bookTitle);
    HapticFeedback.lightImpact();
    _showSnackBar('Joining reading session', AppColors.cloudBlue);
  }

  void _onFabPressed() {
    HapticFeedback.heavyImpact();
    _showSnackBar('Create reading goal', AppColors.sageGreen);
    // TODO: Show reading goal dialog
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.pearlWhite,
          ),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final libraryState = ref.watch(bookLibraryProvider);

    return Scaffold(
      backgroundColor: AppColors.warmCream,
      body: libraryState.when(
        loading: () => _buildLoadingScreen(),
        error: (error, stackTrace) => _buildErrorScreen(error.toString()),
        data: (data) => Stack(
          children: [
            // Main content
            _buildMainContent(data),
            
            // Floating Action Button
            BookLibraryFAB(
              onPressed: _onFabPressed,
              tooltip: 'Create reading goal',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 3.0,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.sageGreen),
          ),
          const SizedBox(height: AppDimensions.spacingXL),
          Text(
            'Curating your perfect reads...',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.softCharcoalLight,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: AppDurations.medium);
  }

  Widget _buildErrorScreen(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.screenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '📚',
              style: TextStyle(fontSize: 48),
            ),
            const SizedBox(height: AppDimensions.spacingL),
            Text(
              'Library temporarily unavailable',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.softCharcoal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingM),
            Text(
              'We couldn\'t load your books right now',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.softCharcoalLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.spacingXXL),
            ElevatedButton.icon(
              onPressed: _refreshLibrary,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.sageGreen,
                foregroundColor: AppColors.pearlWhite,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacingXXL,
                  vertical: AppDimensions.spacingL,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BookLibraryData data) {
    return RefreshIndicator(
      onRefresh: _refreshLibrary,
      color: AppColors.sageGreen,
      backgroundColor: AppColors.pearlWhite,
      displacement: 40.0, // Limit refresh indicator displacement
      strokeWidth: 2.5, // Thinner refresh indicator
      child: CustomScrollView(
        controller: _scrollController,
        physics: const ClampingScrollPhysics(), // Fixed scroll physics - no excessive stretching
        slivers: [
          // Enhanced Header with Social Battery
          SliverToBoxAdapter(
            child: FTStaggerAnimation(
              delay: 100.ms,
              child: BookLibraryHeader(
                userName: data.userName,
                greeting: data.greeting,
                moodSuggestion: data.moodSuggestion,
                searchController: _searchController,
                onSearchChanged: _onSearchChanged,
              ),
            ),
          ),

          // Reading Stats Bar
          SliverToBoxAdapter(
            child: FTStaggerAnimation(
              delay: 200.ms,
              child: ReadingStatsBar(stats: data.stats),
            ),
          ),

          // Main content sections
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.screenPadding),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // AI Recommendation Banner
                FTStaggerAnimation(
                  delay: 300.ms,
                  child: AIRecommendationBanner(
                    recommendation: data.aiRecommendation,
                    onTap: () => _onBookTapped(
                      Book(
                        id: data.aiRecommendation.bookId,
                        title: data.aiRecommendation.title,
                        author: data.aiRecommendation.author,
                        coverEmoji: data.aiRecommendation.coverEmoji.isNotEmpty 
                            ? data.aiRecommendation.coverEmoji 
                            : '✨',
                        rating: 0.0,
                        durationHours: 0,
                        tags: [],
                        isPremium: true,
                        comfortLevel: BookComfortLevel.inspiring,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppDimensions.sectionPadding),

                // Continue Reading Section
                if (data.currentReading != null) ...[
                  FTStaggerAnimation(
                    delay: 400.ms,
                    child: ContinueReadingCard(
                      progress: data.currentReading!,
                      onContinue: _onContinueReading,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sectionPadding),
                ],

                // Mood Selector
                FTStaggerAnimation(
                  delay: 500.ms,
                  child: MoodSelector(
                    selectedMood: ref.read(bookLibraryProvider.notifier).selectedMood,
                    onMoodSelected: _onMoodSelected,
                  ),
                ),

                const SizedBox(height: AppDimensions.sectionPadding),

                // Category Tabs
                FTStaggerAnimation(
                  delay: 600.ms,
                  child: CategoryTabs(
                    categories: data.categories,
                    selectedCategory: ref.read(bookLibraryProvider.notifier).selectedCategory,
                    onCategorySelected: _onCategorySelected,
                  ),
                ),

                const SizedBox(height: AppDimensions.sectionPadding),

                // Friends Reading Section
                FTStaggerAnimation(
                  delay: 700.ms,
                  child: FriendsReadingSection(
                    friends: data.friendsReading,
                    onJoinReading: _onJoinFriendReading,
                  ),
                ),

                const SizedBox(height: AppDimensions.sectionPadding),

                // Books Grid Section Header
                FTStaggerAnimation(
                  delay: 800.ms,
                  child: _buildSectionHeader(
                    _getCategoryTitle(ref.read(bookLibraryProvider.notifier).selectedCategory),
                    'View all',
                  ),
                ),

                const SizedBox(height: AppDimensions.spacingL),

                // Books Grid
                FTStaggerAnimation(
                  delay: 900.ms,
                  child: BookGrid(
                    books: data.books,
                    onBookTapped: _onBookTapped,
                  ),
                ),

                // Bottom padding for FAB
                const SizedBox(height: 120),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String actionText) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: AppTextStyles.featureHeading,
        ),
        GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            _showSnackBar('Viewing all $title', AppColors.sageGreen);
          },
          child: Text(
            actionText,
            style: AppTextStyles.link.copyWith(
              fontSize: 14,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    );
  }

  String _getCategoryTitle(String category) {
    switch (category) {
      case 'For You':
        return 'Peaceful Reads';
      case 'Romance':
        return 'Love Stories';
      case 'Growth':
        return 'Personal Growth';
      case 'Classics':
        return 'Timeless Classics';
      case 'Poetry':
        return 'Beautiful Poetry';
      case 'Mindful':
        return 'Mindful Reading';
      default:
        return 'Recommended Books';
    }
  }
}

/// Responsive book library screen for different screen sizes
class ResponsiveBookLibraryScreen extends StatelessWidget {
  const ResponsiveBookLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    if (screenWidth < AppDimensions.tabletBreakpoint) {
      return const BookLibraryScreen();
    }
    
    // Future: Tablet/Desktop layout with wider grids
    return const BookLibraryScreen();
  }
}