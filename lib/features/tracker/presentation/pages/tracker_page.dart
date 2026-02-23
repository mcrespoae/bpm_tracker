import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metra/l10n/app_localizations.dart';
import 'package:metra/core/theme/app_colors.dart';
import 'package:metra/core/widgets/glass_container.dart';
import 'package:metra/core/widgets/banner_ad_widget.dart';
import 'package:metra/features/history/presentation/history_page.dart';
import 'package:metra/features/history/presentation/history_provider.dart';
import 'package:metra/features/tracker/presentation/providers/bpm_provider.dart';
import 'package:metra/features/settings/presentation/settings_page.dart';
import 'package:metra/features/settings/presentation/settings_provider.dart';

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
    final l10n = AppLocalizations.of(context)!;

    // Toned down red color
    const Color softRed = Color(0xFFFF6B6B);
    const Color emeraldGreen = Color(0xFF00FF95);

    // Finished state color shift
    Color primaryColor = bpmState.isFinished
        ? emeraldGreen
        : AppColors.primary;

    // Conditional styling based on accuracy
    Color accuracyColor = Colors.white38;
    if (bpmState.bpm > 0 && bpmState.taps.length >= 4) {
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
                  color: primaryColor.withValues(alpha: 0.1),
                ),
              ),
            ),

            // App Bar Actions
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.settings, color: Colors.white, size: 28),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SettingsPage()),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.history, color: Colors.white, size: 28),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HistoryPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            SafeArea(
              child: Column(
                children: [
                   // 1. Title
                  const SizedBox(height: 80),
                  Text(
                    l10n.appTitle,
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
                                    color: primaryColor.withValues(alpha: 0.3),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                              child: Text('${bpmState.bpm}'),
                            ),
                            Text(
                              l10n.bpm,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                letterSpacing: 4,
                                color: AppColors.textSecondary,
                              ),
                            ),

                            SizedBox(
                              height: 30,
                              child: Center(
                                child: (bpmState.taps.length >= 4)
                                    ? Text(
                                        '±${bpmState.stdDev.toStringAsFixed(1)} ms · ${bpmState.accuracy.toStringAsFixed(1)}% ${l10n.acc}',
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
                        _buildStatusText(bpmState, l10n),

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
                                      child: Text(l10n.reset),
                                    ),
                                    if (bpmState.isFinished) ...[
                                      const SizedBox(width: 16),
                                      Builder(
                                        builder: (context) {
                                          final settings = ref.watch(settingsProvider);
                                          final historyAsync = ref.watch(historyProvider);
                                          final historyLength = historyAsync.value?.length ?? 0;
                                          final isFull = historyLength >= 10;
                                          final canSave = settings.isOverrideEnabled || !isFull;

                                          return ElevatedButton(
                                            onPressed: () {
                                              if (canSave) {
                                                _showSaveNameDialog(context, bpmState.bpm, bpmState.accuracy, bpmState.stdDev);
                                              } else {
                                                _showHistoryFullDialog(context);
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: canSave
                                                ? (accuracyColor == softRed ? softRed : primaryColor).withValues(alpha: 0.8)
                                                : Colors.transparent,
                                              foregroundColor: canSave ? Colors.black : Colors.white24,
                                              side: canSave ? null : const BorderSide(color: Colors.white10),
                                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                            ),
                                            child: Text(l10n.save),
                                          );
                                        },
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

  void _showHistoryFullDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.white10)),
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.primary),
            const SizedBox(width: 12),
            Text(l10n.historyFull, style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 1)),
          ],
        ),
        content: Text(
          l10n.maxRecordsReached(HistoryRepository.maxItems),
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSaveNameDialog(BuildContext context, int bpm, double accuracy, double stdDev) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.white10)),
        title: Text(l10n.saveNameTitle, style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 1)),
        content: TextField(
          controller: controller,
          maxLength: 50,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: l10n.nameHint,
            hintStyle: const TextStyle(color: Colors.white24),
            counterStyle: const TextStyle(color: Colors.white24),
            enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white10)),
            focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.white38)),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(historyProvider.notifier).addRecord(bpm, accuracy, stdDev, controller.text.trim());
              ref.read(bpmProvider.notifier).reset();
              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n.recordSaved, textAlign: TextAlign.center),
                  backgroundColor: AppColors.primary.withValues(alpha: 0.7),
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
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.black,
            ),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusText(BPMState state, AppLocalizations l10n) {
    if (state.bpm == 0) {
      return Text(
        l10n.tapToStart,
        style: const TextStyle(letterSpacing: 2, color: AppColors.textSecondary),
      ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(duration: 1.seconds);
    }

    if (state.isFinished) {
      const Color softRed = Color(0xFFFF6B6B);
      Color finishedColor = state.accuracy < 80 ? softRed : const Color(0xFF00FF95);
      return Text(
        l10n.measurementComplete,
        style: TextStyle(
          letterSpacing: 2,
          color: finishedColor,
          fontWeight: FontWeight.bold,
        ),
      ).animate().fadeIn().shake();
    }

    return Text(
      l10n.keepTapping,
      style: const TextStyle(letterSpacing: 1, color: Colors.white24),
    ).animate().fadeIn();
  }
}
