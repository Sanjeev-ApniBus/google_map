import 'dart:async';

import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'bloc/custom_info_window_bloc.dart';

class CustomInfoWindowExample extends StatefulWidget {
  const CustomInfoWindowExample({Key? key});

  @override
  _CustomInfoWindowExampleState createState() => _CustomInfoWindowExampleState();
}

class _CustomInfoWindowExampleState extends State<CustomInfoWindowExample> {
  static int Counter = 0;
  final CustomInfoWindowController _customInfoWindowController = CustomInfoWindowController();

  final LatLng _latLng = const LatLng(28.7041, 77.1025);

  final Set<Marker> _markers = {};

  @override
  void dispose() {
    _customInfoWindowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _markers.add(
      Marker(
        markerId: const MarkerId("marker_id_2"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        position: _latLng,
        onTap: () {
          _customInfoWindowController.addInfoWindow!(
            const DemoMarkerInfoWindow(LuggageCount: 10, BoardedCount: 20, DeboardedCount: 12,),
            _latLng,
          );
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Info Window Example'),
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Timer.periodic(const Duration(milliseconds: 2), (timer) {
            if(Counter>9999){
              Counter=0;
            }
            BlocProvider.of<CustomInfoWindowBloc>(context).add(CustomInfoChangeEvent(value: Counter++));
          });
          print("Markers After After:  ${_markers.length}");
        },
      ),
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onTap: (_) {
              _customInfoWindowController.hideInfoWindow!();
            },
            onCameraMove: (_) {
              _customInfoWindowController.onCameraMove!();
            },
            onMapCreated: (GoogleMapController controller) {
              _customInfoWindowController.googleMapController = controller;
            },
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: _latLng,
              zoom: 15.0,
            ),
          ),
          CustomInfoWindow(
            controller: _customInfoWindowController,
            height: 75,
            width: 200,
            offset: 50,
          ),
        ],
      ),
    );
  }
}


class DemoMarkerInfoWindow extends StatefulWidget {
  final int LuggageCount, BoardedCount, DeboardedCount;

  const DemoMarkerInfoWindow({
    Key? key,
    required this.LuggageCount,
    required this.BoardedCount,
    required this.DeboardedCount,
  }) : super(key: key);

  @override
  _DemoMarkerInfoWindowState createState() => _DemoMarkerInfoWindowState();
}

class _DemoMarkerInfoWindowState extends State<DemoMarkerInfoWindow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.84, color: Color(0xFF16A0F9)),
          borderRadius: BorderRadius.circular(7.54),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x1C000000),
            blurRadius: 3.35,
            offset: Offset(0, 3.35),
            spreadRadius: 0,
          )
        ],
      ),
      child: BlocBuilder<CustomInfoWindowBloc, CustomInfoWindowState>(
        builder: (context, state) {
          if (state is CustomInfoWindowChange) {
            return Column(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: const EdgeInsets.all(10),
                              decoration: const ShapeDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.97, -0.24),
                                  end: Alignment(-0.97, 0.24),
                                  colors: [Color(0x384D51AA), Color(0x004D51AA)],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.29),
                                    topRight: Radius.circular(5.29),
                                  ),
                                ),
                              ),
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ' लगेज  : ${state.Luggage}',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'चढ़े  : ${widget.BoardedCount}',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    'उतरे  : ${widget.DeboardedCount}',
                                    textAlign: TextAlign.right,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 12,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
          }else{
            return Column(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: const ShapeDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.97, -0.24),
                        end: Alignment(-0.97, 0.24),
                        colors: [Color(0x384D51AA), Color(0x004D51AA)],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.29),
                          topRight: Radius.circular(5.29),
                        ),
                      ),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          ' लगेज  : ${widget.LuggageCount}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'चढ़े  : ${widget.BoardedCount}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'उतरे  : ${widget.DeboardedCount}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );

          }
        },
      ),
    );
  }
}
