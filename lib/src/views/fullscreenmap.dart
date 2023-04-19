import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;

class FullScreenMap extends StatefulWidget {
  const FullScreenMap({super.key});

  @override
  State<FullScreenMap> createState() => _FullScreenMapState();
}

class _FullScreenMapState extends State<FullScreenMap> {
  MapboxMapController? mapController;

  var isLight = true;
  final center = LatLng(4.687951, -74.060233);
  String selectedStyle = 'mapbox://styles/realis09/clgo2nnxx007h01qg97q9hmlk';
  final monocromatic = 'mapbox://styles/realis09/clgo2hqso008101qn0efqebxu';
  final streetStyle = 'mapbox://styles/realis09/clgo2nnxx007h01qg97q9hmlk';

  _onMapCreated(MapboxMapController controller) {
    mapController = controller;
    _onStyleLoaded();
  }

  void _onStyleLoaded() {
    addImageFromAsset("assetImage", "assets/custom-icon.png");
    addImageFromUrl(
        "networkImage", Uri.parse("https://via.placeholder.com/50"));
  }

  Future<void> addImageFromAsset(String name, String assetName) async {
    final ByteData bytes = await rootBundle.load(assetName);
    final Uint8List list = bytes.buffer.asUint8List();
    return mapController!.addImage(name, list);
  }

  /// Adds a network image to the currently displayed style
  Future<void> addImageFromUrl(String name, Uri uri) async {
    var response = await http.get(uri);
    return mapController!.addImage(name, response.bodyBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: crearMapa(),
      // Cambiar estilo
      floatingActionButton: botonesFlotantes(),
    );
  }

  Column botonesFlotantes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        //Simbolos
        FloatingActionButton(
          onPressed: () {
            mapController?.addSymbol(SymbolOptions(
                geometry: center,
                iconImage: 'networkImage',
                textColor: '#FF0000',
                // iconSize: 3,
                textField: 'Montaña',
                textOffset: Offset(0, 2)));
          },
          child: Icon(Icons.sentiment_satisfied_alt_outlined),
        ),

        SizedBox(height: 5),
        //Zoom in
        FloatingActionButton(
          onPressed: () {
            mapController?.animateCamera(CameraUpdate.zoomIn());
          },
          child: Icon(Icons.zoom_in),
        ),
        SizedBox(height: 5),

        //Zoom out
        FloatingActionButton(
          onPressed: () {
            mapController?.animateCamera(CameraUpdate.zoomOut());
          },
          child: Icon(Icons.zoom_out),
        ),
        SizedBox(height: 8),
        FloatingActionButton(
            child: Icon(Icons.add_to_home_screen),
            onPressed: () {
              if (selectedStyle == monocromatic) {
                selectedStyle = streetStyle;
              } else {
                selectedStyle = monocromatic;
              }
              _onStyleLoaded();
              setState(() {});
            })
      ],
    );
  }

  MapboxMap crearMapa() {
    return MapboxMap(
        styleString: selectedStyle,
        accessToken:
            'sk.eyJ1IjoicmVhbGlzMDkiLCJhIjoiY2xnbnp4ZHVpMGwzcTNnbXJvdmN6eWQyOSJ9.hmT32yEeoBO8oPByVadOvw',
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(target: center, zoom: 14.0));
  }
}
