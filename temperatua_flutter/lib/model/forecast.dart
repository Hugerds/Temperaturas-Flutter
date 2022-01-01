class Forecast {
  late String date;
  late int max;
  late int min;

  Forecast({required this.date, required this.max, required this.min});

  Forecast.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    max = json['max'];
    min = json['min'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['max'] = this.max;
    data['min'] = this.min;
    return data;
  }
}
