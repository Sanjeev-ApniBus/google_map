# Custom Info Window in Google Maps with Flutter

This documentation outlines the process of creating a custom info window in a Google Maps application using Flutter. In this implementation, the custom info window is updated without requiring the user to click on the marker again.

## Overview

The example Flutter project includes the use of the `google_maps_flutter` package for integrating Google Maps. Additionally, it utilizes the `custom_info_window` package for creating a custom info window that can be dynamically updated.

## Project Structure

The project is organized into the following main components:

1. **CustomInfoWindowBloc**: This is a Bloc (Business Logic Component) responsible for managing the state of the custom info window. It emits a state when the `CustomInfoChangeEvent` is triggered, and the emitted state includes the updated luggage count.

```dart
class CustomInfoWindowBloc extends Bloc<CustomInfoWindowEvent, CustomInfoWindowState> {
  // Bloc implementation
}
```
2. **CustomInfoWindowEvent**: This file defines the events that can trigger state changes in the `CustomInfoWindowBloc`. In this case, it includes the `CustomInfoChangeEvent` that is dispatched when the luggage count needs to be updated.
```dart
part of 'custom_info_window_bloc.dart';

@immutable
abstract class CustomInfoWindowEvent {}

class CustomInfoChangeEvent extends CustomInfoWindowEvent {
  // Event to update luggage count
  final int value;

  CustomInfoChangeEvent({required this.value});
}
```
3. **CustomInfoWindowState**: This file defines the states that the CustomInfoWindowBloc can emit. The CustomInfoWindowChange state includes the updated luggage count.
```dart
part of 'custom_info_window_bloc.dart';

@immutable
abstract class CustomInfoWindowState {}

class CustomInfoWindowChange extends CustomInfoWindowState {
  // State to represent the updated luggage count
  final int Luggage;

  CustomInfoWindowChange({required this.Luggage});
}

```
4. **CustomInfoWindowExample**: The main widget where the Google Map and the custom info window are displayed. It uses the CustomInfoWindowController to control the visibility and content of the info window. The luggage count is updated periodically using a timer.
```dart
class CustomInfoWindowExample extends StatefulWidget {
  // Main widget for the Google Map and custom info window
}

```

5. **DemoMarkerInfoWindow**: This widget represents the content of the custom info window. It is updated based on the state emitted by the CustomInfoWindowBloc.
```dart
class DemoMarkerInfoWindow extends StatefulWidget {
  // Widget for the content of the custom info window
}

```
# Implementation Details

## Bloc Pattern
The project follows the Bloc pattern for state management. The `CustomInfoWindowBloc` handles the business logic related to the custom info window and emits states when there are updates.

## Periodic Updates
The luggage count is updated periodically using a timer in the `CustomInfoWindowExample` widget. This is achieved by dispatching the `CustomInfoChangeEvent` with an incremented value.

## Custom Info Window
The `custom_info_window` package is used to create a custom info window. The `CustomInfoWindowController` is used to control the visibility and content of the info window. The content is updated based on the state emitted by the `CustomInfoWindowBloc`.

## Marker Interaction
The marker on the map is configured to show the custom info window when tapped. The `onTap` callback of the marker triggers the display of the info window with the updated content.


# Usage
To use and adapt this code for your project, follow these steps:

## Add Dependencies
Make sure to include the necessary dependencies in your `pubspec.yaml` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_maps_flutter: ^2.0.10
  custom_info_window: ^2.0.0
  bloc: ^7.0.0
```

## CustomInfoWindowExample Widget

<details>
  <summary><b>Click to expand</b></summary>

```dart
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
            if(Counter > 9999){
              Counter = 0;
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
```
</details>


# Create Bloc
Implement a Bloc for managing the state of the custom info window. Customize the events and states based on your requirements.

# Update UI
Modify the `CustomInfoWindowExample` widget to suit your application. Adjust the content of the custom info window (`DemoMarkerInfoWindow`) based on the information you want to display.

# Handle Marker Taps
Customize the behavior when a marker is tapped to show the custom info window. You can use gestures, map events, or other triggers based on your application's requirements.

# Periodic Updates
If you need periodic updates, use a timer or a similar mechanism to dispatch events and update the state accordingly.

# Conclusion
This documentation provides a guide for creating a custom info window in a Google Maps Flutter application. By following the provided code structure and adapting it to your needs, you can implement a dynamic and interactive info window in your map-based applications.

