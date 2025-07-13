import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hybrid_timer/animations/pulse_glow.dart';
import 'package:hybrid_timer/components/buttons/big_button.dart';
import 'package:hybrid_timer/providers/timer_provider.dart';
import 'package:sizer/sizer.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerScreen extends ConsumerStatefulWidget {
  const TimerScreen({super.key});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> 
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.999,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    ref.read(timerControllerProvider.notifier).switchMode();
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerControllerProvider);
    final timer = timerState.timer;
    final isCountdown = timerState.isCountdown;

    return Scaffold(
      backgroundColor: const Color(0xff0b0f34),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, -0.4), 

            radius: 1.2,
            colors: [
              Color(0xFF302B63),           
              Color(0xff0b0f34),           
              Color.fromARGB(255, 26, 22, 66), 
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _handleTap,
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: PulsatingGlow(
                        child: Container(
                          height: 80.w,
                          width: 80.w,
                          decoration: BoxDecoration(
                            color: Color(0xff0b0f34), // Same as your background to block inner shadow
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Color(0xFF302B63), // light center
                                Color(0xff0b0f34), // darker edge
                              ],
                              center: Alignment.center,
                              radius: 0.8,
                            ),
                            border: Border.all(
                              width: 4,
                              color: Colors.white,
                              strokeAlign: BorderSide.strokeAlignOutside
                            ),
                            boxShadow: [
                              // Outer glow - cyan
                              BoxShadow(
                                color: Color(0xFF00F5FF).withValues(alpha: 0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                              // Outer glow - purple
                              BoxShadow(
                                color: Color(0xFF8A2BE2).withValues(alpha: 0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                              // Far outer glow - pink
                              BoxShadow(
                                color: Color(0xFFFF1493).withValues(alpha: 0.2),
                                blurRadius: 30,
                                spreadRadius: 8,
                              ),
                            ]
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                StreamBuilder<int>(
                                  stream: timer.rawTime,
                                  initialData: timer.rawTime.value,
                                  builder: (context, snapshot) {
                                    final value = snapshot.data ?? 0;
                                    final displayTime = StopWatchTimer.getDisplayTime(
                                      value, 
                                      milliSecond: false,
                                    );
                                    return Text(
                                      displayTime,
                                      style: GoogleFonts.sora(
                                        fontSize: 27.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    );
                                  },
                                ),
                                Text(
                                  isCountdown ? 'Tap to Switch to Timer' : 'Tap to Switch to Stopwatch',
                                  style: GoogleFonts.manrope(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 5.h),
              SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 7.5.h,
                      width: 40.w,
                      child: BigButton(
                        onPressed: () => ref.read(timerControllerProvider.notifier).startTimer(),
                        label: 'Start',
                        icon: Icons.play_arrow_rounded,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    SizedBox(
                      height: 7.5.h,
                      width: 40.w,
                      child: BigButton(
                        onPressed: () => ref.read(timerControllerProvider.notifier).stopTimer(),
                        label: 'Stop',
                        icon: Icons.pause_rounded,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.5.h),
              SizedBox(
                width: 60.w,
                child: BigButton(
                  onPressed: () => ref.read(timerControllerProvider.notifier).resetTimer(),
                  label: 'Reset',
                  icon: Icons.restart_alt_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}