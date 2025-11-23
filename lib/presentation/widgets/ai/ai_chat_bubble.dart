import 'package:flutter/material.dart';

const double _bubbleDiameter = 72.0;

class AiChatBubble extends StatefulWidget {
  final VoidCallback onTap;
  final EdgeInsets boundaryPadding;

  const AiChatBubble({
    super.key,
    required this.onTap,
    this.boundaryPadding = const EdgeInsets.fromLTRB(24, 24, 24, 110),
  });

  @override
  State<AiChatBubble> createState() => _AiChatBubbleState();
}

class _AiChatBubbleState extends State<AiChatBubble> {
  Offset? _offset;

  Offset _clampToBounds(Offset candidate, Size bounds, EdgeInsets padding) {
    final minX = padding.left;
    final maxX = bounds.width - _bubbleDiameter - padding.right;
    final minY = padding.top;
    final maxY = bounds.height - _bubbleDiameter - padding.bottom;

    return Offset(
      candidate.dx.clamp(minX, maxX),
      candidate.dy.clamp(minY, maxY),
    );
  }

  Offset _initialPosition(Size bounds, EdgeInsets padding) {
    final start = Offset(
      padding.left,
      bounds.height - _bubbleDiameter - padding.bottom,
    );
    return _clampToBounds(start, bounds, padding);
  }

  Offset _currentPosition(Size bounds, EdgeInsets padding) {
    return _clampToBounds(
      _offset ?? _initialPosition(bounds, padding),
      bounds,
      padding,
    );
  }

  void _onPanUpdate(
    DragUpdateDetails details,
    Size bounds,
    EdgeInsets padding,
  ) {
    setState(() {
      final current = _currentPosition(bounds, padding);
      _offset = _clampToBounds(
        current + details.delta,
        bounds,
        padding,
      );
    });
  }

  void _onPanEnd(Size bounds, EdgeInsets padding) {
    setState(() {
      final current = _currentPosition(bounds, padding);
      final snapToLeft =
          current.dx + (_bubbleDiameter / 2) < bounds.width / 2;
      final snappedX = snapToLeft
          ? padding.left
          : bounds.width - _bubbleDiameter - padding.right;

      _offset = _clampToBounds(
        Offset(snappedX, current.dy),
        bounds,
        padding,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding;
    final boundary = widget.boundaryPadding
        .add(EdgeInsets.only(bottom: safePadding.bottom))
        .resolve(Directionality.of(context));

    return LayoutBuilder(
      builder: (context, constraints) {
        final bounds = Size(constraints.maxWidth, constraints.maxHeight);
        final position = _currentPosition(bounds, boundary);

        return SizedBox.expand(
          child: Stack(
            children: [
              Positioned(
                left: position.dx,
                top: position.dy,
                child: GestureDetector(
                  onPanUpdate: (details) =>
                      _onPanUpdate(details, bounds, boundary),
                  onPanEnd: (_) => _onPanEnd(bounds, boundary),
                  onTap: widget.onTap,
                  child: const _BubbleVisual(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _BubbleVisual extends StatelessWidget {
  const _BubbleVisual();

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: _bubbleDiameter,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD4AF37), Color(0xFFF4D03F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Icon(
            Icons.smart_toy_outlined,
            color: Color(0xFF1A1A1A),
            size: 24,
          ),
        ),
      ),
    );
  }
}
