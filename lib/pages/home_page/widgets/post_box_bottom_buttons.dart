part of 'post_box.dart';

class IconWithLabel extends StatelessWidget {
  const IconWithLabel({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###");
    final String formattedLabel = formatter.format(int.tryParse(label) ?? 0);

    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          formattedLabel,
          style: TextStyle(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
