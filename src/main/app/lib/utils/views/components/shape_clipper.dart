import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:material_3_expressive/foundations/m3e_material_new_shapes_bridge.dart';

class ShapeClipper extends CustomClipper<Path> {
  final RoundedPolygon polygon;

  ShapeClipper(this.polygon);

  @override
  Path getClip(Size size) => _fitToSize(polygon, size).toPath();

  @override
  bool shouldReclip(covariant ShapeClipper oldClipper) => oldClipper.polygon != polygon;
}

class MorphClipper extends CustomClipper<Path> {
  final Morph morph;
  final double progress;

  MorphClipper(this.morph, this.progress);

  @override
  Path getClip(Size size) {
    final path = morph.toPath(progress: progress);

    // Same bounds-fitting approach as before, but on the raw Path's bounds
    final bounds = path.getBounds();
    final scale = math.min(size.width / bounds.width, size.height / bounds.height);

    final matrix = Matrix4.identity()
      ..translate(size.width / 2, size.height / 2)
      ..scale(scale, scale)
      ..translate(-bounds.center.dx, -bounds.center.dy);

    return path.transform(matrix.storage);
  }

  @override
  bool shouldReclip(covariant MorphClipper oldClipper) => oldClipper.progress != progress || oldClipper.morph != morph;
}

class BorderPainter extends CustomPainter {
  final Color color;
  final double width;
  final CustomClipper<Path> clipper;
  BorderPainter({required this.clipper, required this.color, required this.width});

  @override
  void paint(Canvas canvas, Size size) {
    final path = clipper.getClip(size);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

RoundedPolygon _fitToSize(RoundedPolygon polygon, Size size) {
  // [left, top, right, bottom] of the polygon's actual coordinate space
  final bounds = polygon.calculateBounds();
  final srcWidth = bounds[2] - bounds[0];
  final srcHeight = bounds[3] - bounds[1];

  final matrix = Matrix4.identity()
    ..scale(size.width / srcWidth, size.height / srcHeight)
    ..translate(-bounds[0], -bounds[1]);

  return polygon.transformed(matrix.asPointTransformer());
}

/*
RoundedPolygon _scaledPolygon(RoundedPolygon polygon, Size size) {
  final matrix = Matrix4.identity()
    ..translate(size.width / 2, size.height / 2)
    ..scale(size.width / 2, size.height / 2);
  return polygon.transformed(matrix.asPointTransformer());
}
*/
