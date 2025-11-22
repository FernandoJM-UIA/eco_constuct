import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../domain/entities/material_item.dart';

class ProductInfo extends StatelessWidget {
  final MaterialItem item;

  const ProductInfo({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final Color primaryGold = const Color(0xFFD4AF37);
    final Color charcoalBlack = const Color(0xFF1A1A1A);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: charcoalBlack,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    children: [
                      Text(
                        item.category.toString().split('.').last.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryGold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (item.subCategory != null) ...[
                        Text(
                          ' • ',
                          style: GoogleFonts.inter(
                            color: Colors.grey[400],
                          ),
                        ),
                        Text(
                          item.subCategory!,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  item.price == 0 ? 'Donation' : '\$${item.price.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: item.price == 0 ? Colors.grey[600] : const Color(0xFFD4AF37),
                  ),
                ),
                if (item.price > 0)
                  Text(
                    'MXN',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.grey[500],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 18, color: Colors.grey[600]),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Seller Name', // Placeholder
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: charcoalBlack,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, size: 14, color: Color(0xFFFFC107)),
                    const SizedBox(width: 4),
                    Text(
                      '4.8 (124 reviews)', // Placeholder
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
