import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:temperatua_flutter/model/temperatura.dart';
import 'package:temperatua_flutter/view/mapa_view.dart';

class TemperaturaViewWidgetController extends GetxController {
  Position? position;
  late RxString txtPosition;
  late RxString txtTemperatura;
  late RxString txtAmanhecer;
  late RxString txtAnoitecer;
  late RxString txtVelocidadeVento;
  late Placemark place;
  late Temperatura temperatura;

  TemperaturaViewWidgetController(this.temperatura, this.place) {
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
      //Define o valor da variável posição, Nome Cidade + CEP + País
      txtPosition.value =
          "${temperatura.cityName}, ${place.postalCode}, ${place.country}";
      //Define o valor da variável temperatura, de acordo com o recebido
      txtTemperatura.value = temperatura.temp.toString();
      //Define o valor da variável amanhecer, de acordo com o recebido
      txtAmanhecer.value = temperatura.sunrise.toString();
      //Define o valor da variável anoitecer, de acordo com o recebido
      txtAnoitecer.value = temperatura.sunset.toString();
      //Define o valor da variável velocidade vento, se vier nula ele atribuirá em branco, de acordo com o recebido
      txtVelocidadeVento.value = temperatura.windSpeedy ?? "";
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //Função para o botão pesquisar localidade
  onPressedBtnPesquisar() {
    Get.to(MapaView(
        latitude: temperatura.latitude, longitude: temperatura.longitude));
  }
}
