import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'create_capsule_page2_screen.dart';

/// Test screen to demonstrate the time selection page
class TestPage2Screen extends ConsumerWidget {
  const TestPage2Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const CreateCapsulePage2Screen();
  }
}