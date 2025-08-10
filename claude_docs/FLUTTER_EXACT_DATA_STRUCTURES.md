# Flutter Chat Data Structures - EXACT Backend Format

## 🚨 Critical Type Casting Fix

Your Flutter error: `type 'List<dynamic>' is not a subtype of type 'String?'`

**Root Cause**: The backend returns `attachments` as `[]` (empty array), but your Flutter code tries to cast it as `String?`.

---

## 📋 EXACT Backend Response Formats

### 1. Send Message Response (POST /messages)

**Backend Returns (ChatMessageResponse):**
```json
{
  "id": "uuid-string",                    // String
  "conversation_id": "uuid-string",       // String  
  "sender_id": "uuid-string",            // String
  "content": "decrypted message text",    // String
  "message_type": "text",                // String ("text", "voice", "video", "image")
  "reply_to_message_id": null,           // String? or null
  "created_at": "2024-01-01T12:00:00Z",  // String (ISO 8601)
  "edited_at": null,                     // String? or null  
  "attachments": [],                     // List<dynamic> (ALWAYS ARRAY, NEVER NULL)
  "self_destruct_at": null,              // String? or null
  "is_destroyed": false,                 // bool
  "encrypted": true,                     // bool
  "encryption_type": "MILITARY_GRADE_E2E", // String?
  "security_level": "MILITARY_GRADE"     // String?
}
```

### 2. Get Messages Response (GET /messages)

**Backend Returns (List<ChatMessageResponse>):**
```json
[
  {
    "id": "uuid-string",
    "conversation_id": "uuid-string",
    "sender_id": "uuid-string", 
    "content": "decrypted message text",
    "message_type": "text",
    "reply_to_message_id": null,
    "created_at": "2024-01-01T12:00:00Z",
    "edited_at": null,
    "attachments": [],                   // ALWAYS EMPTY ARRAY []
    "self_destruct_at": null,
    "is_destroyed": false,
    "encrypted": true,
    "encryption_type": "MILITARY_GRADE_E2E",
    "security_level": "MILITARY_GRADE"
  }
]
```

### 3. WebSocket Chat Message Event

**Backend Sends:**
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
      "content": "decrypted message text", 
      "message_type": "text",
      "reply_to_message_id": null,
      "created_at": "2024-01-01T12:00:00.123456Z",
      "edited_at": null,
      "attachments": [],                 // ALWAYS EMPTY ARRAY []
      "self_destruct_at": null,
      "is_destroyed": false,
      "encrypted": true,
      "encryption_type": "MILITARY_GRADE_E2E",
      "security_level": "MILITARY_GRADE"
    },
    "sender_info": {
      "user_id": "uuid-string",
      "username": "john_doe",
      "display_name": "John Doe"
    }
  }
}
```

---

## 🎯 EXACT Flutter Models (Type-Safe)

### ChatMessage Model - CORRECTED
```dart
class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderUsername;
  final String content;
  final MessageType messageType;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? editedAt;
  final bool isEdited;
  final bool isDestroyed;
  final String? replyToMessageId;
  final List<Attachment> attachments;  // ALWAYS LIST, NEVER STRING
  final List<Reaction> reactions;      // ALWAYS LIST, NEVER STRING
  final List<String> readBy;           // ALWAYS LIST, NEVER STRING
  final DateTime? selfDestructAt;
  final bool encrypted;
  final String? encryptionType;
  final String? securityLevel;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderUsername,
    required this.content,
    required this.messageType,
    required this.createdAt,
    this.updatedAt,
    this.editedAt,
    this.isEdited = false,
    this.isDestroyed = false,
    this.replyToMessageId,
    this.attachments = const [],      // DEFAULT TO EMPTY LIST
    this.reactions = const [],        // DEFAULT TO EMPTY LIST  
    this.readBy = const [],          // DEFAULT TO EMPTY LIST
    this.selfDestructAt,
    this.encrypted = true,
    this.encryptionType,
    this.securityLevel,
  });

  // CORRECTED fromJson - EXACT BACKEND FORMAT
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
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
      editedAt: json['edited_at'] != null 
        ? DateTime.parse(json['edited_at'] as String) 
        : null,
      isEdited: json['is_edited'] as bool? ?? false,
      isDestroyed: json['is_destroyed'] as bool? ?? false,
      replyToMessageId: json['reply_to_message_id'] as String?,
      
      // CRITICAL FIX: Handle as Lists, not Strings
      attachments: (json['attachments'] as List<dynamic>? ?? [])
        .map((a) => Attachment.fromJson(a as Map<String, dynamic>))
        .toList(),
      reactions: (json['reactions'] as List<dynamic>? ?? [])
        .map((r) => Reaction.fromJson(r as Map<String, dynamic>))
        .toList(),
      readBy: (json['read_by'] as List<dynamic>? ?? [])
        .map((id) => id as String)
        .toList(),
        
      selfDestructAt: json['self_destruct_at'] != null 
        ? DateTime.parse(json['self_destruct_at'] as String) 
        : null,
      encrypted: json['encrypted'] as bool? ?? true,
      encryptionType: json['encryption_type'] as String?,
      securityLevel: json['security_level'] as String?,
    );
  }

  // CORRECTED fromWebSocketMessage - EXACT WEBSOCKET FORMAT
  factory ChatMessage.fromWebSocketMessage(Map<String, dynamic> data) {
    final messageData = data['message_data'] as Map<String, dynamic>;
    final messageInfo = messageData['message'] as Map<String, dynamic>;
    final senderInfo = messageData['sender_info'] as Map<String, dynamic>?;

    return ChatMessage(
      id: messageInfo['id'] as String,
      conversationId: messageInfo['conversation_id'] as String,
      senderId: messageInfo['sender_id'] as String,
      senderUsername: senderInfo?['username'] as String? ?? 
                     messageInfo['sender_username'] as String? ?? 
                     'Unknown',
      content: messageInfo['content'] as String,
      messageType: MessageType.values.firstWhere(
        (e) => e.name == messageInfo['message_type'],
        orElse: () => MessageType.text,
      ),
      createdAt: DateTime.parse(messageInfo['created_at'] as String),
      updatedAt: messageInfo['updated_at'] != null 
        ? DateTime.parse(messageInfo['updated_at'] as String) 
        : null,
      editedAt: messageInfo['edited_at'] != null 
        ? DateTime.parse(messageInfo['edited_at'] as String) 
        : null,
      isEdited: messageInfo['is_edited'] as bool? ?? false,
      isDestroyed: messageInfo['is_destroyed'] as bool? ?? false,
      replyToMessageId: messageInfo['reply_to_message_id'] as String?,
      
      // CRITICAL FIX: Handle WebSocket arrays correctly
      attachments: (messageInfo['attachments'] as List<dynamic>? ?? [])
        .map((a) => Attachment.fromJson(a as Map<String, dynamic>))
        .toList(),
      reactions: (messageInfo['reactions'] as List<dynamic>? ?? [])
        .map((r) => Reaction.fromJson(r as Map<String, dynamic>))
        .toList(),
      readBy: (messageInfo['read_by'] as List<dynamic>? ?? [])
        .map((id) => id as String)
        .toList(),
        
      selfDestructAt: messageInfo['self_destruct_at'] != null 
        ? DateTime.parse(messageInfo['self_destruct_at'] as String) 
        : null,
      encrypted: messageInfo['encrypted'] as bool? ?? true,
      encryptionType: messageInfo['encryption_type'] as String?,
      securityLevel: messageInfo['security_level'] as String?,
    );
  }
}
```

### Message Send Request - CORRECTED
```dart
class MessageSendRequest {
  final String content;
  final String messageType;
  final String? replyToMessageId;
  final List<String> attachments;        // MUST BE LIST<STRING>
  final int? selfDestructTimer;
  final String? clientMessageId;

  MessageSendRequest({
    required this.content,
    this.messageType = 'text',
    this.replyToMessageId,
    this.attachments = const [],         // DEFAULT TO EMPTY LIST
    this.selfDestructTimer,
    this.clientMessageId,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'message_type': messageType,
      'reply_to_message_id': replyToMessageId,
      'attachments': attachments,          // ARRAY, NOT NULL
      'self_destruct_timer': selfDestructTimer,
      'client_message_id': clientMessageId,
    };
  }
}
```

---

## 🔧 EXACT WebSocket Event Handlers

### WebSocket Message Handler - CORRECTED
```dart
void _handleWebSocketMessage(String rawMessage) {
  try {
    final data = jsonDecode(rawMessage) as Map<String, dynamic>;
    final eventType = data['type'] as String;
    
    print('📥 [WebSocket] PARSED MESSAGE: $eventType');
    
    switch (eventType) {
      case 'connection_established':
        _handleConnectionEstablished(data);
        break;
        
      case 'chat_message':
        _handleChatMessage(data);
        break;
        
      case 'typing_indicator':
        _handleTypingIndicator(data);
        break;
        
      case 'typing_indicator_sent':      // MISSING EVENT HANDLER
        _handleTypingIndicatorSent(data);
        break;
        
      case 'conversation_joined':
        _handleConversationJoined(data);
        break;
        
      case 'message_read_receipt':
        _handleReadReceipt(data);
        break;
        
      case 'heartbeat_ack':
        print('💓 Heartbeat acknowledged');
        break;
        
      case 'error':
        _handleWebSocketError(data);
        break;
        
      default:
        print('⚠️ [WebSocket] Unknown event type: $eventType');
    }
    
  } catch (e, stackTrace) {
    print('❌ [WebSocket] Error parsing message: $e');
    print('Stack trace: $stackTrace');
  }
}

// NEW: Handle typing_indicator_sent event
void _handleTypingIndicatorSent(Map<String, dynamic> data) {
  print('✅ Typing indicator sent successfully');
  // This is just an acknowledgment - no UI update needed
}

// CORRECTED: Chat message handler
void _handleChatMessage(Map<String, dynamic> data) {
  try {
    final conversationId = data['conversation_id'] as String;
    final message = ChatMessage.fromWebSocketMessage(data);
    
    print('💬 New message in conversation: $conversationId');
    print('Content: ${message.content}');
    print('From: ${message.senderUsername}');
    
    // Update current conversation if active
    if (_activeConversationId == conversationId) {
      setState(() {
        _messages.add(message);        // Add to end (newest)
      });
      
      // Auto-scroll to bottom
      _scrollToBottom();
    }
    
    // ALWAYS update conversation list (move to top)
    _updateConversationOrder(conversationId, message);
    
  } catch (e, stackTrace) {
    print('❌ Error handling chat message: $e');
    print('Stack trace: $stackTrace');
  }
}
```

---

## 🚨 CRITICAL Flutter Fixes

### Fix 1: Repository Response Parsing
```dart
// In ChatRepository.sendMessage() - BEFORE THE FIX
// WRONG ❌
Future<ChatMessage> sendMessage(MessageSendRequest request) async {
  final response = await _apiClient.post('/messages', data: request.toJson());
  
  // THIS CAUSES THE ERROR - trying to cast List to String
  return ChatMessage.fromJson(response.data);  // BREAKS ON attachments: []
}

// CORRECT ✅  
Future<ChatMessage> sendMessage(MessageSendRequest request) async {
  try {
    final response = await _apiClient.post('/messages', data: request.toJson());
    
    print('📤 Send message response: ${response.data}');
    
    // Use the corrected fromJson method
    return ChatMessage.fromJson(response.data as Map<String, dynamic>);
    
  } catch (e, stackTrace) {
    print('❌ Send message error: $e');
    print('Response data: ${response?.data}');
    print('Stack trace: $stackTrace');
    throw e;
  }
}
```

### Fix 2: Current User ID Loading
```dart
// In your AuthService or UserProvider
class AuthService {
  String? _currentUserId;
  
  String? get currentUserId => _currentUserId;
  
  Future<void> loadCurrentUser() async {
    try {
      final response = await _apiClient.get('/users/me');
      final userData = response.data['user'] as Map<String, dynamic>;
      
      _currentUserId = userData['id'] as String;
      
      print('✅ Current user ID loaded: $_currentUserId');
      
    } catch (e) {
      print('❌ Failed to load current user: $e');
      _currentUserId = null;
    }
  }
}

// Call this during app initialization
Future<void> initializeApp() async {
  await AuthService.instance.loadCurrentUser();
  
  // Now currentUserId should not be null
  print('🏷️ Current user ID: ${AuthService.instance.currentUserId}');
}
```

### Fix 3: Message Alignment Logic
```dart
Widget _buildMessage(ChatMessage message, int index) {
  final currentUserId = AuthService.instance.currentUserId;
  
  if (currentUserId == null) {
    print('⚠️ Current user ID is null!');
    return Container(); // or some error widget
  }
  
  final isFromMe = message.senderId == currentUserId;
  
  print('🔍 Building message ${index + 1}:');
  print('   - Content: "${message.content}"');
  print('   - Sender: ${message.senderUsername} (${message.senderId})');
  print('   - Current User: $currentUserId');
  print('   - Is from me: $isFromMe');
  print('   - ALIGNMENT: ${isFromMe ? 'RIGHT (sent/green)' : 'LEFT (received/white)'}');
  
  return Align(
    alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      // Your message UI here
      decoration: BoxDecoration(
        color: isFromMe ? Colors.green[100] : Colors.white,
        // ... other styling
      ),
      child: Text(message.content),
    ),
  );
}
```

---

## 🧪 Testing Your Fixes

### Test Message Sending
```dart
Future<void> testSendMessage() async {
  try {
    final request = MessageSendRequest(
      content: 'Test message',
      messageType: 'text',
      attachments: [],  // Empty list, not null
    );
    
    print('📤 Sending: ${jsonEncode(request.toJson())}');
    
    final message = await ChatRepository.instance.sendMessage(request);
    
    print('✅ Message sent successfully: ${message.id}');
    print('Content: ${message.content}');
    print('Attachments: ${message.attachments.length} items');
    
  } catch (e, stackTrace) {
    print('❌ Send failed: $e');
    print('Stack trace: $stackTrace');
  }
}
```

### Test WebSocket Connection
```dart
Future<void> testWebSocket() async {
  try {
    final token = await AuthService.instance.getValidToken();
    print('🔑 Token exists: ${token != null}');
    
    final wsUrl = 'ws://10.0.2.2:8000/api/v1/chat/ws?token=$token';
    print('🔗 Connecting to: $wsUrl');
    
    final channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    
    channel.stream.listen(
      (message) {
        print('✅ WebSocket received: $message');
        _handleWebSocketMessage(message);
      },
      onError: (error) {
        print('❌ WebSocket error: $error');
      },
      onDone: () {
        print('🔌 WebSocket closed');
      },
    );
    
  } catch (e) {
    print('💥 WebSocket connection failed: $e');
  }
}
```

---

## 📋 Quick Fix Checklist

- [ ] Replace all `attachments` String casts with `List<dynamic>` handling
- [ ] Replace all `reactions` String casts with `List<dynamic>` handling  
- [ ] Replace all `read_by` String casts with `List<dynamic>` handling
- [ ] Load current user ID during app initialization
- [ ] Add `typing_indicator_sent` WebSocket event handler
- [ ] Use `setState()` when adding new WebSocket messages
- [ ] Always provide empty lists as defaults, never null
- [ ] Handle WebSocket message parsing with try-catch blocks

This should fix all your type casting errors and real-time message display issues! 🚀