import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:temperatua_flutter/core/utils/cores_aplicativo.dart';
import 'package:temperatua_flutter/model/temperatura.dart';
import 'package:temperatua_flutter/service/hg_weather_service.dart';
import 'package:temperatua_flutter/view/temperatura_view_widget_view.dart';
import 'package:temperatua_flutter/view/widgets/alerts/generic_alert_dialog.dart';

//Controlador da view que antecede a inicial, aqui as informações são carregadas e enviadas à view inicial
class AppController extends GetxController {
  Position? position;
  Temperatura? temperatura;
  late CoresAplicativo coresAplicativo;
  late HGWeatherService _hgWeatherService;
  late BuildContext context;
  late RxBool isError;

  AppController(this.context) {
    coresAplicativo = CoresAplicativo();
    _hgWeatherService = HGWeatherService();
    isError = false.obs;
    initializeDateFormatting('pt_BR', null);
    Intl.defaultLocale = 'pt_BR';
  }

  @override
  Future<void> onInit() async {
    position = await _determinePosition();
    await getAddressFromLatLng();
    super.onInit();
  }

  Future<Position?> _determinePosition() async {
    try {
      //Verifica se a localização do dispotiviso está ligada, caso não esteja retorna erro
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw const FormatException(
            'Localização não está ativa no dispositivo');
      }

      //Checa a permissão de localização do dispositivo
      LocationPermission permission = await Geolocator.checkPermission();
      //Caso esteja negada tenta fazer uma nova requisição e se negada novamente retorna um erro
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw const FormatException(
              'Permissão para localização do dispositivo negada');
        }
      }

      //Verifica se a permissão está negada para sempre
      if (permission == LocationPermission.deniedForever) {
        throw const FormatException(
            'A permissão para localização do dispositivo está permanentemente negada, caso queira prosseguir com o uso do aplicativo é necessário ativar a permissão nas configuraõçes.');
      }

      //Caso nenhum dos cenários seja positivo o valor da posição atual é retornados
      return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } on FormatException catch (e) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return GenericAlertDialog(titulo: "Aviso", descricao: e.message);
        },
      );
      isError.value = true;
      return null;
    }
  }

  Future getAddressFromLatLng(
      {bool mapaGoogle = false,
      double latitude = 0,
      double longitude = 0}) async {
    try {
      late List<Placemark> placemarks;
      late Placemark place;
      //a variável placemarks terá uma lista com endereços baseados na latitude e longitude do usuário, o booleano indica se veio do mapa ou da tela inicial
      if (!mapaGoogle) {
        placemarks = await placemarkFromCoordinates(
            position!.latitude, position!.longitude);
      } else {
        placemarks = await placemarkFromCoordinates(latitude, longitude);
      }
      //A variável place é atribuída como o primeiro índice da lista de lugares
      place = placemarks[0];
      //A busca é feita na API para consultar a temperatura, caso venha da view do mapa as variáveis a serem usadas são diferentes
      if (!mapaGoogle) {
        temperatura = await _hgWeatherService.getTemperaturaByLatLong(
            position!.latitude.toString(), position!.longitude.toString());
      } else {
        temperatura = await _hgWeatherService.getTemperaturaByLatLong(
            latitude.toString(), longitude.toString());
      }
      //Caso não encontre a temperatura uma exceção é gerada
      if (temperatura == null) {
        throw const FormatException(
            "Não foi possível encontrar os dados desta localização");
      }
      //Define o ícone da temperatura atual, esse ícone é o exibido na primeira parte da view de temperatur
      temperatura!.iconCondition =
          _defineIconeTemperatura(temperatura!.condition);
      //Atribui o valor de latitude e longitude para o objeto de temperatura
      temperatura?.latitude = position != null ? position!.latitude : latitude;
      temperatura?.longitude =
          position != null ? position!.longitude : longitude;
      for (var item in temperatura!.forecast!) {
        //Define a data para depois identificar o dia da semana correspondente
        DateTime inputDate = DateFormat('yyyy/dd/MM').parse(
            '${DateTime.now().year}/${item.date.substring(0, 2)}/${item.date.substring(3, 5)}');
        //Atribui o diaSemana como String
        String diaSemana =
            DateFormat('EEEE').format(inputDate).capitalize ?? "";
        item.dayWeek = diaSemana;
        //Define o itemCondition
        item.iconCondition = _defineIconeTemperatura(item.condition);
      }
      //Vai para a view de temperatura, mandando todas as informações necessárias
      await Get.offAll(() => TemperaturaViewWidget(
            temperatura: temperatura!,
            place: place,
            backgroundColor: temperatura!.currently == "noite"
                ? coresAplicativo.noite
                : coresAplicativo.dia,
            fontColor: temperatura!.currently == "noite"
                ? coresAplicativo.corBranca
                : coresAplicativo.corPreta,
          ));
    } on FormatException catch (e) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return GenericAlertDialog(titulo: "Aviso", descricao: e.message);
        },
      );
      isError.value = true;
      return null;
    } catch (e) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const GenericAlertDialog(
              titulo: "Aviso",
              descricao:
                  "Aconteceu algo de errado, tente novamente mais tarde");
        },
      );
      isError.value = true;
      return null;
    }
  }

  //Função criada para atribuir valor ao ícone de acordo com o valor da condição que vem da API
  IconData _defineIconeTemperatura(String condicao) {
    switch (condicao) {
      //Chuva
      case "rain":
        return FontAwesomeIcons.cloudRain;
      //Tempestade
      case "storm":
        return FontAwesomeIcons.pooStorm;
      //Neve
      case "snow":
        return FontAwesomeIcons.snowflake;
      //Granizo
      case "hail":
        return FontAwesomeIcons.snowflake;
      //Neblina
      case "fog":
        return FontAwesomeIcons.smog;
      //Dia Limpo
      case "clear_day":
        return FontAwesomeIcons.sun;
      //Noite Limpa
      case "clear_night":
        return FontAwesomeIcons.moon;
      //Nublado
      case "cloud":
        return FontAwesomeIcons.cloud;
      //Nublado de dia
      case "cloudly_day":
        return FontAwesomeIcons.cloudSun;
      //Nublado de noite
      case "cloudly_night":
        return FontAwesomeIcons.cloudMoon;
      //Dia
      case "none_day":
        return FontAwesomeIcons.sun;
      //Noite
      case "none_night":
        return FontAwesomeIcons.moon;
      default:
        return FontAwesomeIcons.moon;
    }
  }
}
