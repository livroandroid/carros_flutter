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
          markers: Set.of(_getMarkers()),
        ),
      ),
    );
  }

  // Retorna os marcores da tela.
  List<Marker> _getMarkers() {
    return [
      Marker(
        markerId: MarkerId("1"),
        position: carro.latlng(),
        infoWindow:
            InfoWindow(title: "Ferrari FF", snippet: "Fábrica da Ferrari"),
        onTap: () {
          print("> ${carro.nome}");
        },
      )
    ];
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }
}
