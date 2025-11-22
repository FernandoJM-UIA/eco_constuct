import 'dart:ui';

import 'package:flutter/material.dart';

class HomeBottomNavBar extends StatelessWidget {
  final VoidCallback onAddPressed;
  final VoidCallback onImpactPressed;

  const HomeBottomNavBar({
    super.key,
    required this.onAddPressed,
    required this.onImpactPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color glassWhite = Colors.white.withOpacity(0.85);
    final Color primaryGold = const Color(0xFFD4AF37);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
        height: 70,
        decoration: BoxDecoration(
          color: glassWhite,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(35),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavItem(Icons.home_outlined, true, () {}),
                _buildNavItem(Icons.favorite_border, false, () {}),
                // Center Button (Signature Action)
                GestureDetector(
                  onTap: onAddPressed,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryGold, const Color(0xFFF4D03F)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryGold.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.star, color: Colors.white, size: 24),
                  ),
                ),
                _buildNavItem(Icons.chat_bubble_outline, false, () {}),
                _buildNavItem(Icons.eco_outlined, false, onImpactPressed),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFF1A1A1A) : Colors.grey[400],
          size: 24,
        ),
      ),
    );
  }
}
