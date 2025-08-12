# Friend Request API Documentation

## Overview
The Friend Request API handles all social connection operations including sending friend requests, accepting/declining requests, managing friendships, and blocking users.

## Endpoints

### 1. Send Friend Request
**POST** `/api/v1/social/friends/request`

Sends a friend request to another user by their username.

#### Request Body
```json
{
  "target_username": "string",  // REQUIRED - Username of the person to send request to
  "message": "string"           // OPTIONAL - Personal message (max 300 chars), can be null
}
```

#### Field Details
- **target_username** (required): 
  - Type: `string`
  - Min length: 3 characters
  - Max length: 50 characters
  - Case-insensitive (automatically converted to lowercase)
  - Must be an existing user's username
  
- **message** (optional):
  - Type: `string` or `null`
  - Max length: 300 characters
  - Personal note to include with the friend request

#### Response - Success (200)
```json
{
  "success": true,
  "friendship_id": "uuid-string",
  "message": "Friend request sent successfully"
}
```

#### Response - Error Cases
```json
{
  "success": false,
  "error": "User not found"  // or other error messages
}
```

Error messages include:
- "User not found" - Target username doesn't exist
- "Cannot send friend request to yourself"
- "Already friends" - You're already connected
- "Friend request already pending" - Request already sent
- "Cannot send request to this user" - User has blocked you or privacy settings prevent it

#### Status Codes
- `200 OK` - Request processed (check success field)
- `401 Unauthorized` - Not authenticated
- `422 Unprocessable Entity` - Validation error (missing/invalid fields)

---

### 2. Accept/Decline Friend Request
**POST** `/api/v1/social/friends/respond`

Respond to a pending friend request.

#### Request Body
```json
{
  "request_id": "uuid-string",     // REQUIRED - ID of the friend request
  "accept": true,                  // REQUIRED - true to accept, false to decline
  "response_message": "string"     // OPTIONAL - Message to sender (max 200 chars)
}
```

#### Field Details
- **request_id** (required):
  - Type: `string` (UUID format)
  - Must be a valid pending request where you are the recipient
  
- **accept** (required):
  - Type: `boolean`
  - `true` to accept the request
  - `false` to decline the request
  
- **response_message** (optional):
  - Type: `string` or `null`
  - Max length: 200 characters
  - Optional message to the requester

#### Response - Success (200)
```json
{
  "success": true,
  "message": "Friend request accepted"  // or "Friend request declined"
}
```

---

### 3. Get Pending Friend Requests
**GET** `/api/v1/social/friends/pending`

Get all pending friend requests (both sent and received).

#### Query Parameters
- **type** (optional): `"received"` | `"sent"` | `"all"` (default: "all")
- **limit** (optional): Number of results (1-50, default: 20)
- **offset** (optional): Pagination offset (default: 0)

#### Response - Success (200)
```json
{
  "received": [
    {
      "id": "request-uuid",
      "requester_id": "user-uuid",
      "requester_username": "john_doe",
      "requester_display_name": "John Doe",
      "requester_profile_picture": "url-or-null",
      "message": "Hey, let's connect!",
      "mutual_friends_count": 5,
      "created_at": "2025-01-12T10:30:00Z"
    }
  ],
  "sent": [
    {
      "id": "request-uuid",
      "addressee_id": "user-uuid",
      "addressee_username": "jane_smith",
      "addressee_display_name": "Jane Smith",
      "addressee_profile_picture": "url-or-null",
      "message": "Would love to connect",
      "created_at": "2025-01-11T15:45:00Z"
    }
  ]
}
```

---

### 4. Get Friends List
**GET** `/api/v1/social/friends`

Get list of all accepted friends.

#### Query Parameters
- **search** (optional): Search friends by username or display name
- **sort** (optional): `"recent"` | `"alphabetical"` | `"online"` (default: "recent")
- **limit** (optional): Number of results (1-100, default: 50)
- **offset** (optional): Pagination offset (default: 0)

#### Response - Success (200)
```json
{
  "friends": [
    {
      "id": "friendship-uuid",
      "friend_user_id": "user-uuid",
      "friend_username": "testuser1",
      "friend_display_name": "Test User One",
      "friend_profile_picture": "url-or-null",
      "friendship_level": "friend",
      "social_battery_visible": true,
      "friend_social_battery": 75,
      "is_online": true,
      "last_interaction_at": "2025-01-12T09:00:00Z",
      "mutual_friends_count": 12,
      "created_at": "2025-01-01T10:00:00Z",
      "accepted_at": "2025-01-01T10:30:00Z"
    }
  ],
  "total_count": 25,
  "has_more": false
}
```

---

### 5. Remove Friend
**DELETE** `/api/v1/social/friends/{friendship_id}`

Remove a friend connection.

#### Path Parameters
- **friendship_id**: UUID of the friendship to remove

#### Response - Success (200)
```json
{
  "success": true,
  "message": "Friend removed successfully"
}
```

---

### 6. Block User
**POST** `/api/v1/social/block`

Block a user from all interactions.

#### Request Body
```json
{
  "user_id": "uuid-string",           // OPTIONAL - User ID to block
  "target_username": "string",        // OPTIONAL - Username to block (provide one)
  "reason": "spam",                    // REQUIRED - Block reason
  "detailed_reason": "string",        // OPTIONAL - Additional details (max 500 chars)
  "block_messages": true,              // OPTIONAL - Block chat messages (default: true)
  "block_time_capsules": true,        // OPTIONAL - Block time capsules (default: true)
  "block_connection_stones": true,    // OPTIONAL - Block stones (default: true)
  "block_reading_invites": true,      // OPTIONAL - Block reading invites (default: true)
  "block_game_invites": true          // OPTIONAL - Block game invites (default: true)
}
```

#### Field Details
- **user_id** OR **target_username** (one required):
  - Provide either the user's ID or username
  
- **reason** (required):
  - Type: `enum`
  - Values: `"spam"` | `"harassment"` | `"inappropriate_content"` | `"other"`
  
- **detailed_reason** (optional):
  - Additional context for the block
  - Max 500 characters

#### Response - Success (200)
```json
{
  "success": true,
  "message": "User blocked successfully"
}
```

---

### 7. Unblock User
**DELETE** `/api/v1/social/block/{user_id}`

Unblock a previously blocked user.

#### Path Parameters
- **user_id**: UUID of the user to unblock

#### Response - Success (200)
```json
{
  "success": true,
  "message": "User unblocked successfully"
}
```

---

### 8. Get Blocked Users
**GET** `/api/v1/social/blocked`

Get list of all blocked users.

#### Response - Success (200)
```json
{
  "blocked_users": [
    {
      "id": "block-uuid",
      "blocked_user_id": "user-uuid",
      "blocked_username": "spam_user",
      "blocked_display_name": "Spam User",
      "reason": "spam",
      "detailed_reason": "Sending promotional messages",
      "blocked_at": "2025-01-10T14:00:00Z",
      "block_scope": {
        "messages": true,
        "time_capsules": true,
        "connection_stones": true,
        "reading_invites": true,
        "game_invites": true
      }
    }
  ],
  "total_count": 3
}
```

---

## Error Handling

### Common Error Responses

#### Validation Error (422)
```json
{
  "detail": [
    {
      "type": "missing",
      "loc": ["body", "target_username"],
      "msg": "Field required",
      "input": {...}
    }
  ]
}
```

#### Authentication Error (401)
```json
{
  "detail": "Not authenticated"
}
```

#### Not Found Error (404)
```json
{
  "detail": "Resource not found"
}
```

---

## Implementation Notes

### Field Naming Convention
- Backend uses **snake_case** for all fields (e.g., `target_username`, `friend_user_id`)
- Frontend should convert from camelCase to snake_case when sending requests
- Responses will be in snake_case and should be converted to camelCase in frontend

### Required vs Optional Fields
- Fields marked as REQUIRED must be present in the request
- Optional fields can be omitted or set to `null`
- Empty strings are not accepted for required string fields

### Authentication
- All endpoints require a valid JWT token in the Authorization header:
  ```
  Authorization: Bearer <token>
  ```

### Rate Limiting
- Friend request sending: Max 20 requests per hour
- Friend list queries: Max 100 requests per minute
- Block operations: Max 10 per minute

### Privacy Considerations
- Users can only see friend requests they sent or received
- Blocked users cannot send friend requests
- Privacy settings may prevent some users from receiving requests
- Some user information may be filtered based on privacy settings

---

## Example Usage

### Sending a Friend Request (cURL)
```bash
curl -X POST "http://localhost:8000/api/v1/social/friends/request" \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "target_username": "testuser1",
    "message": "Hey, let's connect!"
  }'
```

### Accepting a Friend Request (cURL)
```bash
curl -X POST "http://localhost:8000/api/v1/social/friends/respond" \
  -H "Authorization: Bearer <token>" \
  -H "Content-Type: application/json" \
  -d '{
    "request_id": "550e8400-e29b-41d4-a716-446655440000",
    "accept": true,
    "response_message": "Happy to connect!"
  }'
```