import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class DetailPage extends StatefulWidget {
  const DetailPage(
      {super.key, required this.title, required this.lat, required this.lng});

  final String title;
  final double lat;
  final double lng;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: content(widget.lat, widget.lng),
      );
  }

  Widget content(double lat, double lng) {
    return FlutterMap(
        options: MapOptions(
            initialCenter: LatLng(lat, lng),
            initialZoom: 5,
            interactionOptions: const InteractionOptions(
                flags: ~InteractiveFlag.doubleTapZoom)),
        children: [
          openStreetMapLayer,
          MarkerLayer(markers: [
            Marker(
                point: LatLng(lat, lng),
                width: 60,
                height: 60,
                alignment: Alignment.center,
                child:
                    const Icon(Icons.location_pin, size: 60, color: Colors.red))
          ])
        ]);
  }

  TileLayer get openStreetMapLayer => TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
      );
}
