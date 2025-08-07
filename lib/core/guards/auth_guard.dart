import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:future_talk_frontend/features/auth/providers/auth_provider.dart';

class AuthGuard extends ConsumerWidget {
  final Widget child;
  final Widget? loadingWidget;
  final Widget Function()? unauthorizedBuilder;

  const AuthGuard({
    super.key,
    required this.child,
    this.loadingWidget,
    this.unauthorizedBuilder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    print('🛡️ [AuthGuard] Checking auth: isInitialized=${authState.isInitialized}, isLoggedIn=${authState.isLoggedIn}, isLoading=${authState.isLoading}');

    if (!authState.isInitialized) {
      print('🛡️ [AuthGuard] Not initialized, showing loading');
      return loadingWidget ?? _buildLoading();
    }

    if (!authState.isLoggedIn) {
      print('🛡️ [AuthGuard] Not logged in, showing unauthorized');
      return unauthorizedBuilder?.call() ?? _buildUnauthorized(context);
    }

    print('🛡️ [AuthGuard] Authorized, showing protected content');
    return child;
  }

  Widget _buildLoading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildUnauthorized(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Authentication Required',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Please log in to access this feature',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pushReplacementNamed('/sign_in'),
              child: const Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }
}