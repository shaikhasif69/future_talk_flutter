import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/network/api_result.dart';

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

  Map<String, dynamic> toJson() => {
    'content': content,
    'message_type': messageType,
    if (replyToMessageId != null) 'reply_to_message_id': replyToMessageId,
    'attachments': attachments,
    if (selfDestructTimer != null) 'self_destruct_timer': selfDestructTimer,
    if (clientMessageId != null) 'client_message_id': clientMessageId,
  };
}

class ApiConversation {
  final String id;
  final String conversationType;
  final DateTime createdAt;
  final DateTime lastMessageAt;
  final bool isArchived;
  final List<ApiParticipant> participants;
  final ApiMessage? lastMessage;
  final int unreadCount;

  const ApiConversation({
    required this.id,
    required this.conversationType,
    required this.createdAt,
    required this.lastMessageAt,
    required this.isArchived,
    required this.participants,
    this.lastMessage,
    required this.unreadCount,
  });

  factory ApiConversation.fromJson(Map<String, dynamic> json) {
    return ApiConversation(
      id: json['id'] as String,
      conversationType: json['conversation_type'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastMessageAt: DateTime.parse(json['last_message_at'] as String),
      isArchived: json['is_archived'] as bool,
      participants: (json['participants'] as List)
          .map((p) => ApiParticipant.fromJson(p as Map<String, dynamic>))
          .toList(),
      lastMessage: json['last_message'] != null 
          ? ApiMessage.fromJson(json['last_message'] as Map<String, dynamic>)
          : null,
      unreadCount: json['unread_count'] as int,
    );
  }
}

class ApiParticipant {
  final String userId;
  final String username;
  final String role;
  final DateTime joinedAt;

  const ApiParticipant({
    required this.userId,
    required this.username,
    required this.role,
    required this.joinedAt,
  });

  factory ApiParticipant.fromJson(Map<String, dynamic> json) {
    return ApiParticipant(
      userId: json['user_id'] as String,
      username: json['username'] as String,
      role: json['role'] as String,
      joinedAt: DateTime.parse(json['joined_at'] as String),
    );
  }
}

class ApiMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String content;
  final String messageType;
  final String? replyToMessageId;
  final DateTime createdAt;
  final DateTime? editedAt;
  final List<Map<String, dynamic>> attachments;
  final DateTime? selfDestructAt;
  final bool isDestroyed;
  final bool encrypted;
  final String? encryptionType;

  const ApiMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.messageType,
    this.replyToMessageId,
    required this.createdAt,
    this.editedAt,
    required this.attachments,
    this.selfDestructAt,
    required this.isDestroyed,
    required this.encrypted,
    this.encryptionType,
  });

  factory ApiMessage.fromJson(Map<String, dynamic> json) {
    return ApiMessage(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      content: json['content'] as String,
      messageType: json['message_type'] as String,
      replyToMessageId: json['reply_to_message_id'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      editedAt: json['edited_at'] != null 
          ? DateTime.parse(json['edited_at'] as String)
          : null,
      attachments: List<Map<String, dynamic>>.from(json['attachments'] as List? ?? []),
      selfDestructAt: json['self_destruct_at'] != null
          ? DateTime.parse(json['self_destruct_at'] as String)
          : null,
      isDestroyed: json['is_destroyed'] as bool,
      encrypted: json['encrypted'] as bool,
      encryptionType: json['encryption_type'] as String?,
    );
  }
}

/// Repository for chat-related API calls
class ChatRepository {
  // Dynamic base URL that matches ApiClient configuration
  static String get _baseUrl {
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
        return ApiResult.success(fromJson(responseData));
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

  /// Handle HTTP response for list endpoints
  Future<ApiResult<List<T>>> _handleListResponse<T>(
    Future<http.Response> responseFunction,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final response = await responseFunction;
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = jsonDecode(response.body);
        
        if (responseData is List) {
          final items = responseData
              .map((item) => fromJson(item as Map<String, dynamic>))
              .toList();
          return ApiResult.success(items);
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

  /// Create a new conversation
  Future<ApiResult<ApiConversation>> createConversation({
    required List<String> participantIds,
    required String conversationType,
  }) async {
    final request = ConversationCreateRequest(
      participantIds: participantIds,
      conversationType: conversationType,
    );

    debugPrint('🔗 [ChatRepository] Creating conversation with: ${participantIds.length} participants');

    return await _handleResponse<ApiConversation>(
      http.post(
        Uri.parse('$_baseUrl/conversations'),
        headers: await _getHeaders(),
        body: jsonEncode(request.toJson()),
      ),
      (json) => ApiConversation.fromJson(json),
    );
  }

  /// Get user's conversations
  Future<ApiResult<List<ApiConversation>>> getConversations({
    int limit = 20,
    int offset = 0,
  }) async {
    final uri = Uri.parse('$_baseUrl/conversations')
        .replace(queryParameters: {
      'limit': limit.toString(),
      'offset': offset.toString(),
    });

    debugPrint('🔗 [ChatRepository] Fetching conversations: limit=$limit, offset=$offset');

    return await _handleListResponse<ApiConversation>(
      http.get(uri, headers: await _getHeaders()),
      (json) => ApiConversation.fromJson(json),
    );
  }

  /// Send a message in a conversation
  Future<ApiResult<ApiMessage>> sendMessage({
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

    debugPrint('🔗 [ChatRepository] Sending message to conversation: $conversationId');

    return await _handleResponse<ApiMessage>(
      http.post(
        Uri.parse('$_baseUrl/conversations/$conversationId/messages'),
        headers: await _getHeaders(),
        body: jsonEncode(request.toJson()),
      ),
      (json) => ApiMessage.fromJson(json),
    );
  }

  /// Get messages from a conversation
  Future<ApiResult<List<ApiMessage>>> getMessages({
    required String conversationId,
    int limit = 50,
    int offset = 0,
    String? beforeMessageId,
  }) async {
    final queryParams = <String, String>{
      'limit': limit.toString(),
      'offset': offset.toString(),
    };
    
    if (beforeMessageId != null) {
      queryParams['before_message_id'] = beforeMessageId;
    }

    final uri = Uri.parse('$_baseUrl/conversations/$conversationId/messages')
        .replace(queryParameters: queryParams);

    debugPrint('🔗 [ChatRepository] Fetching messages for conversation: $conversationId');

    return await _handleListResponse<ApiMessage>(
      http.get(uri, headers: await _getHeaders()),
      (json) => ApiMessage.fromJson(json),
    );
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

  /// Mark all messages in a conversation as read
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

  /// Get conversation by ID
  Future<ApiResult<ApiConversation>> getConversation(String conversationId) async {
    debugPrint('🔗 [ChatRepository] Fetching conversation: $conversationId');

    return await _handleResponse<ApiConversation>(
      http.get(
        Uri.parse('$_baseUrl/conversations/$conversationId'),
        headers: await _getHeaders(),
      ),
      (json) => ApiConversation.fromJson(json),
    );
  }

  /// Search conversations
  Future<ApiResult<List<ApiConversation>>> searchConversations({
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

    return await _handleListResponse<ApiConversation>(
      http.get(uri, headers: await _getHeaders()),
      (json) => ApiConversation.fromJson(json),
    );
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

  /// Update conversation settings (mute, archive, etc.)
  Future<ApiResult<ApiConversation>> updateConversationSettings({
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

    return await _handleResponse<ApiConversation>(
      http.patch(
        Uri.parse('$_baseUrl/conversations/$conversationId'),
        headers: await _getHeaders(),
        body: jsonEncode(updates),
      ),
      (json) => ApiConversation.fromJson(json),
    );
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

  /// Edit a message (if within allowed time)
  Future<ApiResult<ApiMessage>> editMessage({
    required String messageId,
    required String newContent,
  }) async {
    debugPrint('🔗 [ChatRepository] Editing message: $messageId');

    return await _handleResponse<ApiMessage>(
      http.patch(
        Uri.parse('$_baseUrl/messages/$messageId'),
        headers: await _getHeaders(),
        body: jsonEncode({'content': newContent}),
      ),
      (json) => ApiMessage.fromJson(json),
    );
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
}

/// Singleton instance
final chatRepository = ChatRepository();