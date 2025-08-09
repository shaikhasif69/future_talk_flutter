# Future Talk Chat API Documentation

## Table of Contents
1. [Overview](#overview)
2. [Authentication](#authentication)
3. [Base URLs](#base-urls)
4. [Error Handling](#error-handling)
5. [Chat REST API Endpoints](#chat-rest-api-endpoints)
6. [WebSocket API](#websocket-api)
7. [Data Schemas](#data-schemas)
8. [Implementation Examples](#implementation-examples)
9. [Complete Workflows](#complete-workflows)
10. [Best Practices](#best-practices)

## Overview

The Future Talk Chat API provides a comprehensive real-time messaging system with military-grade encryption, supporting both direct (1-on-1) and group conversations. The system combines REST endpoints for conversation management with WebSocket connections for real-time features.

### Key Features
- **Military-grade encryption**: All messages encrypted with AES-256
- **Real-time messaging**: WebSocket-based instant delivery
- **Read receipts**: Track message delivery and read status
- **Typing indicators**: Real-time typing status
- **Self-destructing messages**: Configurable message timers
- **Friend-only messaging**: Only friends can start conversations
- **Message reactions**: Emoji reactions and interactions
- **Rich attachments**: Support for images, videos, audio, documents

## Authentication

All API endpoints require JWT authentication using Bearer tokens.

### Headers Required
```javascript
{
  "Authorization": "Bearer <jwt_access_token>",
  "Content-Type": "application/json"
}
```

### Getting Auth Token
```javascript
// Login to get access token
const response = await fetch('http://localhost:8000/api/v1/auth/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    username: 'your_username',
    password: 'your_password'
  })
});

const { access_token } = await response.json();
```

## Base URLs

- **REST API**: `http://localhost:8000/api/v1/messages`
- **WebSocket**: `ws://localhost:8000/api/v1/chat/ws`

## Error Handling

### Standard Error Response Format
```json
{
  "detail": "Error message description",
  "error_code": "SPECIFIC_ERROR_CODE",
  "timestamp": "2024-01-15T10:30:00Z"
}
```

### Common HTTP Status Codes
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized (Invalid/expired token)
- `403` - Forbidden (Not friends or insufficient permissions)
- `404` - Not Found
- `422` - Validation Error
- `500` - Internal Server Error

## Chat REST API Endpoints

### 1. Create Conversation

Creates a new chat conversation between friends.

**Endpoint:** `POST /api/v1/messages/conversations`

**Request Body:**
```json
{
  "participant_ids": ["user_uuid_1", "user_uuid_2"],
  "conversation_type": "direct"
}
```

**Response (201):**
```json
{
  "id": "conv_uuid",
  "conversation_type": "direct",
  "created_at": "2024-01-15T10:30:00Z",
  "last_message_at": "2024-01-15T10:30:00Z",
  "is_archived": false,
  "participants": [
    {
      "user_id": "user_uuid_1",
      "username": "alice_doe",
      "role": "member",
      "joined_at": "2024-01-15T10:30:00Z"
    },
    {
      "user_id": "user_uuid_2", 
      "username": "bob_smith",
      "role": "member",
      "joined_at": "2024-01-15T10:30:00Z"
    }
  ],
  "last_message": null,
  "unread_count": 0
}
```

**Validation Rules:**
- `participant_ids`: 1-10 user IDs (for direct: exactly 1 other user)
- `conversation_type`: "direct" or "group"
- All participants must be friends with the creator
- For direct conversations, returns existing conversation if one exists

**Error Examples:**
```json
// 403 - Not friends
{
  "detail": "Can only create conversations with friends"
}

// 400 - Invalid participant count
{
  "detail": "Direct conversations must have exactly 2 participants"
}
```

### 2. Get User Conversations

Retrieves user's conversation list with pagination.

**Endpoint:** `GET /api/v1/messages/conversations`

**Query Parameters:**
- `limit` (optional): 1-50, default 20
- `offset` (optional): Starting position, default 0

**Response (200):**
```json
[
  {
    "id": "conv_uuid",
    "conversation_type": "direct",
    "created_at": "2024-01-15T10:30:00Z",
    "last_message_at": "2024-01-15T14:25:30Z",
    "is_archived": false,
    "participants": [
      {
        "user_id": "user_uuid",
        "username": "alice_doe",
        "role": "member",
        "joined_at": "2024-01-15T10:30:00Z"
      }
    ],
    "last_message": {
      "id": "msg_uuid",
      "conversation_id": "conv_uuid",
      "sender_id": "user_uuid",
      "content": "Hey, how are you?",
      "message_type": "text",
      "created_at": "2024-01-15T14:25:30Z",
      "encrypted": true,
      "encryption_type": "MILITARY_GRADE_E2E"
    },
    "unread_count": 3
  }
]
```

### 3. Send Message

Sends a message in a conversation.

**Endpoint:** `POST /api/v1/messages/conversations/{conversation_id}/messages`

**Path Parameters:**
- `conversation_id`: UUID of the conversation

**Request Body:**
```json
{
  "content": "Hello, how are you doing today?",
  "message_type": "text",
  "reply_to_message_id": null,
  "attachments": [],
  "self_destruct_timer": null,
  "client_message_id": "client_generated_uuid"
}
```

**Request Body Fields:**
- `content` (required): 1-5000 characters
- `message_type` (optional): "text", "voice", "video", "image" (default: "text")
- `reply_to_message_id` (optional): Message ID being replied to
- `attachments` (optional): Array of file IDs
- `self_destruct_timer` (optional): Timer in seconds (5, 10, 30, 60, 300, 3600, 86400, 604800)
- `client_message_id` (optional): Client tracking ID

**Response (201):**
```json
{
  "id": "msg_uuid",
  "conversation_id": "conv_uuid",
  "sender_id": "user_uuid",
  "content": "Hello, how are you doing today?",
  "message_type": "text",
  "reply_to_message_id": null,
  "created_at": "2024-01-15T14:25:30Z",
  "edited_at": null,
  "attachments": [],
  "self_destruct_at": null,
  "is_destroyed": false,
  "encrypted": true,
  "encryption_type": "MILITARY_GRADE_E2E",
  "security_level": "MILITARY_GRADE",
  "perfect_forward_secrecy": false,
  "zero_knowledge": false,
  "session_id": "session_uuid",
  "protocol": "Signal-Protocol-Inspired"
}
```

**Real-time Behavior:**
- Message is instantly sent to all conversation participants via WebSocket
- Sender receives delivery confirmation
- Recipients receive real-time message notification

### 4. Get Conversation Messages

Retrieves messages from a conversation with pagination.

**Endpoint:** `GET /api/v1/messages/conversations/{conversation_id}/messages`

**Query Parameters:**
- `limit` (optional): 1-100, default 50
- `offset` (optional): Starting position, default 0
- `before_message_id` (optional): Cursor-based pagination

**Response (200):**
```json
[
  {
    "id": "msg_uuid_3",
    "conversation_id": "conv_uuid",
    "sender_id": "user_uuid_1",
    "content": "Thanks! You too!",
    "message_type": "text",
    "reply_to_message_id": "msg_uuid_2",
    "created_at": "2024-01-15T14:27:15Z",
    "edited_at": null,
    "attachments": [],
    "self_destruct_at": null,
    "is_destroyed": false,
    "encrypted": true,
    "encryption_type": "MILITARY_GRADE_E2E"
  },
  {
    "id": "msg_uuid_2", 
    "conversation_id": "conv_uuid",
    "sender_id": "user_uuid_2",
    "content": "Good morning! Hope you have a great day.",
    "message_type": "text",
    "reply_to_message_id": null,
    "created_at": "2024-01-15T14:26:45Z",
    "attachments": [],
    "encrypted": true
  }
]
```

**Notes:**
- Messages returned in reverse chronological order (newest first)
- Content is automatically decrypted
- Messages are automatically marked as read when retrieved
- Only conversation participants can access messages

### 5. Mark Message as Read

Marks a specific message as read and creates a read receipt.

**Endpoint:** `POST /api/v1/messages/messages/{message_id}/read`

**Path Parameters:**
- `message_id`: UUID of the message

**Response (200):**
```json
{
  "message": "Message marked as read"
}
```

**Real-time Behavior:**
- Creates read receipt in database
- Sends read receipt notification to message sender via WebSocket
- Updates unread count for conversation

### 6. Mark Conversation as Read

Marks all messages in a conversation as read.

**Endpoint:** `POST /api/v1/messages/conversations/{conversation_id}/read`

**Path Parameters:**
- `conversation_id`: UUID of the conversation

**Response (200):**
```json
{
  "message": "Conversation marked as read"
}
```

**Real-time Behavior:**
- Creates read receipts for all unread messages
- Bulk read receipt notification sent via WebSocket
- Resets unread count to zero

### 7. Send Typing Indicator

Sends typing indicator to conversation participants.

**Endpoint:** `POST /api/v1/messages/conversations/{conversation_id}/typing`

**Query Parameters:**
- `is_typing` (required): Boolean - true when starting, false when stopping

**Response (200):**
```json
{
  "message": "Typing indicator sent"
}
```

**Real-time Behavior:**
- Instant typing status update sent to all participants via WebSocket
- Typing indicators auto-expire after 3 seconds of inactivity

## WebSocket API

### Connection

**URL:** `ws://localhost:8000/api/v1/chat/ws?token=<jwt_access_token>`

### Connection Lifecycle

1. **Connect** with JWT token in query parameter
2. **Authentication** - Server validates token
3. **Connection Established** - Receive confirmation message
4. **Message Exchange** - Send/receive real-time messages
5. **Disconnect** - Clean up and notify participants

### Message Format

All WebSocket messages use JSON format:

```json
{
  "type": "message_type",
  "data": { /* message-specific data */ }
}
```

### Connection Establishment

**Client Request:**
```javascript
const ws = new WebSocket('ws://localhost:8000/api/v1/chat/ws?token=' + accessToken);
```

**Server Response:**
```json
{
  "type": "connection_established",
  "user_id": "user_uuid",
  "timestamp": "2024-01-15T14:30:00Z",
  "message": "Connected to real-time chat"
}
```

### Supported Message Types

#### 1. Heartbeat

Keeps connection alive.

**Client → Server:**
```json
{
  "type": "heartbeat",
  "data": {}
}
```

**Server → Client:**
```json
{
  "type": "heartbeat_ack",
  "user_id": "user_uuid",
  "timestamp": "2024-01-15T14:30:15Z"
}
```

#### 2. Join Conversation

Subscribe to real-time updates for a conversation.

**Client → Server:**
```json
{
  "type": "join_conversation",
  "data": {
    "conversation_id": "conv_uuid"
  }
}
```

**Server → Client:**
```json
{
  "type": "conversation_joined",
  "conversation_id": "conv_uuid",
  "timestamp": "2024-01-15T14:30:30Z"
}
```

#### 3. Leave Conversation

Unsubscribe from conversation updates.

**Client → Server:**
```json
{
  "type": "leave_conversation",
  "data": {
    "conversation_id": "conv_uuid"
  }
}
```

#### 4. Typing Indicators

**Start Typing (Client → Server):**
```json
{
  "type": "typing_start",
  "data": {
    "conversation_id": "conv_uuid"
  }
}
```

**Stop Typing (Client → Server):**
```json
{
  "type": "typing_stop", 
  "data": {
    "conversation_id": "conv_uuid"
  }
}
```

**Typing Notification (Server → Participants):**
```json
{
  "type": "user_typing",
  "conversation_id": "conv_uuid",
  "user_id": "typing_user_uuid",
  "username": "alice_doe",
  "is_typing": true,
  "timestamp": "2024-01-15T14:30:45Z"
}
```

#### 5. Message Read Receipts

**Mark as Read (Client → Server):**
```json
{
  "type": "message_read",
  "data": {
    "message_id": "msg_uuid"
  }
}
```

**Read Receipt Notification (Server → Sender):**
```json
{
  "type": "message_read_receipt",
  "message_id": "msg_uuid",
  "reader_user_id": "reader_uuid",
  "timestamp": "2024-01-15T14:31:00Z"
}
```

#### 6. New Message Delivery

When a message is sent via REST API, it's delivered via WebSocket:

**Server → Recipients:**
```json
{
  "type": "new_message",
  "conversation_id": "conv_uuid",
  "message": {
    "id": "msg_uuid",
    "conversation_id": "conv_uuid", 
    "sender_id": "sender_uuid",
    "sender_username": "alice_doe",
    "content": "Hello everyone!",
    "message_type": "text",
    "created_at": "2024-01-15T14:31:15Z",
    "encrypted": true,
    "encryption_type": "MILITARY_GRADE_E2E"
  },
  "timestamp": "2024-01-15T14:31:15Z"
}
```

#### 7. Online Status

**Get Online Status (Client → Server):**
```json
{
  "type": "get_online_status",
  "data": {
    "user_ids": ["user_uuid_1", "user_uuid_2"]
  }
}
```

**Online Status Response (Server → Client):**
```json
{
  "type": "online_status",
  "online_status": {
    "user_uuid_1": true,
    "user_uuid_2": false
  },
  "timestamp": "2024-01-15T14:31:30Z"
}
```

#### 8. Error Messages

**Server → Client:**
```json
{
  "type": "error",
  "message": "Invalid JSON format",
  "timestamp": "2024-01-15T14:31:45Z"
}
```

## Data Schemas

### ConversationCreate
```typescript
interface ConversationCreate {
  participant_ids: string[];     // 1-10 user UUIDs
  conversation_type: "direct" | "group";
}
```

### ConversationResponse
```typescript
interface ConversationResponse {
  id: string;
  conversation_type: "direct" | "group";
  created_at: string;           // ISO 8601
  last_message_at: string;      // ISO 8601
  is_archived: boolean;
  participants: ParticipantInfo[];
  last_message: ChatMessageResponse | null;
  unread_count: number;
}
```

### ParticipantInfo
```typescript
interface ParticipantInfo {
  user_id: string;
  username: string;
  role: "member" | "admin";
  joined_at: string;           // ISO 8601
}
```

### ChatMessageCreate
```typescript
interface ChatMessageCreate {
  conversation_id: string;
  content: string;             // 1-5000 characters
  message_type?: "text" | "voice" | "video" | "image";
  reply_to_message_id?: string;
  attachments?: string[];      // File IDs
  self_destruct_timer?: number; // Seconds
  client_message_id?: string;
}
```

### ChatMessageResponse
```typescript
interface ChatMessageResponse {
  id: string;
  conversation_id: string;
  sender_id: string;
  content: string;             // Decrypted
  message_type: "text" | "voice" | "video" | "image";
  reply_to_message_id?: string;
  created_at: string;          // ISO 8601
  edited_at?: string;          // ISO 8601
  attachments: AttachmentInfo[];
  self_destruct_at?: string;   // ISO 8601
  is_destroyed: boolean;
  
  // Encryption metadata
  encrypted: boolean;
  encryption_type?: string;
  security_level?: string;
  perfect_forward_secrecy?: boolean;
  zero_knowledge?: boolean;
  session_id?: string;
  protocol?: string;
}
```

### AttachmentInfo
```typescript
interface AttachmentInfo {
  id: string;
  file_name: string;
  file_size: number;
  mime_type: string;
  attachment_type: "image" | "video" | "audio" | "document" | "voice_note";
  download_url?: string;
  thumbnail_url?: string;
  duration_seconds?: number;   // For audio/video
  dimensions?: {               // For images/videos
    width: number;
    height: number;
  };
}
```

## Implementation Examples

### Basic Chat Setup (JavaScript/TypeScript)

```javascript
class ChatClient {
  constructor(accessToken) {
    this.accessToken = accessToken;
    this.baseURL = 'http://localhost:8000/api/v1/messages';
    this.ws = null;
    this.messageHandlers = new Map();
  }

  // HTTP Request helper
  async apiRequest(endpoint, options = {}) {
    const response = await fetch(`${this.baseURL}${endpoint}`, {
      headers: {
        'Authorization': `Bearer ${this.accessToken}`,
        'Content-Type': 'application/json',
        ...options.headers
      },
      ...options
    });

    if (!response.ok) {
      const error = await response.json();
      throw new Error(`API Error: ${error.detail}`);
    }

    return response.json();
  }

  // 1. Create Direct Conversation
  async createDirectChat(friendUserId) {
    try {
      const conversation = await this.apiRequest('/conversations', {
        method: 'POST',
        body: JSON.stringify({
          participant_ids: [friendUserId],
          conversation_type: 'direct'
        })
      });
      
      console.log('Conversation created:', conversation);
      return conversation;
    } catch (error) {
      console.error('Failed to create conversation:', error);
      throw error;
    }
  }

  // 2. Get Conversation List
  async getConversations(limit = 20, offset = 0) {
    try {
      const conversations = await this.apiRequest(
        `/conversations?limit=${limit}&offset=${offset}`
      );
      
      console.log('Loaded conversations:', conversations.length);
      return conversations;
    } catch (error) {
      console.error('Failed to load conversations:', error);
      throw error;
    }
  }

  // 3. Send Message
  async sendMessage(conversationId, content, options = {}) {
    try {
      const message = await this.apiRequest(`/conversations/${conversationId}/messages`, {
        method: 'POST',
        body: JSON.stringify({
          content,
          message_type: options.messageType || 'text',
          reply_to_message_id: options.replyToId || null,
          attachments: options.attachments || [],
          self_destruct_timer: options.selfDestructTimer || null,
          client_message_id: options.clientMessageId || this.generateUUID()
        })
      });
      
      console.log('Message sent:', message);
      return message;
    } catch (error) {
      console.error('Failed to send message:', error);
      throw error;
    }
  }

  // 4. Load Message History
  async loadMessages(conversationId, limit = 50, offset = 0) {
    try {
      const messages = await this.apiRequest(
        `/conversations/${conversationId}/messages?limit=${limit}&offset=${offset}`
      );
      
      console.log('Loaded messages:', messages.length);
      return messages;
    } catch (error) {
      console.error('Failed to load messages:', error);
      throw error;
    }
  }

  // 5. Mark Message as Read
  async markMessageAsRead(messageId) {
    try {
      await this.apiRequest(`/messages/${messageId}/read`, {
        method: 'POST'
      });
      
      console.log('Message marked as read:', messageId);
    } catch (error) {
      console.error('Failed to mark message as read:', error);
      throw error;
    }
  }

  // 6. Send Typing Indicator
  async sendTypingIndicator(conversationId, isTyping) {
    try {
      await this.apiRequest(`/conversations/${conversationId}/typing?is_typing=${isTyping}`, {
        method: 'POST'
      });
    } catch (error) {
      console.error('Failed to send typing indicator:', error);
    }
  }

  // WebSocket Connection
  connectWebSocket() {
    const wsURL = `ws://localhost:8000/api/v1/chat/ws?token=${this.accessToken}`;
    this.ws = new WebSocket(wsURL);

    this.ws.onopen = () => {
      console.log('WebSocket connected');
      this.startHeartbeat();
    };

    this.ws.onmessage = (event) => {
      const message = JSON.parse(event.data);
      this.handleWebSocketMessage(message);
    };

    this.ws.onclose = () => {
      console.log('WebSocket disconnected');
      this.stopHeartbeat();
    };

    this.ws.onerror = (error) => {
      console.error('WebSocket error:', error);
    };
  }

  // Handle WebSocket Messages
  handleWebSocketMessage(message) {
    const { type } = message;
    
    switch (type) {
      case 'connection_established':
        console.log('Chat connection established:', message.user_id);
        break;
        
      case 'new_message':
        this.handleNewMessage(message);
        break;
        
      case 'user_typing':
        this.handleTypingIndicator(message);
        break;
        
      case 'message_read_receipt':
        this.handleReadReceipt(message);
        break;
        
      case 'online_status':
        this.handleOnlineStatus(message);
        break;
        
      case 'error':
        console.error('WebSocket error:', message.message);
        break;
        
      default:
        console.log('Unknown message type:', type);
    }
  }

  // Handle New Message
  handleNewMessage(data) {
    const { conversation_id, message } = data;
    console.log('New message in conversation:', conversation_id, message);
    
    // Update UI with new message
    this.onNewMessage?.(conversation_id, message);
    
    // Auto-mark as read if conversation is active
    if (this.activeConversationId === conversation_id) {
      this.markMessageAsRead(message.id);
    }
  }

  // Handle Typing Indicator
  handleTypingIndicator(data) {
    const { conversation_id, user_id, username, is_typing } = data;
    console.log(`${username} is ${is_typing ? 'typing' : 'stopped typing'} in ${conversation_id}`);
    
    // Update UI typing indicator
    this.onTypingIndicator?.(conversation_id, user_id, username, is_typing);
  }

  // Handle Read Receipt
  handleReadReceipt(data) {
    const { message_id, reader_user_id } = data;
    console.log('Message read:', message_id, 'by:', reader_user_id);
    
    // Update UI read status
    this.onReadReceipt?.(message_id, reader_user_id);
  }

  // WebSocket Actions
  joinConversation(conversationId) {
    this.sendWebSocketMessage('join_conversation', {
      conversation_id: conversationId
    });
    this.activeConversationId = conversationId;
  }

  leaveConversation(conversationId) {
    this.sendWebSocketMessage('leave_conversation', {
      conversation_id: conversationId
    });
    this.activeConversationId = null;
  }

  sendTypingStart(conversationId) {
    this.sendWebSocketMessage('typing_start', {
      conversation_id: conversationId
    });
  }

  sendTypingStop(conversationId) {
    this.sendWebSocketMessage('typing_stop', {
      conversation_id: conversationId
    });
  }

  sendWebSocketMessage(type, data) {
    if (this.ws && this.ws.readyState === WebSocket.OPEN) {
      this.ws.send(JSON.stringify({ type, data }));
    }
  }

  // Heartbeat
  startHeartbeat() {
    this.heartbeatInterval = setInterval(() => {
      this.sendWebSocketMessage('heartbeat', {});
    }, 30000); // 30 seconds
  }

  stopHeartbeat() {
    if (this.heartbeatInterval) {
      clearInterval(this.heartbeatInterval);
    }
  }

  // Utility
  generateUUID() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c) {
      const r = Math.random() * 16 | 0;
      const v = c == 'x' ? r : (r & 0x3 | 0x8);
      return v.toString(16);
    });
  }

  // Event handlers (override these)
  onNewMessage(conversationId, message) {}
  onTypingIndicator(conversationId, userId, username, isTyping) {}
  onReadReceipt(messageId, readerUserId) {}

  // Cleanup
  disconnect() {
    if (this.ws) {
      this.ws.close();
    }
    this.stopHeartbeat();
  }
}
```

### Usage Example

```javascript
// Initialize chat client
const chatClient = new ChatClient('your_jwt_access_token');

// Set up event handlers
chatClient.onNewMessage = (conversationId, message) => {
  console.log('New message received:', message);
  // Update your UI here
  displayMessage(conversationId, message);
};

chatClient.onTypingIndicator = (conversationId, userId, username, isTyping) => {
  // Update typing indicator in UI
  showTypingIndicator(conversationId, username, isTyping);
};

// Connect to real-time chat
chatClient.connectWebSocket();

// Create a conversation
const conversation = await chatClient.createDirectChat('friend_user_id');
console.log('Created conversation:', conversation.id);

// Join conversation for real-time updates
chatClient.joinConversation(conversation.id);

// Send a message
const message = await chatClient.sendMessage(conversation.id, 'Hello friend!');
console.log('Sent message:', message.id);

// Load message history
const messages = await chatClient.loadMessages(conversation.id);
console.log('Message history:', messages);

// Send typing indicator
chatClient.sendTypingStart(conversation.id);
setTimeout(() => {
  chatClient.sendTypingStop(conversation.id);
}, 2000);
```

### React Hook Example

```javascript
import { useState, useEffect, useRef } from 'react';

export function useChatClient(accessToken) {
  const [client, setClient] = useState(null);
  const [conversations, setConversations] = useState([]);
  const [messages, setMessages] = useState({});
  const [isConnected, setIsConnected] = useState(false);
  const [typingUsers, setTypingUsers] = useState({});

  useEffect(() => {
    if (!accessToken) return;

    const chatClient = new ChatClient(accessToken);
    
    // Set up event handlers
    chatClient.onNewMessage = (conversationId, message) => {
      setMessages(prev => ({
        ...prev,
        [conversationId]: [...(prev[conversationId] || []), message]
      }));
    };

    chatClient.onTypingIndicator = (conversationId, userId, username, isTyping) => {
      setTypingUsers(prev => ({
        ...prev,
        [conversationId]: {
          ...prev[conversationId],
          [userId]: isTyping ? username : undefined
        }
      }));
    };

    // Connect WebSocket
    chatClient.connectWebSocket();
    
    chatClient.ws.onopen = () => setIsConnected(true);
    chatClient.ws.onclose = () => setIsConnected(false);

    setClient(chatClient);

    return () => {
      chatClient.disconnect();
    };
  }, [accessToken]);

  const loadConversations = async () => {
    if (!client) return;
    
    try {
      const conversations = await client.getConversations();
      setConversations(conversations);
    } catch (error) {
      console.error('Failed to load conversations:', error);
    }
  };

  const loadMessages = async (conversationId) => {
    if (!client) return;
    
    try {
      const messages = await client.loadMessages(conversationId);
      setMessages(prev => ({
        ...prev,
        [conversationId]: messages.reverse() // Show oldest first
      }));
    } catch (error) {
      console.error('Failed to load messages:', error);
    }
  };

  const sendMessage = async (conversationId, content) => {
    if (!client) return;
    
    try {
      await client.sendMessage(conversationId, content);
    } catch (error) {
      console.error('Failed to send message:', error);
    }
  };

  return {
    client,
    conversations,
    messages,
    isConnected,
    typingUsers,
    loadConversations,
    loadMessages,
    sendMessage
  };
}
```

## Complete Workflows

### 1. Direct Chat Setup (2 Users)

```javascript
// User A creates conversation with User B
async function setupDirectChat() {
  try {
    // 1. Create conversation
    const conversation = await chatClient.createDirectChat('user_b_id');
    
    // 2. Connect to real-time updates
    chatClient.joinConversation(conversation.id);
    
    // 3. Load message history (if any)
    const messages = await chatClient.loadMessages(conversation.id);
    
    // 4. Send first message
    await chatClient.sendMessage(conversation.id, 'Hey! How are you?');
    
    return conversation;
  } catch (error) {
    if (error.message.includes('not friends')) {
      throw new Error('You can only chat with friends. Send a friend request first.');
    }
    throw error;
  }
}
```

### 2. Group Chat Setup (3+ Users)

```javascript
// Create group conversation
async function setupGroupChat(participantIds, groupName) {
  try {
    // 1. Create group conversation
    const conversation = await chatClient.apiRequest('/conversations', {
      method: 'POST',
      body: JSON.stringify({
        participant_ids: participantIds,
        conversation_type: 'group'
      })
    });
    
    // 2. Join for real-time updates
    chatClient.joinConversation(conversation.id);
    
    // 3. Send welcome message
    await chatClient.sendMessage(
      conversation.id, 
      `Welcome to the group chat! 🎉`
    );
    
    return conversation;
  } catch (error) {
    console.error('Group chat setup failed:', error);
    throw error;
  }
}
```

### 3. Real-time Messaging Flow

```javascript
// Complete messaging flow with real-time features
class ChatInterface {
  constructor(chatClient) {
    this.chatClient = chatClient;
    this.typingTimeout = null;
  }

  async sendMessage(conversationId, content) {
    try {
      // 1. Stop typing indicator
      this.chatClient.sendTypingStop(conversationId);
      
      // 2. Send message
      const message = await this.chatClient.sendMessage(conversationId, content);
      
      // 3. Update UI immediately (optimistic update)
      this.addMessageToUI(conversationId, message);
      
      return message;
    } catch (error) {
      // Handle send failure
      this.showErrorMessage('Failed to send message');
      throw error;
    }
  }

  handleTyping(conversationId) {
    // Start typing indicator
    this.chatClient.sendTypingStart(conversationId);
    
    // Auto-stop typing after 3 seconds of inactivity
    clearTimeout(this.typingTimeout);
    this.typingTimeout = setTimeout(() => {
      this.chatClient.sendTypingStop(conversationId);
    }, 3000);
  }

  handleIncomingMessage(conversationId, message) {
    // 1. Add to UI
    this.addMessageToUI(conversationId, message);
    
    // 2. Mark as read if conversation is active
    if (this.activeConversationId === conversationId && this.isWindowFocused) {
      this.chatClient.markMessageAsRead(message.id);
    } else {
      // Show notification if conversation is not active
      this.showNotification(message);
    }
    
    // 3. Update conversation list (move to top)
    this.updateConversationList(conversationId, message);
  }

  handleReadReceipt(messageId, readerUserId) {
    // Update read status in UI
    this.updateMessageReadStatus(messageId, readerUserId);
  }

  addMessageToUI(conversationId, message) {
    // Implementation specific to your UI framework
    console.log('Adding message to UI:', conversationId, message);
  }

  updateMessageReadStatus(messageId, readerUserId) {
    // Implementation specific to your UI framework
    console.log('Message read by:', messageId, readerUserId);
  }

  showNotification(message) {
    // Show browser notification for new messages
    if (Notification.permission === 'granted') {
      new Notification('New Message', {
        body: message.content,
        icon: '/chat-icon.png'
      });
    }
  }
}
```

### 4. Read Receipts Flow

```javascript
// Handle read receipts comprehensively
class ReadReceiptManager {
  constructor(chatClient) {
    this.chatClient = chatClient;
    this.visibilityObserver = null;
    this.setupVisibilityTracking();
  }

  setupVisibilityTracking() {
    // Use Intersection Observer to track visible messages
    this.visibilityObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const messageId = entry.target.dataset.messageId;
          const isRead = entry.target.dataset.isRead === 'true';
          
          if (!isRead) {
            this.markAsRead(messageId);
            entry.target.dataset.isRead = 'true';
          }
        }
      });
    }, { threshold: 0.5 });
  }

  observeMessage(messageElement) {
    this.visibilityObserver.observe(messageElement);
  }

  async markAsRead(messageId) {
    try {
      await this.chatClient.markMessageAsRead(messageId);
    } catch (error) {
      console.error('Failed to mark message as read:', error);
    }
  }

  async markConversationAsRead(conversationId) {
    try {
      await this.chatClient.apiRequest(`/conversations/${conversationId}/read`, {
        method: 'POST'
      });
    } catch (error) {
      console.error('Failed to mark conversation as read:', error);
    }
  }

  handleReadReceipt(messageId, readerUserId) {
    // Update UI to show message was read
    const messageElement = document.querySelector(`[data-message-id="${messageId}"]`);
    if (messageElement) {
      messageElement.classList.add('message-read');
      
      // Update read receipt indicator
      const readIndicator = messageElement.querySelector('.read-indicator');
      if (readIndicator) {
        readIndicator.textContent = '✓✓';
        readIndicator.classList.add('read');
      }
    }
  }
}
```

### 5. Error Handling Scenarios

```javascript
// Comprehensive error handling
class ChatErrorHandler {
  constructor(chatClient) {
    this.chatClient = chatClient;
    this.reconnectAttempts = 0;
    this.maxReconnectAttempts = 5;
  }

  handleAPIError(error, context) {
    console.error(`API Error in ${context}:`, error);

    if (error.message.includes('401')) {
      // Token expired
      this.handleAuthenticationError();
    } else if (error.message.includes('403')) {
      // Permission denied
      this.handlePermissionError(context);
    } else if (error.message.includes('404')) {
      // Resource not found
      this.handleNotFoundError(context);
    } else if (error.message.includes('422')) {
      // Validation error
      this.handleValidationError(error, context);
    } else {
      // Generic error
      this.handleGenericError(error, context);
    }
  }

  handleWebSocketError(error) {
    console.error('WebSocket error:', error);
    this.attemptReconnect();
  }

  handleAuthenticationError() {
    // Token expired - redirect to login
    this.showError('Your session has expired. Please log in again.');
    setTimeout(() => {
      window.location.href = '/login';
    }, 2000);
  }

  handlePermissionError(context) {
    switch (context) {
      case 'createConversation':
        this.showError('You can only chat with friends. Send a friend request first.');
        break;
      case 'sendMessage':
        this.showError('You don\'t have permission to send messages in this conversation.');
        break;
      default:
        this.showError('You don\'t have permission to perform this action.');
    }
  }

  handleNotFoundError(context) {
    switch (context) {
      case 'conversation':
        this.showError('Conversation not found or has been deleted.');
        break;
      case 'message':
        this.showError('Message not found or has been deleted.');
        break;
      default:
        this.showError('The requested resource was not found.');
    }
  }

  handleValidationError(error, context) {
    // Parse validation error details
    const details = error.details || 'Invalid data provided';
    this.showError(`Validation Error: ${details}`);
  }

  handleGenericError(error, context) {
    this.showError(`An error occurred: ${error.message}`);
  }

  attemptReconnect() {
    if (this.reconnectAttempts >= this.maxReconnectAttempts) {
      this.showError('Unable to connect to chat. Please refresh the page.');
      return;
    }

    this.reconnectAttempts++;
    const delay = Math.pow(2, this.reconnectAttempts) * 1000; // Exponential backoff

    setTimeout(() => {
      console.log(`Attempting to reconnect (${this.reconnectAttempts}/${this.maxReconnectAttempts})`);
      this.chatClient.connectWebSocket();
    }, delay);
  }

  showError(message) {
    // Implementation specific to your UI framework
    console.error('User Error:', message);
    
    // Example: Show toast notification
    this.showToast(message, 'error');
  }

  showToast(message, type = 'info') {
    // Example toast implementation
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.textContent = message;
    document.body.appendChild(toast);
    
    setTimeout(() => {
      document.body.removeChild(toast);
    }, 5000);
  }
}
```

## Best Practices

### 1. Connection Management
- Always handle WebSocket reconnection with exponential backoff
- Implement heartbeat to detect connection issues early
- Clean up WebSocket connections when components unmount
- Use connection state to disable UI when offline

### 2. Message Handling
- Implement optimistic UI updates for sent messages
- Store messages locally for offline viewing
- Handle message ordering with timestamps
- Implement proper pagination for message history

### 3. Real-time Features
- Debounce typing indicators to avoid spam
- Auto-expire typing indicators after inactivity
- Mark messages as read when visible in viewport
- Show appropriate indicators for message status

### 4. Performance Optimization
- Implement virtual scrolling for large message lists
- Lazy load conversation details and media
- Cache frequently accessed data
- Use efficient state management

### 5. Security Considerations
- Always validate JWT tokens before WebSocket connection
- Never store sensitive data in localStorage
- Implement proper CORS headers
- Use HTTPS in production environments

### 6. User Experience
- Provide clear error messages and recovery options
- Show connection status and loading states
- Implement smooth animations and transitions
- Support keyboard shortcuts for common actions

### 7. Testing
- Test WebSocket connection stability
- Verify message ordering across multiple clients
- Test offline/online scenarios
- Validate read receipt accuracy

This documentation provides everything needed to implement the complete Future Talk chat system. The API supports both simple direct messaging and complex group chat scenarios with full real-time capabilities, military-grade encryption, and comprehensive error handling.