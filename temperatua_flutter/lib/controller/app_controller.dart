import 'package:flutter/foundation.dart';
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
import 'package:temperatua_flutter/view/initial_view.dart';

class AppController extends GetxController {
  Position? position;
  Temperatura? temperatura;
  late CoresAplicativo coresAplicativo;

  AppController() {
    coresAplicativo = CoresAplicativo();
    initializeDateFormatting('pt_BR', null);
    Intl.defaultLocale = 'pt_BR';
  }

  @override
  Future<void> onInit() async {
    position = await _determinePosition();
    await getAddressFromLatLng();
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

  Future getAddressFromLatLng(
      {bool mapaGoogle = false,
      double latitude = 0,
      double longitude = 0}) async {
    try {
      late List<Placemark> placemarks;
      if (!mapaGoogle) {
        placemarks = await placemarkFromCoordinates(
            position!.latitude, position!.longitude);
      } else {
        placemarks = await placemarkFromCoordinates(latitude, longitude);
      }

      Placemark place = placemarks[0];
      if (kDebugMode) {
        print(position);
      }
      if (!mapaGoogle) {
        temperatura = await HGWeatherService().getTemperaturaByLatLong(
            position!.latitude.toString(),
            position!.longitude.toString(),
            "543c7a0a");
      } else {
        temperatura = await HGWeatherService().getTemperaturaByLatLong(
            latitude.toString(), longitude.toString(), "543c7a0a");
      }
      if (temperatura != null) {
        temperatura!.iconCondition =
            _defineIconeTemperatura(temperatura!.condition);
        for (var item in temperatura!.forecast!) {
          final inputFormat = DateFormat('yyyy/dd/MM');
          DateTime inputDate = inputFormat.parse(
              '${DateTime.now().year}/${item.date.substring(0, 2)}/${item.date.substring(3, 5)}');
          String diaSemana =
              DateFormat('EEEE').format(inputDate).capitalize ?? "";
          item.dayWeek = diaSemana;
          item.iconCondition = _defineIconeTemperatura(item.condition);
        }
        Get.offAll(() => InitialView(
              temperatura: temperatura!,
              place: place,
              backgroundColor: temperatura!.currently == "noite"
                  ? coresAplicativo.noite
                  : coresAplicativo.dia,
              fontColor: temperatura!.currently == "noite"
                  ? coresAplicativo.corBranca
                  : coresAplicativo.corPreta,
            ));
      }
    } catch (e) {
      throw Exception();
    }
  }

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
