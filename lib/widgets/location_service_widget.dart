import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:autogestion_tecnico/global/globals.dart';

class LocationServiceWidget extends StatefulWidget {
  final Function(String) onLocationSelected;

  const LocationServiceWidget({Key? key, required this.onLocationSelected})
      : super(key: key);

  @override
  _LocationServiceWidgetState createState() => _LocationServiceWidgetState();
}

class _LocationServiceWidgetState extends State<LocationServiceWidget> {
  final Location _locationService = Location();
  String _locationInfo = '';

  Future<void> _selectLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Verificar si el servicio de ubicación está habilitado
    serviceEnabled = await _locationService.serviceEnabled();
    print("Servicio de ubicación habilitado: $serviceEnabled");
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      print("Servicio de ubicación habilitado tras solicitud: $serviceEnabled");
      if (!serviceEnabled) {
        setState(() {
          _locationInfo = 'El servicio de ubicación no está habilitado.';
        });
        return;
      }
    }

    // Verificar si los permisos están otorgados
    permissionGranted = await _locationService.hasPermission();
    print("Permiso de ubicación concedido: $permissionGranted");
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
      print("Permiso de ubicación tras solicitud: $permissionGranted");
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          _locationInfo = 'Permisos de ubicación denegados.';
        });
        return;
      }
    }

    // Obtener la ubicación actual
    try {
      LocationData locationData = await _locationService.getLocation();
      print(
          "Datos de ubicación obtenidos: ${locationData.latitude}, ${locationData.longitude}");

      // Añadir más información de depuración
      print("Accuracy: ${locationData.accuracy}");
      print("Altitude: ${locationData.altitude}");
      print("Speed: ${locationData.speed}");

      LatLng selectedLocation =
          LatLng(locationData.latitude!, locationData.longitude!);

      // Obtener la dirección mediante geocodificación inversa
      List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        selectedLocation.latitude,
        selectedLocation.longitude,
      );

      // Verifica si se encontró una dirección
      if (placemarks.isNotEmpty) {
        geo.Placemark place = placemarks.first;
        String address =
            //'${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
            '${place.administrativeArea}, ${place.locality}, ${place.street}';

        // setState(() {
        //   _locationInfo = address;
        // });

        // Devuelve la dirección seleccionada
        widget.onLocationSelected(address);
      } else {
        setState(() {
          _locationInfo =
              'No se pudo obtener la dirección. Inténtelo de nuevo.';
        });
      }
    } catch (e) {
      print("Error al obtener la ubicación: $e");
      setState(() {
        _locationInfo = 'Error al obtener la ubicación: $e';
      });
    }
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Column(
  //     children: [
  //       ElevatedButton(
  //         onPressed: _selectLocation,
  //         child: const Text('Seleccionar ubicación'),
  //       ),
  //       const SizedBox(height: 8),
  //       Text(_locationInfo),
  //     ],
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: _selectLocation,
          child: const Text(
            'Geolocalizar',
            style: TextStyle(color: Colors.white), // Color del texto
          ),
          style: ElevatedButton.styleFrom(
            primary: blueColor, // Color de fondo del botón
            onPrimary: Colors.white, // Color del texto cuando se presiona
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 11), // Padding del botón
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5), // Borde redondeado
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(_locationInfo),
      ],
    );
  }
}

class LatLng {
  final double latitude;
  final double longitude;

  LatLng(this.latitude, this.longitude);
}
