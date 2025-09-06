// 从traintime_pda直接复制的课程数据组织类
import 'package:flutter/material.dart';
import 'package:campus_copilot/model/xidian_ids/classtable.dart';

class ClassOrgainzedData {
  final List<dynamic> data;

  /// The time range of each block is not even in exam
  /// or experiment, so use double...
  ///
  /// Classtable blanks below per blocks.
  ///  * Morning 1-4 each 5 blocks.
  ///  * Noon break 3 blocks
  ///  * Afternoon 5-8 each 5 blocks.
  ///  * Supper time 3 blocks.
  ///  * Evening time 9-11 each 5 blocks.
  /// Total 61 parts, 49 as phone divider.
  ///
  late final double start;
  late final double stop;

  final String name;
  final String? place;

  final MaterialColor color;

  factory ClassOrgainzedData.fromTimeArrangement(
    TimeArrangement timeArrangement,
    MaterialColor color,
    String name,
  ) {
    double transferIndex(int index, {bool isStart = false}) {
      late double toReturn;
      if (index <= 4) {
        toReturn = index * 5;
        if (isStart && index == 4) {
          toReturn += 3;
        }
      } else if (index <= 8) {
        toReturn = index * 5 + 3;
        if (isStart && index == 8) {
          toReturn += 3;
        }
      } else {
        return index * 5 + 6;
      }
      return toReturn;
    }

    return ClassOrgainzedData(
      data: [timeArrangement],
      start: transferIndex(timeArrangement.start - 1, isStart: true),
      stop: transferIndex(timeArrangement.stop),
      color: color,
      name: name,
      place: timeArrangement.classroom,
    );
  }

  ClassOrgainzedData({
    required this.data,
    required this.start,
    required this.stop,
    required this.name,
    required this.color,
    this.place,
  });
}