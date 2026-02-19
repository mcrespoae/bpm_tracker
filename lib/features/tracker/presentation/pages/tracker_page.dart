import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:bpm_tracker/core/theme/app_colors.dart';
import 'package:bpm_tracker/core/widgets/glass_container.dart';
import 'package:bpm_tracker/core/widgets/banner_ad_widget.dart';
import 'package:bpm_tracker/features/history/presentation/history_page.dart';
import 'package:bpm_tracker/features/history/presentation/history_provider.dart';
import 'package:bpm_tracker/features/tracker/presentation/providers/bpm_provider.dart';

class TrackerPage extends ConsumerStatefulWidget {
  const TrackerPage({super.key});

  @override
  ConsumerState<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends ConsumerState<TrackerPage> {
  // Key to force animation restart on every tap
  int _animationKey = 0;

  @override
  Widget build(BuildContext context) {
    final bpmState = ref.watch(bpmProvider);

    // Toned down red color
    const Color softRed = Color(0xFFFF6B6B);
    const Color emeraldGreen = Color(0xFF00FF95);

    // Finished state color shift
    Color primaryColor = bpmState.isFinished
        ? emeraldGreen
        : AppColors.primary;

    // Conditional styling based on accuracy
    Color accuracyColor = Colors.white38;
    if (bpmState.bpm > 0) {
      if (bpmState.accuracy < 80) {
        accuracyColor = softRed;
      } else if (bpmState.accuracy > 90) {
        accuracyColor = emeraldGreen;
      }
    }

    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          ref.read(bpmProvider.notifier).tap();
          setState(() => _animationKey++); // Trigger pulse animation
        },
        child: Stack(
          children: [
            // Background Glow
            Positioned(
              top: -100,
              right: -100,
              child: AnimatedContainer(
                duration: 500.ms,
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(0.1),
                ),
              ),
            ),

            // App Bar Actions
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.history, color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HistoryPage()),
                      );
                    },
                  ),
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                   // 1. Title
                  const SizedBox(height: 80),
                  Text(
                    'BPM TRACKER',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          letterSpacing: 4,
                          fontWeight: FontWeight.w300,
                          color: AppColors.textSecondary,
                        ),
                  ).animate().fadeIn(),

                  const SizedBox(height: 40),

                  // 2. Central BPM Circle (Locked Position)
                  Hero(
                    tag: 'bpm_circle',
                    child: GlassContainer(
                      width: 280,
                      height: 280,
                      borderRadius: 140,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedDefaultTextStyle(
                              duration: 500.ms,
                              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                                fontSize: 100,
                                color: primaryColor,
                                shadows: [
                                  Shadow(
                                    color: primaryColor.withOpacity(0.3),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: Text('${bpmState.bpm}'),
                            ),
                            Text(
                              'BPM',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                letterSpacing: 4,
                                color: AppColors.textSecondary,
                              ),
                            ),

                            SizedBox(
                              height: 30,
                              child: Center(
                                child: (bpmState.bpm > 0)
                                    ? Text(
                                        '±${bpmState.stdDev.toStringAsFixed(1)} · ${bpmState.accuracy.toStringAsFixed(1)}% ACC',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: accuracyColor,
                                          letterSpacing: 1,
                                          fontWeight: bpmState.accuracy < 80 || bpmState.accuracy > 90 ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ).animate().fadeIn()
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ).animate(key: ValueKey(_animationKey)) // Pulse for every tap
                    .scale(
                      begin: const Offset(1.0, 1.0),
                      end: const Offset(1.06, 1.06),
                      duration: 80.ms,
                      curve: Curves.easeOut,
                    ).then().scale(
                      begin: const Offset(1.06, 1.06),
                      end: const Offset(1.0, 1.0),
                      duration: 120.ms,
                      curve: Curves.easeIn,
                    ),

                  // 3. Status & Controls Area - Directly below circle
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildStatusText(bpmState),

                        SizedBox(
                          height: 80,
                          child: (bpmState.bpm > 0)
                            ? Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => ref.read(bpmProvider.notifier).reset(),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: AppColors.textSecondary,
                                        side: const BorderSide(color: Colors.white10),
                                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                      ),
                                      child: const Text('RESET'),
                                    ),
                                    if (bpmState.isFinished) ...[
                                      const SizedBox(width: 16),
                                      ElevatedButton(
                                        onPressed: () {
                                          ref.read(historyProvider.notifier).addRecord(bpmState.bpm, bpmState.accuracy);
                                          ref.read(bpmProvider.notifier).reset();
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: const Text('RECORD SAVED', textAlign: TextAlign.center),
                                              backgroundColor: (accuracyColor == softRed ? softRed : primaryColor).withOpacity(0.7),
                                              behavior: SnackBarBehavior.floating,
                                              margin: EdgeInsets.only(
                                                bottom: MediaQuery.of(context).size.height - 130,
                                                left: 50,
                                                right: 50,
                                              ),
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              duration: const Duration(seconds: 2),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: (accuracyColor == softRed ? softRed : primaryColor).withOpacity(0.8),
                                          foregroundColor: Colors.black,
                                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                        ),
                                        child: const Text('SAVE'),
                                      ).animate().scale().fadeIn(),
                                    ],
                                  ],
                                ),
                              ).animate().fadeIn()
                            : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // 4. Ad Space Area
                  const SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Center(
                      child: BannerAdWidget(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusText(BPMState state) {
    if (state.bpm == 0) {
      return const Text(
        'TAP ANYWHERE TO START',
        style: TextStyle(letterSpacing: 2, color: AppColors.textSecondary),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 1.seconds);
    }

    if (state.isFinished) {
      const Color softRed = Color(0xFFFF6B6B);
      Color finishedColor = state.accuracy < 80 ? softRed : const Color(0xFF00FF95);
      return Text(
        'MEASUREMENT COMPLETE',
        style: TextStyle(
          letterSpacing: 2,
          color: finishedColor,
          fontWeight: FontWeight.bold,
        ),
      ).animate().fadeIn().shake();
    }

    return const Text(
      'KEEP TAPPING',
      style: TextStyle(letterSpacing: 1, color: Colors.white24),
    ).animate().fadeIn();
  }
}
