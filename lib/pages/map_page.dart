
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

  get carro => widget.carro;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(carro.nome),
      ),
      body: Container(
        child: GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(-25.429087, -49.310993)),
          onMapCreated: _onMapCreated,
        ),
      ),

    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() { mapController = controller; });
  }
}
