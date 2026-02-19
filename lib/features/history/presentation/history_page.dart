import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:bpm_tracker/core/theme/app_colors.dart';
import 'package:bpm_tracker/core/widgets/glass_container.dart';
import 'history_provider.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('HISTORY', style: TextStyle(letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () => ref.read(historyProvider.notifier).clear(),
            icon: const Icon(Icons.delete_outline, color: Colors.white54),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Glow
          Positioned(
             bottom: -50,
             left: -50,
             child: Container(
               width: 250,
               height: 250,
               decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 color: AppColors.secondary.withOpacity(0.1),
               ),
             ),
          ),

          historyAsync.when(
            data: (history) {
              if (history.isEmpty) {
                return const Center(
                  child: Text(
                    'NO RECORDS YET',
                    style: TextStyle(color: AppColors.textSecondary, letterSpacing: 2),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 120, 16, 16),
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final record = history[index];
                  final date = DateFormat('MMM dd, yyyy HH:mm').format(record.timestamp);

                  const Color softRed = Color(0xFFFF6B6B);
                  Color accuracyColor = AppColors.textSecondary;
                  if (record.accuracy < 80) {
                    accuracyColor = softRed;
                  } else if (record.accuracy > 90) {
                    accuracyColor = const Color(0xFF00FF95);
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Dismissible(
                      key: Key('record_${record.timestamp.millisecondsSinceEpoch}'),
                      direction: DismissDirection.endToStart, // Swipe Left (Standard)
                      onDismissed: (direction) {
                        ref.read(historyProvider.notifier).removeRecord(index);
                      },
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(Icons.delete, color: Colors.redAccent),
                      ),
                      child: GlassContainer(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '${record.bpm}',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'BPM RECORD',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '${record.accuracy.toStringAsFixed(1)}% ACC',
                                        style: TextStyle(
                                          color: accuracyColor,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    date,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
        ],
      ),
    );
  }
}
