import "package:flutter/material.dart";

/// Class which takes a List of CustomPainters and renders them all on top of
/// each other in the same space. Renders first to last as bottom to top.
/// This is done by recursively stacking CustomPaint objects into a long chain.
/// The provided child Widget is placed at the leaf position.
class MultiPainter extends StatelessWidget {
  final List<CustomPainter> painters;
  final Widget child;

  MultiPainter({ this.painters, this.child });

  @override
  Widget build(final BuildContext context) {
    // Recursively build painters
    return _buildMultiPainter(painters, child);
  }

  // Recursively stack the list of painters inside each other with the given child at the bottom
  Widget _buildMultiPainter(final List<CustomPainter> painters, final Widget child) {
    // If at inner-most painter, insert child
    if (painters.length == 1) {
      return new CustomPaint(
        painter: painters.first,
        child: child,
      );
    }

    // Put remaining painters inside the first painter
    return new CustomPaint(
      painter: painters.first,
      child: _buildMultiPainter(painters.getRange(1, painters.length).toList(), child),
    );
  }
}