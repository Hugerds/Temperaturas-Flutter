import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:temperatua_flutter/controller/app_controller.dart';

class MapaController extends GetxController {
  late double latitude;
  late double longitude;
  late GoogleMapController googleMapController;
  late Set<Marker> markers;
  late AppController appController;
  late RxBool carregando;
  late BuildContext context;

  //Construtor, recebe os parâmetros e seta a posição inicial das variáveis e do marcados do mapa
  MapaController(this.latitude, this.longitude, this.context) {
    carregando = false.obs;
    appController = AppController(context);
    markers = {};
    LatLng posicaoTemperatura = LatLng(latitude, longitude);
    final Marker marker = Marker(
        position: posicaoTemperatura,
        infoWindow: const InfoWindow(title: "Localização Atual"),
        markerId: const MarkerId('1'));
    markers.add(marker);
  }

  //Função para sempre que for identificado um clique no mapa
  void onTapMap(LatLng position) {
    latitude = position.latitude;
    longitude = position.longitude;
    final Marker marker = Marker(
        position: position,
        infoWindow: const InfoWindow(title: "Localização Atual"),
        markerId: const MarkerId('1'));
    markers.clear();
    markers.add(marker);
    update(['mapa']);
  }

  //Função para o botão Buscar Temperatura
  Future onPressedTemperatura() async {
    try {
      carregando.value = true;
      await appController.getAddressFromLatLng(
          latitude: latitude, longitude: longitude, mapaGoogle: true);
      carregando.value = false;
    } catch (e) {
      carregando.value = false;
    }
  }
}
