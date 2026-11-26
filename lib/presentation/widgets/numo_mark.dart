import 'package:flutter/widgets.dart';

import '../../core/theme/numo_brand.dart';

/// Símbolo de Numo: un anillo (la moneda) y un punto (el saldo al día).
///
/// Se dibuja en una caja de 108 × 108 unidades, la misma de
/// docs/brand/numo-icon.svg, escalada a [size].
class NumoMark extends StatelessWidget {
  const NumoMark({
    super.key,
    this.size = 108,
    this.ringColor = NumoBrand.ring,
    this.dotColor = NumoBrand.dot,
  });

  final double size;
  final Color ringColor;
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Numo',
      image: true,
      child: CustomPaint(
        size: Size.square(size),
        painter: _MarkPainter(ringColor, dotColor),
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  _MarkPainter(this.ring, this.dot);

  final Color ring;
  final Color dot;

  @override
  void paint(Canvas canvas, Size size) {
    final k = size.width / 108;
    canvas
      ..drawCircle(
        Offset(51 * k, 58 * k),
        21 * k,
        Paint()
          ..color = ring
          ..style = PaintingStyle.stroke
          ..strokeWidth = 10 * k,
      )
      ..drawCircle(Offset(78 * k, 30 * k), 8 * k, Paint()..color = dot);
  }

  @override
  bool shouldRepaint(_MarkPainter old) => old.ring != ring || old.dot != dot;
}
