import 'forecast.dart';

class Temperatura {
  late int temp;
  late String date;
  String? sunrise;
  String? sunset;
  String? cityName;
  List<Forecast>? forecast;

  Temperatura(
      {required this.temp,
      required this.date,
      this.sunrise,
      this.sunset,
      this.cityName,
      this.forecast});

  Temperatura.fromJson(Map<String, dynamic> json) {
    temp = json['temp'];
    date = json['date'];
    sunrise = json['sunrise'];
    sunset = json['sunset'];
    cityName = json['city_name'];
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
    if (forecast != null) {
      data['forecast'] = forecast?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
