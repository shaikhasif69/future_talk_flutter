/// Future Talk's animation duration system
/// Designed for smooth, calming interactions with introvert-friendly timings
class AppDurations {
  AppDurations._();

  // ==================== BASE DURATIONS ====================
  
  /// Ultra fast - Immediate feedback (50ms)
  static const Duration ultraFast = Duration(milliseconds: 50);
  
  /// Very fast - Quick responses (100ms)
  static const Duration veryFast = Duration(milliseconds: 100);
  
  /// Fast - Micro-interactions (150ms)
  static const Duration fast = Duration(milliseconds: 150);
  
  /// Medium fast - Small component animations (200ms)
  static const Duration mediumFast = Duration(milliseconds: 200);
  
  /// Medium - Standard interactions (300ms)
  static const Duration medium = Duration(milliseconds: 300);
  
  /// Medium slow - Noticeable transitions (400ms)
  static const Duration mediumSlow = Duration(milliseconds: 400);
  
  /// Slow - Prominent animations (500ms)
  static const Duration slow = Duration(milliseconds: 500);
  
  /// Very slow - Major transitions (750ms)
  static const Duration verySlow = Duration(milliseconds: 750);
  
  /// Ultra slow - Dramatic effects (1000ms)
  static const Duration ultraSlow = Duration(milliseconds: 1000);

  // ==================== COMPONENT SPECIFIC DURATIONS ====================
  
  /// Button press feedback
  static const Duration buttonPress = ultraFast; // 50ms
  
  /// Button hover transition
  static const Duration buttonHover = fast; // 150ms
  
  /// Button tap animation
  static const Duration buttonTap = mediumFast; // 200ms
  
  /// Input field focus
  static const Duration inputFocus = mediumFast; // 200ms
  
  /// Input field validation feedback
  static const Duration inputValidation = medium; // 300ms
  
  /// Card hover effect
  static const Duration cardHover = mediumFast; // 200ms
  
  /// Card tap animation
  static const Duration cardTap = medium; // 300ms
  
  /// Modal appearance
  static const Duration modalShow = mediumSlow; // 400ms
  
  /// Modal disappearance
  static const Duration modalHide = medium; // 300ms
  
  /// Loading indicator
  static const Duration loadingIndicator = slow; // 500ms
  
  /// Progress bar animation
  static const Duration progressBar = verySlow; // 750ms
  
  /// Shimmer loading effect
  static const Duration shimmer = ultraSlow; // 1000ms

  // ==================== NAVIGATION DURATIONS ====================
  
  /// Page transition (slide)
  static const Duration pageTransition = mediumSlow; // 400ms
  
  /// Tab change animation
  static const Duration tabChange = medium; // 300ms
  
  /// Drawer slide animation
  static const Duration drawerSlide = mediumSlow; // 400ms
  
  /// Bottom sheet slide
  static const Duration bottomSheetSlide = mediumSlow; // 400ms
  
  /// Route fade transition
  static const Duration routeFade = medium; // 300ms

  // ==================== SPLASH & ONBOARDING ====================
  
  /// Splash screen logo animation
  static const Duration splashLogo = ultraSlow; // 1000ms
  
  /// Splash screen fade in
  static const Duration splashFadeIn = verySlow; // 750ms
  
  /// Splash screen total duration
  static const Duration splashTotal = Duration(milliseconds: 3000); // 3s
  
  /// Onboarding slide transition
  static const Duration onboardingSlide = mediumSlow; // 400ms
  
  /// Onboarding fade animation
  static const Duration onboardingFade = medium; // 300ms
  
  /// Logo breathing animation
  static const Duration logoBreathing = Duration(milliseconds: 3000); // 3s
  
  /// Particle floating animation
  static const Duration particleFloat = Duration(milliseconds: 4000); // 4s

  // ==================== FORM ANIMATIONS ====================
  
  /// Form field slide in
  static const Duration formFieldSlideIn = medium; // 300ms
  
  /// Form validation shake
  static const Duration formValidationShake = mediumSlow; // 400ms
  
  /// Form success animation
  static const Duration formSuccess = slow; // 500ms
  
  /// Form error animation
  static const Duration formError = mediumSlow; // 400ms
  
  /// Checkbox toggle
  static const Duration checkboxToggle = mediumFast; // 200ms
  
  /// Radio button select
  static const Duration radioSelect = mediumFast; // 200ms

  // ==================== LIST & SCROLL ANIMATIONS ====================
  
  /// List item slide in
  static const Duration listItemSlideIn = medium; // 300ms
  
  /// List item fade in
  static const Duration listItemFadeIn = mediumFast; // 200ms
  
  /// Scroll to top animation
  static const Duration scrollToTop = verySlow; // 750ms
  
  /// Pull to refresh
  static const Duration pullToRefresh = slow; // 500ms
  
  /// Infinite scroll loading
  static const Duration infiniteScrollLoading = medium; // 300ms

  // ==================== FEEDBACK ANIMATIONS ====================
  
  /// Success feedback
  static const Duration successFeedback = slow; // 500ms
  
  /// Error feedback
  static const Duration errorFeedback = mediumSlow; // 400ms
  
  /// Warning feedback
  static const Duration warningFeedback = mediumSlow; // 400ms
  
  /// Info feedback
  static const Duration infoFeedback = medium; // 300ms
  
  /// Snackbar animation
  static const Duration snackbar = mediumSlow; // 400ms
  
  /// Toast animation
  static const Duration toast = medium; // 300ms

  // ==================== LOADING STATES ====================
  
  /// Content loading fade
  static const Duration contentLoading = medium; // 300ms
  
  /// Image loading fade
  static const Duration imageLoading = mediumSlow; // 400ms
  
  /// Skeleton loading
  static const Duration skeletonLoading = ultraSlow; // 1000ms
  
  /// Refresh animation
  static const Duration refresh = slow; // 500ms
  
  /// Data sync animation
  static const Duration dataSync = verySlow; // 750ms

  // ==================== SPECIAL EFFECTS ====================
  
  /// Ripple effect
  static const Duration ripple = mediumSlow; // 400ms
  
  /// Pulse animation
  static const Duration pulse = ultraSlow; // 1000ms
  
  /// Glow effect
  static const Duration glow = Duration(milliseconds: 2000); // 2s
  
  /// Fade in up animation
  static const Duration fadeInUp = mediumSlow; // 400ms
  
  /// Scale animation
  static const Duration scale = medium; // 300ms
  
  /// Rotation animation
  static const Duration rotation = slow; // 500ms

  // ==================== GESTURE ANIMATIONS ====================
  
  /// Swipe animation
  static const Duration swipe = medium; // 300ms
  
  /// Long press feedback
  static const Duration longPress = fast; // 150ms
  
  /// Drag animation
  static const Duration drag = mediumFast; // 200ms
  
  /// Pan animation
  static const Duration pan = fast; // 150ms
  
  /// Pinch animation
  static const Duration pinch = mediumFast; // 200ms

  // ==================== STAGGERED ANIMATIONS ====================
  
  /// Stagger delay between items
  static const Duration staggerDelay = veryFast; // 100ms
  
  /// Short stagger delay
  static const Duration staggerDelayShort = ultraFast; // 50ms
  
  /// Long stagger delay
  static const Duration staggerDelayLong = fast; // 150ms

  // ==================== TIMEOUT DURATIONS ====================
  
  /// API request timeout
  static const Duration apiTimeout = Duration(seconds: 30);
  
  /// Image loading timeout
  static const Duration imageTimeout = Duration(seconds: 10);
  
  /// Auto-save delay
  static const Duration autoSaveDelay = Duration(seconds: 2);
  
  /// Debounce delay for search
  static const Duration searchDebounce = Duration(milliseconds: 500);
  
  /// Double tap detection window
  static const Duration doubleTapWindow = Duration(milliseconds: 300);

  // ==================== HELPER METHODS ====================
  
  /// Get staggered duration for lists
  static Duration getStaggeredDuration(int index, {Duration baseDelay = staggerDelay}) {
    return Duration(milliseconds: baseDelay.inMilliseconds * index);
  }
  
  /// Get responsive duration based on device performance
  static Duration getResponsiveDuration(Duration baseDuration, {bool isLowEnd = false}) {
    if (isLowEnd) {
      // Reduce animation duration on low-end devices
      return Duration(milliseconds: (baseDuration.inMilliseconds * 0.7).round());
    }
    return baseDuration;
  }
  
  /// Get eased duration for smoother animations
  static Duration getEasedDuration(Duration baseDuration, {double easeFactor = 1.2}) {
    return Duration(milliseconds: (baseDuration.inMilliseconds * easeFactor).round());
  }
}