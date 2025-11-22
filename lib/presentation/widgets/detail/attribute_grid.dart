import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../domain/entities/material_item.dart';

class AttributeGrid extends StatelessWidget {
  final MaterialItem item;

  const AttributeGrid({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 3.2, // Increased to prevent overflow
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _buildAttributeItem('Condition', _getConditionLabel(item.condition)),
        _buildAttributeItem('Quantity', '${item.quantity} ${item.unit}'),
        _buildAttributeItem('Min. Purchase', '1 ${item.unit}'), // Placeholder logic
      ],
    );
  }

  Widget _buildAttributeItem(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  String _getConditionLabel(MaterialCondition condition) {
    switch (condition) {
      case MaterialCondition.newUnused:
        return 'New';
      case MaterialCondition.likeNew:
        return 'Like New';
      case MaterialCondition.usedGood:
        return 'Used (Good)';
      case MaterialCondition.usedAcceptable:
        return 'Used (Fair)';
      case MaterialCondition.forParts:
        return 'For Parts';
      case MaterialCondition.industrialSurplus:
        return 'Surplus';
    }
  }
}
