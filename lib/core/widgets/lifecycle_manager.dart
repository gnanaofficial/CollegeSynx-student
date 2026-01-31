import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/state/auth_provider.dart';
import '../../features/auth/state/auth_state.dart';

class LifecycleManager extends ConsumerStatefulWidget {
  final Widget child;
  const LifecycleManager({super.key, required this.child});

  @override
  ConsumerState<LifecycleManager> createState() => _LifecycleManagerState();
}

class _LifecycleManagerState extends ConsumerState<LifecycleManager>
    with WidgetsBindingObserver {
  DateTime? _lastPausedTime;
  // Threshold to avoid asking instantly if user just swapped apps for a second
  // Setting to 0 for now as per "automatically after some time" request - maybe 2 seconds?
  static const int _lockTimeoutSeconds = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      _lastPausedTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed) {
      _checkAuthOnResume();
    }
  }

  Future<void> _checkAuthOnResume() async {
    final authState = ref.read(authProvider);

    // Only check if user is logged in
    if (authState.status != AuthStatus.authenticated) return;

    if (_lastPausedTime != null) {
      final timeDiff = DateTime.now().difference(_lastPausedTime!);
      if (timeDiff.inSeconds > _lockTimeoutSeconds) {
        // Trigger generic "Re-verify" which defaults to Biometric then MPIN
        // We set isMpinVerified to false to force lock screen if we had one
        // But better to just trigger logic

        // We want to force re-verification
        ref.read(authProvider.notifier).requireMpinVerification();

        // Then try auto-biometrics immediately
        ref.read(authProvider.notifier).promptBiometric(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
