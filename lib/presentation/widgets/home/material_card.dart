import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../domain/entities/material_item.dart';
import '../../routes/route_arguments.dart';

class MaterialCard extends StatelessWidget {
  final MaterialItem item;

  const MaterialCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final Color charcoalBlack = const Color(0xFF1A1A1A);
    final Color primaryGold = const Color(0xFFD4AF37);

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/materialDetail',
          arguments: MaterialDetailArgs(item: item),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Image Section
            Expanded(
              flex: 4, // Increased image flex to give more space to image and less to text
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(20)),
                      image: DecorationImage(
                        image: item.imageUrls.isNotEmpty
                            ? NetworkImage(item.imageUrls.first)
                            : const NetworkImage(
                                'https://via.placeholder.com/300'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // New Label
                  Positioned(
                    top: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: charcoalBlack,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'NEW',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  // Favorite Icon
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        size: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Info Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: charcoalBlack,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.category.name.toUpperCase(),
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        color: Colors.grey[500],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      item.price == 0
                          ? 'Donation'
                          : '\$${item.price.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: primaryGold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
