import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StickyActionBar extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onBuyNow;
  final VoidCallback onContactSeller;

  const StickyActionBar({
    super.key,
    required this.totalPrice,
    required this.onBuyNow,
    required this.onContactSeller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Contact Seller Button
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: onContactSeller,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.grey.withOpacity(0.3)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Icon(Icons.chat_bubble_outline, color: Color(0xFF1A1A1A)),
              ),
            ),
            const SizedBox(width: 12),
            
            // Buy Now Button
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: onBuyNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A3A52),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 8,
                  shadowColor: const Color(0xFF1A3A52).withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'BUY NOW',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 16,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      totalPrice == 0 ? 'FREE' : '\$${totalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
