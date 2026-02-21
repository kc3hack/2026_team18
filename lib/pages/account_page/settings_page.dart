// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/providers/ai_settings_provider.dart';
import 'package:mikata/widgets/custom_appbar.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  Animate _fadeSlideIn(
    Widget child, {
    required Duration fadeDuration,
    Duration? fadeDelay,
    required Duration slideDuration,
    required double slideBegin,
    Curve? slideCurve,
  }) {
    var animated = child.animate().fadeIn(
      duration: fadeDuration,
      delay: fadeDelay,
    );

    return animated.slideY(
      duration: slideDuration,
      begin: slideBegin,
      end: 0,
      curve: slideCurve,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiSettingsAsync = ref.watch(aiSettingsProvider);
    final aiSettingsNotifier = ref.read(aiSettingsProvider.notifier);

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppbar(title: const Text("Settings")),
      body: aiSettingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (settings) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _fadeSlideIn(
                Text("AI 性格設定", style: textTheme.titleLarge),
                fadeDuration: 200.ms,
                slideDuration: 240.ms,
                slideBegin: 0.06,
              ),
              const SizedBox(height: 8),
              _fadeSlideIn(
                Text(
                  "AIの性格パラメータを設定します。\n設定を変更するとアプリの雰囲気（テーマカラー）も変化します。",
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                fadeDuration: 200.ms,
                fadeDelay: 60.ms,
                slideDuration: 240.ms,
                slideBegin: 0.05,
              ),
              const Divider(height: 32),

              // 褒め (Praise)
              _fadeSlideIn(
                _ParameterSlider(
                  label: "褒め (Praise)",
                  description: "肯定的な言葉の多さ",
                  value: settings.praise,
                  color: Colors.pink,
                  icon: Icons.thumb_up_alt_rounded,
                  onChanged: aiSettingsNotifier.updatePraise,
                ),
                fadeDuration: 220.ms,
                fadeDelay: 120.ms,
                slideDuration: 260.ms,
                slideBegin: 0.06,
                slideCurve: Curves.easeOutCubic,
              ),

              // 共感 (Empathy)
              _fadeSlideIn(
                _ParameterSlider(
                  label: "共感 (Empathy)",
                  description: "寄り添う言葉の多さ",
                  value: settings.empathy,
                  color: Colors.orange,
                  icon: Icons.favorite_rounded,
                  onChanged: aiSettingsNotifier.updateEmpathy,
                ),
                fadeDuration: 220.ms,
                fadeDelay: 180.ms,
                slideDuration: 260.ms,
                slideBegin: 0.06,
                slideCurve: Curves.easeOutCubic,
              ),

              // 批判 (Criticism)
              _fadeSlideIn(
                _ParameterSlider(
                  label: "批判 (Criticism)",
                  description: "厳しい指摘の多さ",
                  value: settings.criticism,
                  color: Colors.blueGrey,
                  icon: Icons.gavel_rounded,
                  onChanged: aiSettingsNotifier.updateCriticism,
                ),
                fadeDuration: 220.ms,
                fadeDelay: 240.ms,
                slideDuration: 260.ms,
                slideBegin: 0.06,
                slideCurve: Curves.easeOutCubic,
              ),
              const Divider(height: 32),

              _fadeSlideIn(
                ListTile(
                  title: const Text("ライセンス"),
                  leading: const Icon(Icons.info_outline_rounded),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LicensePage(),
                    ),
                  ),
                ),
                fadeDuration: 200.ms,
                fadeDelay: 300.ms,
                slideDuration: 240.ms,
                slideBegin: 0.04,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ParameterSlider extends StatelessWidget {
  final String label;
  final String description;
  final double value;
  final Color color;
  final IconData icon;
  final ValueChanged<double> onChanged;

  const _ParameterSlider({
    required this.label,
    required this.description,
    required this.value,
    required this.color,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label, style: textTheme.titleMedium),
            const Spacer(),
            Text(
              '${value.toInt()}%',
              style: textTheme.titleLarge?.copyWith(color: color),
            ),
          ],
        ),
        Text(description, style: textTheme.bodyMedium),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 100,
          activeColor: color,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
