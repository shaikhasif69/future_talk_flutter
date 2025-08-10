# Flutter Message Status Implementation Guide - UPDATED
## WhatsApp-Style Tick System 🔵🔵

### 🎯 **COMPLETE IMPLEMENTATION SPECIFICATIONS - FINAL VERSION**

This is the **FINAL, UPDATED** guide for implementing WhatsApp-style message delivery status in Flutter with the completed backend integration.

---

## 📊 **EXACT Message Status Logic Flow**

### **Individual Chat Status Determination:**
```dart
MessageStatus determineIndividualChatStatus(ChatMessage message, String currentUserId) {
  // Only show status for messages I sent
  if (message.senderId != currentUserId) {
    return MessageStatus.received; // Don't show status for received messages
  }
  
  // Check if the OTHER person read the message
  final otherPersonRead = message.readBy.any((id) => id != currentUserId);
  if (otherPersonRead) {
    return MessageStatus.read;      // 🔵🔵 Blue double tick
  }
  
  // Check if the OTHER person received the message  
  final otherPersonDelivered = message.deliveredTo.any((id) => id != currentUserId);
  if (otherPersonDelivered) {
    return MessageStatus.delivered; // ✅✅ Gray double tick
  }
  
  // Message sent to server but not yet delivered
  if (message.id.isNotEmpty) {
    return MessageStatus.sent;      // ✅ Gray single tick
  }
  
  return MessageStatus.sending;     // ⏳ Clock icon
}
```

### **Group Chat Status Determination:**
```dart
MessageStatus determineGroupChatStatus(ChatMessage message, String currentUserId, List<String> allParticipants) {
  // Only show status for messages I sent
  if (message.senderId != currentUserId) {
    return MessageStatus.received;
  }
  
  // Get other participants (exclude myself)
  final otherParticipants = allParticipants.where((id) => id != currentUserId).toList();
  
  // Count how many others have read/delivered
  final readCount = otherParticipants.where((id) => message.readBy.contains(id)).length;
  final deliveredCount = otherParticipants.where((id) => message.deliveredTo.contains(id)).length;
  
  final totalOthers = otherParticipants.length;
  
  if (readCount == totalOthers) {
    return MessageStatus.read;      // 🔵🔵 All read - Blue double tick
  } else if (deliveredCount == totalOthers) {
    return MessageStatus.delivered; // ✅✅ All delivered - Gray double tick
  } else {
    return MessageStatus.sent;      // ✅ Not all delivered - Single tick
  }
}
```

---

## 🎨 **EXACT Tick Icon Specifications - UPDATED**

### **Icon Colors & Styles:**
```dart
class MessageStatusIcons {
  static const Color grayTick = Color(0xFF8E8E93);    // iOS gray
  static const Color blueTick = Color(0xFF007AFF);    // WhatsApp blue
  static const Color redError = Color(0xFFFF3B30);    // Error red
  static const Color sendingGray = Color(0xFFBEBEBE); // Sending state

  static Widget getStatusIcon(MessageStatus status) {
    switch (status) {
      case MessageStatus.sending:
        return Icon(Icons.schedule, size: 14, color: sendingGray);
        
      case MessageStatus.sent:
        return Icon(Icons.done, size: 14, color: grayTick);           // ✓ Single tick
        
      case MessageStatus.delivered:
        return Icon(Icons.done_all, size: 14, color: grayTick);       // ✓✓ Double tick  
        
      case MessageStatus.read:
        return Icon(Icons.done_all, size: 14, color: blueTick);       // 🔵🔵 Blue double tick
        
      case MessageStatus.failed:
        return Icon(Icons.error, size: 14, color: redError);
        
      case MessageStatus.received:
        return SizedBox.shrink(); // No status for received messages
    }
  }
}

enum MessageStatus { 
  sending, 
  sent, 
  delivered, 
  read, 
  failed, 
  received  // NEW: For messages received from others
}
```

---

## 🔄 **COMPLETE WebSocket Event Handling - UPDATED**

### **1. New Message Event Structure**
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
      "content": "Hello!",
      "message_type": "text",
      "created_at": "2024-01-01T12:00:00Z",
      "attachments": [],
      "status": "sent",              // NEW: Overall message status
      "read_by": [],                 // NEW: Array of user IDs who read
      "delivered_to": []             // NEW: Array of user IDs who received
    },
    "sender_info": {
      "id": "sender-user-id",
      "username": "john_doe"
    }
  }
}
```

### **2. Message Delivery Status Update Event - NEW**
```json
{
  "type": "chat_message",
  "conversation_id": "uuid-string", 
  "message_data": {
    "type": "message_delivery_status_update",
    "message_id": "uuid-string",
    "user_id": "recipient-user-id",
    "old_status": "sent",
    "new_status": "delivered",
    "overall_status": "delivered",
    "timestamp": "2024-01-01T12:00:00Z"
  }
}
```

### **3. Message Overall Status Update Event - NEW**
```json
{
  "type": "chat_message",
  "conversation_id": "uuid-string",
  "message_data": {
    "type": "message_overall_status_update", 
    "message_id": "uuid-string",
    "old_overall_status": "delivered",
    "new_overall_status": "read",
    "read_by": ["user1", "user2"],
    "delivered_to": ["user1", "user2", "user3"],
    "timestamp": "2024-01-01T12:00:00Z"
  }
}
```

### **4. User Delivery Confirmation Event - NEW**
```json
{
  "type": "chat_message",
  "conversation_id": "uuid-string",
  "message_data": {
    "type": "user_delivery_confirmation",
    "user_id": "user-who-came-online",
    "delivered_message_ids": ["msg1", "msg2", "msg3"],
    "conversation_id": "uuid-string",
    "timestamp": "2024-01-01T12:00:00Z"
  }
}
```

### **5. Read Receipt Event - ENHANCED**
```json
{
  "type": "chat_message",
  "conversation_id": "uuid-string",
  "message_data": {
    "type": "message_read_receipt",
    "message_id": "uuid-string",
    "reader_user_id": "uuid-string",
    "conversation_id": "uuid-string",
    "timestamp": "2024-01-01T12:00:00Z"
  }
}
```

---

## 📱 **COMPLETE Flutter WebSocket Handler - FINAL VERSION**

### **Master WebSocket Message Handler:**
```dart
void _handleWebSocketMessage(String rawMessage) {
  try {
    final data = jsonDecode(rawMessage) as Map<String, dynamic>;
    final eventType = data['type'] as String;
    
    print('📥 [WebSocket] Event Type: $eventType');
    
    switch (eventType) {
      case 'connection_established':
        _handleConnectionEstablished(data);
        break;
        
      case 'chat_message':
        final messageData = data['message_data'] as Map<String, dynamic>;
        final messageType = messageData['type'] as String;
        
        print('📥 [WebSocket] Message Type: $messageType');
        
        switch (messageType) {
          case 'new_message':
            _handleNewMessage(data);
            break;
            
          case 'message_delivery_status_update':      // ⭐ NEW
            _handleDeliveryStatusUpdate(data);
            break;
            
          case 'message_overall_status_update':       // ⭐ NEW  
            _handleOverallStatusUpdate(data);
            break;
            
          case 'user_delivery_confirmation':          // ⭐ NEW
            _handleUserDeliveryConfirmation(data);
            break;
            
          case 'message_read_receipt':
            _handleReadReceipt(data);
            break;
            
          case 'typing_indicator':
            _handleTypingIndicator(data);
            break;
            
          default:
            print('⚠️ [WebSocket] Unknown message type: $messageType');
        }
        break;
        
      default:
        print('⚠️ [WebSocket] Unknown event type: $eventType');
    }
    
  } catch (e, stackTrace) {
    print('❌ [WebSocket] Error parsing message: $e');
    print('Stack trace: $stackTrace');
  }
}
```

### **Individual Status Update Handler - NEW:**
```dart
void _handleDeliveryStatusUpdate(Map<String, dynamic> data) {
  try {
    final messageData = data['message_data'] as Map<String, dynamic>;
    final messageId = messageData['message_id'] as String;
    final userId = messageData['user_id'] as String;
    final oldStatus = messageData['old_status'] as String;
    final newStatus = messageData['new_status'] as String;
    final overallStatus = messageData['overall_status'] as String;
    
    print('📊 [Status] Individual status update:');
    print('   Message: ${messageId.substring(0, 8)}...');
    print('   User: ${userId.substring(0, 8)}...');
    print('   Status: $oldStatus → $newStatus');
    print('   Overall: $overallStatus');
    
    // Update the message's delivered_to or read_by array
    _updateIndividualMessageStatus(messageId, userId, newStatus);
    
  } catch (e) {
    print('❌ [Status] Error handling delivery status update: $e');
  }
}

void _updateIndividualMessageStatus(String messageId, String userId, String newStatus) {
  setState(() {
    final messageIndex = _messages.indexWhere((m) => m.id == messageId);
    if (messageIndex != -1) {
      var message = _messages[messageIndex];
      
      // Update delivered_to or read_by arrays
      final updatedDeliveredTo = List<String>.from(message.deliveredTo);
      final updatedReadBy = List<String>.from(message.readBy);
      
      if (newStatus == 'delivered' && !updatedDeliveredTo.contains(userId)) {
        updatedDeliveredTo.add(userId);
      } else if (newStatus == 'read') {
        if (!updatedDeliveredTo.contains(userId)) {
          updatedDeliveredTo.add(userId);
        }
        if (!updatedReadBy.contains(userId)) {
          updatedReadBy.add(userId);
        }
      }
      
      _messages[messageIndex] = message.copyWith(
        deliveredTo: updatedDeliveredTo,
        readBy: updatedReadBy,
      );
      
      print('✅ [Status] Updated message status arrays');
    }
  });
}
```

### **Overall Status Update Handler - NEW:**
```dart
void _handleOverallStatusUpdate(Map<String, dynamic> data) {
  try {
    final messageData = data['message_data'] as Map<String, dynamic>;
    final messageId = messageData['message_id'] as String;
    final oldOverallStatus = messageData['old_overall_status'] as String;
    final newOverallStatus = messageData['new_overall_status'] as String;
    final readBy = (messageData['read_by'] as List<dynamic>).cast<String>();
    final deliveredTo = (messageData['delivered_to'] as List<dynamic>).cast<String>();
    
    print('🎯 [Status] Overall status update:');
    print('   Message: ${messageId.substring(0, 8)}...');  
    print('   Overall: $oldOverallStatus → $newOverallStatus');
    print('   Read by: ${readBy.length} users');
    print('   Delivered to: ${deliveredTo.length} users');
    
    // Update the message with complete status arrays
    setState(() {
      final messageIndex = _messages.indexWhere((m) => m.id == messageId);
      if (messageIndex != -1) {
        _messages[messageIndex] = _messages[messageIndex].copyWith(
          readBy: readBy,
          deliveredTo: deliveredTo,
          status: newOverallStatus,
        );
        
        print('✅ [Status] Updated overall message status');
      }
    });
    
  } catch (e) {
    print('❌ [Status] Error handling overall status update: $e');
  }
}
```

### **User Delivery Confirmation Handler - NEW:**
```dart
void _handleUserDeliveryConfirmation(Map<String, dynamic> data) {
  try {
    final messageData = data['message_data'] as Map<String, dynamic>;
    final userId = messageData['user_id'] as String;
    final deliveredMessageIds = (messageData['delivered_message_ids'] as List<dynamic>).cast<String>();
    
    print('📬 [Delivery] User delivery confirmation:');
    print('   User: ${userId.substring(0, 8)}...');
    print('   Messages delivered: ${deliveredMessageIds.length}');
    
    // Update all affected messages
    setState(() {
      for (final messageId in deliveredMessageIds) {
        final messageIndex = _messages.indexWhere((m) => m.id == messageId);
        if (messageIndex != -1) {
          final message = _messages[messageIndex];
          final updatedDeliveredTo = List<String>.from(message.deliveredTo);
          
          if (!updatedDeliveredTo.contains(userId)) {
            updatedDeliveredTo.add(userId);
            
            _messages[messageIndex] = message.copyWith(
              deliveredTo: updatedDeliveredTo,
            );
          }
        }
      }
    });
    
    print('✅ [Delivery] Updated ${deliveredMessageIds.length} messages');
    
  } catch (e) {
    print('❌ [Delivery] Error handling user delivery confirmation: $e');
  }
}
```

---

## 🧪 **ENHANCED ChatMessage Model - FINAL VERSION**

### **Complete ChatMessage Class:**
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
  final List<Attachment> attachments;
  final List<Reaction> reactions;
  final List<String> readBy;           // ⭐ WHO READ THE MESSAGE
  final List<String> deliveredTo;      // ⭐ WHO RECEIVED THE MESSAGE  
  final String status;                 // ⭐ OVERALL STATUS
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
    this.attachments = const [],
    this.reactions = const [],        
    this.readBy = const [],              // ⭐ DEFAULT EMPTY
    this.deliveredTo = const [],         // ⭐ DEFAULT EMPTY
    this.status = 'sent',                // ⭐ DEFAULT STATUS
    this.selfDestructAt,
    this.encrypted = true,
    this.encryptionType,
    this.securityLevel,
  });

  // ⭐ ENHANCED fromJson - HANDLES NEW FIELDS
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
      
      // ⭐ CRITICAL: Handle new status fields
      attachments: (json['attachments'] as List<dynamic>? ?? [])
        .map((a) => Attachment.fromJson(a as Map<String, dynamic>))
        .toList(),
      reactions: (json['reactions'] as List<dynamic>? ?? [])
        .map((r) => Reaction.fromJson(r as Map<String, dynamic>))
        .toList(),
      readBy: (json['read_by'] as List<dynamic>? ?? [])      // ⭐ NEW
        .map((id) => id as String)
        .toList(),
      deliveredTo: (json['delivered_to'] as List<dynamic>? ?? [])  // ⭐ NEW
        .map((id) => id as String)
        .toList(),
      status: json['status'] as String? ?? 'sent',          // ⭐ NEW
        
      selfDestructAt: json['self_destruct_at'] != null 
        ? DateTime.parse(json['self_destruct_at'] as String) 
        : null,
      encrypted: json['encrypted'] as bool? ?? true,
      encryptionType: json['encryption_type'] as String?,
      securityLevel: json['security_level'] as String?,
    );
  }

  // ⭐ ENHANCED copyWith - SUPPORTS NEW FIELDS
  ChatMessage copyWith({
    String? id,
    String? conversationId,
    String? senderId,
    String? senderUsername,
    String? content,
    MessageType? messageType,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? editedAt,
    bool? isEdited,
    bool? isDestroyed,
    String? replyToMessageId,
    List<Attachment>? attachments,
    List<Reaction>? reactions,
    List<String>? readBy,              // ⭐ NEW
    List<String>? deliveredTo,         // ⭐ NEW
    String? status,                    // ⭐ NEW
    DateTime? selfDestructAt,
    bool? encrypted,
    String? encryptionType,
    String? securityLevel,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      senderUsername: senderUsername ?? this.senderUsername,
      content: content ?? this.content,
      messageType: messageType ?? this.messageType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      editedAt: editedAt ?? this.editedAt,
      isEdited: isEdited ?? this.isEdited,
      isDestroyed: isDestroyed ?? this.isDestroyed,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      attachments: attachments ?? this.attachments,
      reactions: reactions ?? this.reactions,
      readBy: readBy ?? this.readBy,                      // ⭐ NEW
      deliveredTo: deliveredTo ?? this.deliveredTo,       // ⭐ NEW
      status: status ?? this.status,                      // ⭐ NEW
      selfDestructAt: selfDestructAt ?? this.selfDestructAt,
      encrypted: encrypted ?? this.encrypted,
      encryptionType: encryptionType ?? this.encryptionType,
      securityLevel: securityLevel ?? this.securityLevel,
    );
  }
}
```

---

## 🎯 **FINAL Implementation Checklist**

✅ **WebSocket Events**:
- [ ] Handle `message_delivery_status_update` events
- [ ] Handle `message_overall_status_update` events  
- [ ] Handle `user_delivery_confirmation` events
- [ ] Handle enhanced `message_read_receipt` events

✅ **Message Model**:
- [ ] Add `readBy`, `deliveredTo`, `status` fields
- [ ] Update `fromJson()` to parse new fields
- [ ] Update `copyWith()` to support new fields

✅ **Status Logic**:
- [ ] Implement individual chat status determination
- [ ] Implement group chat status determination
- [ ] Use correct tick icons based on status

✅ **UI Integration**:
- [ ] Show status icons only for sent messages
- [ ] Update status in real-time via WebSocket
- [ ] Handle both individual and group chat scenarios

This is the **complete, final implementation** that works with the enhanced backend! 🚀