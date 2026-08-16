import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/app_colors.dart';
import '../../theme/common_methods.dart';

class SkeletonLoader extends StatelessWidget {
  final Widget child;
  final bool enabled;

  const SkeletonLoader({
    super.key,
    required this.child,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Softer and more subtle shimmer colors for a premium feel
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[200]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[50]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(milliseconds: 1500), // Slower, elegant shimmer
      child: child,
    );
  }
}

// A reusable shape for inside skeleton cards
Widget buildSkeletonBox(BuildContext context, {double? width, double? height, double radius = 8, BoxShape shape = BoxShape.rectangle}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: isDark ? Colors.grey[800] : Colors.white,
      shape: shape,
      borderRadius: shape == BoxShape.rectangle ? BorderRadius.circular(radius) : null,
    ),
  );
}

class SkeletonCard extends StatelessWidget {
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;

  const SkeletonCard({
    super.key,
    this.height,
    this.width,
    this.margin = const EdgeInsets.symmetric(vertical: 8.0),
  });

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      height: height,
      width: width ?? double.infinity,
      margin: margin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? c.cardDark : c.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: c.divider.withValues(alpha: 0.4)),
      ),
      child: SkeletonLoader(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSkeletonBox(context, width: 44, height: 44, radius: 14),
                  buildSkeletonBox(context, width: 60, height: 20, radius: 10),
                ],
              ),
              if (height == null || height! > 100) const SizedBox(height: 16),
              if (height != null && height! <= 100) const SizedBox(height: 12),
              buildSkeletonBox(context, width: 100, height: 12, radius: 6),
              const SizedBox(height: 8),
              buildSkeletonBox(context, width: double.infinity, height: 24, radius: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class SkeletonListTile extends StatelessWidget {
  const SkeletonListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final c = getThemeBaseColors(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: isDark ? c.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: c.divider.withValues(alpha: 0.3)),
      ),
      child: SkeletonLoader(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildSkeletonBox(context, width: 56, height: 56, shape: BoxShape.circle),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildSkeletonBox(context, width: double.infinity, height: 16, radius: 8),
                  const SizedBox(height: 10.0),
                  buildSkeletonBox(context, width: 140, height: 12, radius: 6),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            buildSkeletonBox(context, width: 24, height: 24, shape: BoxShape.circle),
          ],
        ),
      ),
    );
  }
}
