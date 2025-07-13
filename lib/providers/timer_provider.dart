import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'dart:async'; // Import for StreamSubscription

// Simple state providers - no circular dependencies
final isCountdownProvider = StateProvider<bool>((ref) => false);
final savedTimeProvider = StateProvider<int>((ref) => 0);

// Timer provider that only depends on mode, not on savedTime
final stopWatchTimerProvider = StateProvider<StopWatchTimer>((ref) {
  final isCountdown = ref.watch(isCountdownProvider);

  final timer = StopWatchTimer(
    mode: isCountdown ? StopWatchMode.countDown : StopWatchMode.countUp,
    presetMillisecond: 0, // Don't preset here - handle in UI
  );

  ref.onDispose(() => timer.dispose());
  return timer;
});

// Notifier for handling timer mode switches with proper cleanup
final timerControllerProvider = StateNotifierProvider<TimerController, TimerState>((ref) {
  return TimerController(ref);
});

class TimerState {
  final StopWatchTimer timer;
  final bool isCountdown;
  final int savedTime;

  TimerState({
    required this.timer,
    required this.isCountdown,
    required this.savedTime,
  });

  TimerState copyWith({
    StopWatchTimer? timer,
    bool? isCountdown,
    int? savedTime,
  }) {
    return TimerState(
      timer: timer ?? this.timer,
      isCountdown: isCountdown ?? this.isCountdown,
      savedTime: savedTime ?? this.savedTime,
    );
  }
}

class TimerController extends StateNotifier<TimerState> {
  final Ref ref;
  StreamSubscription? _onEndedSubscription; // To hold our stream subscription

  TimerController(this.ref) : super(TimerState(
    timer: StopWatchTimer(mode: StopWatchMode.countUp),
    isCountdown: false,
    savedTime: 0,
  )) {
    _setupTimerListener();
  }

  void _setupTimerListener() {
    // Cancel any existing subscription to prevent duplicates
    _onEndedSubscription?.cancel();

    // Listen to the fetchEnded stream of the current timer
    _onEndedSubscription = state.timer.fetchEnded.listen((isEnded) {
      if (isEnded && state.isCountdown) {
        // If it's a countdown and it has ended
        switchMode();
      }
    });
  }

  void switchMode() {
    // Stop current timer and save time
    state.timer.onStopTimer();
    final currentTime = state.timer.rawTime.value;

    // Dispose old timer
    state.timer.dispose();
    _onEndedSubscription?.cancel(); // Cancel subscription for the old timer

    // Create new timer with opposite mode
    final newIsCountdown = !state.isCountdown;
    final newTimer = StopWatchTimer(
      mode: newIsCountdown ? StopWatchMode.countDown : StopWatchMode.countUp,
      presetMillisecond: currentTime,
    );

    // Update state
    state = state.copyWith(
      timer: newTimer,
      isCountdown: newIsCountdown,
      savedTime: currentTime,
    );

    // Set up listener for the new timer
    _setupTimerListener();

    // Auto-start new timer
    newTimer.onStartTimer();
  }

  // Method to manually start the timer (e.g., from UI button)
  void startTimer() {
    state.timer.onStartTimer();
  }

  // Method to manually stop the timer (e.g., from UI button)
  void stopTimer() {
    state.timer.onStopTimer();
  }

  // Method to reset the timer (e.g., from UI button)
  void resetTimer() {
    // Stop and dispose the current timer
    state.timer.onStopTimer();
    state.timer.dispose();
    _onEndedSubscription?.cancel();

    // Create a new timer with 0 preset (truly reset to 0)
    final newTimer = StopWatchTimer(
      mode: state.isCountdown ? StopWatchMode.countDown : StopWatchMode.countUp,
      presetMillisecond: 0, // Always reset to 0
    );

    // Update state with the new timer
    state = state.copyWith(
      timer: newTimer,
      savedTime: 0,
    );

    // Set up listener for the new timer
    _setupTimerListener();
  }

  @override
  void dispose() {
    _onEndedSubscription?.cancel(); // Ensure subscription is cancelled
    state.timer.dispose();
    super.dispose();
  }
}