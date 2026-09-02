/* =======================================================
   REUSABLE WIDGET: Shimmer Loading & Skeleton Components
   ======================================================= */

import 'package:flutter/material.dart';

/* ============= Shimmer Controller & Gradient Provider ============= */
class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.isLoading = true,
    this.baseColor = const Color(0xFFE5E7EB),
    this.highlightColor = const Color(0xFFF9FAFB),
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(
        min: -0.5,
        max: 1.5,
        period: const Duration(milliseconds: 1400),
      );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            final double value = _shimmerController.value;
            return LinearGradient(
              begin: const Alignment(-1.0, -0.3),
              end: const Alignment(1.0, 0.3),
              colors: [
                widget.baseColor,
                widget.highlightColor,
                widget.baseColor,
              ],
              stops: const [0.1, 0.5, 0.9],
              transform: _SlidingGradientTransform(slidePercent: value),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

/* ============= Skeleton Primitive Shapes ============= */
class SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double borderRadius;
  final BoxShape shape;
  final Color color;

  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = 8,
    this.shape = BoxShape.rectangle,
    this.color = const Color(0xFFE2E8F0),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        shape: shape,
        borderRadius: shape == BoxShape.rectangle
            ? BorderRadius.circular(borderRadius)
            : null,
      ),
    );
  }
}

/* ============= Product Grid Skeleton ============= */
class ShimmerProductGridSkeleton extends StatelessWidget {
  final int itemCount;
  final EdgeInsetsGeometry padding;
  final double childAspectRatio;

  const ShimmerProductGridSkeleton({
    super.key,
    this.itemCount = 4,
    this.padding = const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
    this.childAspectRatio = 0.95,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: GridView.builder(
        padding: padding,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14.0,
          mainAxisSpacing: 14.0,
          childAspectRatio: childAspectRatio,
        ),
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3F4F6), width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonBox(
                  height: 110,
                  width: double.infinity,
                  borderRadius: 12,
                ),
                const SizedBox(height: 10),
                const SkeletonBox(
                  height: 14,
                  width: 90,
                  borderRadius: 4,
                ),
                const SizedBox(height: 6),
                const SkeletonBox(
                  height: 14,
                  width: 50,
                  borderRadius: 4,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/* ============= Orders List Skeleton ============= */
class ShimmerOrdersListSkeleton extends StatelessWidget {
  final int itemCount;

  const ShimmerOrdersListSkeleton({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFF3F4F6), width: 1.2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    SkeletonBox(width: 110, height: 16, borderRadius: 4),
                    SkeletonBox(width: 70, height: 22, borderRadius: 8),
                  ],
                ),
                const SizedBox(height: 12),
                const SkeletonBox(width: 150, height: 12, borderRadius: 4),
                const SizedBox(height: 12),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    SkeletonBox(width: 80, height: 14, borderRadius: 4),
                    SkeletonBox(width: 60, height: 16, borderRadius: 4),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/* ============= Cart List Skeleton ============= */
class ShimmerCartListSkeleton extends StatelessWidget {
  final int itemCount;

  const ShimmerCartListSkeleton({
    super.key,
    this.itemCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F7F7),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const SkeletonBox(
                  width: 80,
                  height: 80,
                  borderRadius: 12,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      SkeletonBox(width: 120, height: 15, borderRadius: 4),
                      SizedBox(height: 8),
                      SkeletonBox(width: 60, height: 14, borderRadius: 4),
                    ],
                  ),
                ),
                const SkeletonBox(
                  width: 70,
                  height: 32,
                  borderRadius: 8,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/* ============= Profile Header Skeleton ============= */
class ShimmerProfileSkeleton extends StatelessWidget {
  const ShimmerProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          const SkeletonBox(
            width: 96,
            height: 96,
            shape: BoxShape.circle,
          ),
          const SizedBox(height: 14),
          const SkeletonBox(width: 140, height: 18, borderRadius: 4),
          const SizedBox(height: 8),
          const SkeletonBox(width: 180, height: 13, borderRadius: 4),
          const SizedBox(height: 28),
          for (int i = 0; i < 5; i++) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8F7F7),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: const [
                  SkeletonBox(width: 22, height: 22, borderRadius: 6),
                  SizedBox(width: 14),
                  Expanded(
                    child: SkeletonBox(width: 120, height: 14, borderRadius: 4),
                  ),
                  SkeletonBox(width: 16, height: 16, borderRadius: 4),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
