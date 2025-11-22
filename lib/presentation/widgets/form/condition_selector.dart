import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../domain/entities/material_item.dart';

class ConditionSelector extends StatelessWidget {
  final MaterialCondition selectedCondition;
  final ValueChanged<MaterialCondition> onConditionSelected;

  const ConditionSelector({
    super.key,
    required this.selectedCondition,
    required this.onConditionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CONDITION',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 12,
          children: MaterialCondition.values.map((condition) {
            final isSelected = selectedCondition == condition;
            return GestureDetector(
              onTap: () => onConditionSelected(condition),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF1A1A1A)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1A1A1A)
                        : Colors.grey.withOpacity(0.3),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          )
                        ]
                      : [],
                ),
                child: Text(
                  _getConditionLabel(condition),
                  style: GoogleFonts.inter(
                    color: isSelected ? Colors.white : Colors.grey[600],
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  String _getConditionLabel(MaterialCondition condition) {
    switch (condition) {
      case MaterialCondition.newUnused:
        return 'New (Unused)';
      case MaterialCondition.likeNew:
        return 'Like New';
      case MaterialCondition.usedGood:
        return 'Used - Good';
      case MaterialCondition.usedAcceptable:
        return 'Used - Acceptable';
      case MaterialCondition.forParts:
        return 'For Parts';
      case MaterialCondition.industrialSurplus:
        return 'Industrial Surplus';
    }
  }
}
