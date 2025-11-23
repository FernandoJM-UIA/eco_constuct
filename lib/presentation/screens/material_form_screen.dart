import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/material_item.dart';
import '../providers/auth_provider.dart';
import '../providers/material_provider.dart';
import '../widgets/form/action_button.dart';
import '../widgets/form/condition_selector.dart';
import '../widgets/form/glass_container.dart';
import '../widgets/form/photo_uploader.dart';
import '../widgets/form/premium_dropdown.dart';
import '../widgets/form/premium_input_field.dart';

class MaterialFormScreen extends StatefulWidget {
  const MaterialFormScreen({super.key});

  @override
  State<MaterialFormScreen> createState() => _MaterialFormScreenState();
}

class _MaterialFormScreenState extends State<MaterialFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _unitController = TextEditingController(text: 'kg');
  final _priceController = TextEditingController();
  final _locationDescController = TextEditingController();

  MaterialCategory? _selectedCategory;
  String? _selectedSubCategory;
  MaterialCondition _selectedCondition = MaterialCondition.newUnused;
  List<String> _photos = []; // Placeholder for photo paths/urls
  bool _isSubmitting = false;

  // Mock Subcategories (Ideally this comes from a repository or constant)
  final Map<MaterialCategory, List<String>> _subCategories = {
    MaterialCategory.electrical: [
      'Connectors',
      'Switches',
      'Wires & Cables',
      'Breakers',
      'Electrical Panels',
      'Transformers',
      'Conduits & Trays',
      'Lighting Fixtures',
      'Sockets & Outlets',
      'Sensors'
    ],
    MaterialCategory.hydraulic: [
      'Pipes (PVC, Copper, HDPE, Steel)',
      'Valves',
      'Pumps',
      'Water Tanks',
      'Drains & Traps',
      'Fittings & Couplings',
      'Filters',
      'Manholes',
      'Irrigation Components'
    ],
    MaterialCategory.signalCommunication: [
      'Traffic Lights',
      'Controllers',
      'Network Cables',
      'Routers & Switches',
      'Antennas',
      'CCTV Cameras',
      'Alarms',
      'Sensors'
    ],
    MaterialCategory.wood: [
      'Beams',
      'Boards / Planks',
      'MDF / Plywood',
      'Doors',
      'Window Frames',
      'Pallets',
      'Formwork Panels',
      'Wood Flooring'
    ],
    MaterialCategory.glass: [
      'Tempered',
      'Laminated',
      'Windows',
      'Facades',
      'Glass Blocks',
      'Mirrors',
      'Shower Panels',
      'Skylights'
    ],
    MaterialCategory.metal: [
      'Steel Beams',
      'Aluminum Sheets',
      'Rebars',
      'Pipes',
      'Metal Plates',
      'Roofing Sheets',
      'Wire Mesh',
      'Handrails'
    ],
    MaterialCategory.concreteMasonry: [
      'Blocks',
      'Bricks',
      'Cement',
      'Precast Panels',
      'Slabs',
      'Tiles',
      'Mortar',
      'Aggregates'
    ],
    MaterialCategory.other: [
      'Insulation',
      'Drywall',
      'Roof Shingles',
      'Composite Panels',
      'Plastic Sheets',
      'Rubber',
      'Reusable Waste',
      'Mixed Materials'
    ],
  };

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    _priceController.dispose();
    _locationDescController.dispose();
    super.dispose();
  }

  void _saveMaterial() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a category')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final currentUser = context.read<AuthProvider>().currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: User not identified')),
      );
      setState(() => _isSubmitting = false);
      return;
    }

    final quantity =
        double.tryParse(_quantityController.text.replaceAll(',', '.')) ?? 0;
    final price =
        double.tryParse(_priceController.text.replaceAll(',', '.')) ?? 0;

    final item = MaterialItem(
      id: const Uuid().v4(),
      name: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _selectedCategory!,
      subCategory: _selectedSubCategory,
      condition: _selectedCondition,
      quantity: quantity,
      unit: _unitController.text.trim(),
      price: price,
      locationDescription: _locationDescController.text.trim(),
      latitude: 0.0, // Placeholder for now
      longitude: 0.0, // Placeholder for now
      sellerId: currentUser.id,
      createdAt: DateTime.now(),
      imageUrls: _photos,
    );

    final success = await context.read<MaterialProvider>().addMaterial(item);

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your material is now live.')),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error publishing material')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Very light warm gray
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFAFAFA), // Cream White
                  Color(0xFFF0F0F0), // Light Warm Gray
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CREATE',
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2.0, // Increased letter spacing
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Title with shadow
                          Text(
                            'List a new material',
                            style: GoogleFonts.playfairDisplay(
                              fontSize: 27, // Increased by ~12%
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A1A1A),
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.08),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Subtle gradient underline
                          Container(
                            height: 2.5,
                            width: 120, // ~50% of title width
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  const Color(0xFFD4AF37), // Primary gold
                                  const Color(0xFFD4AF37).withOpacity(0.0),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              size: 20, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),

                // Form Content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          GlassContainer(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Title
                                PremiumInputField(
                                  label: 'Title',
                                  placeholder: 'Enter material title',
                                  controller: _titleController,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Required'
                                      : null,
                                ),
                                const SizedBox(height: 24),

                                // Description
                                PremiumInputField(
                                  label: 'Description',
                                  placeholder:
                                      'Describe the material, measurements, history, etc.',
                                  controller: _descriptionController,
                                  isMultiline: true,
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Required'
                                      : null,
                                ),
                                const SizedBox(height: 24),

                                // Category
                                PremiumDropdown<MaterialCategory>(
                                  label: 'Category',
                                  value: _selectedCategory,
                                  items: MaterialCategory.values.map((c) {
                                    // Convert enum to display text (e.g., concreteMasonry -> Concrete & Masonry)
                                    String text = c.toString().split('.').last;
                                    // Simple formatting for display
                                    text = text[0].toUpperCase() +
                                        text.substring(1);
                                    // Handle special cases if needed
                                    return DropdownMenuItem(
                                        value: c, child: Text(text));
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCategory = value;
                                      _selectedSubCategory =
                                          null; // Reset subcategory
                                    });
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Subcategory
                                PremiumDropdown<String>(
                                  label: 'Subcategory',
                                  value: _selectedSubCategory,
                                  isEnabled: _selectedCategory != null,
                                  items: _selectedCategory != null
                                      ? _subCategories[_selectedCategory]!
                                          .map((s) {
                                          return DropdownMenuItem(
                                              value: s, child: Text(s));
                                        }).toList()
                                      : [],
                                  onChanged: (value) {
                                    setState(
                                        () => _selectedSubCategory = value);
                                  },
                                ),
                                const SizedBox(height: 24),

                                // Condition
                                ConditionSelector(
                                  selectedCondition: _selectedCondition,
                                  onConditionSelected: (c) =>
                                      setState(() => _selectedCondition = c),
                                ),
                                const SizedBox(height: 32),

                                // Material Details Section
                                Text(
                                  'MATERIAL DETAILS',
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[500],
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Top row: Quantity + Unit
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2)),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 3,
                                        child: TextFormField(
                                          controller: _quantityController,
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          decoration: InputDecoration(
                                            labelText: 'Quantity',
                                            border: InputBorder.none,
                                            labelStyle: GoogleFonts.inter(
                                                color: Colors.grey[500]),
                                          ),
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      Container(
                                          width: 1,
                                          height: 40,
                                          color: Colors.grey.withOpacity(0.3)),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        flex: 2,
                                        child: DropdownButtonFormField<String>(
                                          value: _unitController.text.isEmpty
                                              ? 'kg'
                                              : _unitController.text,
                                          decoration: InputDecoration(
                                            labelText: 'Unit',
                                            border: InputBorder.none,
                                            labelStyle: GoogleFonts.inter(
                                                color: Colors.grey[500],
                                                fontSize: 12),
                                            contentPadding: EdgeInsets.zero,
                                          ),
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              color: const Color(0xFF1A1A1A)),
                                          dropdownColor: Colors.white,
                                          icon: Icon(Icons.keyboard_arrow_down,
                                              color: Colors.grey[600],
                                              size: 16),
                                          isDense: true,
                                          isExpanded: true,
                                          items: const [
                                            DropdownMenuItem(
                                                value: 'kg', child: Text('kg')),
                                            DropdownMenuItem(
                                                value: 'g', child: Text('g')),
                                            DropdownMenuItem(
                                                value: 'tons',
                                                child: Text('tons')),
                                            DropdownMenuItem(
                                                value: 'units',
                                                child: Text('units')),
                                            DropdownMenuItem(
                                                value: 'boxes',
                                                child: Text('boxes')),
                                            DropdownMenuItem(
                                                value: 'liters',
                                                child: Text('liters')),
                                            DropdownMenuItem(
                                                value: 'meters',
                                                child: Text('meters')),
                                            DropdownMenuItem(
                                                value: 'cm',
                                                child: Text('cm')),
                                            DropdownMenuItem(
                                                value: 'rolls',
                                                child: Text('rolls')),
                                            DropdownMenuItem(
                                                value: 'pallets',
                                                child: Text('pallets')),
                                            DropdownMenuItem(
                                                value: 'other',
                                                child: Text('other')),
                                          ],
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                _unitController.text = value;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),
                                // Bottom row: Price (full width)
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2)),
                                  ),
                                  child: TextFormField(
                                    controller: _priceController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    decoration: InputDecoration(
                                      labelText: 'Price (0 = Donation)',
                                      border: InputBorder.none,
                                      labelStyle: GoogleFonts.inter(
                                          color: Colors.grey[500]),
                                    ),
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFD4AF37)),
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Photos
                                PhotoUploader(
                                  photos: _photos,
                                  onTakePhoto: () {
                                    // Implement photo taking logic
                                    setState(() {
                                      _photos.add(
                                          'https://via.placeholder.com/150'); // Mock
                                    });
                                  },
                                  onUploadGallery: () {
                                    // Implement gallery upload logic
                                    setState(() {
                                      _photos.add(
                                          'https://via.placeholder.com/150'); // Mock
                                    });
                                  },
                                  onRemovePhoto: (index) {
                                    setState(() {
                                      _photos.removeAt(index);
                                    });
                                  },
                                ),
                                const SizedBox(height: 32),

                                // Location (Simplified)
                                PremiumInputField(
                                  label: 'Location',
                                  placeholder: 'Enter material location',
                                  controller: _locationDescController,
                                  suffixIcon: const Icon(Icons.place,
                                      color: Colors.grey),
                                  validator: (v) => v == null || v.isEmpty
                                      ? 'Required'
                                      : null,
                                ),
                                const SizedBox(height: 40),

                                // Action Button
                                ActionButton(
                                  text: 'Publish Material',
                                  onPressed: _saveMaterial,
                                  isLoading: _isSubmitting,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40), // Bottom spacing
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
