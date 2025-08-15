import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/network/api_result.dart';
import '../models/chat_message.dart';
import '../models/chat_conversation.dart';

/// Data models for API requests and responses
class ConversationCreateRequest {
  final List<String> participantIds;
  final String conversationType;

  const ConversationCreateRequest({
    required this.participantIds,
    required this.conversationType,
  });

  Map<String, dynamic> toJson() => {
    'participant_ids': participantIds,
    'conversation_type': conversationType,
  };
}

class SendMessageRequest {
  final String content;
  final String messageType;
  final String? replyToMessageId;
  final List<String> attachments;
  final int? selfDestructTimer;
  final String? clientMessageId;

  const SendMessageRequest({
    required this.content,
    this.messageType = 'text',
    this.replyToMessageId,
    this.attachments = const [],
    this.selfDestructTimer,
    this.clientMessageId,
  });

  Map<String, dynamic> toJson({String? conversationId}) => {
    'content': content,
    'message_type': messageType,
    if (conversationId != null) 'conversation_id': conversationId, // REQUIRED BY BACKEND
    if (replyToMessageId != null) 'reply_to_message_id': replyToMessageId,
    'attachments': attachments, // Always include as List<String>, never null
    if (selfDestructTimer != null) 'self_destruct_timer': selfDestructTimer,
    if (clientMessageId != null) 'client_message_id': clientMessageId,
  };
}

/// Legacy API models - keeping for compatibility with old methods that haven't been updated yet

/// Repository for chat-related API calls
class ChatRepository {
  // Environment configuration
  static const bool _useProduction = true; // Change to false for development
  
  // Dynamic base URL that matches ApiClient configuration
  static String get _baseUrl {
    if (_useProduction) {
      // Production backend URL
      return 'https://future.bytefuse.in/api/v1/messages';
    }
    
    // Development URLs based on platform
    if (kIsWeb) {
      // Web - use localhost
      return 'http://127.0.0.1:8000/api/v1/messages';
    } else if (Platform.isAndroid) {
      // Android emulator - use 10.0.2.2 (special IP that maps to host)
      return 'http://10.0.2.2:8000/api/v1/messages';
    } else if (Platform.isIOS) {
      // iOS simulator - use localhost
      return 'http://127.0.0.1:8000/api/v1/messages';
    } else {
      // Default fallback
      return 'http://127.0.0.1:8000/api/v1/messages';
    }
  }

  /// Get authorization headers with JWT token
  Future<Map<String, String>> _getHeaders() async {
    final accessToken = await SecureStorageService.getAccessToken();
    debugPrint('🔑 [ChatRepository] Access token exists: ${accessToken != null}');
    debugPrint('🔑 [ChatRepository] Token length: ${accessToken?.length ?? 0}');
    
    if (accessToken == null || accessToken.isEmpty) {
      debugPrint('❌ [ChatRepository] CRITICAL: No access token available for API request');
    }
    
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${accessToken ?? ''}',
    };
  }

  /// Handle HTTP response and convert to ApiResult
  Future<ApiResult<T>> _handleResponse<T>(
    Future<http.Response> responseFunction,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await responseFunction;
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('🔍 [ChatRepository] Response data structure: ${responseData.toString()}');
        debugPrint('🔍 [ChatRepository] Response data keys: ${responseData.keys.toList()}');
        debugPrint('🔍 [ChatRepository] Response data types: ${responseData.map((key, value) => MapEntry(key, value.runtimeType.toString()))}');
        
        try {
          return ApiResult.success(fromJson(responseData));
        } catch (parseError) {
          debugPrint('❌ [ChatRepository] JSON parsing error: $parseError');
          debugPrint('❌ [ChatRepository] Failed to parse response: ${responseData.toString()}');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse response: $parseError',
            statusCode: response.statusCode,
          ));
        }
      } else {
        final errorMessage = responseData['detail'] as String? ?? 
                           'Request failed with status: ${response.statusCode}';
        return ApiResult.failure(ApiError(
          message: errorMessage,
          statusCode: response.statusCode,
        ));
      }
    } on FormatException catch (e) {
      return ApiResult.failure(ApiError(
        message: 'Invalid response format: $e',
        statusCode: 0,
      ));
    } catch (e) {
      return ApiResult.failure(ApiError(
        message: 'Network error: $e',
        statusCode: 0,
      ));
    }
  }


  /// Create a new conversation with proper type conversion
  Future<ApiResult<Conversation>> createConversation({
    required List<String> participantIds,
    required String conversationType,
  }) async {
    final request = ConversationCreateRequest(
      participantIds: participantIds,
      conversationType: conversationType,
    );

    debugPrint('🔗 [ChatRepository] Creating conversation with: ${participantIds.length} participants');

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/conversations'),
        headers: await _getHeaders(),
        body: jsonEncode(request.toJson()),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final userId = await _getCurrentUserId();
        
        try {
          debugPrint('🔍 [ChatRepository] Parsing single conversation response data keys: ${responseData.keys.toList()}');
          final conversation = Conversation.fromApiConversation(responseData, userId);
          return ApiResult.success(conversation);
        } catch (parseError, stackTrace) {
          debugPrint('❌ [ChatRepository] JSON parsing error: $parseError');
          debugPrint('❌ [ChatRepository] Stack trace: $stackTrace');
          debugPrint('❌ [ChatRepository] Failed to parse response structure: ${responseData.toString()}');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse response: $parseError',
            statusCode: response.statusCode,
          ));
        }
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = errorData['detail'] as String? ?? 
                           'Request failed with status: ${response.statusCode}';
        return ApiResult.failure(ApiError(
          message: errorMessage,
          statusCode: response.statusCode,
        ));
      }
    } catch (e) {
      return ApiResult.failure(ApiError(
        message: 'Network error: $e',
        statusCode: 0,
      ));
    }
  }

  /// Get user's conversations with proper type conversion
  Future<ApiResult<List<Conversation>>> getConversations({
    int limit = 20,
    int offset = 0,
  }) async {
    final uri = Uri.parse('$_baseUrl/conversations')
        .replace(queryParameters: {
      'limit': limit.toString(),
      'offset': offset.toString(),
    });

    debugPrint('🔗 [ChatRepository] Fetching conversations: limit=$limit, offset=$offset');

    try {
      final response = await http.get(uri, headers: await _getHeaders());
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body);
        
        if (responseData is List) {
          // Get current user ID for message processing
          final userId = await _getCurrentUserId();
          
          debugPrint('🔍 [ChatRepository] Processing ${responseData.length} conversations');
          
          final conversations = <Conversation>[];
          for (int i = 0; i < responseData.length; i++) {
            try {
              final item = responseData[i] as Map<String, dynamic>;
              debugPrint('🔍 [ChatRepository] Processing conversation $i with keys: ${item.keys.toList()}');
              final conversation = Conversation.fromApiConversation(item, userId);
              conversations.add(conversation);
            } catch (e, stackTrace) {
              debugPrint('❌ [ChatRepository] Failed to parse conversation $i: $e');
              debugPrint('❌ [ChatRepository] Stack trace: $stackTrace');
              debugPrint('❌ [ChatRepository] Conversation data: ${responseData[i]}');
              // Continue processing other conversations instead of failing completely
              continue;
            }
          }
          
          return ApiResult.success(conversations);
        } else {
          return ApiResult.failure(ApiError(
            message: 'Expected list response but got: ${responseData.runtimeType}',
            statusCode: response.statusCode,
          ));
        }
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = errorData['detail'] as String? ?? 
                           'Request failed with status: ${response.statusCode}';
        return ApiResult.failure(ApiError(
          message: errorMessage,
          statusCode: response.statusCode,
        ));
      }
    } catch (e) {
      return ApiResult.failure(ApiError(
        message: 'Network error: $e',
        statusCode: 0,
      ));
    }
  }

  /// Send a message in a conversation with proper type conversion
  Future<ApiResult<ChatMessage>> sendMessage({
    required String conversationId,
    required String content,
    String messageType = 'text',
    String? replyToMessageId,
    List<String> attachments = const [],
    int? selfDestructTimer,
    String? clientMessageId,
  }) async {
    final request = SendMessageRequest(
      content: content,
      messageType: messageType,
      replyToMessageId: replyToMessageId,
      attachments: attachments,
      selfDestructTimer: selfDestructTimer,
      clientMessageId: clientMessageId,
    );

    final payload = request.toJson(conversationId: conversationId);
    debugPrint('🔗 [ChatRepository] Sending message payload: ${jsonEncode(payload)}');

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/conversations/$conversationId/messages'),
        headers: await _getHeaders(),
        body: jsonEncode(payload),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final userId = await _getCurrentUserId();
        
        try {
          final message = ChatMessage.fromApiMessage(responseData, userId);
          return ApiResult.success(message);
        } catch (parseError) {
          debugPrint('❌ [ChatRepository] JSON parsing error: $parseError');
          debugPrint('❌ [ChatRepository] Failed to parse response: ${responseData.toString()}');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse response: $parseError',
            statusCode: response.statusCode,
          ));
        }
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        debugPrint('❌ [ChatRepository] Send Message HTTP ${response.statusCode} Error: ${response.body}');
        
        final errorMessage = errorData['message'] as String? ?? 
                           errorData['detail'] as String? ?? 
                           'Request failed with status: ${response.statusCode}';
        return ApiResult.failure(ApiError(
          message: errorMessage,
          statusCode: response.statusCode,
        ));
      }
    } catch (e) {
      return ApiResult.failure(ApiError(
        message: 'Network error: $e',
        statusCode: 0,
      ));
    }
  }

  /// Get messages from a conversation with proper pagination and type conversion
  Future<ApiResult<List<ChatMessage>>> getMessages({
    required String conversationId,
    int limit = 100,
    int offset = 0,
    String? beforeMessageId,
  }) async {
    final queryParams = <String, String>{
      'limit': limit.toString(),
    };
    
    // Use before_message_id for proper pagination (preferred over offset)
    if (beforeMessageId != null) {
      queryParams['before_message_id'] = beforeMessageId;
    } else {
      queryParams['offset'] = offset.toString();
    }

    final uri = Uri.parse('$_baseUrl/conversations/$conversationId/messages')
        .replace(queryParameters: queryParams);

    debugPrint('🔗 [ChatRepository] Fetching messages for conversation: $conversationId, limit=$limit, beforeMessageId=$beforeMessageId');
    debugPrint('🔗 [ChatRepository] Request URI: $uri');
    debugPrint('🔗 [ChatRepository] Query parameters: ${uri.queryParameters}');

    try {
      final response = await http.get(uri, headers: await _getHeaders());
      
      debugPrint('🔗 [ChatRepository] Response status: ${response.statusCode}');
      debugPrint('🔗 [ChatRepository] Response body: ${response.body}');
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body);
        debugPrint('🔗 [ChatRepository] Parsed response type: ${responseData.runtimeType}');
        
        if (responseData is List) {
          debugPrint('🔗 [ChatRepository] Response is a list with ${responseData.length} items');
          // Get current user ID for message processing
          final userId = await _getCurrentUserId();
          
          // Log each message before processing
          if (responseData.isNotEmpty) {
            debugPrint('🔗 [ChatRepository] Sample message from API: ${responseData[0]}');
          }
          
          // Messages come from API in reverse chronological order (newest first)
          // We need to reverse them for display (oldest first, newest last)
          final messages = responseData
              .map((item) => ChatMessage.fromApiMessage(
                  item as Map<String, dynamic>,
                  userId,
                ))
              .toList()
              .reversed
              .toList();
              
          debugPrint('🔗 [ChatRepository] Loaded ${messages.length} messages, reversed for display');
          if (messages.isNotEmpty) {
            debugPrint('🔗 [ChatRepository] First message content: ${messages.first.content}');
            debugPrint('🔗 [ChatRepository] Last message content: ${messages.last.content}');
          }
          return ApiResult.success(messages);
        } else {
          return ApiResult.failure(ApiError(
            message: 'Expected list response but got: ${responseData.runtimeType}',
            statusCode: response.statusCode,
          ));
        }
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = errorData['detail'] as String? ?? 
                           'Request failed with status: ${response.statusCode}';
        return ApiResult.failure(ApiError(
          message: errorMessage,
          statusCode: response.statusCode,
        ));
      }
    } catch (e) {
      return ApiResult.failure(ApiError(
        message: 'Network error: $e',
        statusCode: 0,
      ));
    }
  }

  /// Mark a message as read
  Future<ApiResult<void>> markMessageAsRead(String messageId) async {
    debugPrint('🔗 [ChatRepository] Marking message as read: $messageId');

    return await _handleResponse<void>(
      http.post(
        Uri.parse('$_baseUrl/messages/$messageId/read'),
        headers: await _getHeaders(),
      ),
      (_) {},
    );
  }

  /// Mark all messages in a conversation as read (Blue Tick for all messages)
  Future<ApiResult<void>> markConversationAsRead(String conversationId) async {
    debugPrint('🔗 [ChatRepository] Marking conversation as read: $conversationId');

    return await _handleResponse<void>(
      http.post(
        Uri.parse('$_baseUrl/conversations/$conversationId/read'),
        headers: await _getHeaders(),
      ),
      (_) {},
    );
  }

  /// Mark messages in conversation as delivered (Gray Double Tick)
  Future<ApiResult<Map<String, dynamic>>> markConversationAsDelivered(String conversationId) async {
    debugPrint('🔗 [ChatRepository] Marking conversation as delivered: $conversationId');

    return await _handleResponse<Map<String, dynamic>>(
      http.post(
        Uri.parse('$_baseUrl/conversations/$conversationId/mark-delivered'),
        headers: await _getHeaders(),
      ),
      (json) => json,
    );
  }

  /// Update individual message delivery status
  Future<ApiResult<Map<String, dynamic>>> updateMessageDeliveryStatus({
    required String messageId,
    required String newStatus, // "sent", "delivered", "read"
  }) async {
    debugPrint('🔗 [ChatRepository] Updating message $messageId status to: $newStatus');

    final uri = Uri.parse('$_baseUrl/messages/$messageId/delivery-status')
        .replace(queryParameters: {'new_status': newStatus});

    return await _handleResponse<Map<String, dynamic>>(
      http.post(uri, headers: await _getHeaders()),
      (json) => json,
    );
  }

  /// Get message status details
  Future<ApiResult<Map<String, dynamic>>> getMessageStatus(String messageId) async {
    debugPrint('🔗 [ChatRepository] Getting status for message: $messageId');

    return await _handleResponse<Map<String, dynamic>>(
      http.get(
        Uri.parse('$_baseUrl/messages/$messageId/status'),
        headers: await _getHeaders(),
      ),
      (json) => json,
    );
  }

  /// Send typing indicator
  Future<ApiResult<void>> sendTypingIndicator({
    required String conversationId,
    required bool isTyping,
  }) async {
    final uri = Uri.parse('$_baseUrl/conversations/$conversationId/typing')
        .replace(queryParameters: {
      'is_typing': isTyping.toString(),
    });

    debugPrint('🔗 [ChatRepository] Sending typing indicator: $conversationId, isTyping: $isTyping');

    return await _handleResponse<void>(
      http.post(uri, headers: await _getHeaders()),
      (_) {},
    );
  }

  /// Get conversation by ID with proper type conversion
  Future<ApiResult<Conversation>> getConversation(String conversationId) async {
    debugPrint('🔗 [ChatRepository] Fetching conversation: $conversationId');

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/conversations/$conversationId'),
        headers: await _getHeaders(),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final userId = await _getCurrentUserId();
        
        try {
          final conversation = Conversation.fromApiConversation(responseData, userId);
          return ApiResult.success(conversation);
        } catch (parseError) {
          debugPrint('❌ [ChatRepository] JSON parsing error: $parseError');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse response: $parseError',
            statusCode: response.statusCode,
          ));
        }
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = errorData['detail'] as String? ?? 
                           'Request failed with status: ${response.statusCode}';
        return ApiResult.failure(ApiError(
          message: errorMessage,
          statusCode: response.statusCode,
        ));
      }
    } catch (e) {
      return ApiResult.failure(ApiError(
        message: 'Network error: $e',
        statusCode: 0,
      ));
    }
  }

  /// Search conversations with proper type conversion
  Future<ApiResult<List<Conversation>>> searchConversations({
    required String query,
    int limit = 20,
    int offset = 0,
  }) async {
    final uri = Uri.parse('$_baseUrl/conversations/search')
        .replace(queryParameters: {
      'q': query,
      'limit': limit.toString(),
      'offset': offset.toString(),
    });

    debugPrint('🔗 [ChatRepository] Searching conversations: "$query"');

    try {
      final response = await http.get(uri, headers: await _getHeaders());
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body);
        
        if (responseData is List) {
          // Get current user ID for message processing
          final userId = await _getCurrentUserId();
          
          final conversations = responseData
              .map((item) => Conversation.fromApiConversation(
                  item as Map<String, dynamic>, 
                  userId,
                ))
              .toList();
          return ApiResult.success(conversations);
        } else {
          return ApiResult.failure(ApiError(
            message: 'Expected list response but got: ${responseData.runtimeType}',
            statusCode: response.statusCode,
          ));
        }
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = errorData['detail'] as String? ?? 
                           'Request failed with status: ${response.statusCode}';
        return ApiResult.failure(ApiError(
          message: errorMessage,
          statusCode: response.statusCode,
        ));
      }
    } catch (e) {
      return ApiResult.failure(ApiError(
        message: 'Network error: $e',
        statusCode: 0,
      ));
    }
  }

  /// Get conversation participants' online status
  Future<ApiResult<Map<String, bool>>> getParticipantsOnlineStatus({
    required String conversationId,
  }) async {
    final uri = Uri.parse('$_baseUrl/conversations/$conversationId/participants/status');

    debugPrint('🔗 [ChatRepository] Getting participants online status: $conversationId');

    return await _handleResponse<Map<String, bool>>(
      http.get(uri, headers: await _getHeaders()),
      (json) {
        final statusMap = <String, bool>{};
        for (final entry in json.entries) {
          statusMap[entry.key] = entry.value as bool;
        }
        return statusMap;
      },
    );
  }

  /// Update conversation settings (mute, archive, etc.) with proper type conversion
  Future<ApiResult<Conversation>> updateConversationSettings({
    required String conversationId,
    bool? isMuted,
    bool? isArchived,
    bool? isPinned,
  }) async {
    final updates = <String, dynamic>{};
    if (isMuted != null) updates['is_muted'] = isMuted;
    if (isArchived != null) updates['is_archived'] = isArchived;
    if (isPinned != null) updates['is_pinned'] = isPinned;

    if (updates.isEmpty) {
      return ApiResult.failure(ApiError(
        message: 'No updates provided',
        statusCode: 400,
      ));
    }

    debugPrint('🔗 [ChatRepository] Updating conversation settings: $conversationId');

    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/conversations/$conversationId'),
        headers: await _getHeaders(),
        body: jsonEncode(updates),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final userId = await _getCurrentUserId();
        
        try {
          final conversation = Conversation.fromApiConversation(responseData, userId);
          return ApiResult.success(conversation);
        } catch (parseError) {
          debugPrint('❌ [ChatRepository] JSON parsing error: $parseError');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse response: $parseError',
            statusCode: response.statusCode,
          ));
        }
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = errorData['detail'] as String? ?? 
                           'Request failed with status: ${response.statusCode}';
        return ApiResult.failure(ApiError(
          message: errorMessage,
          statusCode: response.statusCode,
        ));
      }
    } catch (e) {
      return ApiResult.failure(ApiError(
        message: 'Network error: $e',
        statusCode: 0,
      ));
    }
  }

  /// Delete a message (if within allowed time)
  Future<ApiResult<void>> deleteMessage(String messageId) async {
    debugPrint('🔗 [ChatRepository] Deleting message: $messageId');

    return await _handleResponse<void>(
      http.delete(
        Uri.parse('$_baseUrl/messages/$messageId'),
        headers: await _getHeaders(),
      ),
      (_) {},
    );
  }

  /// Edit a message (if within allowed time) with proper type conversion
  Future<ApiResult<ChatMessage>> editMessage({
    required String messageId,
    required String newContent,
  }) async {
    debugPrint('🔗 [ChatRepository] Editing message: $messageId');

    try {
      final response = await http.patch(
        Uri.parse('$_baseUrl/messages/$messageId'),
        headers: await _getHeaders(),
        body: jsonEncode({'content': newContent}),
      );
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body) as Map<String, dynamic>;
        final userId = await _getCurrentUserId();
        
        try {
          final message = ChatMessage.fromApiMessage(responseData, userId);
          return ApiResult.success(message);
        } catch (parseError) {
          debugPrint('❌ [ChatRepository] JSON parsing error: $parseError');
          return ApiResult.failure(ApiError(
            message: 'Failed to parse response: $parseError',
            statusCode: response.statusCode,
          ));
        }
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        final errorMessage = errorData['detail'] as String? ?? 
                           'Request failed with status: ${response.statusCode}';
        return ApiResult.failure(ApiError(
          message: errorMessage,
          statusCode: response.statusCode,
        ));
      }
    } catch (e) {
      return ApiResult.failure(ApiError(
        message: 'Network error: $e',
        statusCode: 0,
      ));
    }
  }

  /// React to a message
  Future<ApiResult<void>> addReaction({
    required String messageId,
    required String emoji,
  }) async {
    debugPrint('🔗 [ChatRepository] Adding reaction to message: $messageId, emoji: $emoji');

    return await _handleResponse<void>(
      http.post(
        Uri.parse('$_baseUrl/messages/$messageId/reactions'),
        headers: await _getHeaders(),
        body: jsonEncode({'emoji': emoji}),
      ),
      (_) {},
    );
  }

  /// Remove reaction from a message
  Future<ApiResult<void>> removeReaction({
    required String messageId,
    required String emoji,
  }) async {
    debugPrint('🔗 [ChatRepository] Removing reaction from message: $messageId, emoji: $emoji');

    return await _handleResponse<void>(
      http.delete(
        Uri.parse('$_baseUrl/messages/$messageId/reactions/$emoji'),
        headers: await _getHeaders(),
      ),
      (_) {},
    );
  }

  /// Get current user ID from storage
  Future<String> _getCurrentUserId() async {
    try {
      // Try to get user ID from secure storage
      final userId = await SecureStorageService.getUserId();
      debugPrint('🔍 [ChatRepository] Raw user ID from storage: $userId');
      
      if (userId != null && userId.isNotEmpty && userId != 'unknown-user') {
        debugPrint('✅ [ChatRepository] Valid user ID found: $userId');
        return userId;
      }
      
      debugPrint('⚠️ [ChatRepository] No user ID found in storage, returning empty string');
      return '';
    } catch (e) {
      debugPrint('❌ [ChatRepository] Failed to get current user ID: $e');
      return '';
    }
  }

  /// Get current user ID from storage (public method)
  Future<String> getCurrentUserId() async {
    return await _getCurrentUserId();
  }
}

/// Singleton instance
final chatRepository = ChatRepository();