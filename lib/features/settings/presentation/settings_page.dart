import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:metra/l10n/app_localizations.dart';
import 'package:metra/core/theme/app_colors.dart';
import 'package:metra/core/widgets/glass_container.dart';
import 'package:metra/features/settings/presentation/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings, style: const TextStyle(letterSpacing: 2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background Glow
          Positioned(
             top: -50,
             left: -50,
             child: Container(
               width: 250,
               height: 250,
               decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 color: AppColors.primary.withValues(alpha: 0.05),
               ),
             ),
          ),

          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/images/logo_bg.png',
                                height: 80,
                                filterQuality: FilterQuality.high,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'METRA',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSectionHeader(context, l10n.preferences),
                      _buildHapticToggle(ref, settings.isHapticsEnabled, l10n.hapticFeedback),
                      const SizedBox(height: 12),
                      _buildOverrideToggle(ref, settings.isOverrideEnabled, l10n.overrideOldest),
                    ],
                  ),
                ),

                // Footer Separator
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Divider(color: Colors.white10, height: 1),
                ),

                // Footer
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                  child: Column(
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        children: [
                          Text(
                            l10n.madeWithLove,
                            style: const TextStyle(
                              color: Colors.white24,
                              fontSize: 10,
                              letterSpacing: 1,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _launchURL('https://www.mcrespo.dev'),
                            child: const Text(
                              'www.mcrespo.dev',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 10,
                                letterSpacing: 1,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () => _launchURL('https://buymeacoffee.com/mcrespo'),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white10),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.coffee, size: 12, color: Colors.white38),
                              const SizedBox(width: 8),
                              Text(
                                l10n.buyMeCoffee,
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontSize: 10,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<PackageInfo>(
                        future: PackageInfo.fromPlatform(),
                        builder: (context, snapshot) {
                          final version = snapshot.data?.version ?? '0.0.1';
                          final build = snapshot.data?.buildNumber ?? '1';
                          return Text(
                            'v$version ($build)',
                            style: const TextStyle(
                              color: Colors.white10,
                              fontSize: 10,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildHapticToggle(WidgetRef ref, bool value, String label) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.vibration, color: AppColors.primary, size: 20),
              const SizedBox(width: 16),
              Text(label, style: const TextStyle(color: Colors.white)),
            ],
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: AppColors.primary,
            activeThumbColor: Colors.white,
            onChanged: (val) => ref.read(settingsProvider.notifier).toggleHaptics(val),
          ),
        ],
      ),
    );
  }

  Widget _buildOverrideToggle(WidgetRef ref, bool value, String label) {
    return GlassContainer(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.history, color: AppColors.primary, size: 20),
              const SizedBox(width: 16),
              Text(label, style: const TextStyle(color: Colors.white)),
            ],
          ),
          Switch.adaptive(
            value: value,
            activeTrackColor: AppColors.primary,
            activeThumbColor: Colors.white,
            onChanged: (val) => ref.read(settingsProvider.notifier).toggleOverride(val),
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
