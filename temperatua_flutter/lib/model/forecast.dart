import 'package:flutter/cupertino.dart';

class Forecast {
  late String date;
  late String dayWeek;
  late String condition;
  late IconData iconCondition;
  late int max;
  late int min;

  Forecast(
      {required this.date,
      required this.max,
      required this.min,
      required this.dayWeek,
      required this.condition,
      required this.iconCondition});

  Forecast.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    max = json['max'];
    min = json['min'];
    condition = json['condition'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['date'] = date;
    data['max'] = max;
    data['min'] = min;
    data['condition'] = condition;
    return data;
  }
}
