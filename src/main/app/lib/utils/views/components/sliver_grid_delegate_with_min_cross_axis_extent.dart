import 'dart:math';

import 'package:flutter/rendering.dart';

/// Grid delegate that fits as many columns as possible while keeping each item at least [minCrossAxisExtent] wide.
/// Items stretch to fill the remaining width, and there is always at least one column even if it is narrower
/// than [minCrossAxisExtent].
class SliverGridDelegateWithMinCrossAxisExtent extends SliverGridDelegate {
  final double minCrossAxisExtent;
  final double mainAxisExtent;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

  const SliverGridDelegateWithMinCrossAxisExtent({
    required this.minCrossAxisExtent,
    required this.mainAxisExtent,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
  });

  @override
  SliverGridLayout getLayout(SliverConstraints constraints) {
    final crossAxisCount = max(
      1,
      ((constraints.crossAxisExtent + crossAxisSpacing) / (minCrossAxisExtent + crossAxisSpacing)).floor(),
    );
    final usableCrossAxisExtent = max(0.0, constraints.crossAxisExtent - crossAxisSpacing * (crossAxisCount - 1));
    final childCrossAxisExtent = usableCrossAxisExtent / crossAxisCount;

    return SliverGridRegularTileLayout(
      crossAxisCount: crossAxisCount,
      mainAxisStride: mainAxisExtent + mainAxisSpacing,
      crossAxisStride: childCrossAxisExtent + crossAxisSpacing,
      childMainAxisExtent: mainAxisExtent,
      childCrossAxisExtent: childCrossAxisExtent,
      reverseCrossAxis: axisDirectionIsReversed(constraints.crossAxisDirection),
    );
  }

  @override
  bool shouldRelayout(SliverGridDelegateWithMinCrossAxisExtent oldDelegate) =>
      oldDelegate.minCrossAxisExtent != minCrossAxisExtent ||
      oldDelegate.mainAxisExtent != mainAxisExtent ||
      oldDelegate.crossAxisSpacing != crossAxisSpacing ||
      oldDelegate.mainAxisSpacing != mainAxisSpacing;
}
