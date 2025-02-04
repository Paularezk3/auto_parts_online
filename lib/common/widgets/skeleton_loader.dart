import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final Color? baseColor;
  final Color? highlightColor;
  final Color? borderColor;

  const ShimmerBox({
    super.key,
    this.baseColor,
    this.borderColor,
    this.highlightColor,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: baseColor ??
          (isDarkMode
              ? Colors.white.withValues(alpha: 0.1)
              : Colors.grey[300]!),
      highlightColor:
          highlightColor ?? (isDarkMode ? Colors.black12 : Colors.grey[100]!),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: borderColor ?? (isDarkMode ? Colors.black : Colors.white),
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Section Skeleton
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(4, (index) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: ShimmerBox(width: 80, height: 40),
                );
              }),
            ),
          ),

          // Text Skeleton
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ShimmerBox(width: 200, height: 20),
          ),

          // Grid Skeleton
          GridView.builder(
            padding: const EdgeInsets.all(16.0),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3 / 4,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return const ShimmerBox(
                  width: double.infinity, height: double.infinity);
            },
          ),

          // Footer Skeleton
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: ShimmerBox(width: double.infinity, height: 50),
          ),
        ],
      ),
    );
  }
}

class SearchSkeletonLoader extends StatelessWidget {
  const SearchSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Results Skeleton
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 10,
            itemBuilder: (context, index) {
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: ShimmerBox(width: double.infinity, height: 80),
              );
            },
          ),
        ],
      ),
    );
  }
}
