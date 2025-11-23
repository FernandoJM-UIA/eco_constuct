import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/material_item.dart';
import '../providers/auth_provider.dart';
import '../routes/route_arguments.dart';
import '../widgets/detail/attribute_grid.dart';
import '../widgets/detail/detail_header.dart';
import '../widgets/detail/expandable_description.dart';
import '../widgets/detail/image_carousel.dart';
import '../widgets/detail/impact_section.dart';
import '../widgets/detail/location_card.dart';
import '../widgets/detail/product_info.dart';
import '../widgets/detail/quantity_selector.dart';
import '../widgets/detail/review_section.dart';
import '../widgets/detail/similar_products.dart';
import '../widgets/detail/sticky_action_bar.dart';

class MaterialDetailScreen extends StatefulWidget {
  final MaterialItem item;

  const MaterialDetailScreen({super.key, required this.item});

  @override
  State<MaterialDetailScreen> createState() => _MaterialDetailScreenState();
}

class _MaterialDetailScreenState extends State<MaterialDetailScreen> {
  late double _quantity;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _quantity = 1;
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = context.read<AuthProvider>().currentUser;
    final isOwner = currentUser?.id == widget.item.sellerId;
    final totalPrice = _quantity * widget.item.price;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Stack(
        children: [
          // Main Content
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero Image Carousel
              SliverToBoxAdapter(
                child: ImageCarousel(imageUrls: widget.item.imageUrls),
              ),

              // Content
              SliverToBoxAdapter(
                child: Container(
                  transform: Matrix4.translationValues(0, -24, 0),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFAFAFA),
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Info (Title, Price, Seller)
                        ProductInfo(item: widget.item),
                        const SizedBox(height: 24),

                        // Attribute Grid (Condition, Quantity, etc.)
                        AttributeGrid(item: widget.item),
                        const SizedBox(height: 24),

                        // Description
                        ExpandableDescription(
                            description: widget.item.description),
                        const SizedBox(height: 32),

                        // Location
                        LocationCard(
                          item: widget.item,
                          onViewMap: () {
                            Navigator.pushNamed(
                              context,
                              '/map',
                              arguments: MapScreenArgs(item: widget.item),
                            );
                          },
                        ),
                        const SizedBox(height: 32),

                        // Quantity Selector (Only if not owner)
                        if (!isOwner) ...[
                          QuantitySelector(
                            quantity: _quantity,
                            maxQuantity: widget.item.quantity,
                            unit: widget.item.unit,
                            pricePerUnit: widget.item.price,
                            onChanged: (value) =>
                                setState(() => _quantity = value),
                          ),
                          const SizedBox(height: 32),
                        ],

                        // Impact Section
                        const ImpactSection(),
                        const SizedBox(height: 32),

                        // Reviews
                        const ReviewSection(),
                        const SizedBox(height: 32),

                        // Similar Products (Mock Data)
                        SimilarProducts(items: [
                          widget.item,
                          widget.item
                        ]), // Mocking with same item

                        // Bottom Padding for Sticky Bar
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: DetailHeader(
                onBack: () => Navigator.pop(context),
                onShare: () {
                  // Implement share functionality
                },
                onFavorite: () => setState(() => _isFavorite = !_isFavorite),
                isFavorite: _isFavorite,
              ),
            ),
          ),

          // Sticky Action Bar
          if (!isOwner)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: StickyActionBar(
                totalPrice: totalPrice,
                onBuyNow: () {
                  Navigator.pushNamed(
                    context,
                    '/payment',
                    arguments: PaymentScreenArgs(material: widget.item),
                  );
                },
                onContactSeller: () {
                  Navigator.pushNamed(
                    context,
                    '/chat',
                    arguments: ChatScreenArgs(
                      otherUserId: widget.item.sellerId,
                      materialId: widget.item.id,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
