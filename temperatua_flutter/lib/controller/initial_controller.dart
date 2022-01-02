import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:temperatua_flutter/model/temperatura.dart';

class InitialController extends GetxController {
  Position? position;
  late RxString txtPosition;
  late RxString txtTemperatura;
  late RxString txtAmanhecer;
  late RxString txtAnoitecer;
  late RxString txtVelocidadeVento;
  late Placemark place;
  late Temperatura temperatura;

  InitialController(this.temperatura, this.place) {
    txtPosition = "".obs;
    txtTemperatura = "".obs;
    txtAmanhecer = "".obs;
    txtAnoitecer = "".obs;
    txtVelocidadeVento = "".obs;
  }

  @override
  Future<void> onInit() async {
    await getAddressFromLatLng();
    super.onInit();
  }

  Future getAddressFromLatLng() async {
    try {
      txtPosition.value =
          "${temperatura.cityName}, ${place.postalCode}, ${place.country}";
      txtTemperatura.value = temperatura.temp.toString();
      txtAmanhecer.value = temperatura.sunrise.toString();
      txtAnoitecer.value = temperatura.sunset.toString();
      txtVelocidadeVento.value = temperatura.windSpeedy ?? "";
      if (kDebugMode) {
        print(temperatura.toJson());
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
