import 'dart:convert';

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
      // print(retorno.body);
      String retorno2 = """
    {
    "temp": 26,
    "date": "02/01/2022",
    "time": "13:47",
    "condition_code": "27",
    "description": "Tempo limpo",
    "currently": "dia",
    "cid": "",
    "city": "São Paulo, SP",
    "img_id": "27",
    "humidity": 60,
    "wind_speedy": "1.54 km/h",
    "sunrise": "05:23 am",
    "sunset": "06:56 pm",
    "condition_slug": "clear_day",
    "city_name": "São Paulo",
    "forecast": [
      {
        "date": "02/01",
        "weekday": "Dom",
        "max": 27,
        "min": 18,
        "description": "Chuva",
        "condition": "rain"
      },
      {
        "date": "03/01",
        "weekday": "Seg",
        "max": 31,
        "min": 18,
        "description": "Tempo limpo",
        "condition": "clear_day"
      },
      {
        "date": "04/01",
        "weekday": "Ter",
        "max": 29,
        "min": 20,
        "description": "Chuva",
        "condition": "rain"
      },
      {
        "date": "05/01",
        "weekday": "Qua",
        "max": 25,
        "min": 20,
        "description": "Chuva",
        "condition": "rain"
      },
      {
        "date": "06/01",
        "weekday": "Qui",
        "max": 20,
        "min": 19,
        "description": "Chuvas esparsas",
        "condition": "rain"
      },
      {
        "date": "07/01",
        "weekday": "Sex",
        "max": 20,
        "min": 19,
        "description": "Chuvas esparsas",
        "condition": "rain"
      },
      {
        "date": "08/01",
        "weekday": "Sáb",
        "max": 22,
        "min": 18,
        "description": "Chuvas esparsas",
        "condition": "rain"
      },
      {
        "date": "09/01",
        "weekday": "Dom",
        "max": 22,
        "min": 18,
        "description": "Chuvas esparsas",
        "condition": "rain"
      },
      {
        "date": "10/01",
        "weekday": "Seg",
        "max": 27,
        "min": 19,
        "description": "Chuvas esparsas",
        "condition": "rain"
      },
      {
        "date": "11/01",
        "weekday": "Ter",
        "max": 29,
        "min": 19,
        "description": "Chuvas esparsas",
        "condition": "rain"
      }
    ]
  }""";

      Temperatura temperatura = Temperatura.fromJson(retorno.body);

      return temperatura;
    } catch (e) {
      return null;
    }
  }
}
