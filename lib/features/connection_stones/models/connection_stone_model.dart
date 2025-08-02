import 'package:freezed_annotation/freezed_annotation.dart';
import 'stone_type.dart';

part 'connection_stone_model.freezed.dart';
part 'connection_stone_model.g.dart';

/// Model representing a Connection Stone - a digital comfort object
/// that creates emotional bridges between friends
@freezed
class ConnectionStone with _$ConnectionStone {
  const factory ConnectionStone({
    /// Unique identifier for the stone
    required String id,
    
    /// The type of stone with its visual and emotional properties
    required StoneType stoneType,
    
    /// Name given to this specific stone
    required String name,
    
    /// Friend this stone is connected to
    required String friendName,
    
    /// Friend's user ID for real-time connections
    required String friendId,
    
    /// When this stone was created
    required DateTime createdAt,
    
    /// Last time this stone was touched by the owner
    DateTime? lastTouchedByOwner,
    
    /// Last time this stone received comfort from the friend
    DateTime? lastReceivedComfort,
    
    /// Total times this stone has been touched by owner
    @Default(0) int totalTouches,
    
    /// Total times comfort has been received through this stone
    @Default(0) int totalComfortReceived,
    
    /// Whether this stone is currently receiving comfort
    @Default(false) bool isReceivingComfort,
    
    /// Whether this stone is currently being touched (sending comfort)
    @Default(false) bool isSendingComfort,
    
    /// Custom message or intention set for this stone
    String? intention,
    
    /// Whether this stone is part of the quick touch bar
    @Default(false) bool isQuickAccess,
    
    /// Connection strength (0.0 to 1.0) based on usage
    @Default(0.5) double connectionStrength,
  }) = _ConnectionStone;

  factory ConnectionStone.fromJson(Map<String, dynamic> json) =>
      _$ConnectionStoneFromJson(json);
}

/// Extensions for ConnectionStone to provide computed properties
extension ConnectionStoneExtensions on ConnectionStone {
  /// Get formatted last touch time
  String get lastTouchDisplay {
    if (lastTouchedByOwner == null) {
      return 'Never touched';
    }
    
    final now = DateTime.now();
    final difference = now.difference(lastTouchedByOwner!);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }

  /// Get formatted last received comfort time
  String get lastReceivedDisplay {
    if (isReceivingComfort) {
      return 'Receiving comfort...';
    }
    
    if (lastReceivedComfort == null) {
      return 'No comfort received yet';
    }
    
    final now = DateTime.now();
    final difference = now.difference(lastReceivedComfort!);
    
    if (difference.inMinutes < 1) {
      return 'Just received comfort';
    } else if (difference.inMinutes < 60) {
      return 'Received ${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return 'Received ${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Received yesterday';
    } else {
      return 'Received ${difference.inDays} days ago';
    }
  }

  /// Calculate connection strength based on usage patterns
  double get calculatedConnectionStrength {
    const maxTouches = 50.0;
    const maxReceived = 30.0;
    
    final touchStrength = (totalTouches / maxTouches).clamp(0.0, 1.0);
    final receiveStrength = (totalComfortReceived / maxReceived).clamp(0.0, 1.0);
    
    // Recent activity bonus
    final now = DateTime.now();
    double recentBonus = 0.0;
    
    if (lastTouchedByOwner != null) {
      final daysSinceTouch = now.difference(lastTouchedByOwner!).inDays;
      if (daysSinceTouch < 7) {
        recentBonus += 0.1;
      }
    }
    
    if (lastReceivedComfort != null) {
      final daysSinceReceived = now.difference(lastReceivedComfort!).inDays;
      if (daysSinceReceived < 7) {
        recentBonus += 0.1;
      }
    }
    
    return ((touchStrength + receiveStrength) / 2 + recentBonus).clamp(0.0, 1.0);
  }

  /// Get connection strength as display text
  String get connectionStrengthDisplay {
    final strength = calculatedConnectionStrength;
    if (strength >= 0.8) {
      return 'Sacred Bond';
    } else if (strength >= 0.6) {
      return 'Strong Connection';
    } else if (strength >= 0.4) {
      return 'Growing Bond';
    } else if (strength >= 0.2) {
      return 'New Connection';
    } else {
      return 'Awakening';
    }
  }

  /// Whether this stone should show breathing animation
  bool get shouldBreathe => !isReceivingComfort && !isSendingComfort;

  /// Whether this stone should show receiving glow animation
  bool get shouldGlow => isReceivingComfort;

  /// Whether this stone should show sending pulse animation  
  bool get shouldPulse => isSendingComfort;

  /// Get the stone's current state for animations
  StoneAnimationState get animationState {
    if (isSendingComfort) return StoneAnimationState.sending;
    if (isReceivingComfort) return StoneAnimationState.receiving;
    return StoneAnimationState.breathing;
  }
}

/// Animation states for connection stones
enum StoneAnimationState {
  breathing,
  receiving,
  sending,
  idle,
}

/// Factory methods for creating common stone configurations
class ConnectionStoneFactory {
  /// Create a new stone with common defaults
  static ConnectionStone create({
    required StoneType stoneType,
    required String name,
    required String friendName,
    required String friendId,
    String? intention,
    bool isQuickAccess = false,
  }) {
    return ConnectionStone(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      stoneType: stoneType,
      name: name,
      friendName: friendName,
      friendId: friendId,
      createdAt: DateTime.now(),
      intention: intention,
      isQuickAccess: isQuickAccess,
    );
  }

  /// Create a quick access stone
  static ConnectionStone createQuickAccess({
    required StoneType stoneType,
    required String friendName,
    required String friendId,
  }) {
    return create(
      stoneType: stoneType,
      name: '${stoneType.displayName} for ${friendName}',
      friendName: friendName,
      friendId: friendId,
      isQuickAccess: true,
    );
  }
}