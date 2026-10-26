import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/database/app_database.dart';

class ActiveFocusSessionScreen extends ConsumerStatefulWidget {
  const ActiveFocusSessionScreen({super.key});

  @override
  ConsumerState<ActiveFocusSessionScreen> createState() =>
      _ActiveFocusSessionScreenState();
}

class _ActiveFocusSessionScreenState
    extends ConsumerState<ActiveFocusSessionScreen> {
  Timer? _ticker;
  int _remainingSeconds = 0;
  int _totalSeconds = 1500;
  bool _isPaused = false;
  FocusSession? _currentSession;

  @override
  void initState() {
    super.initState();
    _startTicker();
  }

  void _startTicker() {
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_currentSession == null || _isPaused) return;

      final nowMs = DateTime.now().millisecondsSinceEpoch;
      final sessionEndMs =
          _currentSession!.startedAtUtcMs +
          (_currentSession!.targetDurationMinutes * 60 * 1000);
      final remaining = ((sessionEndMs - nowMs) / 1000).round();

      if (remaining <= 0) {
        _ticker?.cancel();
        _onCompleteSession();
      } else {
        setState(() {
          _remainingSeconds = remaining;
        });
      }
    });
  }

  Future<void> _onCompleteSession() async {
    if (_currentSession == null) return;
    final focusRepo = ref.read(focusRepositoryProvider);
    await focusRepo.completeSession(
      _currentSession!.id,
      _currentSession!.targetDurationMinutes,
    );

    await ref
        .read(notificationServiceProvider)
        .showNotification(
          id: 101,
          title: 'Focus Complete!',
          body:
              'Great job staying focused for ${_currentSession!.targetDurationMinutes} minutes.',
          channelId: AppConstants.notifChannelFocus,
        );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Focus session completed! Great job!')),
      );
      context.pop();
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final focusRepo = ref.watch(focusRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Session'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: StreamBuilder<FocusSession?>(
        stream: focusRepo.watchActiveSession(),
        builder: (context, snapshot) {
          final session = snapshot.data;
          if (session == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No active focus session found.'),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => context.pop(),
                    child: const Text('Return'),
                  ),
                ],
              ),
            );
          }

          _currentSession = session;
          _isPaused = session.status == 'paused';
          _totalSeconds = session.targetDurationMinutes * 60;

          if (_remainingSeconds == 0 && !_isPaused) {
            final nowMs = DateTime.now().millisecondsSinceEpoch;
            final endMs = session.startedAtUtcMs + (_totalSeconds * 1000);
            _remainingSeconds = ((endMs - nowMs) / 1000)
                .clamp(0, _totalSeconds)
                .round();
          }

          final progress = _totalSeconds > 0
              ? (_remainingSeconds / _totalSeconds).clamp(0.0, 1.0)
              : 0.0;
          final mins = _remainingSeconds ~/ 60;
          final secs = _remainingSeconds % 60;
          final timeStr =
              '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Circular Countdown
                  SizedBox(
                    width: 240,
                    height: 240,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 12,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHigh,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              timeStr,
                              style: theme.textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isPaused ? 'PAUSED' : 'FOCUSING',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: _isPaused
                                    ? Colors.amber
                                    : theme.colorScheme.primary,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),

                  // Session Control Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Pause / Resume Button
                      OutlinedButton.icon(
                        icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
                        label: Text(_isPaused ? 'Resume' : 'Pause'),
                        onPressed: () async {
                          if (_isPaused) {
                            await focusRepo.resumeSession(session.id);
                          } else {
                            await focusRepo.pauseSession(
                              session.id,
                              _remainingSeconds,
                            );
                          }
                        },
                      ),
                      const SizedBox(width: 16),

                      // End Session Early
                      FilledButton.tonalIcon(
                        icon: const Icon(Icons.check),
                        label: const Text('Complete'),
                        onPressed: _onCompleteSession,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  TextButton(
                    onPressed: () async {
                      await focusRepo.abandonSession(
                        session.id,
                        session.targetDurationMinutes -
                            (_remainingSeconds ~/ 60),
                      );
                      if (context.mounted) context.pop();
                    },
                    child: Text(
                      'Give up session',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
