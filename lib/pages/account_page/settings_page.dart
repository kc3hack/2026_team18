// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/providers/ai_settings_provider.dart';
import 'package:mikata/providers/theme_provider.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiSettingsAsync = ref.watch(aiSettingsProvider);
    final themeNotifier = ref.read(themeDataProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: aiSettingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (settings) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text("AI Environment Tuning", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              const Text(
                "AIの性格パラメータを設定します。\n設定を変更するとアプリの雰囲気（テーマカラー）も変化します。",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const Divider(height: 30),

              // 褒め (Praise)
              _ParameterSlider(
                label: "褒め (Praise)",
                description: "肯定的な言葉の多さ",
                value: settings.praise,
                color: Colors.pink,
                icon: Icons.thumb_up_alt_rounded,
                onChanged: (val) {
                  ref.read(aiSettingsProvider.notifier).updatePraise(val);
                  _updateThemeMood(val, settings.criticism, themeNotifier);
                },
              ),

              // 共感 (Empathy)
              _ParameterSlider(
                label: "共感 (Empathy)",
                description: "寄り添う言葉の多さ",
                value: settings.empathy,
                color: Colors.orange,
                icon: Icons.favorite_rounded,
                onChanged: (val) {
                  ref.read(aiSettingsProvider.notifier).updateEmpathy(val);
                },
              ),

              // 批判 (Criticism)
              _ParameterSlider(
                label: "批判 (Criticism)",
                description: "厳しい指摘の多さ",
                value: settings.criticism,
                color: Colors.blueGrey,
                icon: Icons.gavel_rounded,
                onChanged: (val) {
                  ref.read(aiSettingsProvider.notifier).updateCriticism(val);
                  _updateThemeMood(settings.praise, val, themeNotifier);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _updateThemeMood(double praise, double criticism, ThemeNotifier notifier) {
    final double moodScore = ((praise - criticism) / 100).clamp(-1.0, 1.0);
    notifier.updateColorSchemaValue(moodScore);
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Text("${value.toInt()}%", style: TextStyle(fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        Text(description, style: Theme.of(context).textTheme.bodySmall),
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