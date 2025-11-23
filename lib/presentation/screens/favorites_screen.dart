import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/material_item.dart';
import '../providers/material_provider.dart';
import '../widgets/home/home_bottom_nav_bar.dart';
import 'material_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<MaterialProvider>();
      if (provider.status == MaterialLoadingStatus.initial) {
        provider.loadMaterials();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MaterialProvider>();
    final favorites = _resolveFavorites(provider.materials);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFDFBF6),
                  Color(0xFFF4F7FA),
                  Color(0xFFEFF2F6),
                ],
              ),
            ),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                    child: _buildHeader(context, favorites.length)),
                const SliverToBoxAdapter(child: SizedBox(height: 12)),
                SliverToBoxAdapter(child: _buildSummaryCard(favorites.length)),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                if (provider.status == MaterialLoadingStatus.loading)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                else if (favorites.isEmpty)
                  const SliverToBoxAdapter(child: _EmptyState())
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = favorites[index];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: index == favorites.length - 1 ? 120 : 14,
                            ),
                            child: _FavoriteCard(item: item),
                          );
                        },
                        childCount: favorites.length,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          HomeBottomNavBar(
            activeIndex: 1,
            onHomePressed: () =>
                Navigator.pushReplacementNamed(context, '/home'),
            onFavoritesPressed: () {},
            onAddPressed: () => Navigator.pushNamed(context, '/addMaterial'),
            onChatPressed: () =>
                Navigator.pushReplacementNamed(context, '/chatTab'),
            onImpactPressed: () => Navigator.pushNamed(context, '/impact'),
          ),
        ],
      ),
    );
  }

  List<MaterialItem> _resolveFavorites(List<MaterialItem> materials) {
    if (materials.isEmpty) return [];
    if (materials.length <= 3) return materials;
    return materials.take(3).toList();
  }

  Widget _buildHeader(BuildContext context, int count) {
    final subtitle = count == 0
        ? 'Aún no guardas materiales.'
        : '$count materiales guardados.';
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Color(0xFFEAE0C8),
            child: Icon(Icons.favorite, color: Color(0xFF9A7B4F)),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tus favoritos',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.auto_awesome, color: Colors.amber[700], size: 18),
                const SizedBox(width: 6),
                Text(
                  'Mock view',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[900],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD4AF37), Color(0xFFF4D03F)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.32),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.eco, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Materiales salvados',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    count == 0
                        ? 'Empieza a crear tu lista eco-friendly.'
                        : '$count productos listos para reusar.',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Text(
                    'CO₂',
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${(count * 12.4).toStringAsFixed(1)} kg',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final MaterialItem item;

  const _FavoriteCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final Color charcoalBlack = const Color(0xFF1A1A1A);
    final Color primaryGold = const Color(0xFFD4AF37);
    final imageUrl = item.imageUrls.isNotEmpty
        ? item.imageUrls.first
        : 'https://images.unsplash.com/photo-1545239351-1141bd82e8a6?auto=format&fit=crop&w=400&q=60';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MaterialDetailScreen(item: item),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(18),
              ),
              child: Stack(
                children: [
                  Image.network(
                    imageUrl,
                    width: 118,
                    height: 130,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: primaryGold, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            item.category.name.toUpperCase(),
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: charcoalBlack,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.recycling,
                                  size: 14, color: Colors.green),
                              const SizedBox(width: 6),
                              Text(
                                'Listo para reusar',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.green[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Icon(Icons.chevron_right,
                            color: Colors.grey[600], size: 22),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: charcoalBlack,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.grey[700],
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.06),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.place,
                                    size: 14, color: Colors.black87),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    item.locationDescription,
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          item.price == 0
                              ? 'Donación'
                              : '\$${item.price.toStringAsFixed(2)}',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: primaryGold,
                          ),
                        ),
                      ],
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

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 60),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: const Icon(Icons.favorite_border,
                color: Color(0xFF9A7B4F), size: 32),
          ),
          const SizedBox(height: 18),
          Text(
            'Todavía no hay favoritos',
            style: GoogleFonts.playfairDisplay(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Explora materiales y toca el corazón para guardarlos aquí.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
