import 'package:flutter/material.dart';

import 'forecast.dart';

class Temperatura {
  late int temp;
  late String date;
  late String condition;
  late String currently;
  late double latitude;
  late double longitude;
  String? sunrise;
  String? sunset;
  String? cityName;
  String? windSpeedy;
  late IconData iconCondition;
  List<Forecast>? forecast;

  Temperatura(
      {required this.temp,
      required this.date,
      required this.iconCondition,
      required this.condition,
      required this.currently,
      required this.longitude,
      required this.latitude,
      this.sunrise,
      this.sunset,
      this.cityName,
      this.forecast,
      this.windSpeedy});

  Temperatura.fromJson(Map<String, dynamic> json) {
    temp = json['temp'];
    date = json['date'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    cityName = json['city_name'];
    windSpeedy = json['wind_speedy'];
    condition = json['condition_slug'];
    currently = json['currently'];
    if (json['forecast'] != null) {
      forecast = <Forecast>[];
      json['forecast'].forEach((v) {
        forecast?.add(Forecast.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['temp'] = temp;
    data['date'] = date;
    data['sunrise'] = sunrise;
    data['sunset'] = sunset;
    data['city_name'] = cityName;
    data['wind_speedy'] = windSpeedy;
    data['condition_slug'] = condition;
    data['currently'] = currently;
    if (forecast != null) {
      data['forecast'] = forecast?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
