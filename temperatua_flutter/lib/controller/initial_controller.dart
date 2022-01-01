import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:temperatua_flutter/model/temperatura.dart';
import 'package:temperatua_flutter/service/hg_weather_service.dart';

class InitialController extends GetxController {
  Position? position;
  late RxString txtPosition;
  late RxString txtTemperatura;
  late RxString txtAmanhecer;
  late RxString txtAnoitecer;
  Temperatura? temperatura;

  InitialController() {
    txtPosition = "".obs;
    txtTemperatura = "".obs;
    txtAmanhecer = "".obs;
    txtAnoitecer = "".obs;
  }

  @override
  Future<void> onInit() async {
    position = await _determinePosition();
    txtPosition.value =
        "Latitude: ${position?.latitude} | Longitude: ${position?.longitude}";
    super.onInit();
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position!.latitude, position!.longitude);

      Placemark place = placemarks[0];
      if (kDebugMode) {
        print(position);
      }
      txtPosition.value =
          "${place.subAdministrativeArea}, ${place.postalCode}, ${place.country}";
      temperatura = await HGWeatherService().getTemperaturaByLatLong(
          position!.latitude.toString(),
          position!.longitude.toString(),
          "543c7a0a");
      if (temperatura != null) {
        txtTemperatura.value = temperatura!.temp.toString();
        txtAmanhecer.value = temperatura!.sunrise.toString();
        txtAnoitecer.value = temperatura!.sunset.toString();
      }
      if (kDebugMode) {
        print(temperatura?.toJson());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
