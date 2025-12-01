import 'package:flutter/material.dart';
import 'package:onceinmind/core/config/theme.dart';

class CustomTextFieldWidget extends StatefulWidget {
  const CustomTextFieldWidget({
    super.key,
    this.hint,
    this.keyboardType,
    this.isPassword = false,
    this.textInputAction = TextInputAction.next,
    this.validator,
    this.controller,
  });

  final String? hint;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final bool isPassword;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  @override
  State<CustomTextFieldWidget> createState() => _CustomTextFieldWidgetState();
}

class _CustomTextFieldWidgetState extends State<CustomTextFieldWidget> {
  bool obscureText = true;
  @override
  Widget build(BuildContext context) {
    // Painter draws the background + folded corner. Put a TextField on top.
    return Center(
      child: SizedBox(
        width: 320, // you can change this width to test scaling
        height: 70, // matches the SVG aspect ratio (274x55 scaled)
        child: CustomPaint(
          painter: _SvgFieldPainter(),
          child: Padding(
            // necessary to avoid overlap with painted borders/fold
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: TextFormField(
              controller: widget.controller,
              validator: widget.validator,
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              obscureText: widget.isPassword ? obscureText : false,
              decoration: InputDecoration(
                suffixIcon: widget.isPassword
                    ? IconButton(
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          obscureText
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureText = !obscureText;
                          });
                        },
                        color: AppColors.primaryColor,
                      )
                    : null,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: 12,
                ),
                border: const OutlineInputBorder(borderSide: BorderSide.none),
                hintText: widget.hint,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SvgFieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // The original SVG viewBox: 0 0 274 55
    const double vbWidth = 274.0;
    const double vbHeight = 55.0;

    // Scale so we can reuse original coordinates
    final double sx = size.width / vbWidth;
    final double sy = size.height / vbHeight;

    canvas.save();
    canvas.scale(sx, sy);

    // --- Paths copied/translated from the SVG ---
    // main rectangle with bottom-right triangle cut out:
    // M1.5 0.5 H270.5 V35.0558 L254.815 48.5 H1.5 V0.5 Z
    final Path mainPath = Path()
      ..moveTo(1.5, 0.5)
      ..lineTo(270.5, 0.5)
      ..lineTo(270.5, 35.0558)
      ..lineTo(254.815, 48.5)
      ..lineTo(1.5, 48.5)
      ..close();

    // folded triangle overlay:
    // M254.881 48.4519 V35.0781 H270.516 L254.881 48.4519 Z
    final Path foldPath = Path()
      ..moveTo(254.881, 48.4519)
      ..lineTo(254.881, 35.0781)
      ..lineTo(270.516, 35.0781)
      ..close();

    // --- Paint shadows similar to the SVG filters ---
    // SVG filter0: dy=1, stdDeviation=0.75, opacity about 0.160784
    // We'll simulate with a blurred, slightly offset fill.
    final Paint mainShadow = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 1.0);

    // draw main shadow slightly shifted down (dy=1)
    canvas.save();
    canvas.translate(0, 1); // dy = 1 (SVG uses small offset)
    canvas.drawPath(mainPath, mainShadow);
    canvas.restore();

    // Draw main white shape
    final Paint mainFill = Paint()..color = AppColors.white;
    canvas.drawPath(mainPath, mainFill);

    // Draw a very light stroke around the main shape for definition
    final Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..color =
          const Color(0x1F000000) // very light border
      ..strokeWidth = 1.0;
    canvas.drawPath(mainPath, strokePaint);

    // --- Fold shadow + fold fill ---
    // SVG filter1: dy=3, stdDeviation=1.5, same opacity 0.160784
    final Paint foldShadow = Paint()
      ..color = Colors.black.withValues(alpha: 0.16)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2.0);

    // shift fold shadow down by 3 units to mimic SVG filter
    canvas.save();
    canvas.translate(0, 3);
    canvas.drawPath(foldPath, foldShadow);
    canvas.restore();

    // Fill the fold triangle with a subtle gradient (top-left slightly darker)
    final Rect foldRect = Rect.fromLTWH(254.881, 35.0781, 15.635, 13.3738);
    final Paint foldFill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFEDEDED), // slightly darker near the top-left (edge)
          Color(0xFFFFFFFF), // white for the visible face
        ],
      ).createShader(foldRect);

    canvas.drawPath(foldPath, foldFill);

    // small stroke on the fold to match SVG's path outlines
    final Paint foldStroke = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0x1F000000)
      ..strokeWidth = 0.8;
    canvas.drawPath(foldPath, foldStroke);

    canvas.restore(); // restore scaling
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
