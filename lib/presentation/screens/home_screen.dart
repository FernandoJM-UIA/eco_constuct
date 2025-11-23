import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/material_provider.dart';
import '../widgets/home/category_tabs.dart';
import '../widgets/home/hero_carousel.dart';
import '../widgets/home/home_bottom_nav_bar.dart';
import '../widgets/home/home_header.dart';
import '../widgets/home/material_card.dart';
import '../widgets/home/section_header.dart';
import '../widgets/ai/ai_chat_bubble.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'All',
    'Wood',
    'Metal',
    'Concrete',
    'Glass',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MaterialProvider>().loadMaterials();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the bottom safe area padding for responsive positioning
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Subtle Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Color(0xFFF9F9F9),
                  Color(0xFFF0F0F0),
                ],
              ),
            ),
          ),

          // Main Scrollable Content
          SafeArea(
            bottom: false,
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. Header
                const SliverToBoxAdapter(
                  child: HomeHeader(),
                ),

                // 2. Hero Carousel
                const SliverToBoxAdapter(
                  child: HeroCarousel(),
                ),

                const SliverGap(24),

                // 3. Category Navigation (Pills)
                SliverToBoxAdapter(
                  child: CategoryTabs(
                    categories: _categories,
                    selectedIndex: _selectedCategoryIndex,
                    onCategorySelected: (index) {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                      // Filter logic would go here
                    },
                  ),
                ),

                const SliverGap(32),

                // 4. Section Header
                SliverToBoxAdapter(
                  child: SectionHeader(
                    title: 'Curated for You',
                    actionText: 'View All →',
                    onActionTap: () {
                      // Navigate to view all
                    },
                  ),
                ),

                const SliverGap(16),

                // 5. Products Grid
                Consumer<MaterialProvider>(
                  builder: (context, provider, _) {
                    if (provider.status == MaterialLoadingStatus.loading) {
                      return const SliverToBoxAdapter(
                        child: Center(
                            child: Padding(
                          padding: EdgeInsets.all(32.0),
                          child: CircularProgressIndicator(),
                        )),
                      );
                    }

                    final items =
                        provider.materials; // Apply filter here if needed

                    if (items.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.0),
                            child: Text(
                              'No materials found.',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      );
                    }

                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 24,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.74,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = items[index];
                            return MaterialCard(item: item);
                          },
                          childCount: items.length,
                        ),
                      ),
                    );
                  },
                ),

                // Bottom Padding for Nav Bar
                const SliverGap(100),
              ],
            ),
          ),

          // 6. Floating Action Button (Optional - kept for specific requirement)
          Positioned(
            bottom: 100 + bottomPadding,
            right: 24,
            child: FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, '/addMaterial'),
              backgroundColor: const Color(0xFF1A1A1A),
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),

          // AI Chat Bubble (Movable)
          AiChatBubble(
            onTap: () => Navigator.pushNamed(context, '/aiChat'),
          ),

          // 7. Bottom Navigation Bar (Floating Glass)
          HomeBottomNavBar(
            activeIndex: 0,
            onHomePressed: () {},
            onFavoritesPressed: () {
              Navigator.pushReplacementNamed(context, '/favorites');
            },
            onChatPressed: () {
              Navigator.pushReplacementNamed(context, '/chatTab');
            },
            onAddPressed: () {
              // Signature action - maybe same as FAB or different
              Navigator.pushNamed(context, '/addMaterial');
            },
            onImpactPressed: () {
              Navigator.pushNamed(context, '/impact');
            },
          ),
        ],
      ),
    );
  }
}

class SliverGap extends StatelessWidget {
  final double size;
  const SliverGap(this.size, {super.key});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(child: SizedBox(height: size));
  }
}
