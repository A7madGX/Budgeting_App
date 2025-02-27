import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../models/embeddings.dart';
import '../../../utils/color_palette_generator.dart';

class RenderChartData {
  final String label;
  final num value;

  const RenderChartData({required this.label, required this.value});
}

class ChartRenderer extends StatelessWidget {
  const ChartRenderer({super.key, required this.chartData});

  final Chart chartData;

  @override
  Widget build(BuildContext context) {
    final List<List<RenderChartData>> renderChartDataList = [];
    final List<String> seriesNames = [];

    if (chartData.type == ChartType.pie) {
      final series = chartData.series.single;
      renderChartDataList.add([]);
      for (int i = 0; i < series.data.length; i++) {
        renderChartDataList.single.add(
          RenderChartData(
            label: chartData.labels[i],
            value: series.data[i].toDouble(),
          ),
        );
      }
    } else {
      for (int i = 0; i < chartData.series.length; i++) {
        final series =
            chartData.series[i].data.map<num>((e) => e.toDouble()).toList();
        seriesNames.add(chartData.legend[i]);

        renderChartDataList.add([]);
        for (int j = 0; j < series.length; j++) {
          renderChartDataList[i].add(
            RenderChartData(label: chartData.labels[j], value: series[j]),
          );
        }
      }
    }

    return AspectRatio(
      aspectRatio: 1.5,
      child: switch (chartData.type) {
        ChartType.line => _LineChart(
          chartData: renderChartDataList,
          seriesNames: seriesNames,
        ),
        ChartType.bar => _BarChart(
          chartData: renderChartDataList,
          seriesNames: seriesNames,
        ),
        ChartType.pie => _PieChart(chartData: renderChartDataList.single),
      },
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart({required this.chartData, required this.seriesNames});

  final List<List<RenderChartData>> chartData;
  final List<String> seriesNames;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(),
      series: [
        for (int i = 0; i < chartData.length; i++)
          LineSeries<RenderChartData, String>(
            dataSource: chartData[i],
            xValueMapper: (data, _) => data.label,
            yValueMapper: (data, _) => data.value,
            name: seriesNames[i],
            color: generatePalette(context)[i],
          ),
      ],
      legend: Legend(isVisible: true),
    );
  }
}

class _BarChart extends StatelessWidget {
  const _BarChart({required this.chartData, required this.seriesNames});

  final List<List<RenderChartData>> chartData;
  final List<String> seriesNames;

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      primaryYAxis: NumericAxis(),
      series: [
        for (int i = 0; i < chartData.length; i++)
          BarSeries<RenderChartData, String>(
            dataSource: chartData[i],
            xValueMapper: (data, _) => data.label,
            yValueMapper: (data, _) => data.value,
            name: seriesNames[i],
            color: generatePalette(context)[i],
          ),
      ],
      legend: Legend(isVisible: true),
    );
  }
}

class _PieChart extends StatelessWidget {
  const _PieChart({required this.chartData});

  final List<RenderChartData> chartData;

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      series: [
        PieSeries<RenderChartData, String>(
          dataSource: chartData,
          xValueMapper: (data, _) => data.label,
          yValueMapper: (data, _) => data.value,
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            useSeriesColor: true,
            showCumulativeValues: true,
            borderRadius: 8,
            labelPosition: ChartDataLabelPosition.outside,
          ),
          pointColorMapper:
              (data, _) => generatePalette(context)[chartData.indexOf(data)],
          explode: true,
          radius: chartData.length > 3 ? '60%' : '80%',
        ),
      ],
      legend: Legend(isVisible: true),
    );
  }
}
