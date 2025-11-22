import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PremiumInputField extends StatelessWidget {
  final String label;
  final String placeholder;
  final TextEditingController controller;
  final bool isMultiline;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const PremiumInputField({
    super.key,
    required this.label,
    required this.placeholder,
    required this.controller,
    this.isMultiline = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final Color charcoalBlack = const Color(0xFF1A1A1A);
    final Color primaryGold = const Color(0xFFD4AF37);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: isMultiline ? 4 : 1,
            keyboardType: keyboardType,
            validator: validator,
            style: GoogleFonts.playfairDisplay(
              fontSize: 16,
              color: charcoalBlack,
              fontWeight: FontWeight.w500,
            ),
            cursorColor: primaryGold,
            decoration: InputDecoration(
              hintText: placeholder,
              hintStyle: GoogleFonts.inter(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryGold, width: 1.5),
              ),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
