# Future Talk Chat API Documentation

## Table of Contents
1. [Overview](#overview)
2. [Authentication](#authentication)
3. [REST API Endpoints](#rest-api-endpoints)
4. [WebSocket Events](#websocket-events)
5. [Data Types and Models](#data-types-and-models)
6. [Flutter Implementation Guide](#flutter-implementation-guide)
7. [Message Flow Diagrams](#message-flow-diagrams)
8. [Testing with chat_test.html](#testing-with-chat_testhtml)

---

## Overview

Future Talk Chat is a real-time messaging system with the following features:
- **Direct and Group Messaging**: Support for one-on-one and group conversations
- **Real-time Updates**: WebSocket-based instant message delivery
- **Message Pagination**: Efficient loading of message history (100 messages at a time)
- **Typing Indicators**: See when others are typing
- **Read Receipts**: Track message read status
- **Conversation Ordering**: Auto-reorder conversations by latest activity
- **Message Encryption**: End-to-end encryption for message content

### Base URLs
```
REST API: http://localhost:8000/api/v1
WebSocket: ws://localhost:8000/api/v1/chat/ws
```

---

## Authentication

### Login Endpoint
```http
POST /api/v1/auth/login
```

**Request Body:**
```json
{
  "username_or_email": "string",  // Email or username
  "password": "string"
}
```

**Response (200 OK):**
```json
{
  "access_token": "string",  // JWT token for authentication
  "token_type": "bearer",
  "user": {
    "id": "uuid-string",
    "username": "string",
    "email": "string",
    "display_name": "string",
    "profile_picture": "string?",  // nullable
    "created_at": "2024-01-01T00:00:00Z"
  }
}
```

**Flutter Type Definitions:**
```dart
class LoginResponse {
  final String accessToken;
  final String tokenType;
  final User user;
}

class User {
  final String id;  // UUID as string
  final String username;
  final String email;
  final String? displayName;
  final String? profilePicture;
  final DateTime createdAt;
}
```

---

## REST API Endpoints

### 1. Create Conversation
```http
POST /api/v1/messages/conversations
```

**Headers:**
```
Authorization: Bearer {access_token}
Content-Type: application/json
```

**Request Body:**
```json
{
  "participant_ids": ["uuid-string"],  // List of user IDs (excluding yourself)
  "conversation_type": "direct"  // "direct" or "group"
}
```

**Response (201 Created):**
```json
{
  "id": "uuid-string",
  "conversation_type": "direct",
  "created_at": "2024-01-01T00:00:00Z",
  "last_message_at": "2024-01-01T00:00:00Z",
  "is_archived": false,
  "participants": [
    {
      "user_id": "uuid-string",
      "username": "string",
      "role": "member",  // "admin" or "member"
      "joined_at": "2024-01-01T00:00:00Z"
    }
  ],
  "last_message": null,  // ChatMessage object or null
  "unread_count": 0
}
```

### 2. Get User Conversations
```http
GET /api/v1/messages/conversations?limit=20&offset=0
```

**Query Parameters:**
- `limit`: Number of conversations (1-50, default 20)
- `offset`: Number to skip for pagination

**Response (200 OK):**
```json
[
  {
    "id": "uuid-string",
    "conversation_type": "direct",
    "created_at": "2024-01-01T00:00:00Z",
    "last_message_at": "2024-01-01T00:00:00Z",
    "is_archived": false,
    "participants": [...],
    "last_message": {
      "id": "uuid-string",
      "content": "string",
      "sender_id": "uuid-string",
      "sender_username": "string",
      "created_at": "2024-01-01T00:00:00Z",
      "message_type": "text"
    },
    "unread_count": 5
  }
]
```

**Important:** Conversations are returned sorted by `last_message_at` in descending order (most recent first).

### 3. Send Chat Message
```http
POST /api/v1/messages/conversations/{conversation_id}/messages
```

**Request Body:**
```json
{
  "conversation_id": "uuid-string",  // Will be overridden by URL parameter
  "content": "string",  // 1-5000 characters
  "message_type": "text",  // "text", "voice", "video", or "image"
  "reply_to_message_id": "uuid-string?",  // Optional
  "attachments": ["uuid-string"]?,  // Optional list of file IDs
  "self_destruct_timer": 0,  // Optional, in seconds
  "client_message_id": "string?"  // Optional client-side tracking ID
}
```

**Response (201 Created):**
```json
{
  "id": "uuid-string",
  "conversation_id": "uuid-string",
  "sender_id": "uuid-string",
  "sender_username": "string",
  "content": "string",
  "message_type": "text",
  "created_at": "2024-01-01T00:00:00Z",
  "updated_at": "2024-01-01T00:00:00Z",
  "is_edited": false,
  "is_destroyed": false,
  "reply_to_message_id": null,
  "attachments": [],
  "reactions": [],
  "read_by": []
}
```

### 4. Get Conversation Messages (with Pagination)
```http
GET /api/v1/messages/conversations/{conversation_id}/messages?limit=100&before_message_id={uuid}
```

**Query Parameters:**
- `limit`: Number of messages (1-100, default 50)
- `offset`: Number to skip (deprecated, use before_message_id)
- `before_message_id`: Get messages before this ID (for pagination)

**Response (200 OK):**
```json
[
  {
    "id": "uuid-string",
    "conversation_id": "uuid-string",
    "sender_id": "uuid-string",
    "sender_username": "string",
    "content": "string",
    "message_type": "text",
    "created_at": "2024-01-01T00:00:00Z",
    "updated_at": "2024-01-01T00:00:00Z",
    "is_edited": false,
    "is_destroyed": false,
    "reply_to_message_id": null,
    "attachments": [],
    "reactions": [],
    "read_by": ["uuid-string"]
  }
]
```

**Important:** Messages are returned in reverse chronological order (newest first). Frontend should reverse this array to display oldest first, newest last.

### 5. Mark Message as Read
```http
POST /api/v1/messages/messages/{message_id}/read
```

**Response (200 OK):**
```json
{
  "message": "Message marked as read"
}
```

### 6. Mark Entire Conversation as Read
```http
POST /api/v1/messages/conversations/{conversation_id}/read
```

**Response (200 OK):**
```json
{
  "message": "Conversation marked as read"
}
```

### 7. Send Typing Indicator
```http
POST /api/v1/messages/conversations/{conversation_id}/typing?is_typing=true
```

**Query Parameters:**
- `is_typing`: boolean (true when starting, false when stopping)

**Response (200 OK):**
```json
{
  "message": "Typing indicator sent"
}
```

---

## WebSocket Events

### Connection
```javascript
// Connect with authentication
const ws = new WebSocket('ws://localhost:8000/api/v1/chat/ws?token={access_token}');
```

### Outgoing Events (Client → Server)

#### 1. Join Conversation
```json
{
  "type": "join_conversation",
  "data": {
    "conversation_id": "uuid-string"
  }
}
```

#### 2. Send Typing Indicator
```json
{
  "type": "typing_start",
  "data": {
    "conversation_id": "uuid-string"
  }
}
```

```json
{
  "type": "typing_stop",
  "data": {
    "conversation_id": "uuid-string"
  }
}
```

#### 3. Heartbeat (Keep-Alive)
```json
{
  "type": "heartbeat",
  "data": {}
}
```

### Incoming Events (Server → Client)

#### 1. Connection Established
```json
{
  "type": "connection_established",
  "user_id": "uuid-string",
  "timestamp": "2024-01-01T00:00:00Z"
}
```

#### 2. Chat Message
```json
{
  "type": "chat_message",
  "conversation_id": "uuid-string",
  "message_data": {
    "type": "new_message",
    "message": {
      "id": "uuid-string",
      "conversation_id": "uuid-string",
      "sender_id": "uuid-string",
      "sender_username": "string",
      "content": "string",
      "message_type": "text",
      "created_at": "2024-01-01T00:00:00Z",
      "is_edited": false,
      "is_destroyed": false,
      "attachments": [],
      "reactions": []
    },
    "sender_info": {
      "user_id": "uuid-string",
      "username": "string",
      "display_name": "string"
    }
  }
}
```

#### 3. Typing Indicator
```json
{
  "type": "typing_indicator",
  "conversation_id": "uuid-string",
  "user_id": "uuid-string",
  "username": "string",
  "is_typing": true
}
```

#### 4. Message Read Receipt
```json
{
  "type": "message_read_receipt",
  "message_id": "uuid-string",
  "reader_user_id": "uuid-string",
  "read_at": "2024-01-01T00:00:00Z"
}
```

#### 5. Conversation Joined
```json
{
  "type": "conversation_joined",
  "conversation_id": "uuid-string"
}
```

#### 6. Heartbeat Acknowledgment
```json
{
  "type": "heartbeat_ack"
}
```

#### 7. Error
```json
{
  "type": "error",
  "message": "string",
  "code": "string"
}
```

---

## Data Types and Models

### Flutter Type Definitions

```dart
// Enums
enum ConversationType { direct, group }
enum MessageType { text, voice, video, image }
enum ParticipantRole { admin, member }

// Core Models
class Conversation {
  final String id;  // UUID
  final ConversationType conversationType;
  final DateTime createdAt;
  final DateTime? lastMessageAt;
  final bool isArchived;
  final List<Participant> participants;
  final ChatMessage? lastMessage;
  final int unreadCount;
}

class Participant {
  final String userId;  // UUID
  final String username;
  final ParticipantRole role;
  final DateTime joinedAt;
}

class ChatMessage {
  final String id;  // UUID
  final String conversationId;  // UUID
  final String senderId;  // UUID
  final String senderUsername;
  final String content;
  final MessageType messageType;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isEdited;
  final bool isDestroyed;
  final String? replyToMessageId;  // UUID or null
  final List<Attachment> attachments;
  final List<Reaction> reactions;
  final List<String> readBy;  // List of user IDs
}

class Attachment {
  final String id;  // UUID
  final String fileName;
  final String fileUrl;
  final String fileType;
  final int fileSize;
}

class Reaction {
  final String userId;  // UUID
  final String emoji;
  final DateTime createdAt;
}

// WebSocket Message Wrapper
class WebSocketMessage {
  final String type;
  final Map<String, dynamic> data;
}
```

---

## Flutter Implementation Guide

### 1. WebSocket Connection Management

```dart
class ChatWebSocketService {
  WebSocketChannel? _channel;
  String? _accessToken;
  
  void connect(String accessToken) {
    _accessToken = accessToken;
    final wsUrl = Uri.parse('ws://localhost:8000/api/v1/chat/ws?token=$accessToken');
    _channel = WebSocketChannel.connect(wsUrl);
    
    // Listen to messages
    _channel!.stream.listen(
      _handleMessage,
      onError: _handleError,
      onDone: _handleDisconnect,
    );
  }
  
  void _handleMessage(dynamic message) {
    final data = jsonDecode(message);
    final type = data['type'] as String;
    
    switch (type) {
      case 'chat_message':
        _handleChatMessage(data);
        break;
      case 'typing_indicator':
        _handleTypingIndicator(data);
        break;
      // ... handle other events
    }
  }
  
  void sendMessage(String type, Map<String, dynamic> data) {
    final message = jsonEncode({
      'type': type,
      'data': data,
    });
    _channel?.sink.add(message);
  }
}
```

### 2. Message Ordering and Pagination

```dart
class ChatViewModel {
  final List<ChatMessage> messages = [];
  bool hasMoreMessages = true;
  String? oldestMessageId;
  
  Future<void> loadMessages(String conversationId, {bool loadMore = false}) async {
    if (!loadMore) {
      messages.clear();
      oldestMessageId = null;
      hasMoreMessages = true;
    }
    
    String url = '/api/v1/messages/conversations/$conversationId/messages?limit=100';
    if (loadMore && oldestMessageId != null) {
      url += '&before_message_id=$oldestMessageId';
    }
    
    final response = await http.get(Uri.parse(url));
    final List<dynamic> newMessages = jsonDecode(response.body);
    
    hasMoreMessages = newMessages.length == 100;
    
    if (newMessages.isNotEmpty) {
      oldestMessageId = newMessages.last['id'];
      
      // Important: Reverse the messages to show oldest first
      final reversedMessages = newMessages.reversed.toList();
      
      if (loadMore) {
        messages.insertAll(0, reversedMessages.map((m) => ChatMessage.fromJson(m)));
      } else {
        messages.addAll(reversedMessages.map((m) => ChatMessage.fromJson(m)));
      }
    }
  }
}
```

### 3. Conversation List Auto-Reordering

```dart
class ConversationListViewModel {
  final List<Conversation> conversations = [];
  
  void handleNewMessage(ChatMessage message) {
    // Find conversation
    final index = conversations.indexWhere((c) => c.id == message.conversationId);
    
    if (index > -1) {
      // Move to top if not already there
      if (index != 0) {
        final conversation = conversations.removeAt(index);
        conversation.lastMessage = message;
        conversation.lastMessageAt = message.createdAt;
        conversations.insert(0, conversation);
      } else {
        // Update last message if already at top
        conversations[0].lastMessage = message;
        conversations[0].lastMessageAt = message.createdAt;
      }
      
      notifyListeners();
    } else {
      // Reload conversations if not found
      loadConversations();
    }
  }
}
```

### 4. Handling Type Safety

```dart
// Safe JSON parsing with null safety
class ChatMessage {
  static ChatMessage fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      conversationId: json['conversation_id'] as String,
      senderId: json['sender_id'] as String,
      senderUsername: json['sender_username'] as String? ?? 'Unknown',
      content: json['content'] as String,
      messageType: MessageType.values.firstWhere(
        (e) => e.name == json['message_type'],
        orElse: () => MessageType.text,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null 
        ? DateTime.parse(json['updated_at'] as String)
        : null,
      isEdited: json['is_edited'] as bool? ?? false,
      isDestroyed: json['is_destroyed'] as bool? ?? false,
      replyToMessageId: json['reply_to_message_id'] as String?,
      attachments: (json['attachments'] as List<dynamic>? ?? [])
        .map((a) => Attachment.fromJson(a as Map<String, dynamic>))
        .toList(),
      reactions: (json['reactions'] as List<dynamic>? ?? [])
        .map((r) => Reaction.fromJson(r as Map<String, dynamic>))
        .toList(),
      readBy: (json['read_by'] as List<dynamic>? ?? [])
        .map((id) => id as String)
        .toList(),
    );
  }
}
```

---

## Message Flow Diagrams

### Sending a Message Flow
```
User A                    Server                    User B
  |                         |                         |
  |--POST /messages-------->|                         |
  |                         |                         |
  |<--201 Created-----------|                         |
  |                         |                         |
  |                         |--WebSocket: new_msg--->|
  |                         |                         |
  |                         |                         |
  |                    (Update DB)                    |
  |                         |                         |
  |                    (Reorder convos)               |
```

### Real-time Updates Flow
```
User sends message → Server processes → WebSocket broadcasts to all participants
                                     ↓
                            Each client updates:
                            1. Add message to chat (if active)
                            2. Reorder conversation list
                            3. Update unread counts
                            4. Show notification (if app in background)
```

---

## Testing with chat_test.html

The `chat_test.html` file is a complete implementation reference showing:

### Key Features Demonstrated:
1. **Authentication**: Login with email/password
2. **WebSocket Connection**: Real-time message handling
3. **Message Pagination**: Load more on scroll up
4. **Conversation Reordering**: Auto-reorder on new messages
5. **Typing Indicators**: Show when users are typing
6. **Message Ordering**: Latest messages at bottom

### How to Test:
1. Start the backend server:
   ```bash
   python -m uvicorn app.main:app --reload
   ```

2. Open `chat_test.html` in browser

3. Use quick login buttons or enter credentials:
   - User 1: theshaikhasif03@gmail.com / Pass@123
   - User 2: sayedmehreengulamhusain@gmail.com / Pass@123
   - User 3: shaikhasif0925@gmail.com / Pass@123

4. Test scenarios:
   - Send messages between users
   - Check conversation reordering
   - Scroll up to load more messages
   - Watch typing indicators

### JavaScript Implementation Reference:

```javascript
// Key functions from chat_test.html:

// 1. Message Loading with Pagination
async function loadMessages(conversationId, loadMore = false) {
    let url = `${API_BASE}/messages/conversations/${conversationId}/messages?limit=100`;
    if (loadMore && oldestMessageId) {
        url += `&before_message_id=${oldestMessageId}`;
    }
    
    const response = await fetch(url, {
        headers: {
            'Authorization': `Bearer ${accessToken}`,
            'Content-Type': 'application/json'
        }
    });
    
    const newMessages = await response.json();
    
    // Important: Reverse messages to show oldest first
    if (loadMore) {
        messages = [...newMessages.reverse(), ...messages];
    } else {
        messages = newMessages.reverse();
    }
}

// 2. Conversation Reordering (Works for ALL participants)
function updateConversationOrder(conversationId, lastMessage) {
    const convIndex = conversations.findIndex(conv => conv.id === conversationId);
    
    if (convIndex > -1 && convIndex !== 0) {
        // Move conversation to top
        const [conversation] = conversations.splice(convIndex, 1);
        conversation.last_message = lastMessage;
        conversations.unshift(conversation);
        renderConversations();
    }
}

// 3. WebSocket Message Handling
function handleWebSocketMessage(data) {
    switch (data.type) {
        case 'chat_message':
            // Always process to update conversation order for ALL users
            handleChatMessageData(data);
            break;
        // ... other cases
    }
}

// 4. Scroll-based Pagination
function handleMessageScroll(event) {
    const container = event.target;
    
    // Load more when scrolled to top
    if (container.scrollTop < 100 && hasMoreMessages && !isLoadingMessages) {
        loadMessages(currentConversation.id, true);
    }
}
```

---

## Common Issues and Solutions

### Flutter-Specific Issues

1. **Type Casting Errors**
   - Always use explicit type casting: `json['id'] as String`
   - Provide defaults for nullable fields: `?? defaultValue`

2. **WebSocket Connection Drops**
   - Implement reconnection logic with exponential backoff
   - Send heartbeat every 30 seconds

3. **Message Ordering**
   - Backend returns newest first
   - Frontend must reverse for display
   - Maintain scroll position when loading more

4. **Conversation List Updates**
   - Must update for ALL participants via WebSocket
   - Handle both sender and receiver sides
   - Preserve active conversation highlighting

### Best Practices

1. **Error Handling**
   ```dart
   try {
     final response = await http.post(...);
     if (response.statusCode == 201) {
       // Success
     } else {
       // Handle error
     }
   } catch (e) {
     // Network error
   }
   ```

2. **Null Safety**
   ```dart
   final username = json['username'] as String? ?? 'Unknown';
   final lastMessage = json['last_message'] != null 
     ? ChatMessage.fromJson(json['last_message']) 
     : null;
   ```

3. **State Management**
   - Use Provider/Riverpod/Bloc for state
   - Separate WebSocket service from UI
   - Cache messages locally for offline support

---

## API Response Status Codes

- `200 OK`: Successful GET request
- `201 Created`: Successful POST request (resource created)
- `400 Bad Request`: Invalid request data
- `401 Unauthorized`: Missing or invalid token
- `403 Forbidden`: Not authorized for this resource
- `404 Not Found`: Resource doesn't exist
- `500 Internal Server Error`: Server error

---

## Security Considerations

1. **Authentication**: Always include Bearer token in headers
2. **Message Encryption**: Content is encrypted before storage
3. **Input Validation**: 
   - Message content: 1-5000 characters
   - Conversation type: "direct" or "group" only
4. **Rate Limiting**: Implement client-side throttling for typing indicators
5. **WebSocket Security**: Use WSS in production

---

## Appendix: Quick Reference

### Headers for All Authenticated Requests
```http
Authorization: Bearer {access_token}
Content-Type: application/json
```

### WebSocket Connection URL
```
ws://localhost:8000/api/v1/chat/ws?token={access_token}
```

### Message Pagination Pattern
```
Initial load: /messages?limit=100
Load more: /messages?limit=100&before_message_id={oldest_message_id}
```

### Conversation Ordering Rule
```
Always sort by last_message_at DESC (most recent first)
```

---

## Support and Debugging

For debugging, check the browser console in `chat_test.html` - it logs all WebSocket events and API calls with detailed information.

Common debug commands:
```javascript
// In browser console while chat_test.html is open:
console.log(conversations);  // View all conversations
console.log(messages);       // View current messages
console.log(currentUser);    // View logged-in user
console.log(websocket.readyState);  // Check WebSocket status
```

---

*Last Updated: 2024*
*Version: 1.0.0*