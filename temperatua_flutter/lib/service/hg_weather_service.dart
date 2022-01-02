import 'package:get/get.dart';
import 'package:temperatua_flutter/model/temperatura.dart';

class HGWeatherService extends GetConnect {
  HGWeatherService() {
    httpClient.timeout = const Duration(seconds: 30);
  }

  Future<Temperatura?> getTemperaturaByLatLong(
      String latitude, String longitude, String key) async {
    try {
      const url = "https://api.hgbrasil.com/weather";
      Response retorno = await httpClient.get(url, query: {
        "fields":
            "only_results,temp,city_name,condition_slug, currently, forecast,max,min,date,sunrise,sunset,wind_speedy,condition",
        "key": key,
        "lat": latitude,
        "lon": longitude
      });
      if (retorno.hasError || retorno.unauthorized || retorno.body == null) {
        throw Exception();
      }
      Temperatura temperatura = Temperatura.fromJson(retorno.body);

      return temperatura;
    } catch (e) {
      return null;
    }
  }
}
