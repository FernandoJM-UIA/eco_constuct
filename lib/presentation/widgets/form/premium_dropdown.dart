import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PremiumDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final bool isEnabled;

  const PremiumDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isEnabled = true,
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
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isEnabled
                ? (value != null ? primaryGold : Colors.white.withOpacity(0.5))
                : Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: isEnabled
                  ? (value != null ? primaryGold : Colors.grey.withOpacity(0.3))
                  : Colors.transparent,
            ),
            boxShadow: value != null && isEnabled
                ? [
                    BoxShadow(
                      color: primaryGold.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: value,
              items: items,
              onChanged: isEnabled ? onChanged : null,
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: value != null ? Colors.white : charcoalBlack,
              ),
              isExpanded: true,
              dropdownColor: Colors.white,
              style: GoogleFonts.inter(
                color: value != null ? Colors.white : charcoalBlack,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              hint: Text(
                'Select $label',
                style: GoogleFonts.inter(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
