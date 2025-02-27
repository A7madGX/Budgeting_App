import 'package:budgeting_app/models/base_embedding_model.dart';

class Chart extends BaseEmbeddingModel {
  final ChartType type;
  final List<String> labels;
  final List<Series> series;

  Chart({required this.type, required this.labels, required this.series});

  factory Chart.fromJson(Map<String, dynamic> json) {
    final type = ChartType.fromString(json['chartType'] as String);
    final labels = (json['labels'] as List).cast<String>();
    final series =
        (json['series'] as List).map((e) => Series.fromJson(e)).toList();

    return Chart(type: type, labels: labels, series: series);
  }
}

class Series {
  final String name;
  final List<double> data;

  Series({required this.name, required this.data});

  factory Series.fromJson(Map<String, dynamic> json) {
    final name = json['name'] as String;
    final data = (json['data'] as List).cast<double>();

    return Series(name: name, data: data);
  }
}

enum ChartType {
  line,
  bar,
  pie;

  static ChartType fromString(String value) {
    switch (value) {
      case 'line':
        return ChartType.line;
      case 'bar':
        return ChartType.bar;
      case 'pie':
        return ChartType.pie;
      default:
        throw ArgumentError('Invalid ChartType: $value');
    }
  }
}
