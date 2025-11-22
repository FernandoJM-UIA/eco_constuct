import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/material_item.dart';



class MapScreen extends StatefulWidget {
  final MaterialItem item;
  const MapScreen({super.key, required this.item});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // GoogleMapController? _controller; // Unused for now
  final bool _mapError = false;

  @override
  Widget build(BuildContext context) {
    final position = LatLng(widget.item.latitude, widget.item.longitude);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicación'),
        backgroundColor: Colors.green,
      ),
      body: _mapError
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('No se pudo cargar el mapa.'),
                  const Text('Verifique su clave de API de Google Maps.'),
                  const SizedBox(height: 16),
                  Text('Lat: ${widget.item.latitude}, Lon: ${widget.item.longitude}'),
                ],
              ),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(target: position, zoom: 15),
              markers: {
                Marker(
                  markerId: MarkerId(widget.item.id),
                  position: position,
                  infoWindow: InfoWindow(title: widget.item.name, snippet: widget.item.locationDescription),
                ),
              },
              onMapCreated: (controller) {
                // _controller = controller;
              },
            ),
    );
  }
}
