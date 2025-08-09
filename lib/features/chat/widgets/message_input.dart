import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../models/chat_message.dart';
import '../providers/realtime_individual_chat_provider.dart';

/// Premium message input with auto-resizing, voice recording, and thoughtful interactions
class MessageInput extends StatefulWidget {
  const MessageInput({
    super.key,
    required this.provider,
    this.onMessageSent,
    this.onQuickReactionPressed,
  });

  final RealtimeIndividualChatProvider provider;
  final VoidCallback? onMessageSent;
  final VoidCallback? onQuickReactionPressed;

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput>
    with TickerProviderStateMixin {
  late TextEditingController _textController;
  late FocusNode _focusNode;
  late AnimationController _sendButtonController;
  late AnimationController _slowModeController;
  late Animation<double> _sendButtonScale;

  bool _isRecordingVoice = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
    _listenToProviderChanges();
  }

  void _initializeControllers() {
    _textController = TextEditingController();
    _focusNode = FocusNode();
    
    _sendButtonController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _slowModeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  void _setupAnimations() {
    _sendButtonScale = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sendButtonController,
      curve: Curves.elasticOut,
    ));

  }

  void _listenToProviderChanges() {
    widget.provider.addListener(_onProviderChanged);
  }

  void _onProviderChanged() {
    final canSend = widget.provider.canSendMessage;
    
    if (canSend) {
      _sendButtonController.forward();
    } else {
      _sendButtonController.reverse();
    }

    if (widget.provider.isSlowModeActive) {
      _slowModeController.forward();
    } else {
      _slowModeController.reverse();
    }
  }

  @override
  void dispose() {
    widget.provider.removeListener(_onProviderChanged);
    _textController.dispose();
    _focusNode.dispose();
    _sendButtonController.dispose();
    _slowModeController.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    widget.provider.updateDraft(text);
  }

  void _onSendPressed() {
    if (!widget.provider.canSendMessage) return;

    widget.provider.sendMessage();
    _textController.clear();
    widget.onMessageSent?.call();
    
    // Give haptic feedback
    HapticFeedback.lightImpact();
  }

  void _onVoiceRecordToggle() {
    setState(() {
      _isRecordingVoice = !_isRecordingVoice;
    });
    
    if (_isRecordingVoice) {
      HapticFeedback.heavyImpact();
      // TODO: Start voice recording
    } else {
      HapticFeedback.lightImpact();
      // TODO: Stop voice recording and process
    }
  }

  void _onPhotoPressed() {
    HapticFeedback.lightImpact();
    // TODO: Show photo picker
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pearlWhite.withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(
            color: AppColors.sageGreenWithOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppDimensions.paddingM),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Slow Mode Indicator
                _buildSlowModeIndicator(),
                
                // Quick Reactions Row
                _buildQuickReactionsRow(),
                
                // Main Input Container
                _buildMainInputContainer(),
              ],
            ),
          ),
      ),
    );
  }

  Widget _buildSlowModeIndicator() {
    return ListenableBuilder(
      listenable: widget.provider,
      builder: (context, _) {
        if (!widget.provider.isSlowModeActive) {
          return const SizedBox.shrink();
        }

        final cooldownRemaining = widget.provider.slowModeCooldownRemaining;
        final isInCooldown = cooldownRemaining > Duration.zero;

        return AnimatedBuilder(
          animation: _slowModeController,
          builder: (context, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _slowModeController,
                curve: Curves.easeOutCubic,
              )),
              child: Container(
                margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingM,
                  vertical: AppDimensions.spacingM,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.warmPeach.withValues(alpha: 0.1),
                      AppColors.sageGreen.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                  border: Border.all(
                    color: AppColors.warmPeach.withValues(alpha: 0.2),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    const Text('🐌', style: TextStyle(fontSize: 16.0)),
                    
                    const SizedBox(width: AppDimensions.spacingM),
                    
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Slow mode active',
                            style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          
                          Text(
                            isInCooldown
                                ? 'Wait ${cooldownRemaining.inSeconds}s before sending another message'
                                : 'Thoughtful conversation pace',
                            style: AppTextStyles.personalContent.copyWith(
                              fontSize: 12.0,
                              color: AppColors.softCharcoalLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    IconButton(
                      onPressed: widget.provider.toggleSlowMode,
                      icon: const Icon(
                        Icons.settings_outlined,
                        color: AppColors.sageGreen,
                        size: 20.0,
                      ),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(24.0, 24.0),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuickReactionsRow() {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.spacingM),
      height: 44.0,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: QuickReactions.defaultReactions.length,
        separatorBuilder: (context, index) => 
          const SizedBox(width: AppDimensions.spacingS),
        itemBuilder: (context, index) {
          final emoji = QuickReactions.defaultReactions[index];
          
          return _buildQuickReactionButton(emoji);
        },
      ),
    );
  }

  Widget _buildQuickReactionButton(String emoji) {
    return GestureDetector(
      onTap: () {
        widget.provider.sendQuickReaction(emoji);
        HapticFeedback.selectionClick();
      },
      child: Container(
        width: 44.0,
        height: 44.0,
        decoration: BoxDecoration(
          color: AppColors.sageGreenWithOpacity(0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusL),
          border: Border.all(
            color: AppColors.sageGreenWithOpacity(0.15),
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            emoji,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }

  Widget _buildMainInputContainer() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pearlWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
        border: Border.all(
          color: AppColors.sageGreenWithOpacity(0.15),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Voice/Photo Button
          _buildInputActionButton(),
          
          // Text Input
          Expanded(
            child: _buildTextInput(),
          ),
          
          // Send Button
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildInputActionButton() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacingS),
      child: GestureDetector(
        onTap: _isRecordingVoice ? null : _onPhotoPressed,
        onLongPressStart: (_) => _onVoiceRecordToggle(),
        onLongPressEnd: (_) => _onVoiceRecordToggle(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 36.0,
          height: 36.0,
          decoration: BoxDecoration(
            color: _isRecordingVoice 
                ? AppColors.dustyRose.withValues(alpha: 0.2)
                : AppColors.sageGreenWithOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: _isRecordingVoice 
                  ? AppColors.dustyRose
                  : AppColors.sageGreenWithOpacity(0.3),
              width: _isRecordingVoice ? 2.0 : 1.0,
            ),
          ),
          child: Icon(
            _isRecordingVoice ? Icons.mic : Icons.add,
            color: _isRecordingVoice ? AppColors.dustyRose : AppColors.sageGreen,
            size: 20.0,
          ),
        ),
      ),
    );
  }

  Widget _buildTextInput() {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minHeight: 36.0,
        maxHeight: 100.0,
      ),
      child: ListenableBuilder(
        listenable: widget.provider,
        builder: (context, _) {
          final replyToMessage = widget.provider.replyToMessageId != null
              ? widget.provider.getMessageById(widget.provider.replyToMessageId!)
              : null;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Reply Preview
              if (replyToMessage != null)
                _buildReplyPreview(replyToMessage),

              // Text Input Field
              TextField(
                controller: _textController,
                focusNode: _focusNode,
                onChanged: _onTextChanged,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                style: AppTextStyles.personalContent.copyWith(
                  fontSize: 15.0,
                  color: AppColors.softCharcoal,
                ),
                decoration: InputDecoration(
                  hintText: _getHintText(),
                  hintStyle: AppTextStyles.personalContent.copyWith(
                    fontSize: 15.0,
                    color: AppColors.softCharcoalLight,
                    fontStyle: FontStyle.italic,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.paddingM,
                    vertical: AppDimensions.spacingM,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildReplyPreview(ChatMessage replyToMessage) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppDimensions.paddingM,
        AppDimensions.spacingS,
        AppDimensions.paddingM,
        0,
      ),
      padding: const EdgeInsets.all(AppDimensions.spacingS),
      decoration: BoxDecoration(
        color: AppColors.sageGreenWithOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimensions.spacingS),
        border: Border(
          left: BorderSide(
            color: AppColors.sageGreen,
            width: 3.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Replying to ${replyToMessage.senderName}',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.sageGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                
                const SizedBox(height: 2.0),
                
                Text(
                  replyToMessage.contentPreview,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.softCharcoalLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          
          GestureDetector(
            onTap: widget.provider.clearReply,
            child: Container(
              padding: const EdgeInsets.all(4.0),
              child: const Icon(
                Icons.close,
                size: 16.0,
                color: AppColors.softCharcoalLight,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return Container(
      margin: const EdgeInsets.all(AppDimensions.spacingS),
      child: ListenableBuilder(
        listenable: widget.provider,
        builder: (context, _) {
          final canSend = widget.provider.canSendMessage;
          
          return AnimatedBuilder(
            animation: _sendButtonController,
            builder: (context, child) {
              return Transform.scale(
                scale: _sendButtonScale.value,
                child: GestureDetector(
                  onTap: canSend ? _onSendPressed : null,
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      gradient: canSend
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [AppColors.sageGreen, AppColors.sageGreenHover],
                            )
                          : null,
                      color: canSend ? null : AppColors.sageGreenWithOpacity(0.3),
                      shape: BoxShape.circle,
                      boxShadow: canSend
                          ? [
                              BoxShadow(
                                color: AppColors.buttonShadow,
                                blurRadius: 8.0,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Icon(
                      Icons.send_rounded,
                      color: AppColors.pearlWhite,
                      size: 20.0,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _getHintText() {
    final socialBattery = widget.provider.otherUserSocialBattery;
    
    if (socialBattery?.needsGentleInteraction == true) {
      return 'Share your thoughts gently...';
    }
    
    return 'Share your thoughts mindfully...';
  }
}