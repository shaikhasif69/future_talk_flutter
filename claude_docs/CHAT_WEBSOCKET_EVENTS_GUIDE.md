# Future Talk Chat WebSocket Events - Complete Flutter Guide

## Table of Contents
1. [WebSocket Connection Flow](#websocket-connection-flow)
2. [All WebSocket Events](#all-websocket-events)
3. [Flutter Implementation Issues & Solutions](#flutter-implementation-issues--solutions)
4. [Real-time Message Flow](#real-time-message-flow)
5. [Common Flutter Integration Problems](#common-flutter-integration-problems)
6. [Testing & Debugging](#testing--debugging)

---

## WebSocket Connection Flow

### Step 1: Authentication & Connection
```dart
// 1. Get valid JWT token (check expiry first!)
String token = await AuthService.getValidToken();

// 2. Connect to WebSocket
final wsUrl = 'ws://10.0.2.2:8000/api/v1/chat/ws?token=$token';
_channel = WebSocketChannel.connect(Uri.parse(wsUrl));

// 3. Listen for connection confirmation
_channel.stream.listen((message) {
  final data = jsonDecode(message);
  if (data['type'] == 'connection_established') {
    print('✅ WebSocket connected for user: ${data['user_id']}');
    _isConnected = true;
  }
});
```

### Step 2: Join Conversations
```dart
// Must join each conversation to receive real-time updates
void joinConversation(String conversationId) {
  final message = {
    'type': 'join_conversation',
    'data': {
      'conversation_id': conversationId,
    }
  };
  _channel.sink.add(jsonEncode(message));
}
```

### Step 3: Handle Incoming Messages
```dart
// Listen for different event types
void _handleWebSocketMessage(dynamic rawMessage) {
  final data = jsonDecode(rawMessage);
  final eventType = data['type'] as String;
  
  switch (eventType) {
    case 'connection_established':
      _handleConnectionEstablished(data);
      break;
    case 'chat_message':
      _handleNewMessage(data);
      break;
    case 'typing_indicator':
      _handleTypingIndicator(data);
      break;
    // ... other events
  }
}
```

---

## All WebSocket Events

### 🔗 CONNECTION EVENTS

#### 1. Connection Established (Server → Client)
**When**: After successful WebSocket connection
**Data Structure**:
```dart
{
  "type": "connection_established",
  "user_id": "92ab562c-858e-4dc2-a243-6ec8c0bb055e",  // String (UUID)
  "timestamp": "2024-01-01T12:00:00Z"                  // String (ISO 8601)
}
```

**Flutter Handler**:
```dart
void _handleConnectionEstablished(Map<String, dynamic> data) {
  final userId = data['user_id'] as String;
  final timestamp = data['timestamp'] as String;
  
  setState(() {
    _isWebSocketConnected = true;
    _connectedUserId = userId;
  });
  
  print('✅ WebSocket connected for user: $userId at $timestamp');
}
```

#### 2. Heartbeat (Client → Server)
**When**: Every 30 seconds to keep connection alive
**Send**:
```dart
{
  "type": "heartbeat",
  "data": {}
}
```

**Receive**:
```dart
{
  "type": "heartbeat_ack"
}
```

#### 3. Error (Server → Client)
**When**: Authentication fails, invalid message format, etc.
**Data Structure**:
```dart
{
  "type": "error",
  "message": "Authentication failed",  // String
  "code": "AUTH_ERROR"                 // String (optional)
}
```

### 💬 CONVERSATION EVENTS

#### 4. Join Conversation (Client → Server)
**When**: User opens a conversation
**Send**:
```dart
{
  "type": "join_conversation",
  "data": {
    "conversation_id": "uuid-string"  // String (UUID)
  }
}
```

**Response**:
```dart
{
  "type": "conversation_joined",
  "conversation_id": "uuid-string"   // String (UUID)
}
```

**Flutter Implementation**:
```dart
void joinConversation(String conversationId) {
  if (!_isWebSocketConnected) {
    print('❌ Cannot join conversation: WebSocket not connected');
    return;
  }
  
  final message = {
    'type': 'join_conversation',
    'data': {
      'conversation_id': conversationId,
    }
  };
  
  _channel?.sink.add(jsonEncode(message));
  _activeConversationId = conversationId;
}

void _handleConversationJoined(Map<String, dynamic> data) {
  final conversationId = data['conversation_id'] as String;
  print('✅ Joined conversation: $conversationId');
}
```

#### 5. Leave Conversation (Client → Server)
**When**: User leaves a conversation screen
**Send**:
```dart
{
  "type": "leave_conversation",
  "data": {
    "conversation_id": "uuid-string"  // String (UUID)
  }
}
```

### 📨 MESSAGE EVENTS

#### 6. New Message (Server → Client) - **MOST IMPORTANT**
**When**: Someone sends a message in any conversation you've joined
**Data Structure**:
```dart
{
  "type": "chat_message",
  "conversation_id": "uuid-string",              // String (UUID)
  "message_data": {
    "type": "new_message",                       // String
    "message": {
      "id": "uuid-string",                       // String (UUID)
      "conversation_id": "uuid-string",          // String (UUID)
      "sender_id": "uuid-string",                // String (UUID)
      "sender_username": "john_doe",             // String
      "content": "Hello everyone!",             // String
      "message_type": "text",                   // String ("text", "voice", "video", "image")
      "created_at": "2024-01-01T12:00:00Z",     // String (ISO 8601)
      "updated_at": "2024-01-01T12:00:00Z",     // String (ISO 8601)
      "is_edited": false,                       // bool
      "is_destroyed": false,                    // bool
      "reply_to_message_id": null,              // String? (UUID or null)
      "attachments": [],                        // List<dynamic>
      "reactions": [],                          // List<dynamic>
      "read_by": []                             // List<dynamic> (user IDs)
    },
    "sender_info": {
      "user_id": "uuid-string",                 // String (UUID)
      "username": "john_doe",                   // String
      "display_name": "John Doe"                // String
    }
  }
}
```

**Flutter Handler** (CRITICAL - This fixes your real-time display issue):
```dart
void _handleNewMessage(Map<String, dynamic> data) {
  try {
    final conversationId = data['conversation_id'] as String;
    final messageData = data['message_data'] as Map<String, dynamic>;
    final messageInfo = messageData['message'] as Map<String, dynamic>;
    final senderInfo = messageData['sender_info'] as Map<String, dynamic>?;
    
    // Create message object
    final message = ChatMessage(
      id: messageInfo['id'] as String,
      conversationId: messageInfo['conversation_id'] as String,
      senderId: messageInfo['sender_id'] as String,
      senderUsername: messageInfo['sender_username'] as String? ?? 'Unknown',
      content: messageInfo['content'] as String,
      messageType: MessageType.values.firstWhere(
        (e) => e.name == messageInfo['message_type'],
        orElse: () => MessageType.text,
      ),
      createdAt: DateTime.parse(messageInfo['created_at'] as String),
      updatedAt: messageInfo['updated_at'] != null 
        ? DateTime.parse(messageInfo['updated_at'] as String) 
        : null,
      isEdited: messageInfo['is_edited'] as bool? ?? false,
      isDestroyed: messageInfo['is_destroyed'] as bool? ?? false,
      replyToMessageId: messageInfo['reply_to_message_id'] as String?,
      attachments: (messageInfo['attachments'] as List<dynamic>? ?? [])
        .map((a) => Attachment.fromJson(a as Map<String, dynamic>))
        .toList(),
      reactions: (messageInfo['reactions'] as List<dynamic>? ?? [])
        .map((r) => Reaction.fromJson(r as Map<String, dynamic>))
        .toList(),
      readBy: (messageInfo['read_by'] as List<dynamic>? ?? [])
        .map((id) => id as String)
        .toList(),
    );
    
    // CRITICAL: Update UI immediately for active conversation
    if (conversationId == _activeConversationId) {
      setState(() {
        _messages.add(message);
      });
      
      // Auto-scroll to bottom
      _scrollToBottom();
    }
    
    // Always update conversation list (move to top)
    _moveConversationToTop(conversationId, message);
    
    print('✅ New message received: ${message.content.substring(0, 20)}...');
    
  } catch (e, stackTrace) {
    print('❌ Error handling new message: $e');
    print('Stack trace: $stackTrace');
  }
}

void _scrollToBottom() {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  });
}
```

### ⌨️ TYPING EVENTS

#### 7. Start Typing (Client → Server)
**When**: User starts typing in a conversation
**Send**:
```dart
{
  "type": "typing_start",
  "data": {
    "conversation_id": "uuid-string"  // String (UUID)
  }
}
```

#### 8. Stop Typing (Client → Server)
**When**: User stops typing (automatically after 3 seconds)
**Send**:
```dart
{
  "type": "typing_stop",
  "data": {
    "conversation_id": "uuid-string"  // String (UUID)
  }
}
```

#### 9. Typing Indicator (Server → Client)
**When**: Someone else is typing in a conversation
**Data Structure**:
```dart
{
  "type": "typing_indicator",
  "conversation_id": "uuid-string",    // String (UUID)
  "user_id": "uuid-string",            // String (UUID)
  "username": "john_doe",              // String
  "is_typing": true                    // bool
}
```

**Flutter Handler**:
```dart
void _handleTypingIndicator(Map<String, dynamic> data) {
  final conversationId = data['conversation_id'] as String;
  final userId = data['user_id'] as String;
  final username = data['username'] as String;
  final isTyping = data['is_typing'] as bool;
  
  // Don't show typing indicator for own messages
  if (userId == _currentUserId) return;
  
  // Only show for active conversation
  if (conversationId == _activeConversationId) {
    setState(() {
      if (isTyping) {
        _typingUsers[userId] = username;
      } else {
        _typingUsers.remove(userId);
      }
    });
  }
}

// In your UI:
Widget _buildTypingIndicator() {
  if (_typingUsers.isEmpty) return SizedBox.shrink();
  
  final names = _typingUsers.values.join(', ');
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Text(
      '$names ${_typingUsers.length == 1 ? 'is' : 'are'} typing...',
      style: TextStyle(
        fontStyle: FontStyle.italic,
        color: Colors.grey[600],
      ),
    ),
  );
}
```

### 📖 READ RECEIPT EVENTS

#### 10. Mark Message as Read (Client → Server)
**When**: User views a message
**Send**:
```dart
{
  "type": "message_read",
  "data": {
    "message_id": "uuid-string"  // String (UUID)
  }
}
```

#### 11. Read Receipt (Server → Client)
**When**: Someone reads your message
**Data Structure**:
```dart
{
  "type": "message_read_receipt",
  "message_id": "uuid-string",         // String (UUID)
  "reader_user_id": "uuid-string",     // String (UUID)
  "read_at": "2024-01-01T12:00:00Z"    // String (ISO 8601)
}
```

---

## Flutter Implementation Issues & Solutions

### Issue 1: Type Cast Error (`List<dynamic>' is not a subtype of type 'String?'`)

**Root Cause**: The `attachments`, `reactions`, and `read_by` fields are arrays, not strings.

**Solution**:
```dart
// WRONG ❌
final attachments = messageInfo['attachments'] as String?;

// CORRECT ✅
final attachments = (messageInfo['attachments'] as List<dynamic>? ?? [])
  .map((a) => Attachment.fromJson(a as Map<String, dynamic>))
  .toList();

final reactions = (messageInfo['reactions'] as List<dynamic>? ?? [])
  .map((r) => Reaction.fromJson(r as Map<String, dynamic>))
  .toList();

final readBy = (messageInfo['read_by'] as List<dynamic>? ?? [])
  .map((id) => id as String)
  .toList();
```

### Issue 2: Real-time Messages Not Displaying

**Root Cause**: Not calling `setState()` when new messages arrive via WebSocket.

**Solution**:
```dart
void _handleNewMessage(Map<String, dynamic> data) {
  // ... parse message ...
  
  // CRITICAL: Must call setState() to update UI
  if (conversationId == _activeConversationId) {
    setState(() {
      _messages.add(message);  // Add to current conversation
    });
    
    // Auto-scroll to show new message
    _scrollToBottom();
  }
  
  // Update conversation list
  _moveConversationToTop(conversationId, message);
}
```

### Issue 3: Sender Names Showing as "Unknown"

**Root Cause**: Not properly mapping sender info from WebSocket messages.

**Solution**:
```dart
// Extract sender info correctly
final messageInfo = messageData['message'] as Map<String, dynamic>;
final senderInfo = messageData['sender_info'] as Map<String, dynamic>?;

final message = ChatMessage(
  // Use sender info from WebSocket data
  senderUsername: senderInfo?['username'] as String? ?? 
                  messageInfo['sender_username'] as String? ?? 
                  'Unknown',
  senderDisplayName: senderInfo?['display_name'] as String?,
  // ... other fields
);
```

### Issue 4: WebSocket Connection Drops

**Root Cause**: Token expiry or network issues.

**Solution**:
```dart
class ChatWebSocketService {
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  
  void _setupWebSocket() {
    _channel.stream.listen(
      _handleMessage,
      onError: (error) {
        print('❌ WebSocket error: $error');
        _scheduleReconnect();
      },
      onDone: () {
        print('🔌 WebSocket connection closed');
        _scheduleReconnect();
      },
    );
  }
  
  void _scheduleReconnect() {
    if (_reconnectAttempts >= 5) {
      print('❌ Max reconnect attempts reached');
      return;
    }
    
    _reconnectAttempts++;
    final delay = Duration(seconds: math.pow(2, _reconnectAttempts).toInt());
    
    _reconnectTimer = Timer(delay, () async {
      try {
        await connect(await AuthService.getValidToken());
        _reconnectAttempts = 0;
      } catch (e) {
        print('❌ Reconnect failed: $e');
        _scheduleReconnect();
      }
    });
  }
}
```

---

## Real-time Message Flow

### Complete Flow Diagram:
```
User A sends message:
1. User A → REST API: POST /conversations/{id}/messages
2. Server → Database: Save message
3. Server → User A: HTTP 201 (message saved)
4. Server → WebSocket: Broadcast to all participants
5. User B ← WebSocket: Receives 'chat_message' event
6. User B → UI: setState() updates message list
7. User B → UI: Auto-scroll to bottom
8. User B → Conversation List: Move conversation to top
```

### Flutter State Management:
```dart
class RealtimeChatProvider extends ChangeNotifier {
  List<ChatMessage> _messages = [];
  List<Conversation> _conversations = [];
  String? _activeConversationId;
  
  // Handle new message from WebSocket
  void _handleNewMessage(ChatMessage message) {
    // 1. Add to current conversation if active
    if (message.conversationId == _activeConversationId) {
      _messages.add(message);
      notifyListeners(); // Triggers UI rebuild
    }
    
    // 2. Update conversation list (always)
    _moveConversationToTop(message.conversationId, message);
    notifyListeners();
    
    // 3. Show notification if conversation not active
    if (message.conversationId != _activeConversationId) {
      _showNotification(message);
    }
  }
  
  void _moveConversationToTop(String conversationId, ChatMessage lastMessage) {
    final index = _conversations.indexWhere((c) => c.id == conversationId);
    if (index > 0) {
      final conversation = _conversations.removeAt(index);
      conversation.lastMessage = lastMessage;
      conversation.lastMessageAt = lastMessage.createdAt;
      _conversations.insert(0, conversation);
    }
  }
}
```

---

## Common Flutter Integration Problems

### Problem 1: Messages Not Sending
**Symptom**: REST API call fails with type errors
**Fix**: Check message creation payload:
```dart
// Correct message payload
final messagePayload = {
  'content': messageText,                    // String
  'message_type': 'text',                   // String
  'conversation_id': conversationId,        // String (will be overridden by URL)
  'reply_to_message_id': null,             // String? or null
  'attachments': <String>[],               // List<String>, not List<dynamic>
  'self_destruct_timer': null,             // int? or null
  'client_message_id': uuid.v4(),          // String
};
```

### Problem 2: WebSocket Not Connecting
**Symptoms**: 403 Forbidden, connection fails
**Common Causes**:
1. **Expired JWT Token** (most common)
2. **Wrong WebSocket URL**
3. **Token not in query parameter**

**Fix**:
```dart
Future<void> connectWebSocket() async {
  // 1. Always get fresh token
  final token = await AuthService.getValidToken();
  
  // 2. Check token expiry
  if (await _isTokenExpired(token)) {
    token = await AuthService.refreshToken();
  }
  
  // 3. Correct WebSocket URL format
  final wsUrl = 'ws://10.0.2.2:8000/api/v1/chat/ws?token=$token';
  
  _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
}
```

### Problem 3: UI Not Updating
**Symptoms**: Messages arrive but UI doesn't refresh
**Fix**: Always use `setState()` or `notifyListeners()`:
```dart
// In StatefulWidget
void _handleNewMessage(ChatMessage message) {
  setState(() {  // REQUIRED!
    _messages.add(message);
  });
}

// In Provider/Notifier
void _handleNewMessage(ChatMessage message) {
  _messages.add(message);
  notifyListeners();  // REQUIRED!
}
```

### Problem 4: Conversation List Not Reordering
**Symptoms**: New messages don't move conversation to top
**Fix**: Handle all WebSocket messages, not just active conversation:
```dart
void _handleNewMessage(Map<String, dynamic> data) {
  final message = _parseMessage(data);
  
  // Update current conversation UI (if active)
  if (message.conversationId == _activeConversationId) {
    setState(() {
      _messages.add(message);
    });
  }
  
  // ALWAYS update conversation list
  _updateConversationList(message.conversationId, message);
}
```

---

## Testing & Debugging

### Debug Commands for Flutter:
```dart
// Add these to your WebSocket message handler
print('📥 WebSocket Raw Message: $rawMessage');
print('📊 Parsed Message Type: ${data['type']}');
print('💬 Message Content: ${data['message_data']?['message']?['content']}');
print('👤 Current User ID: $_currentUserId');
print('🏠 Active Conversation: $_activeConversationId');
print('📝 Current Messages Count: ${_messages.length}');
```

### WebSocket Connection Test:
```dart
void testWebSocketConnection() async {
  try {
    final token = await AuthService.getToken();
    print('🔑 Token: ${token?.substring(0, 20)}...');
    
    final wsUrl = 'ws://10.0.2.2:8000/api/v1/chat/ws?token=$token';
    print('🔗 Connecting to: $wsUrl');
    
    final channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    
    channel.stream.listen(
      (message) => print('✅ Received: $message'),
      onError: (error) => print('❌ Error: $error'),
      onDone: () => print('🔌 Connection closed'),
    );
    
    // Test heartbeat
    Timer.periodic(Duration(seconds: 30), (timer) {
      channel.sink.add(jsonEncode({
        'type': 'heartbeat',
        'data': {}
      }));
      print('💓 Heartbeat sent');
    });
    
  } catch (e) {
    print('💥 Connection failed: $e');
  }
}
```

### Message Send Test:
```dart
Future<void> testSendMessage() async {
  final payload = {
    'content': 'Test message',
    'message_type': 'text',
    'conversation_id': 'your-conversation-id',
    'attachments': <String>[],  // Empty array, not null
    'reply_to_message_id': null,
  };
  
  print('📤 Sending payload: ${jsonEncode(payload)}');
  
  try {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/v1/messages/conversations/your-conversation-id/messages'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );
    
    print('📥 Response: ${response.statusCode}');
    print('📄 Body: ${response.body}');
    
  } catch (e) {
    print('❌ Send failed: $e');
  }
}
```

---

## Quick Fixes Checklist

✅ **Token Management**:
- [ ] Check token expiry before WebSocket connection
- [ ] Implement automatic token refresh
- [ ] Handle 403/401 errors gracefully

✅ **WebSocket Events**:
- [ ] Join conversations after connecting
- [ ] Handle all message types in switch statement
- [ ] Use proper type casting for arrays vs strings

✅ **UI Updates**:
- [ ] Call `setState()` for StatefulWidgets
- [ ] Call `notifyListeners()` for ChangeNotifier
- [ ] Update both active conversation AND conversation list

✅ **Message Parsing**:
- [ ] Handle `attachments` as `List<dynamic>`, not `String`
- [ ] Handle `reactions` as `List<dynamic>`, not `String`  
- [ ] Handle `read_by` as `List<dynamic>`, not `String`
- [ ] Extract sender info from both places (message + sender_info)

✅ **Real-time Display**:
- [ ] Add new messages immediately with `setState()`
- [ ] Auto-scroll to bottom after new message
- [ ] Move conversation to top of list
- [ ] Show typing indicators only for active conversation

This guide should solve all your Flutter WebSocket integration issues! 🚀