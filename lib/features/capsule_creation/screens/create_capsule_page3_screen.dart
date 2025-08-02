import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../shared/widgets/ft_button.dart';
import '../models/time_capsule_creation_data.dart';
import '../models/message_creation_data.dart';
import '../providers/time_capsule_creation_provider.dart';
import '../providers/message_creation_provider_simple.dart';
import '../widgets/time_capsule_header.dart';
import '../widgets/animated_water_droplet_background.dart';
import '../widgets/message_creation/context_bar_widget.dart';
import '../widgets/message_creation/mode_switcher_widget.dart';
import '../widgets/message_creation/message_editor_widget.dart';
import '../widgets/message_creation/voice_recording_widget.dart';
import '../widgets/message_creation/writing_tools_widget.dart';
import '../widgets/message_creation/writing_inspiration_widget.dart';

/// Third page of time capsule creation flow - Message Creation/Text Editor
/// Universal screen that adapts for all message types (Future Me, Someone Special, Anonymous)
/// Premium Flutter implementation with advanced text editing and voice recording
class CreateCapsulePage3Screen extends ConsumerStatefulWidget {
  const CreateCapsulePage3Screen({super.key});

  @override
  ConsumerState<CreateCapsulePage3Screen> createState() => _CreateCapsulePage3ScreenState();
}

class _CreateCapsulePage3ScreenState extends ConsumerState<CreateCapsulePage3Screen>
    with TickerProviderStateMixin {
  
  // Animation controllers
  late AnimationController _continueButtonController;
  late AnimationController _fullScreenController;
  late AnimationController _expandController;
  
  // Animations
  late Animation<double> _continueButtonAnimation;
  late Animation<Offset> _continueButtonSlide;
  late Animation<double> _fullScreenAnimation;
  late Animation<double> _expandAnimation;
  
  // Focus nodes
  final FocusNode _textFocusNode = FocusNode();
  
  // Controllers
  late TextEditingController _textController;
  
  // State variables
  bool _isFullScreen = false;
  bool _isExpanded = false;
  
  @override
  void initState() {
    super.initState();
    
    // Initialize controllers
    _textController = TextEditingController();
    
    // Setup animation controllers
    _continueButtonController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fullScreenController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    
    // Setup animations
    _continueButtonAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _continueButtonController,
      curve: Curves.easeOut,
    ));
    
    _continueButtonSlide = Tween<Offset>(
      begin: const Offset(0, 1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _continueButtonController,
      curve: Curves.easeOut,
    ));
    
    _fullScreenAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fullScreenController,
      curve: Curves.easeInOut,
    ));
    
    _expandAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOut,
    ));
    
    // Load saved content
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedContent();
    });
    
    // Listen to text changes for auto-save
    _textController.addListener(_handleTextChanged);
    
    // Keyboard shortcuts
    _setupKeyboardShortcuts();
  }
  
  @override
  void dispose() {
    _continueButtonController.dispose();
    _fullScreenController.dispose();
    _expandController.dispose();
    _textController.dispose();
    _textFocusNode.dispose();
    super.dispose();
  }
  
  void _setupKeyboardShortcuts() {
    // Handle keyboard shortcuts (Escape to exit full-screen, Ctrl+Enter to continue)
    // This will be handled in the build method with RawKeyboardListener
  }
  
  void _loadSavedContent() {
    final messageState = ref.read(messageCreationNotifierProvider);
    if (messageState.textContent.isNotEmpty) {
      _textController.text = messageState.textContent;
    }
  }
  
  void _handleTextChanged() {
    final notifier = ref.read(messageCreationNotifierProvider.notifier);
    notifier.updateTextContent(_textController.text);
    
    // Show continue button when content is added
    final hasContent = _textController.text.trim().isNotEmpty;
    if (hasContent && !_continueButtonController.isCompleted) {
      _continueButtonController.forward();
    } else if (!hasContent && _continueButtonController.isCompleted) {
      _continueButtonController.reverse();
    }
  }
  
  void _handleModeSwitch(MessageMode mode) {
    final notifier = ref.read(messageCreationNotifierProvider.notifier);
    notifier.switchMode(mode);
    
    // Haptic feedback
    HapticFeedback.selectionClick();
    
    // Focus handling
    if (mode == MessageMode.write) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _textFocusNode.requestFocus();
      });
    }
  }
  
  void _handleFullScreenToggle() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    
    if (_isFullScreen) {
      _fullScreenController.forward();
      // Hide system UI for true full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    } else {
      _fullScreenController.reverse();
      // Restore system UI
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    
    // Enhanced haptic feedback
    HapticFeedback.mediumImpact();
  }
  
  void _handleExpandToggle() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
    
    HapticFeedback.selectionClick();
  }
  
  void _handleContinue() async {
    final messageNotifier = ref.read(messageCreationNotifierProvider.notifier);
    final capsuleNotifier = ref.read(timeCapsuleCreationNotifierProvider.notifier);
    
    // Save final content
    await messageNotifier.saveDraft();
    
    // Move to next step
    await capsuleNotifier.continueToNextStep();
    
    // Strong haptic feedback
    HapticFeedback.heavyImpact();
    
    // Navigate to final step
    if (mounted) {
      context.go('/capsule/create/review');
    }
  }
  
  void _handleBackPressed() {
    // Save current progress before going back
    final notifier = ref.read(messageCreationNotifierProvider.notifier);
    notifier.saveDraft();
    
    // Navigate back
    context.pop();
  }
  
  Widget _buildKeyboardListener({required Widget child}) {
    return RawKeyboardListener(
      focusNode: FocusNode(),
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          // Escape key to exit full-screen
          if (event.logicalKey == LogicalKeyboardKey.escape && _isFullScreen) {
            _handleFullScreenToggle();
          }
          // Ctrl+Enter to continue
          else if (event.isControlPressed && 
                   event.logicalKey == LogicalKeyboardKey.enter) {
            final hasContent = _textController.text.trim().isNotEmpty;
            if (hasContent) {
              _handleContinue();
            }
          }
        }
      },
      child: child,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final messageState = ref.watch(messageCreationNotifierProvider);
    final capsuleState = ref.watch(timeCapsuleCreationNotifierProvider);
    final hasContent = messageState.textContent.isNotEmpty || 
                      messageState.voiceRecordings.isNotEmpty;
    
    return _buildKeyboardListener(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: AnimatedBuilder(
          animation: _fullScreenAnimation,
          builder: (context, child) {
            return Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF7F5F3),
                    Color(0xFFFEFEFE),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Floating particles background
                  const AnimatedWaterDropletBackground(),
                  
                  // Main content
                  Column(
                    children: [
                      // Header (hidden in full-screen mode)
                      if (!_isFullScreen) ...[
                        TimeCapsuleHeader(
                          currentStep: 3, // Step 3 active, steps 1-2 completed
                          title: 'Your Message',
                          subtitle: _getSubtitleForRecipient(capsuleState.selectedPurpose),
                          onBackPressed: _handleBackPressed,
                        ),
                        
                        // Context bar showing recipient and time selection
                        ContextBarWidget(
                          purpose: capsuleState.selectedPurpose,
                          timeDisplay: capsuleState.timeDisplay,
                          timeMetaphor: capsuleState.timeMetaphor,
                        ),
                        
                        // Mode switcher (Write vs Record)
                        ModeSwitcherWidget(
                          currentMode: messageState.mode,
                          onModeChanged: _handleModeSwitch,
                        ),
                      ],
                      
                      // Main content area
                      Expanded(
                        child: _buildMainContent(messageState, capsuleState),
                      ),
                    ],
                  ),
                  
                  // Continue button (hidden in full-screen mode)
                  if (!_isFullScreen)
                    Positioned(
                      left: AppDimensions.screenPadding,
                      right: AppDimensions.screenPadding,
                      bottom: AppDimensions.spacingXXXL,
                      child: FadeTransition(
                        opacity: _continueButtonAnimation,
                        child: SlideTransition(
                          position: _continueButtonSlide,
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.sageGreenWithOpacity(0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: FTButton.primary(
                              text: messageState.isLoading 
                                  ? 'Saving message...' 
                                  : 'Continue to Review',
                              onPressed: hasContent && !messageState.isLoading 
                                  ? _handleContinue 
                                  : null,
                              isLoading: messageState.isLoading,
                              width: double.infinity,
                              icon: messageState.isLoading ? null : Icons.arrow_forward,
                              iconPosition: FTButtonIconPosition.right,
                            ),
                          ),
                        ),
                      ),
                    ),
                  
                  // Full-screen exit button
                  if (_isFullScreen)
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 16,
                      right: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.softCharcoalWithOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: IconButton(
                          onPressed: _handleFullScreenToggle,
                          icon: const Icon(
                            Icons.fullscreen_exit,
                            color: AppColors.pearlWhite,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildMainContent(MessageCreationData messageState, TimeCapsuleCreationData capsuleState) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        AppDimensions.screenPadding,
        0,
        AppDimensions.screenPadding,
        _isFullScreen ? AppDimensions.spacingXL : 120, // Space for continue button
      ),
      child: Column(
        children: [
          // Writing inspiration (collapsed by default)
          WritingInspirationWidget(
            purpose: capsuleState.selectedPurpose,
            isExpanded: _isExpanded,
            onExpandToggle: _handleExpandToggle,
            expandAnimation: _expandAnimation,
          ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // Main editor area
          if (messageState.mode == MessageMode.write)
            MessageEditorWidget(
              textController: _textController,
              focusNode: _textFocusNode,
              purpose: capsuleState.selectedPurpose,
              selectedFont: messageState.selectedFont,
              fontSize: messageState.fontSize,
              wordCount: messageState.wordCount,
              isFullScreen: _isFullScreen,
              onFullScreenToggle: _handleFullScreenToggle,
              onFontChanged: (font) {
                ref.read(messageCreationNotifierProvider.notifier).updateFont(font);
              },
              onFontSizeChanged: (size) {
                ref.read(messageCreationNotifierProvider.notifier).updateFontSize(size);
              },
            )
          else
            VoiceRecordingWidget(
              recordings: messageState.voiceRecordings,
              isRecording: messageState.isRecording,
              currentRecordingDuration: messageState.recordingDuration,
              onStartRecording: () {
                ref.read(messageCreationNotifierProvider.notifier).startRecording();
              },
              onStopRecording: () {
                ref.read(messageCreationNotifierProvider.notifier).stopRecording();
              },
              onDeleteRecording: (index) {
                ref.read(messageCreationNotifierProvider.notifier).deleteRecording(index);
              },
              onInsertIntoText: (index) {
                final notifier = ref.read(messageCreationNotifierProvider.notifier);
                notifier.insertVoiceMarker(index, _textController);
              },
            ),
          
          const SizedBox(height: AppDimensions.spacingL),
          
          // Writing tools (only in write mode and not full-screen)
          if (messageState.mode == MessageMode.write && !_isFullScreen)
            WritingToolsWidget(
              selectedFont: messageState.selectedFont,
              fontSize: messageState.fontSize,
              onFontChanged: (font) {
                ref.read(messageCreationNotifierProvider.notifier).updateFont(font);
              },
              onFontSizeChanged: (size) {
                ref.read(messageCreationNotifierProvider.notifier).updateFontSize(size);
              },
              onInsertVoiceNote: () {
                // Switch to recording mode temporarily
                ref.read(messageCreationNotifierProvider.notifier).switchMode(MessageMode.record);
              },
            ),
        ],
      ),
    );
  }
  
  String _getSubtitleForRecipient(TimeCapsulePurpose? purpose) {
    if (purpose == null) return 'Write your heartfelt message';
    
    switch (purpose) {
      case TimeCapsulePurpose.futureMe:
        return 'A message for future you';
      case TimeCapsulePurpose.someoneSpecial:
        return 'A message for someone special';
      case TimeCapsulePurpose.anonymous:
        return 'An anonymous message of hope';
    }
  }
}