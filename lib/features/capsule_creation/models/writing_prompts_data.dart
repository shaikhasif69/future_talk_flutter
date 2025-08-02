import 'message_creation_data.dart';
import '../models/time_capsule_creation_data.dart';

/// Static data for writing prompts and inspiration quotes
class WritingPromptsData {
  /// All available writing prompts
  static const List<WritingPrompt> prompts = [
    WritingPrompt(
      id: 'gratitude_1',
      text: 'What I\'m grateful for',
      category: PromptCategory.gratitude,
      subtitle: 'Share your appreciation',
      inspiration: 'Right now, I\'m grateful for...',
    ),
    WritingPrompt(
      id: 'growth_1',
      text: 'How I\'m growing',
      category: PromptCategory.growth,
      subtitle: 'Reflect on your journey',
      inspiration: 'I\'m learning that...',
    ),
    WritingPrompt(
      id: 'hopes_1',
      text: 'My hopes and dreams',
      category: PromptCategory.hopes,
      subtitle: 'Look toward the future',
      inspiration: 'I hope by then you...',
    ),
    WritingPrompt(
      id: 'memories_1',
      text: 'Favorite memories',
      category: PromptCategory.memories,
      subtitle: 'Cherish special moments',
      inspiration: 'I want you to remember...',
    ),
    WritingPrompt(
      id: 'advice_1',
      text: 'Advice for myself',
      category: PromptCategory.advice,
      subtitle: 'Share your wisdom',
      inspiration: 'What I\'ve learned is...',
    ),
    WritingPrompt(
      id: 'encouragement_1',
      text: 'Words of encouragement',
      category: PromptCategory.encouragement,
      subtitle: 'Motivate and inspire',
      inspiration: 'You are stronger than...',
    ),
  ];

  /// Get prompts filtered by purpose
  static List<WritingPrompt> getPromptsForPurpose(TimeCapsulePurpose purpose) {
    switch (purpose) {
      case TimeCapsulePurpose.futureMe:
        return prompts.where((p) => [
          PromptCategory.gratitude,
          PromptCategory.growth,
          PromptCategory.advice,
        ].contains(p.category)).toList();
      
      case TimeCapsulePurpose.someoneSpecial:
        return prompts.where((p) => [
          PromptCategory.gratitude,
          PromptCategory.memories,
          PromptCategory.encouragement,
        ].contains(p.category)).toList();
      
      case TimeCapsulePurpose.anonymous:
        return prompts.where((p) => [
          PromptCategory.encouragement,
          PromptCategory.hopes,
          PromptCategory.advice,
        ].contains(p.category)).toList();
    }
  }

  /// Get prompts by category
  static List<WritingPrompt> getPromptsByCategory(PromptCategory category) {
    return prompts.where((p) => p.category == category).toList();
  }
}

/// Static data for writing inspiration quotes
class WritingQuotes {
  /// All available inspiration quotes
  static const List<String> quotes = [
    "Right now, I'm learning that...",
    "I hope you remember how...",
    "Today I realized...",
    "I want you to know that...",
    "Six months ago, I was...",
    "I'm proud of myself for...",
    "My biggest challenge right now is...",
    "I hope by then you've...",
    "What's bringing me joy today is...",
    "I'm working on becoming...",
    "The most important thing I've learned is...",
    "I'm grateful for this moment because...",
    "Looking back, I wish I had known...",
    "The person I'm becoming is...",
    "Right now, my heart is full of...",
  ];

  /// Get a specific quote by index
  static String getQuote(int index) {
    if (index < 0 || index >= quotes.length) {
      return quotes.first;
    }
    return quotes[index];
  }

  /// Get a random quote
  static String getRandomQuote() {
    final now = DateTime.now();
    final index = now.millisecondsSinceEpoch % quotes.length;
    return quotes[index];
  }

  /// Get daily quote (same quote for the whole day)
  static String getDailyQuote() {
    final now = DateTime.now();
    final daysSinceEpoch = now.millisecondsSinceEpoch ~/ (1000 * 60 * 60 * 24);
    final index = daysSinceEpoch % quotes.length;
    return quotes[index];
  }
}