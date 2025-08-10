import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/chat_message.dart' as msg;
import '../models/chat_conversation.dart';
import '../models/social_battery_status.dart';
// TODO: Import WebSocket and ChatRepository services when implemented
// import '../services/websocket_service.dart';
// import '../services/chat_repository.dart';
// import '../../../core/storage/secure_storage_service.dart';

/// Real-time individual chat provider with WebSocket integration (mock implementation)
class RealtimeIndividualChatProvider extends ChangeNotifier {
  final String conversationId;
  final ChatParticipant otherParticipant;

  Timer? _typingTimer;
  Timer? _onlineStatusTimer;

  // State
  List<msg.ChatMessage> _messages = [];
  msg.MessageDraft _currentDraft = const msg.MessageDraft();
  List<msg.TypingIndicator> _typingIndicators = [];
  bool _isLoading = false;
  bool _isOtherUserOnline = true;
  bool _isSlowModeActive = false;
  DateTime? _lastMessageSentAt;
  String? _replyToMessageId;
  String? _errorMessage;
  bool _isInitialized = false;
  bool _isInitializing = false;
  String? _currentUserId; // TODO: Use for message ownership and API calls

  // Getters
  List<msg.ChatMessage> get messages => _messages;
  msg.MessageDraft get currentDraft => _currentDraft;
  List<msg.TypingIndicator> get activeTypingIndicators => 
      _typingIndicators.where((t) => t.isValid).toList();
  bool get isLoading => _isLoading;
  bool get isOtherUserOnline => _isOtherUserOnline;
  bool get isSlowModeActive => _isSlowModeActive;
  bool get canSendMessage => _currentDraft.hasContent && !_isInSlowModeCooldown;
  bool get hasMessages => _messages.isNotEmpty;
  bool get isOtherUserTyping => activeTypingIndicators.isNotEmpty;
  String? get replyToMessageId => _replyToMessageId;
  String? get errorMessage => _errorMessage;
  bool get isInitialized => _isInitialized;
  bool get isInitializing => _isInitializing;

  /// Check if user is in slow mode cooldown
  bool get _isInSlowModeCooldown {
    if (!_isSlowModeActive || _lastMessageSentAt == null) return false;
    
    final cooldownPeriod = const Duration(seconds: 30); // 30 second cooldown
    final elapsed = DateTime.now().difference(_lastMessageSentAt!);
    return elapsed < cooldownPeriod;
  }

  /// Get remaining cooldown time
  Duration get slowModeCooldownRemaining {
    if (!_isInSlowModeCooldown) return Duration.zero;
    
    final cooldownPeriod = const Duration(seconds: 30);
    final elapsed = DateTime.now().difference(_lastMessageSentAt!);
    return cooldownPeriod - elapsed;
  }

  /// Get other participant's social battery status
  SocialBatteryStatus? get otherUserSocialBattery => otherParticipant.socialBattery;

  /// Get other participant's display name
  String get otherUserName => otherParticipant.name;

  /// Get other participant's online status text  
  String get otherUserStatusText {
    if (isOtherUserTyping) return 'typing...';
    if (_isOtherUserOnline) return 'Online';
    return otherParticipant.onlineStatusText;
  }

  RealtimeIndividualChatProvider({
    required this.conversationId,
    required this.otherParticipant,
  });

  /// Initialize provider (call from screen after provider is created)
  Future<void> initialize() async {
    if (_isInitialized || _isInitializing) return;
    
    _isInitializing = true;
    notifyListeners();
    
    try {
      // TODO: Get current user ID from secure storage
      _currentUserId = 'mock_user_id';
      
      await _loadMessages();
      _startOnlineStatusUpdates();
      
      // Set slow mode based on social battery
      final socialBattery = otherParticipant.socialBattery;
      _isSlowModeActive = socialBattery?.needsGentleInteraction ?? false;
      
      _isInitialized = true;
    } catch (e) {
      _errorMessage = 'Failed to initialize: $e';
      debugPrint('❌ [RealtimeIndividualChat] Initialization failed: $e');
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  /// Load messages (using mock data for now)
  Future<void> _loadMessages() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Simulate API delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      // Generate mock messages
      _messages = _generateMockMessages();
      
      _isLoading = false;
      notifyListeners();
      
      debugPrint('✅ [RealtimeIndividualChat] Loaded ${_messages.length} mock messages for user: $_currentUserId');
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Unexpected error: $e';
      notifyListeners();
      debugPrint('❌ [RealtimeIndividualChat] Unexpected error loading messages: $e');
    }
  }

  /// Generate mock messages for development
  List<msg.ChatMessage> _generateMockMessages() {
    return [
      msg.ChatMessage(
        id: 'msg_1',
        senderId: otherParticipant.id,
        senderUsername: otherParticipant.name,
        conversationId: conversationId,
        messageType: msg.MessageType.text,
        createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
        status: msg.MessageStatus.read,
        content: "Hey! How are you feeling today? I'm in a selective mood but always have energy for you 😊",
        reactions: [
          msg.Reaction(
            userId: 'current_user',
            emoji: '❤️',
            createdAt: DateTime.now().subtract(const Duration(minutes: 44)),
          ),
        ],
        isFromMe: false,
      ),
      
      msg.ChatMessage(
        id: 'msg_2',
        senderId: 'current_user',
        senderUsername: 'You',
        conversationId: conversationId,
        messageType: msg.MessageType.text,
        createdAt: DateTime.now().subtract(const Duration(minutes: 42)),
        status: msg.MessageStatus.read,
        content: "I'm doing wonderful! Just finished my morning meditation and I'm feeling really centered. How's your social battery looking today?",
        isFromMe: true,
      ),
      
      msg.ChatMessage(
        id: 'msg_3',
        senderId: otherParticipant.id,
        senderUsername: otherParticipant.name,
        conversationId: conversationId,
        messageType: msg.MessageType.voice,
        createdAt: DateTime.now().subtract(const Duration(minutes: 40)),
        status: msg.MessageStatus.delivered,
        content: 'Voice message',
        isFromMe: false,
      ),
      
      msg.ChatMessage(
        id: 'msg_4',
        senderId: 'current_user',
        senderUsername: 'You',
        conversationId: conversationId,
        messageType: msg.MessageType.text,
        createdAt: DateTime.now().subtract(const Duration(minutes: 38)),
        status: msg.MessageStatus.read,
        content: "This message will disappear soon - just wanted to say you're amazing 💫",
        isFromMe: true,
      ),
      
      msg.ChatMessage(
        id: 'msg_5',
        senderId: otherParticipant.id,
        senderUsername: otherParticipant.name,
        conversationId: conversationId,
        messageType: msg.MessageType.text,
        createdAt: DateTime.now().subtract(const Duration(minutes: 35)),
        status: msg.MessageStatus.read,
        content: "Perfect! I'm feeling yellow today - selective responses mode. Thanks for being so understanding about my energy levels 💛",
        reactions: [
          msg.Reaction(
            userId: 'current_user',
            emoji: '🤗',
            createdAt: DateTime.now().subtract(const Duration(minutes: 34)),
          ),
          msg.Reaction(
            userId: 'current_user',
            emoji: '💛',
            createdAt: DateTime.now().subtract(const Duration(minutes: 34)),
          ),
        ],
        isFromMe: false,
      ),
      
      msg.ChatMessage(
        id: 'msg_6',
        senderId: 'current_user',
        senderUsername: 'You',
        conversationId: conversationId,
        messageType: msg.MessageType.text,
        createdAt: DateTime.now().subtract(const Duration(minutes: 32)),
        status: msg.MessageStatus.delivered,
        content: "No worries at all! Take your time with responses. Want to do some parallel reading later when you're feeling more social? No pressure at all 📚",
        isFromMe: true,
      ),
    ];
  }

  /// Update current message draft
  void updateDraft(String content) {
    if (_currentDraft.content == content) return;
    
    _currentDraft = _currentDraft.copyWith(content: content);
    notifyListeners();

    // Send typing indicator if content is not empty
    if (content.trim().isNotEmpty) {
      _sendTypingIndicator();
    } else {
      _stopTypingIndicator();
    }
  }

  /// Set reply to message
  void setReplyToMessage(String? messageId) {
    _replyToMessageId = messageId;
    notifyListeners();
  }

  /// Clear reply
  void clearReply() {
    setReplyToMessage(null);
  }

  /// Send current message
  Future<void> sendMessage() async {
    if (!canSendMessage) return;

    // Create haptic feedback
    HapticFeedback.lightImpact();

    final messageContent = _currentDraft.content.trim();
    final messageId = 'msg_${DateTime.now().millisecondsSinceEpoch}';
    
    // Create new message
    final newMessage = msg.ChatMessage(
      id: messageId,
      senderId: 'current_user',
      senderUsername: 'You',
      conversationId: conversationId,
      messageType: _currentDraft.type,
      createdAt: DateTime.now(),
      status: msg.MessageStatus.sending,
      content: messageContent,
      isFromMe: true,
      replyToMessageId: _replyToMessageId,
    );

    // Add message to list
    _messages.add(newMessage);
    
    // Clear draft and reply
    _currentDraft = const msg.MessageDraft();
    _replyToMessageId = null;
    _lastMessageSentAt = DateTime.now();
    
    // Stop typing indicator
    _stopTypingIndicator();
    
    notifyListeners();

    // Simulate message sending
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Update message status to sent
    final messageIndex = _messages.indexWhere((m) => m.id == messageId);
    if (messageIndex != -1) {
      _messages[messageIndex] = _messages[messageIndex].copyWith(
        status: msg.MessageStatus.sent,
      );
      notifyListeners();
    }

    // Simulate delivery confirmation
    await Future.delayed(const Duration(milliseconds: 1000));
    
    if (messageIndex != -1) {
      _messages[messageIndex] = _messages[messageIndex].copyWith(
        status: msg.MessageStatus.delivered,
      );
      notifyListeners();
    }

    // Simulate other user reading (sometimes)
    if (DateTime.now().millisecond % 3 == 0) {
      await Future.delayed(const Duration(seconds: 2));
      
      if (messageIndex != -1) {
        _messages[messageIndex] = _messages[messageIndex].copyWith(
          status: msg.MessageStatus.read,
        );
        notifyListeners();
      }
    }
  }

  /// Send quick reaction to last received message
  Future<void> sendQuickReaction(String emoji) async {
    // Find last received message
    final lastReceivedMessage = _messages
        .where((m) => !m.isFromMe)
        .lastOrNull;
    
    if (lastReceivedMessage == null) return;

    await addReaction(lastReceivedMessage.id, emoji);
    
    // Create haptic feedback
    HapticFeedback.selectionClick();
  }

  /// Add reaction to a message
  Future<void> addReaction(String messageId, String emoji) async {
    final messageIndex = _messages.indexWhere((m) => m.id == messageId);
    if (messageIndex == -1) return;

    final message = _messages[messageIndex];
    
    // Check if user already reacted with this emoji
    if (message.hasUserReaction(emoji, 'current_user')) {
      // Remove existing reaction
      final updatedReactions = message.reactions
          .where((r) => !(r.userId == 'current_user' && r.emoji == emoji))
          .toList();
      
      _messages[messageIndex] = message.copyWith(reactions: updatedReactions);
    } else {
      // Add new reaction
      final newReaction = msg.Reaction(
        userId: 'current_user',
        emoji: emoji,
        createdAt: DateTime.now(),
      );
      
      final updatedReactions = [...message.reactions, newReaction];
      _messages[messageIndex] = message.copyWith(reactions: updatedReactions);
    }

    notifyListeners();
    
    // Create haptic feedback
    HapticFeedback.selectionClick();
  }

  /// Delete a message
  Future<void> deleteMessage(String messageId) async {
    final messageIndex = _messages.indexWhere((m) => m.id == messageId);
    if (messageIndex == -1) return;

    final message = _messages[messageIndex];
    
    // Only allow deletion of own messages within 5 minutes
    if (!message.isFromMe) return;
    
    final timeSinceSent = DateTime.now().difference(message.createdAt).inMinutes;
    if (timeSinceSent > 5) return;

    _messages.removeAt(messageIndex);
    notifyListeners();
    
    // Create haptic feedback
    HapticFeedback.heavyImpact();
  }

  /// Start typing indicator
  void _sendTypingIndicator() {
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 3), _stopTypingIndicator);
  }

  /// Stop typing indicator
  void _stopTypingIndicator() {
    _typingTimer?.cancel();
    _typingTimer = null;
  }

  /// Simulate other user typing
  void _simulateOtherUserTyping() {
    if (DateTime.now().millisecond % 10 == 0) { // 10% chance
      final typingIndicator = msg.TypingIndicator(
        userId: otherParticipant.id,
        userName: otherParticipant.name,
        startedAt: DateTime.now(),
        isActive: true,
      );
      
      _typingIndicators = [typingIndicator];
      notifyListeners();
      
      // Stop typing after 3 seconds
      Timer(const Duration(seconds: 3), () {
        _typingIndicators.clear();
        notifyListeners();
      });
    }
  }

  /// Start periodic online status updates
  void _startOnlineStatusUpdates() {
    _onlineStatusTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      // Simulate online status changes
      if (DateTime.now().millisecond % 7 == 0) {
        _isOtherUserOnline = !_isOtherUserOnline;
        notifyListeners();
      }
      
      // Simulate typing
      _simulateOtherUserTyping();
    });
  }

  /// Toggle slow mode
  void toggleSlowMode() {
    _isSlowModeActive = !_isSlowModeActive;
    notifyListeners();
  }

  /// Refresh messages
  Future<void> refreshMessages() async {
    await _loadMessages();
  }

  /// Mark all messages as read
  void markAllAsRead() {
    bool hasChanges = false;
    
    for (int i = 0; i < _messages.length; i++) {
      final message = _messages[i];
      if (!message.isFromMe && message.status != msg.MessageStatus.read) {
        _messages[i] = message.copyWith(status: msg.MessageStatus.read);
        hasChanges = true;
      }
    }
    
    if (hasChanges) {
      notifyListeners();
    }
  }

  /// Get message by ID
  msg.ChatMessage? getMessageById(String messageId) {
    try {
      return _messages.firstWhere((m) => m.id == messageId);
    } catch (e) {
      return null;
    }
  }

  /// Get messages grouped by date
  Map<String, List<msg.ChatMessage>> get messagesByDate {
    final Map<String, List<msg.ChatMessage>> grouped = {};
    
    for (final message in _messages) {
      final dateKey = message.formattedDate;
      grouped.putIfAbsent(dateKey, () => []).add(message);
    }
    
    return grouped;
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    // TODO: Cancel WebSocket subscriptions when implemented
    _typingTimer?.cancel();
    _onlineStatusTimer?.cancel();
    super.dispose();
  }
}