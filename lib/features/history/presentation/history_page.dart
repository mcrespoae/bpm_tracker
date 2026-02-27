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

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _HistoryRecordItem(
                            record: record,
                            index: index,
                            l10n: l10n,
                            onRename: () => _showRenameDialog(context, ref, record, index),
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
        content: SizedBox(
          width: 300,
          child: TextField(
            controller: controller,
            maxLength: 30,
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
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel, style: const TextStyle(color: Colors.white38)),
          ),
          ElevatedButton(
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final String newName = controller.text.trim();

              Navigator.pop(context);

              final success = await ref.read(historyProvider.notifier).updateRecordName(index, newName);

              if (!success) {
                const Color softRed = Color(0xFFFF6B6B);
                scaffoldMessenger.showSnackBar(
                  SnackBar(
                    content: Text(l10n.saveError, textAlign: TextAlign.center),
                    backgroundColor: softRed.withValues(alpha: 0.8),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
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

class _HistoryRecordItem extends ConsumerStatefulWidget {
  final BPMRecord record;
  final int index;
  final AppLocalizations l10n;
  final VoidCallback onRename;

  const _HistoryRecordItem({
    required this.record,
    required this.index,
    required this.l10n,
    required this.onRename,
  });

  @override
  ConsumerState<_HistoryRecordItem> createState() => _HistoryRecordItemState();
}

class _HistoryRecordItemState extends ConsumerState<_HistoryRecordItem> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolling = false;

  void _onTap() async {
    if (_isScrolling || !_scrollController.hasClients) return;
    if (_scrollController.position.maxScrollExtent <= 0) return;

    // Set this index as the active scroll
    ref.read(scrollingRecordIndexProvider.notifier).setIndex(widget.index);
    setState(() => _isScrolling = true);

    await _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: _scrollController.position.maxScrollExtent.toInt() * 40),
      curve: Curves.linear,
    );

    await Future.delayed(const Duration(seconds: 1));

    if (mounted && _isScrolling) {
      await _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.easeOut,
      );
      if (mounted) {
        setState(() => _isScrolling = false);
        if (ref.read(scrollingRecordIndexProvider) == widget.index) {
          ref.read(scrollingRecordIndexProvider.notifier).setIndex(null);
        }
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen for changes in the active scroll index
    ref.listen<int?>(scrollingRecordIndexProvider, (previous, next) {
      if (next != widget.index && _isScrolling) {
        // Someone else started scrolling, stop this one and reset
        _scrollController.jumpTo(0);
        setState(() => _isScrolling = false);
      }
    });

    final date = DateFormat('MMM dd, yyyy HH:mm').format(widget.record.timestamp);
    const Color softRed = Color(0xFFFF6B6B);
    Color accuracyColor = AppColors.textSecondary;
    if (widget.record.accuracy < 80) {
      accuracyColor = softRed;
    } else if (widget.record.accuracy > 90) {
      accuracyColor = const Color(0xFF00FF95);
    }

    return Dismissible(
      key: Key('record_${widget.record.timestamp.millisecondsSinceEpoch}'),
      direction: DismissDirection.horizontal,
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          widget.onRename();
          return false;
        }
        return true;
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          ref.read(historyProvider.notifier).removeRecord(widget.index);
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
      child: GestureDetector(
        onTap: _onTap,
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
                  '${widget.record.bpm}',
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
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            controller: _scrollController,
                            scrollDirection: Axis.horizontal,
                            physics: const NeverScrollableScrollPhysics(),
                            child: Text(
                              widget.record.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '±${widget.record.stdDev.toStringAsFixed(1)} ms · ${widget.record.accuracy.toStringAsFixed(1)}% ${widget.l10n.acc}',
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
  }
}
