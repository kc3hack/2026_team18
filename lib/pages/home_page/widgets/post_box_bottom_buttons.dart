part of 'post_box.dart';

class IconWithLabel extends StatelessWidget {
  const IconWithLabel({
    super.key,
    required this.isActive,
    required this.activeColor,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final Color activeColor;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat("#,###");
    final String formattedLabel = formatter.format(int.tryParse(label) ?? 0);

    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: (isActive) ? activeColor : colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 4),
          Text(
            formattedLabel,
            style: TextStyle(
              color: (isActive) ? activeColor : colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
