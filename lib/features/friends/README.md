# Friend Search and Management API Services

This module provides comprehensive friend search and management functionality for Future Talk, including user search, friend requests, and relationship management.

## Overview

The friend search system consists of:

- **Models**: Data structures for user search results, friend requests, and friendship status
- **Services**: API client for friend-related operations
- **Providers**: State management for friend search functionality
- **Examples**: Usage demonstrations and integration guides

## Features

### ✅ Implemented Features

1. **User Search**
   - Partial match search by username, email, or name
   - Configurable search types and result limits
   - Friendship status included in results

2. **User Lookup**
   - Exact match lookup by username or email
   - Detailed user information with friendship status
   - Comprehensive error handling

3. **User Suggestions**
   - Personalized user recommendations
   - Based on mutual connections and interests
   - Configurable result limits

4. **Friend Request Management**
   - Send friend requests with optional messages
   - Accept, reject, and cancel friend requests
   - Comprehensive status tracking

5. **User Blocking**
   - Block and unblock users
   - Automatic friendship termination on block
   - Privacy protection features

## API Endpoints

### Search & Discovery
- `GET /api/v1/users/search` - Search users (partial match)
- `POST /api/v1/users/lookup` - Lookup user (exact match)
- `GET /api/v1/users/search/suggestions` - Get user suggestions

### Friend Management
- `POST /api/v1/social/friends/request` - Send friend request
- `POST /api/v1/social/friends/accept/{requestId}` - Accept friend request
- `POST /api/v1/social/friends/reject/{requestId}` - Reject friend request
- `POST /api/v1/social/friends/cancel/{requestId}` - Cancel friend request
- `POST /api/v1/social/friends/block/{userId}` - Block user
- `POST /api/v1/social/friends/unblock/{userId}` - Unblock user

## Models

### FriendshipStatus
Represents the relationship status between users:
- `none` - No relationship
- `pending` - Friend request pending
- `accepted` - Friends
- `blocked` - User is blocked

### UserSearchResult
Used for partial match search results:
```dart
final user = UserSearchResult(
  id: 'user_123',
  username: 'john_doe',
  firstName: 'John',
  lastName: 'Doe',
  friendshipStatus: FriendshipStatus.none,
  socialBattery: 75,
  mutualFriendsCount: 5,
);
```

### UserLookupResult
Used for exact match lookups with detailed information:
```dart
final user = UserLookupResult(
  id: 'user_123',
  email: 'john@example.com',
  username: 'john_doe',
  firstName: 'John',
  lastName: 'Doe',
  friendshipStatus: FriendshipStatus.none,
  socialBattery: 75,
  createdAt: DateTime.now(),
  updatedAt: DateTime.now(),
);
```

## Service Usage

### Basic Service Usage

```dart
import 'package:future_talk_frontend/features/friends/services/friend_search_service.dart';

final friendSearchService = FriendSearchService();

// Search for users
final searchResult = await friendSearchService.searchUsers(
  query: 'john',
  searchType: SearchType.all,
  limit: 10,
);

searchResult.when(
  success: (users) => print('Found ${users.length} users'),
  failure: (error) => print('Search failed: ${error.message}'),
);
```

### User Search

```dart
// Basic search
final result = await friendSearchService.searchUsers(
  query: 'john',
  searchType: SearchType.all,
  limit: 20,
);

// Username-only search
final result = await friendSearchService.searchUsers(
  query: 'john_doe',
  searchType: SearchType.username,
  limit: 10,
);

// Email search
final result = await friendSearchService.searchUsers(
  query: 'john@example.com',
  searchType: SearchType.email,
  limit: 5,
);
```

### User Lookup

```dart
// Lookup by username
final result = await friendSearchService.lookupUser('john_doe');

// Lookup by email
final result = await friendSearchService.lookupUser('john@example.com');

result.when(
  success: (user) => print('Found: ${user.displayName}'),
  failure: (error) => print('Not found: ${error.message}'),
);
```

### Friend Requests

```dart
// Send friend request
final result = await friendSearchService.sendFriendRequest(
  targetUsername: 'jane_smith',
  message: 'Hi! Would love to connect.',
);

// Accept friend request
final result = await friendSearchService.acceptFriendRequest('request_123');

// Reject friend request
final result = await friendSearchService.rejectFriendRequest('request_123');

// Cancel sent request
final result = await friendSearchService.cancelFriendRequest('request_123');
```

### User Blocking

```dart
// Block user
final result = await friendSearchService.blockUser('user_789');

// Unblock user
final result = await friendSearchService.unblockUser('user_789');
```

## State Management with Riverpod

### Provider Usage

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_talk_frontend/features/friends/providers/friend_search_provider.dart';

class FriendSearchScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(friendSearchNotifierProvider);
    final searchNotifier = ref.read(friendSearchNotifierProvider.notifier);

    return Column(
      children: [
        // Search input
        TextField(
          onChanged: (query) => searchNotifier.searchUsers(query: query),
        ),
        
        // Search results
        if (searchState.isSearching)
          CircularProgressIndicator()
        else if (searchState.searchError != null)
          Text('Error: ${searchState.searchError}')
        else
          ListView.builder(
            itemCount: searchState.searchResults.length,
            itemBuilder: (context, index) {
              final user = searchState.searchResults[index];
              return ListTile(
                title: Text(user.displayName),
                subtitle: Text('@${user.username}'),
                trailing: FriendActionButton(user: user),
              );
            },
          ),
      ],
    );
  }
}
```

### State Management Methods

```dart
// Search users
await ref.read(friendSearchNotifierProvider.notifier).searchUsers(
  query: 'john',
  searchType: SearchType.all,
);

// Load suggestions
await ref.read(friendSearchNotifierProvider.notifier).loadSuggestions();

// Send friend request
final success = await ref.read(friendSearchNotifierProvider.notifier)
    .sendFriendRequest(
      targetUsername: 'jane_smith',
      message: 'Hi Jane!',
    );

// Clear search
ref.read(friendSearchNotifierProvider.notifier).clearSearch();
```

## Error Handling

All API methods return `ApiResult<T>` for consistent error handling:

```dart
final result = await friendSearchService.searchUsers(query: 'john');

result.when(
  success: (users) {
    // Handle successful response
    print('Found ${users.length} users');
  },
  failure: (error) {
    // Handle error
    switch (error.statusCode) {
      case 400:
        print('Bad request: ${error.message}');
        break;
      case 404:
        print('Not found: ${error.message}');
        break;
      case 429:
        print('Rate limit exceeded');
        break;
      default:
        print('Error: ${error.message}');
    }
  },
);
```

## Common Error Codes

- **400** - Bad Request (invalid parameters)
- **401** - Unauthorized (authentication required)
- **403** - Forbidden (insufficient permissions)
- **404** - Not Found (user/request not found)
- **429** - Rate limit exceeded
- **500** - Server error

## Input Validation

### Search Query Validation
- Minimum 2 characters
- Maximum 50 characters
- Trimmed automatically

### Limit Validation
- Search: 1-50 results
- Suggestions: 1-20 results

### Message Validation
- Maximum 280 characters
- Optional for friend requests
- Trimmed automatically

## Integration Examples

### Search with Debouncing

```dart
class FriendSearchWidget extends ConsumerStatefulWidget {
  @override
  _FriendSearchWidgetState createState() => _FriendSearchWidgetState();
}

class _FriendSearchWidgetState extends ConsumerState<FriendSearchWidget> {
  Timer? _debounceTimer;

  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(Duration(milliseconds: 500), () {
      ref.read(friendSearchNotifierProvider.notifier).searchUsers(query: query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: _onSearchChanged,
      decoration: InputDecoration(
        hintText: 'Search for friends...',
        prefixIcon: Icon(Icons.search),
      ),
    );
  }
}
```

### Friend Request Button

```dart
class FriendRequestButton extends ConsumerWidget {
  final UserSearchResult user;

  const FriendRequestButton({required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(friendSearchNotifierProvider);
    
    return ElevatedButton(
      onPressed: user.friendshipStatus.canSendRequest 
        ? () => _sendFriendRequest(ref)
        : null,
      child: Text(user.friendshipStatus.actionLabel),
    );
  }

  Future<void> _sendFriendRequest(WidgetRef ref) async {
    final success = await ref.read(friendSearchNotifierProvider.notifier)
        .sendFriendRequest(targetUsername: user.username);
        
    if (success) {
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Friend request sent!')),
      );
    }
  }
}
```

## Performance Considerations

1. **Debounce Search**: Implement search debouncing to avoid excessive API calls
2. **Caching**: Results are not automatically cached - implement caching if needed
3. **Pagination**: Consider implementing pagination for large result sets
4. **Rate Limiting**: Respect API rate limits (429 responses)

## Security Features

1. **Authentication**: All endpoints require valid authentication
2. **Authorization**: Users can only manage their own friend requests
3. **Privacy**: Blocked users cannot see or interact with the user
4. **Validation**: All inputs are validated on both client and server

## Future Enhancements

- [ ] Friend lists management
- [ ] Advanced search filters (interests, location, etc.)
- [ ] Real-time friend request notifications
- [ ] Bulk friend operations
- [ ] Friend recommendation algorithms
- [ ] Social graph analytics

## Testing

See `friend_search_example.dart` for comprehensive usage examples and testing scenarios.

## Dependencies

This module depends on:
- `dio` - HTTP client
- `riverpod` - State management
- `freezed` - Code generation
- `json_annotation` - JSON serialization

## File Structure

```
lib/features/friends/
├── models/
│   ├── friend_search_models.dart           # Core data models
│   ├── friend_search_models.freezed.dart   # Generated Freezed code
│   └── friend_search_models.g.dart         # Generated JSON code
├── services/
│   └── friend_search_service.dart          # API service layer
├── providers/
│   ├── friend_search_provider.dart         # State management
│   ├── friend_search_provider.freezed.dart # Generated Freezed code
│   └── friend_search_provider.g.dart       # Generated Riverpod code
├── examples/
│   └── friend_search_example.dart          # Usage examples
└── README.md                               # This documentation
```

## Integration with Existing Features

This friend search system integrates seamlessly with:
- **Authentication**: Uses existing auth tokens
- **API Client**: Follows existing API patterns
- **Error Handling**: Uses existing ApiResult system
- **State Management**: Compatible with Riverpod ecosystem
- **Chat System**: Friend status affects chat availability
- **User Profiles**: Links to existing user profile system