import 'dart:math' as math;
import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gleeky_flutter/src/host/insight/controller/insight_controller.dart';
import 'package:gleeky_flutter/utills/app_colors.dart';
import 'package:gleeky_flutter/utills/text_styles.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class LineChartDemo extends StatelessWidget {
  const LineChartDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return InsightController.to.insightApiResponse.isEmpty?Shimmer.fromColors(
          baseColor: AppColors.colorD9D9D9.withOpacity(0.2),
          highlightColor: AppColors.colorD9D9D9,
          child: SizedBox(
            height: 270,
            width: Get.width,
            child:  Container(color: Colors.white),
          ),
        ): LineChart(
          LineChartData(
            maxX: (InsightController.to.insightApiResponse['data'] != null &&
                    InsightController.to.insightApiResponse['data']['days'] != null)
                ? double.parse(InsightController
                    .to.insightApiResponse['data']['days'].length
                    .toString())
                : 10,
            minX: 0,
            maxY: (List.generate(
                        InsightController.to
                            .insightApiResponse['data']?['total_view_daily'].length,
                        (index) => int.parse(
                            (InsightController.to.insightApiResponse['data']
                                        ?['total_view_daily'][index] ??
                                    '0')
                                .toString())).reduce(max) +
                    2)
                .toDouble(),
            minY: 0,
            gridData: FlGridData(
                show: true,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                      color: AppColors.color000000.withOpacity(0.2),
                      strokeWidth: 1);
                },
                getDrawingVerticalLine: (value) {
                  return FlLine(color: Colors.transparent, strokeWidth: 1);
                }),
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: AppColors.colorFE6927,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map(
                    (touchedSpot) {
                      return LineTooltipItem(
                        '${touchedSpot.y.toInt()} Views',
                        colorfffffffs13w600,
                      );
                    },
                  ).toList();
                },
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, data) {
                  if (InsightController.to.insightApiResponse['data'] != null &&
                      InsightController.to.insightApiResponse['data']['days'] !=
                          null) {
                    switch (value.toInt()) {
                      case 0:
                        return Text(
                          InsightController.to.insightApiResponse['data']['days']
                              [value.toInt()],
                          style: color00000s14w500,
                        );
                      case 1:
                        return Text(
                          InsightController.to.insightApiResponse['data']['days']
                              [value.toInt()],
                          style: color00000s14w500,
                        );
                      case 2:
                        return Text(
                          InsightController.to.insightApiResponse['data']['days']
                              [value.toInt()],
                          style: color00000s14w500,
                        );

                      case 4:
                        return Text(
                          InsightController.to.insightApiResponse['data']['days']
                              [value.toInt()],
                          style: color00000s14w500,
                        );

                      case 6:
                        return Text(
                          InsightController.to.insightApiResponse['data']['days']
                              [value.toInt()],
                          style: color00000s14w500,
                        );
                      case 8:
                        return Text(
                          InsightController.to.insightApiResponse['data']['days']
                              [value.toInt()],
                          style: color00000s14w500,
                        );
                      case 10:
                        return Text(
                          InsightController.to.insightApiResponse['data']['days']
                              [value.toInt()],
                          style: color00000s14w500,
                        );
                      case 12:
                        return Text(
                          InsightController.to.insightApiResponse['data']['days']
                              [value.toInt()],
                          style: color00000s14w500,
                        );
                      case 14:
                        return Text(
                          InsightController.to.insightApiResponse['data']['days']
                              [value.toInt()],
                          style: color00000s14w500,
                        );
                      case 16:
                        return Text(
                          InsightController.to.insightApiResponse['data']['days']
                              [value.toInt()],
                          style: color00000s14w500,
                        );
                      case 18:
                        return Text(
                          InsightController.to.insightApiResponse['data']['days']
                              [value.toInt()],
                          style: color00000s14w500,
                        );
                      case 20:
                        return Text(
                          InsightController.to.insightApiResponse['data']['days']
                              [value.toInt()],
                          style: color00000s14w500,
                        );
                      case 22:
                        return Text(
                          InsightController.to.insightApiResponse['data']['days']
                              [value.toInt()],
                          style: color00000s14w500,
                        );
                      case 24:
                        return Text(
                          InsightController.to.insightApiResponse['data']['days']
                              [value.toInt()],
                          style: color00000s14w500,
                        );
                      case 26:
                        return Text(
                          InsightController.to.insightApiResponse['data']['days']
                              [value.toInt()],
                          style: color00000s14w500,
                        );
                      case 28:
                        return Text(
                          InsightController.to.insightApiResponse['data']['days']
                              [value.toInt()],
                          style: color00000s14w500,
                        );
                      case 30:
                        return Text(
                          InsightController.to.insightApiResponse['data']['days']
                              [value.toInt()],
                          style: color00000s14w500,
                        );
                    }
                    return const Text('');
                  } else {
                    switch (value.toInt()) {
                      case 1:
                        return Text(
                          'Jan',
                          style: color00000s14w500,
                        );
                      case 2:
                        return Text(
                          'Feb',
                          style: color00000s14w500,
                        );
                      case 3:
                        return Text(
                          'Mar',
                          style: color00000s14w500,
                        );
                      case 4:
                        return Text(
                          'Apr',
                          style: color00000s14w500,
                        );
                      case 5:
                        return Text(
                          'May',
                          style: color00000s14w500,
                        );
                      case 6:
                        return Text(
                          'June',
                          style: color00000s14w500,
                        );
                      case 7:
                        return Text(
                          'July',
                          style: color00000s14w500,
                        );
                      case 8:
                        return Text(
                          'Aug',
                          style: color00000s14w500,
                        );
                      case 9:
                        return Text(
                          'Sep',
                          style: color00000s14w500,
                        );
                      case 10:
                        return Text(
                          'Oct',
                          style: color00000s14w500,
                        );
                      case 11:
                        return Text(
                          'Nov',
                          style: color00000s14w500,
                        );
                      case 12:
                        return Text(
                          'Dec',
                          style: color00000s14w500,
                        );
                    }
                  }
                  return const Text('');
                },
              )),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, data) {
                    return Text(
                      value.toInt().toString(),
                      style: color00000s14w500,
                    );
                  },
                ),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.color000000.withOpacity(0.8),
                ),
                left: BorderSide(
                  color: AppColors.color000000.withOpacity(0),
                ),
              ),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: (InsightController.to.insightApiResponse['data'] != null &&
                        InsightController.to.insightApiResponse['data']
                                ['total_view_daily'] !=
                            null)
                    ? List.generate(
                        InsightController.to
                            .insightApiResponse['data']['total_view_daily'].length,
                        (index) => FlSpot(
                          index.toDouble(),
                          double.parse(
                            (InsightController.to.insightApiResponse['data']
                                        ['total_view_daily'][index] ??
                                    '0')
                                .toString(),
                          ),
                        ),
                      )
                    : [
                        const FlSpot(1, 3),
                        const FlSpot(2, 4),
                        const FlSpot(3, 5),
                        const FlSpot(4, 6),
                        const FlSpot(5, 5),
                        const FlSpot(6, 2),
                        const FlSpot(7, 6),
                        const FlSpot(8, 7),
                        const FlSpot(9, 8),
                        const FlSpot(10, 9),
                        const FlSpot(11, 10),
                        const FlSpot(12, 15),
                      ],
                isCurved: false,
                color: const Color(0xffE84802),
                barWidth: 3,
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.colorFE6927,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class BarchartDemo extends StatelessWidget {
  const BarchartDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return  InsightController.to.insightApiResponse.isEmpty||(!InsightController.to.insightApiResponse.containsKey('data'))? Shimmer.fromColors(
          baseColor: AppColors.colorD9D9D9.withOpacity(0.2),
          highlightColor: AppColors.colorD9D9D9,
          child: SizedBox(
            height: 270,
            width: Get.width,
            child:  Container(color: Colors.white),
          ),
        ): BarChart(
          BarChartData(
            maxY:
              (List.generate(
                (InsightController.to.insightApiResponse['data']
                ?['total_amt_monthly']).length,
                    (index) => int.parse(
                    (InsightController.to.insightApiResponse['data']
                    ?['total_amt_monthly'][index] ??
                        '0')
                        .toString())+
                      (( int.parse(
                        (InsightController.to.insightApiResponse['data']
                        ?['total_amt_monthly'][index] ??
                            '0')
                            .toString())<1000)?200:( int.parse(
                          (InsightController.to.insightApiResponse['data']
                          ?['total_amt_monthly'][index] ??
                              '0')
                              .toString())<5000)?1500:( int.parse(
                          (InsightController.to.insightApiResponse['data']
                          ?['total_amt_monthly'][index] ??
                              '0')
                              .toString())<10000)?2000:( int.parse(
                          (InsightController.to.insightApiResponse['data']
                          ?['total_amt_monthly'][index] ??
                              '0')
                              .toString())<100000)?20000:( int.parse(
                          (InsightController.to.insightApiResponse['data']
                          ?['total_amt_monthly'][index] ??
                              '0')
                              .toString())<1000000)?200000:2000000)).reduce(max))
                .toDouble().ceilToDouble(),
            // maxY: 150000,
            minY: 0,
            gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                    color: AppColors.color000000.withOpacity(0.2), strokeWidth: 1);
              },
              getDrawingVerticalLine: (value) {
                return FlLine(color: Colors.transparent, strokeWidth: 1);
              },
            ),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: AppColors.colorFE6927,
                getTooltipItem: (
                  BarChartGroupData group,
                  int groupIndex,
                  BarChartRodData rod,
                  int rodIndex,
                ) {
                  return BarTooltipItem('₹ ${rod.toY}', colorfffffffs13w600);
                },
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(
                  color: AppColors.color000000.withOpacity(0.8),
                ),
                left: BorderSide(
                  color: AppColors.color000000.withOpacity(0.8),
                ),
              ),
            ),
            titlesData: FlTitlesData(
              topTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, data) {
                    return const Text('');
                  },
                ),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, data) {
                    return const Text('');
                  },
                ),
              ),
              bottomTitles: AxisTitles(sideTitles: _bottomTitles),
            ),
            barGroups: List.generate(
              InsightController.to.insightApiResponse['data']
              ?['total_amt_monthly'].length,
              (index) => BarChartGroupData(
                x: index + 1,
                barRods: [
                  BarChartRodData(
                      toY: double.parse(
                        (InsightController.to.insightApiResponse['data']
                                    ?['total_amt_monthly']?[index] ??
                                '0')
                            .toString(),
                      ),
                      color:(index==(InsightController.to.insightApiResponse['data']
                      ?['total_amt_monthly'].length-1))?( (int.parse(
                                  (InsightController.to.insightApiResponse['data']
                                              ?['total_amt_monthly']?[InsightController.to.insightApiResponse['data']
                                  ?['total_amt_monthly'].length-2] ??
                                          '0')
                                      .toString()) <
                              int.parse(
                                  (InsightController.to.insightApiResponse['data']
                                              ?['total_amt_monthly']?[InsightController.to.insightApiResponse['data']
                                  ?['total_amt_monthly'].length-1] ??
                                          '0')
                                      .toString()))
                          ? AppColors.color32BD01
                          :(int.parse(
                          (InsightController.to.insightApiResponse['data']
                          ?['total_amt_monthly']?[InsightController.to.insightApiResponse['data']
                          ?['total_amt_monthly'].length-2] ??
                              '0')
                              .toString()) >
                          int.parse(
                              (InsightController.to.insightApiResponse['data']
                              ?['total_amt_monthly']?[InsightController.to.insightApiResponse['data']
                              ?['total_amt_monthly'].length-1] ??
                                  '0')
                                  .toString()))?AppColors.color9a0400: AppColors.colorFE6927):AppColors.colorFE6927)
                ],
                barsSpace: 100,
              ),
            ),
          ),
        );
      }
    );
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          String text = '';
          switch (value.toInt()) {
            case 1:
              text = 'Jan';
              break;
            case 2:
              text = 'Feb';
              break;
            case 3:
              text = 'Mar';
              break;
            case 4:
              text = 'Apr';
              break;
            case 5:
              text = 'May';
              break;
            case 6:
              text = 'Jun';
              break;
            case 7:
              text = 'July';
              break;
            case 8:
              text = 'Aug';
              break;
            case 9:
              text = 'Sep';
              break;
            case 10:
              text = 'Oct';
              break;
            case 11:
              text = 'Nov';
              break;
            case 12:
              text = 'Dec';
              break;
            case 13:
              text = 'Jan';
              break;
          }
          if (InsightController.to.insightApiResponse['data'].isNotEmpty &&
              (InsightController.to.insightApiResponse['data']['months'] !=
                  null)) {
            text = (InsightController.to.insightApiResponse['data']['months']
                    [value.toInt() - 1])
                .toString();
          }
          return Text(
            text,
            style: color50perBlacks13w400.copyWith(fontSize: 12),
          );
        },
      );
}
