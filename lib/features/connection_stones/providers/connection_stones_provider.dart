import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/connection_stone_model.dart';
import '../models/stone_type.dart';
import '../models/touch_interaction_model.dart';

part 'connection_stones_provider.g.dart';

/// Provider for managing the collection of connection stones
@riverpod
class ConnectionStones extends _$ConnectionStones {
  Timer? _simulationTimer;

  @override
  List<ConnectionStone> build() {
    // Create demo stones for a magical experience
    final demoStones = _createDemoStones();
    
    // Start simulation of incoming touches
    _startIncomingTouchSimulation();
    
    return demoStones;
  }

  /// Create demo stones for the showcase
  List<ConnectionStone> _createDemoStones() {
    final now = DateTime.now();
    
    return [
      // Rose Quartz for Emma (active connection)
      ConnectionStone(
        id: '1',
        stoneType: StoneType.roseQuartz,
        name: 'Rose Quartz',
        friendName: 'Emma',
        friendId: 'emma_123',
        createdAt: now.subtract(const Duration(days: 30)),
        lastTouchedByOwner: now.subtract(const Duration(hours: 2)),
        lastReceivedComfort: now.subtract(const Duration(hours: 1)),
        totalTouches: 47,
        totalComfortReceived: 32,
        isQuickAccess: true,
        connectionStrength: 0.85,
        intention: 'For moments when Emma needs gentle love',
      ),
      
      // Clear Quartz for Alex (currently receiving)
      ConnectionStone(
        id: '2',
        stoneType: StoneType.clearQuartz,
        name: 'Clear Quartz',
        friendName: 'Alex',
        friendId: 'alex_456',
        createdAt: now.subtract(const Duration(days: 25)),
        lastTouchedByOwner: now.subtract(const Duration(hours: 8)),
        lastReceivedComfort: now.subtract(const Duration(minutes: 30)),
        totalTouches: 35,
        totalComfortReceived: 28,
        isReceivingComfort: true, // Currently receiving
        isQuickAccess: true,
        connectionStrength: 0.72,
        intention: 'Clarity and peace in difficult times',
      ),
      
      // Amethyst for Mom (wisdom stone)
      ConnectionStone(
        id: '3',
        stoneType: StoneType.amethyst,
        name: 'Amethyst',
        friendName: 'Mom',
        friendId: 'mom_789',
        createdAt: now.subtract(const Duration(days: 60)),
        lastTouchedByOwner: now.subtract(const Duration(days: 1)),
        lastReceivedComfort: now.subtract(const Duration(hours: 12)),
        totalTouches: 89,
        totalComfortReceived: 67,
        isQuickAccess: true,
        connectionStrength: 0.94,
        intention: 'Wisdom and guidance from the heart',
      ),
      
      // Ocean Wave for Sarah (flowing connection)
      ConnectionStone(
        id: '4',
        stoneType: StoneType.oceanWave,
        name: 'Ocean Wave',
        friendName: 'Sarah',
        friendId: 'sarah_012',
        createdAt: now.subtract(const Duration(days: 15)),
        lastTouchedByOwner: now.subtract(const Duration(days: 3)),
        lastReceivedComfort: now.subtract(const Duration(days: 2)),
        totalTouches: 23,
        totalComfortReceived: 18,
        isQuickAccess: true,
        connectionStrength: 0.58,
        intention: 'Flow with emotions like the ocean tide',
      ),
      
      // Cherry Blossom for Sister (new beginnings)
      ConnectionStone(
        id: '5',
        stoneType: StoneType.cherryBlossom,
        name: 'Cherry Blossom',
        friendName: 'Sister',
        friendId: 'sister_345',
        createdAt: now.subtract(const Duration(days: 10)),
        lastTouchedByOwner: now.subtract(const Duration(days: 5)),
        lastReceivedComfort: now.subtract(const Duration(days: 4)),
        totalTouches: 12,
        totalComfortReceived: 9,
        connectionStrength: 0.42,
        intention: 'Celebrating beautiful moments together',
      ),
    ];
  }

  /// Start simulation of incoming touches for demo purposes
  void _startIncomingTouchSimulation() {
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(const Duration(seconds: 25), (timer) {
      _simulateIncomingTouch();
    });
  }

  /// Simulate an incoming touch from a friend
  void _simulateIncomingTouch() {
    final stones = state.where((stone) => !stone.isReceivingComfort).toList();
    if (stones.isEmpty) return;

    final random = Random();
    final randomStone = stones[random.nextInt(stones.length)];
    
    // Start receiving comfort
    receiveComfort(randomStone.id);
    
    // Stop receiving after 3-5 seconds
    final duration = Duration(
      seconds: 3 + random.nextInt(3),
    );
    
    Timer(duration, () {
      stopReceivingComfort(randomStone.id);
    });
  }

  /// Add a new connection stone
  void addStone(ConnectionStone stone) {
    state = [...state, stone];
  }

  /// Remove a connection stone
  void removeStone(String stoneId) {
    state = state.where((stone) => stone.id != stoneId).toList();
  }

  /// Update an existing stone
  void updateStone(ConnectionStone updatedStone) {
    state = state.map((stone) {
      return stone.id == updatedStone.id ? updatedStone : stone;
    }).toList();
  }

  /// Touch a stone to send comfort
  Future<void> touchStone(String stoneId, TouchType touchType) async {
    final stoneIndex = state.indexWhere((stone) => stone.id == stoneId);
    if (stoneIndex == -1) return;

    final stone = state[stoneIndex];
    final now = DateTime.now();
    
    // Update stone state to sending
    final updatedStone = stone.copyWith(
      isSendingComfort: true,
      lastTouchedByOwner: now,
      totalTouches: stone.totalTouches + 1,
    );
    
    state = [
      ...state.sublist(0, stoneIndex),
      updatedStone,
      ...state.sublist(stoneIndex + 1),
    ];

    // Record the interaction
    ref.read(touchInteractionsProvider.notifier).addInteraction(
      TouchInteraction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        stoneId: stoneId,
        touchType: touchType,
        timestamp: now,
        direction: TouchDirection.sent,
        friendId: stone.friendId,
        intensity: touchType == TouchType.longPress ? 1.0 : 0.7,
      ),
    );

    // Stop sending after touch duration
    final duration = touchType == TouchType.longPress 
        ? const Duration(milliseconds: 1500)
        : const Duration(milliseconds: 800);
        
    Timer(duration, () {
      stopSendingComfort(stoneId);
    });
  }

  /// Stop sending comfort animation
  void stopSendingComfort(String stoneId) {
    final stoneIndex = state.indexWhere((stone) => stone.id == stoneId);
    if (stoneIndex == -1) return;

    final stone = state[stoneIndex];
    final updatedStone = stone.copyWith(isSendingComfort: false);
    
    state = [
      ...state.sublist(0, stoneIndex),
      updatedStone,
      ...state.sublist(stoneIndex + 1),
    ];
  }

  /// Start receiving comfort from a friend
  void receiveComfort(String stoneId) {
    final stoneIndex = state.indexWhere((stone) => stone.id == stoneId);
    if (stoneIndex == -1) return;

    final stone = state[stoneIndex];
    final now = DateTime.now();
    
    final updatedStone = stone.copyWith(
      isReceivingComfort: true,
      lastReceivedComfort: now,
      totalComfortReceived: stone.totalComfortReceived + 1,
    );
    
    state = [
      ...state.sublist(0, stoneIndex),
      updatedStone,
      ...state.sublist(stoneIndex + 1),
    ];

    // Record the interaction
    ref.read(touchInteractionsProvider.notifier).addInteraction(
      TouchInteraction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        stoneId: stoneId,
        touchType: TouchType.longPress,
        timestamp: now,
        direction: TouchDirection.received,
        friendId: stone.friendId,
        intensity: 0.8,
      ),
    );
  }

  /// Stop receiving comfort animation
  void stopReceivingComfort(String stoneId) {
    final stoneIndex = state.indexWhere((stone) => stone.id == stoneId);
    if (stoneIndex == -1) return;

    final stone = state[stoneIndex];
    final updatedStone = stone.copyWith(isReceivingComfort: false);
    
    state = [
      ...state.sublist(0, stoneIndex),
      updatedStone,
      ...state.sublist(stoneIndex + 1),
    ];
  }

  /// Toggle quick access for a stone
  void toggleQuickAccess(String stoneId) {
    final stoneIndex = state.indexWhere((stone) => stone.id == stoneId);
    if (stoneIndex == -1) return;

    final stone = state[stoneIndex];
    final updatedStone = stone.copyWith(isQuickAccess: !stone.isQuickAccess);
    
    state = [
      ...state.sublist(0, stoneIndex),
      updatedStone,
      ...state.sublist(stoneIndex + 1),
    ];
  }

  /// Get stones for quick access bar
  List<ConnectionStone> getQuickAccessStones() {
    return state.where((stone) => stone.isQuickAccess).take(4).toList();
  }

  /// Get stones sorted by connection strength
  List<ConnectionStone> getStonesByConnection() {
    final stones = List<ConnectionStone>.from(state);
    stones.sort((a, b) => b.calculatedConnectionStrength.compareTo(a.calculatedConnectionStrength));
    return stones;
  }

  void dispose() {
    _simulationTimer?.cancel();
  }
}

/// Provider for touch interactions history
@riverpod
class TouchInteractions extends _$TouchInteractions {
  @override
  List<TouchInteraction> build() {
    return [];
  }

  /// Add a new touch interaction
  void addInteraction(TouchInteraction interaction) {
    state = [interaction, ...state];
    
    // Keep only last 100 interactions
    if (state.length > 100) {
      state = state.take(100).toList();
    }
  }

  /// Get interactions for a specific stone
  List<TouchInteraction> getStoneInteractions(String stoneId) {
    return state.where((interaction) => interaction.stoneId == stoneId).toList();
  }

  /// Get recent interactions (last 24 hours)
  List<TouchInteraction> getRecentInteractions() {
    final yesterday = DateTime.now().subtract(const Duration(hours: 24));
    return state.where((interaction) => interaction.timestamp.isAfter(yesterday)).toList();
  }
}

/// Provider for comfort statistics
@riverpod
ComfortStats comfortStats(Ref ref) {
  final stones = ref.watch(connectionStonesProvider);
  final interactions = ref.watch(touchInteractionsProvider);
  
  final touchesGiven = interactions
      .where((interaction) => interaction.direction == TouchDirection.sent)
      .length;
      
  final comfortReceived = interactions
      .where((interaction) => interaction.direction == TouchDirection.received)
      .length;
      
  final sacredStones = stones
      .where((stone) => stone.calculatedConnectionStrength >= 0.8)
      .length;

  // Calculate weekly touches
  final weekAgo = DateTime.now().subtract(const Duration(days: 7));
  final weeklyTouches = interactions
      .where((interaction) => 
          interaction.direction == TouchDirection.sent &&
          interaction.timestamp.isAfter(weekAgo))
      .length;

  // Calculate monthly comfort received
  final monthAgo = DateTime.now().subtract(const Duration(days: 30));
  final monthlyComfortReceived = interactions
      .where((interaction) => 
          interaction.direction == TouchDirection.received &&
          interaction.timestamp.isAfter(monthAgo))
      .length;

  // Find most connected friend
  final friendCounts = <String, int>{};
  for (final stone in stones) {
    friendCounts[stone.friendName] = (friendCounts[stone.friendName] ?? 0) + 1;
  }
  
  String? mostConnectedFriend;
  int maxCount = 0;
  friendCounts.forEach((friend, count) {
    if (count > maxCount) {
      maxCount = count;
      mostConnectedFriend = friend;
    }
  });

  return ComfortStats(
    touchesGiven: touchesGiven,
    comfortReceived: comfortReceived,
    sacredStones: sacredStones,
    totalStones: stones.length,
    mostConnectedFriend: mostConnectedFriend,
    weeklyTouches: weeklyTouches,
    monthlyComfortReceived: monthlyComfortReceived,
  );
}