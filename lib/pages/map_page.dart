import 'package:carros/domain/carro.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final Carro carro;

  MapPage(this.carro);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController mapController;

  Carro get carro => widget.carro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(carro.nome),
      ),
      body: Container(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: carro.latlng(),
            zoom: 12,
          ),
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
          zoomGesturesEnabled: true,
        ),
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      mapController.addMarker(MarkerOptions(
          position: carro.latlng(),
          infoWindowText: InfoWindowText("Ferrari FF", "Fábrica da Ferrari")
      ));
    });
  }

  // se quiser testar...
  LatLng curitiba() => LatLng(-25.429087, -49.310993);
}
