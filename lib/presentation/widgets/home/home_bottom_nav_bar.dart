import 'dart:ui';

import 'package:flutter/material.dart';

class HomeBottomNavBar extends StatelessWidget {
  final int activeIndex;
  final VoidCallback onHomePressed;
  final VoidCallback onFavoritesPressed;
  final VoidCallback onChatPressed;
  final VoidCallback onAddPressed;
  final VoidCallback onImpactPressed;

  const HomeBottomNavBar({
    super.key,
    this.activeIndex = 0,
    required this.onHomePressed,
    required this.onFavoritesPressed,
    required this.onChatPressed,
    required this.onAddPressed,
    required this.onImpactPressed,
  });

  @override
  Widget build(BuildContext context) {
    final Color glassWhite = Colors.white.withOpacity(0.85);
    final Color primaryGold = const Color(0xFFD4AF37);
    
    // Get the bottom safe area padding (e.g., for system nav bars)
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(
          left: 24, 
          right: 24, 
          bottom: 24 + bottomPadding,
        ),
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
                _buildNavItem(
                    Icons.home_outlined, activeIndex == 0, onHomePressed),
                _buildNavItem(Icons.favorite_border, activeIndex == 1,
                    onFavoritesPressed),
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
                    child: const Icon(Icons.star,
                        color: Colors.white, size: 24),
                  ),
                ),
                _buildNavItem(
                    Icons.chat_bubble_outline, activeIndex == 2, onChatPressed),
                _buildNavItem(
                    Icons.eco_outlined, activeIndex == 3, onImpactPressed),
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
