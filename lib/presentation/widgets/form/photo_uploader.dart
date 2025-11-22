import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhotoUploader extends StatelessWidget {
  final List<String> photos;
  final VoidCallback onTakePhoto;
  final VoidCallback onUploadGallery;
  final Function(int) onRemovePhoto;

  const PhotoUploader({
    super.key,
    required this.photos,
    required this.onTakePhoto,
    required this.onUploadGallery,
    required this.onRemovePhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'MATERIAL PHOTOS',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey[500],
                letterSpacing: 1.2,
              ),
            ),
            Text(
              '${photos.length}/7',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.grey[400],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Clear photos increase trust and improve visibility',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              // Take Photo Button
              _buildActionButton(
                icon: Icons.camera_alt_outlined,
                label: 'Take Photo',
                onTap: onTakePhoto,
              ),
              const SizedBox(width: 12),
              // Upload Button
              _buildActionButton(
                icon: Icons.image_outlined,
                label: 'Gallery',
                onTap: onUploadGallery,
              ),
              const SizedBox(width: 16),
              // Photo List
              ...photos.asMap().entries.map((entry) {
                final index = entry.key;
                final path = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildPhotoCard(path, () => onRemovePhoto(index)),
                );
              }),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: const Color(0xFF1A1A1A), size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoCard(String path, VoidCallback onRemove) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(path), // Assuming URL for now, change to FileImage if local
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
        ),
        Positioned(
          top: -4,
          right: -4,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.red),
            ),
          ),
        ),
      ],
    );
  }
}
