import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metra/l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:metra/core/theme/app_colors.dart';
import 'package:metra/core/widgets/glass_container.dart';
import 'package:metra/core/widgets/banner_ad_widget.dart';
import 'history_provider.dart';
import '../domain/bpm_record.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.history, style: const TextStyle(letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFF111111),
                  title: Text(l10n.clearHistoryQuestion, style: const TextStyle(color: Colors.white)),
                  content: Text(l10n.clearHistoryWarning, style: const TextStyle(color: Colors.white70)),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.cancel, style: const TextStyle(color: Colors.white38)),
                    ),
                    TextButton(
                      onPressed: () {
                        ref.read(historyProvider.notifier).clear();
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.historyCleared)),
                        );
                      },
                      child: Text(l10n.clear, style: const TextStyle(color: Colors.redAccent)),
                    ),
                  ],
                ),
              );
            },
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
                 color: AppColors.secondary.withValues(alpha: 0.1),
               ),
             ),
          ),

          Column(
            children: [
              Expanded(
                child: historyAsync.when(
                  data: (history) {
                    if (history.isEmpty) {
                      return Center(
                        child: Text(
                          l10n.noRecords,
                          style: const TextStyle(color: AppColors.textSecondary, letterSpacing: 2),
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
                            direction: DismissDirection.horizontal,
                            confirmDismiss: (direction) async {
                              if (direction == DismissDirection.startToEnd) {
                                // Rename
                                await _showRenameDialog(context, ref, record, index);
                                return false; // Don't dismiss for rename
                              }
                              return true; // Dismiss for delete
                            },
                            onDismissed: (direction) {
                              if (direction == DismissDirection.endToStart) {
                                ref.read(historyProvider.notifier).removeRecord(index);
                              }
                            },
                            background: Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.only(left: 20),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.edit, color: AppColors.primary),
                            ),
                            secondaryBackground: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.2),
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
                                      color: AppColors.primary.withValues(alpha: 0.1),
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
                                            Text(
                                              record.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              '±${record.stdDev.toStringAsFixed(1)} ms · ${record.accuracy.toStringAsFixed(1)}% ${l10n.acc}',
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
              ),

              // Ad Banner Area
              const SafeArea(
                top: false,
                child: SizedBox(
                  height: 60,
                  child: Center(child: BannerAdWidget()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showRenameDialog(BuildContext context, WidgetRef ref, BPMRecord record, int index) async {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController controller = TextEditingController(text: record.name == l10n.unnamed ? '' : record.name);

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.white10)),
        title: Text(l10n.renameRecord, style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 1)),
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
              ref.read(historyProvider.notifier).updateRecordName(index, controller.text.trim());
              Navigator.pop(context);
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
}
