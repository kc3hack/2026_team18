// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:mikata/providers/ai_settings_provider.dart';
import 'package:mikata/providers/theme_provider.dart';
import 'package:mikata/widgets/custom_appbar.dart';

class SettingsPage extends HookConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aiSettingsAsync = ref.watch(aiSettingsProvider);

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
              Text("AI 性格設定", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              Text(
                "AIの性格パラメータを設定します。\n設定を変更するとアプリの雰囲気（テーマカラー）も変化します。",
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const Divider(height: 32),

              // 褒め (Praise)
              _ParameterSlider(
                label: "褒め (Praise)",
                description: "肯定的な言葉の多さ",
                value: settings.praise,
                color: Colors.pink,
                icon: Icons.thumb_up_alt_rounded,
                onChanged: (val) {
                  ref.read(aiSettingsProvider.notifier).updatePraise(val);
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
                },
              ),
              const Divider(height: 32),

              ListTile(
                title: const Text("ライセンス"),
                leading: const Icon(Icons.info_outline_rounded),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LicensePage()),
                ),
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
              "${value.toInt()}%",
              style: textTheme.titleLarge?.copyWith(color: color),
            ),
          ],
        ),
        Text(description, style: Theme.of(context).textTheme.bodyMedium),
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
