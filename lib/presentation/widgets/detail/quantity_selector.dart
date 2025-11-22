import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class QuantitySelector extends StatelessWidget {
  final double quantity;
  final double maxQuantity;
  final String unit;
  final double pricePerUnit;
  final ValueChanged<double> onChanged;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.maxQuantity,
    required this.unit,
    required this.pricePerUnit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final Color primaryGold = const Color(0xFFD4AF37);
    final Color charcoalBlack = const Color(0xFF1A1A1A);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Select Quantity',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: charcoalBlack,
                ),
              ),
              Text(
                'Max: $maxQuantity $unit',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Counter
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildCounterButton(
                      icon: Icons.remove,
                      onTap: quantity > 1 ? () => onChanged(quantity - 1) : null,
                    ),
                    Container(
                      width: 60,
                      alignment: Alignment.center,
                      child: Text(
                        quantity.toStringAsFixed(0), // Assuming integer steps for now
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: charcoalBlack,
                        ),
                      ),
                    ),
                    _buildCounterButton(
                      icon: Icons.add,
                      onTap: quantity < maxQuantity ? () => onChanged(quantity + 1) : null,
                    ),
                  ],
                ),
              ),
              
              // Total Price
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  Text(
                    pricePerUnit == 0
                        ? 'Donation'
                        : '\$${(quantity * pricePerUnit).toStringAsFixed(2)}',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryGold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCounterButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: onTap != null ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: onTap != null
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Icon(
          icon,
          size: 20,
          color: onTap != null ? const Color(0xFF1A1A1A) : Colors.grey[400],
        ),
      ),
    );
  }
}
