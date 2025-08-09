import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/chat_message.dart' as msg;
import '../models/chat_conversation.dart';
import '../models/social_battery_status.dart';
import '../services/websocket_service.dart';
import '../services/chat_repository.dart';
import '../../../core/storage/secure_storage_service.dart';

// Global WebSocket service instance
WebSocketService? _globalWebSocketService;

WebSocketService _getWebSocketService() {
  _globalWebSocketService ??= WebSocketService();
  return _globalWebSocketService!;
}

/// Real-time individual chat provider with WebSocket integration
class RealtimeIndividualChatProvider extends ChangeNotifier {
  final String conversationId;
  final ChatParticipant otherParticipant;

  WebSocketService? _webSocketService;
  late StreamSubscription _newMessageSubscription;
  late StreamSubscription _readReceiptSubscription;
  late StreamSubscription _typingSubscription;
  late StreamSubscription _onlineStatusSubscription;
  Timer? _typingTimer;
  Timer? _onlineStatusTimer;

  // State
  List<msg.ChatMessage> _messages = [];
  msg.MessageDraft _currentDraft = const msg.MessageDraft();
  List<msg.TypingIndicator> _typingIndicators = [];
  // Note: Message queue functionality can be implemented later for offline support
  bool _isLoading = false;
  bool _isOtherUserOnline = true;
  bool _isSlowModeActive = false;
  DateTime? _lastMessageSentAt;
  String? _replyToMessageId;
  String? _errorMessage;
  bool _isInitialized = false;
  bool _isInitializing = false;
  String? _currentUserId;

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
      // Get current user ID first
      _currentUserId = await SecureStorageService.getUserId();
      if (_currentUserId == null) {
        throw Exception('User not authenticated - no user ID found');
      }
      
      await _initializeWebSocket();
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

  /// Initialize WebSocket connection and event listeners
  Future<void> _initializeWebSocket() async {
    try {
      _webSocketService = _getWebSocketService();
      if (!_webSocketService!.isConnected) {
        await _webSocketService!.connect();
      }

      // Join this conversation for real-time updates
      await _webSocketService!.joinConversation(conversationId);

      // Listen to new messages
      _newMessageSubscription = _webSocketService!.onNewMessage.listen(
        _handleNewMessage,
        onError: (error) {
          debugPrint('❌ [RealtimeIndividualChat] New message stream error: $error');
        },
      );

      // Listen to read receipts
      _readReceiptSubscription = _webSocketService!.onReadReceipt.listen(
        _handleReadReceipt,
        onError: (error) {
          debugPrint('❌ [RealtimeIndividualChat] Read receipt stream error: $error');
        },
      );

      // Listen to typing indicators
      _typingSubscription = _webSocketService!.onTyping.listen(
        _handleTypingIndicator,
        onError: (error) {
          debugPrint('❌ [RealtimeIndividualChat] Typing stream error: $error');
        },
      );

      // Listen to online status updates
      _onlineStatusSubscription = _webSocketService!.onOnlineStatus.listen(
        _handleOnlineStatusUpdate,
        onError: (error) {
          debugPrint('❌ [RealtimeIndividualChat] Online status stream error: $error');
        },
      );

      debugPrint('✅ [RealtimeIndividualChat] WebSocket initialized for conversation: $conversationId');
    } catch (e) {
      debugPrint('❌ [RealtimeIndividualChat] WebSocket initialization failed: $e');
      _errorMessage = 'Failed to initialize real-time features: $e';
      notifyListeners();
    }
  }

  /// Load messages from API
  Future<void> _loadMessages() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final result = await chatRepository.getMessages(conversationId: conversationId);
      
      result.when(
        success: (apiMessages) async {
          // Convert API messages to app models
          _messages = _convertApiMessages(apiMessages);
          _isLoading = false;
          notifyListeners();
          
          debugPrint('✅ [RealtimeIndividualChat] Loaded ${_messages.length} messages');
          for (final msg in _messages) {
            debugPrint('📝 [RealtimeIndividualChat] Message: ${msg.id} - ${msg.content.substring(0, 20)}... - isFromMe: ${msg.isFromMe}');
          }
        },
        failure: (error) {
          _isLoading = false;
          _errorMessage = error.message;
          notifyListeners();
          debugPrint('❌ [RealtimeIndividualChat] Failed to load messages: ${error.message}');
        },
      );
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Unexpected error: $e';
      notifyListeners();
      debugPrint('❌ [RealtimeIndividualChat] Unexpected error loading messages: $e');
    }
  }

  /// Convert API messages to app message models
  List<msg.ChatMessage> _convertApiMessages(List<ApiMessage> apiMessages) {
    // API messages come in reverse chronological order (newest first)
    // We want oldest first for display
    final reversedMessages = apiMessages.reversed.toList();
    
    return reversedMessages.map((apiMsg) {
      return msg.ChatMessage(
        id: apiMsg.id,
        senderId: apiMsg.senderId,
        senderName: 'User', // We might need to fetch this separately
        conversationId: apiMsg.conversationId,
        type: _parseMessageType(apiMsg.messageType),
        timestamp: apiMsg.createdAt,
        status: msg.MessageStatus.delivered, // Default status
        content: apiMsg.content,
        isFromMe: apiMsg.senderId == _currentUserId,
        replyToMessageId: apiMsg.replyToMessageId,
        reactions: [], // We might need to fetch reactions separately
        voiceMessage: apiMsg.messageType == 'voice' 
            ? const msg.VoiceMessage(audioUrl: '', duration: Duration(seconds: 0))
            : null,
        imageMessage: apiMsg.messageType == 'image' 
            ? const msg.ImageMessage(imageUrl: '', width: 0, height: 0)
            : null,
        selfDestruct: apiMsg.selfDestructAt != null
            ? msg.SelfDestructMessage(
                countdown: apiMsg.selfDestructAt!.difference(DateTime.now()),
                createdAt: apiMsg.createdAt,
              )
            : null,
      );
    }).toList();
  }

  /// Parse message type from API string
  msg.MessageType _parseMessageType(String apiType) {
    switch (apiType) {
      case 'text':
        return msg.MessageType.text;
      case 'voice':
        return msg.MessageType.voice;
      case 'image':
        return msg.MessageType.image;
      case 'video':
        return msg.MessageType.text; // Fallback for video messages
      default:
        return msg.MessageType.text;
    }
  }

  /// Handle new message from WebSocket
  void _handleNewMessage(Map<String, dynamic> messageData) {
    try {
      final msgConversationId = messageData['conversation_id'] as String;
      if (msgConversationId != conversationId) return; // Not for this conversation
      
      final messageInfo = messageData['message'] as Map<String, dynamic>;
      
      final newMessage = msg.ChatMessage(
        id: messageInfo['id'] as String,
        senderId: messageInfo['sender_id'] as String,
        senderName: messageInfo['sender_username'] as String? ?? 'User',
        conversationId: msgConversationId,
        type: _parseMessageType(messageInfo['message_type'] as String),
        timestamp: DateTime.parse(messageInfo['created_at'] as String),
        status: msg.MessageStatus.delivered,
        content: messageInfo['content'] as String,
        isFromMe: messageInfo['sender_id'] as String == _currentUserId,
      );
      
      _messages.add(newMessage);
      notifyListeners();
      
      // Auto-mark as read if message is not from me
      if (!newMessage.isFromMe) {
        _markMessageAsRead(newMessage.id);
      }
      
      debugPrint('📨 [RealtimeIndividualChat] New message received: ${newMessage.id}');
    } catch (e) {
      debugPrint('❌ [RealtimeIndividualChat] Error handling new message: $e');
    }
  }

  /// Handle read receipt from WebSocket
  void _handleReadReceipt(Map<String, dynamic> receiptData) {
    try {
      final messageId = receiptData['message_id'] as String;
      final readerUserId = receiptData['reader_user_id'] as String;
      
      // Update message status to read
      for (int i = 0; i < _messages.length; i++) {
        if (_messages[i].id == messageId && _messages[i].isFromMe) {
          _messages[i] = _messages[i].copyWith(status: msg.MessageStatus.read);
          break;
        }
      }
      
      notifyListeners();
      debugPrint('✅ [RealtimeIndividualChat] Message read receipt: $messageId by $readerUserId');
    } catch (e) {
      debugPrint('❌ [RealtimeIndividualChat] Error handling read receipt: $e');
    }
  }

  /// Handle typing indicator from WebSocket
  void _handleTypingIndicator(WebSocketMessage message) {
    try {
      final msgConversationId = message.conversationId;
      if (msgConversationId != conversationId) return; // Not for this conversation
      
      final isTyping = message.data['is_typing'] as bool? ?? false;
      final userId = message.data['user_id'] as String? ?? '';
      final userName = message.data['username'] as String? ?? 'Someone';
      
      // Don't show typing indicator for own messages
      if (userId == _currentUserId) return;
      
      if (isTyping) {
        // Add or update typing indicator
        final existingIndex = _typingIndicators.indexWhere((t) => t.userId == userId);
        final typingIndicator = msg.TypingIndicator(
          userId: userId,
          userName: userName,
          startedAt: DateTime.now(),
          isActive: true,
        );
        
        if (existingIndex != -1) {
          _typingIndicators[existingIndex] = typingIndicator;
        } else {
          _typingIndicators.add(typingIndicator);
        }
      } else {
        // Remove typing indicator
        _typingIndicators.removeWhere((t) => t.userId == userId);
      }
      
      notifyListeners();
    } catch (e) {
      debugPrint('❌ [RealtimeIndividualChat] Error handling typing indicator: $e');
    }
  }

  /// Handle online status update from WebSocket
  void _handleOnlineStatusUpdate(WebSocketMessage message) {
    try {
      final onlineStatusData = message.data['online_status'] as Map<String, dynamic>?;
      
      if (onlineStatusData != null) {
        final otherUserOnlineStatus = onlineStatusData[otherParticipant.id] as bool?;
        if (otherUserOnlineStatus != null && otherUserOnlineStatus != _isOtherUserOnline) {
          _isOtherUserOnline = otherUserOnlineStatus;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('❌ [RealtimeIndividualChat] Error handling online status: $e');
    }
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
    final clientMessageId = 'client_${DateTime.now().millisecondsSinceEpoch}';
    
    // Create optimistic message for immediate UI update
    final optimisticMessage = msg.ChatMessage(
      id: clientMessageId,
      senderId: _currentUserId!,
      senderName: 'You',
      conversationId: conversationId,
      type: _currentDraft.type,
      timestamp: DateTime.now(),
      status: msg.MessageStatus.sending,
      content: messageContent,
      isFromMe: true,
      replyToMessageId: _replyToMessageId,
      voiceMessage: _currentDraft.voiceMessage,
      imageMessage: _currentDraft.imageMessage,
      selfDestruct: _currentDraft.isSelfDestruct 
          ? msg.SelfDestructMessage(
              countdown: _currentDraft.selfDestructDuration ?? const Duration(minutes: 5),
              createdAt: DateTime.now(),
            )
          : null,
    );

    // Add message to list for immediate UI update
    _messages.add(optimisticMessage);
    
    // Clear draft and reply
    _currentDraft = const msg.MessageDraft();
    _replyToMessageId = null;
    _lastMessageSentAt = DateTime.now();
    
    // Stop typing indicator
    _stopTypingIndicator();
    
    notifyListeners();

    try {
      // Send message via API
      final result = await chatRepository.sendMessage(
        conversationId: conversationId,
        content: messageContent,
        messageType: _currentDraft.type.name,
        replyToMessageId: _replyToMessageId,
        clientMessageId: clientMessageId,
      );

      result.when(
        success: (apiMessage) {
          // Update optimistic message with real data
          final messageIndex = _messages.indexWhere((m) => m.id == clientMessageId);
          if (messageIndex != -1) {
            final realMessage = msg.ChatMessage(
              id: apiMessage.id,
              senderId: apiMessage.senderId,
              senderName: 'You',
              conversationId: apiMessage.conversationId,
              type: _parseMessageType(apiMessage.messageType),
              timestamp: apiMessage.createdAt,
              status: msg.MessageStatus.sent,
              content: apiMessage.content,
              isFromMe: true,
              replyToMessageId: apiMessage.replyToMessageId,
            );
            
            _messages[messageIndex] = realMessage;
            notifyListeners();
            
            // Simulate delivery confirmation
            Timer(const Duration(milliseconds: 1000), () {
              final currentIndex = _messages.indexWhere((m) => m.id == apiMessage.id);
              if (currentIndex != -1) {
                _messages[currentIndex] = _messages[currentIndex].copyWith(
                  status: msg.MessageStatus.delivered,
                );
                notifyListeners();
              }
            });
          }
          
          debugPrint('✅ [RealtimeIndividualChat] Message sent successfully: ${apiMessage.id}');
        },
        failure: (error) {
          // Update optimistic message to show error
          final messageIndex = _messages.indexWhere((m) => m.id == clientMessageId);
          if (messageIndex != -1) {
            _messages[messageIndex] = _messages[messageIndex].copyWith(
              status: msg.MessageStatus.failed,
            );
            notifyListeners();
          }
          
          _errorMessage = 'Failed to send message: ${error.message}';
          notifyListeners();
          debugPrint('❌ [RealtimeIndividualChat] Failed to send message: ${error.message}');
        },
      );
    } catch (e) {
      // Update optimistic message to show error
      final messageIndex = _messages.indexWhere((m) => m.id == clientMessageId);
      if (messageIndex != -1) {
        _messages[messageIndex] = _messages[messageIndex].copyWith(
          status: msg.MessageStatus.failed,
        );
        notifyListeners();
      }
      
      _errorMessage = 'Unexpected error sending message: $e';
      notifyListeners();
      debugPrint('❌ [RealtimeIndividualChat] Unexpected error sending message: $e');
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
    try {
      final messageIndex = _messages.indexWhere((m) => m.id == messageId);
      if (messageIndex == -1) return;

      final message = _messages[messageIndex];
      
      // Check if user already reacted with this emoji
      if (message.hasMyReaction(emoji)) {
        // Remove existing reaction
        final updatedReactions = message.reactions
            .where((r) => !(r.isFromMe && r.emoji == emoji))
            .toList();
        
        _messages[messageIndex] = message.copyWith(reactions: updatedReactions);
      } else {
        // Add new reaction
        final newReaction = msg.MessageReaction(
          id: 'reaction_${DateTime.now().millisecondsSinceEpoch}',
          emoji: emoji,
          userId: _currentUserId!,
          userName: 'You',
          timestamp: DateTime.now(),
          isFromMe: true,
        );
        
        final updatedReactions = [...message.reactions, newReaction];
        _messages[messageIndex] = message.copyWith(reactions: updatedReactions);
      }

      notifyListeners();
      
      // Send reaction to server
      final result = await chatRepository.addReaction(
        messageId: messageId,
        emoji: emoji,
      );
      
      result.when(
        success: (_) {
          debugPrint('✅ [RealtimeIndividualChat] Reaction added: $emoji to $messageId');
        },
        failure: (error) {
          debugPrint('❌ [RealtimeIndividualChat] Failed to add reaction: ${error.message}');
        },
      );
      
      // Create haptic feedback
      HapticFeedback.selectionClick();
    } catch (e) {
      debugPrint('❌ [RealtimeIndividualChat] Error adding reaction: $e');
    }
  }

  /// Delete a message
  Future<void> deleteMessage(String messageId) async {
    try {
      final messageIndex = _messages.indexWhere((m) => m.id == messageId);
      if (messageIndex == -1) return;

      final message = _messages[messageIndex];
      
      // Only allow deletion of own messages within 5 minutes
      if (!message.isFromMe) return;
      
      final timeSinceSent = DateTime.now().difference(message.timestamp).inMinutes;
      if (timeSinceSent > 5) return;

      // Remove from local state immediately
      _messages.removeAt(messageIndex);
      notifyListeners();
      
      // Delete on server
      final result = await chatRepository.deleteMessage(messageId);
      result.when(
        success: (_) {
          debugPrint('✅ [RealtimeIndividualChat] Message deleted: $messageId');
        },
        failure: (error) {
          // Re-add message on failure
          _messages.insert(messageIndex, message);
          notifyListeners();
          debugPrint('❌ [RealtimeIndividualChat] Failed to delete message: ${error.message}');
        },
      );
      
      // Create haptic feedback
      HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('❌ [RealtimeIndividualChat] Error deleting message: $e');
    }
  }

  /// Mark message as read
  Future<void> _markMessageAsRead(String messageId) async {
    try {
      // Send via WebSocket for immediate delivery
      _webSocketService?.markMessageAsRead(messageId);
      
      // Also call REST API for reliability
      final result = await chatRepository.markMessageAsRead(messageId);
      result.when(
        success: (_) {
          debugPrint('✅ [RealtimeIndividualChat] Message marked as read: $messageId');
        },
        failure: (error) {
          debugPrint('❌ [RealtimeIndividualChat] Failed to mark message as read: ${error.message}');
        },
      );
    } catch (e) {
      debugPrint('❌ [RealtimeIndividualChat] Error marking message as read: $e');
    }
  }

  /// Start typing indicator
  void _sendTypingIndicator() {
    _typingTimer?.cancel();
    
    // Send typing start
    _webSocketService?.startTyping(conversationId);
    
    // Auto-stop after 3 seconds
    _typingTimer = Timer(const Duration(seconds: 3), _stopTypingIndicator);
  }

  /// Stop typing indicator
  void _stopTypingIndicator() {
    _typingTimer?.cancel();
    _typingTimer = null;
    
    // Send typing stop
    _webSocketService?.stopTyping(conversationId);
  }

  /// Start periodic online status updates
  void _startOnlineStatusUpdates() {
    _onlineStatusTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      // Request online status for the other participant
      _webSocketService?.getOnlineStatus([otherParticipant.id]);
      
      // Simulate typing occasionally for demo
      if (DateTime.now().millisecond % 10 == 0) { // 10% chance
        _simulateOtherUserTyping();
      }
    });
  }

  /// Simulate other user typing (for demo purposes)
  void _simulateOtherUserTyping() {
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
        _markMessageAsRead(message.id);
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
    _newMessageSubscription.cancel();
    _readReceiptSubscription.cancel();
    _typingSubscription.cancel();
    _onlineStatusSubscription.cancel();
    _typingTimer?.cancel();
    _onlineStatusTimer?.cancel();
    
    // Leave conversation
    _webSocketService?.leaveConversation(conversationId);
    _webSocketService?.dispose();
    
    super.dispose();
  }
}