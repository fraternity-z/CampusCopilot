// Copyright 2023-2025 BenderBlog Rodriguez and contributors
// Copyright 2025 Traintime PDA authors.
// SPDX-License-Identifier: MPL-2.0 OR Apache-2.0

// The class table window source.
// Thanks xidian-script and libxdauth!

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:time/time.dart';
import 'package:campus_copilot/repository/xidian_ids/jc_captcha.dart';
import 'package:campus_copilot/shared/utils/debug_log.dart';
import 'package:campus_copilot/repository/network_session.dart';
import 'package:campus_copilot/repository/preference.dart' as preference;
import 'package:campus_copilot/model/xidian_ids/classtable.dart';
import 'package:campus_copilot/repository/xidian_ids/ehall_session.dart';
import 'package:campus_copilot/repository/classtable_cache_manager.dart';

/// 课程表 4770397878132218
class ClassTableFile extends EhallSession {
  static const schoolClassName = "ClassTable.json";
  static const userDefinedClassName = "UserClass.json";
  static const partnerClassName = "darling.erc.json";
  static const decorationName = "decoration.jpg";

  /// 获取课程表（优先使用缓存，必要时从网络获取）
  Future<ClassTableData> getClassTableWithCache({bool forceRefresh = false}) async {
    debugLog(() => "[ClassTableFile] Getting class table with cache, forceRefresh: $forceRefresh");

    // 如果不强制刷新，尝试从缓存加载
    if (!forceRefresh) {
      final cachedData = await ClassTableCacheManager.loadClassTable();
      if (cachedData != null) {
        debugLog(() => "[ClassTableFile] Loaded class table from cache");
        return cachedData;
      }
    }

    // 从网络获取数据
    debugLog(() => "[ClassTableFile] Loading class table from network");
    ClassTableData classTable;
    
    try {
      // 根据用户身份选择获取方式
      final isPostgraduate = preference.getBool(preference.Preference.role);
      if (isPostgraduate) {
        classTable = await getYjspt();
      } else {
        classTable = await getEhall();
      }

      // 保存到缓存
      await ClassTableCacheManager.saveClassTable(classTable);
      debugLog(() => "[ClassTableFile] Class table saved to cache");
      
      return classTable;
    } catch (e) {
      debugLog(() => "[ClassTableFile] Failed to get class table from network: $e");
      
      // 网络获取失败，尝试使用过期的缓存数据
      final cachedData = await ClassTableCacheManager.loadClassTable();
      if (cachedData != null) {
        debugLog(() => "[ClassTableFile] Using expired cache data due to network error");
        return cachedData;
      }
      
      // 重新抛出异常
      rethrow;
    }
  }

  /// 清除缓存
  Future<void> clearCache() async {
    await ClassTableCacheManager.clearCache();
    debugLog(() => "[ClassTableFile] Cache cleared");
  }

  ClassTableData simplifyData(Map<String, dynamic> qResult) {
    ClassTableData toReturn = ClassTableData();

    toReturn.semesterCode = qResult["semesterCode"];
    toReturn.termStartDay = qResult["termStartDay"];

    debugLog(() => "[getClasstable][simplifyData] ${toReturn.semesterCode} ${toReturn.termStartDay}");

    for (var i in qResult["rows"]) {
      var toDeal = ClassDetail(
        name: i["KCM"],
        code: i["KCH"],
        number: i["KXH"],
      );
      if (!toReturn.classDetail.contains(toDeal)) {
        toReturn.classDetail.add(toDeal);
      }
      toReturn.timeArrangement.add(
        TimeArrangement(
          source: Source.school,
          index: toReturn.classDetail.indexOf(toDeal),
          start: int.parse(i["KSJC"]),
          teacher: i["SKJS"],
          stop: int.parse(i["JSJC"]),
          day: int.parse(i["SKXQ"]),
          weekList: List<bool>.generate(
            i["SKZC"].toString().length,
            (index) => i["SKZC"].toString()[index] == "1",
          ),
          classroom: i["JASMC"],
        ),
      );
      if (i["SKZC"].toString().length > toReturn.semesterLength) {
        toReturn.semesterLength = i["SKZC"].toString().length;
      }
    }

    // Deal with the not arranged data.
    for (var i in qResult["notArranged"]) {
      toReturn.notArranged.add(
        NotArrangementClassDetail(
          name: i["KCM"],
          code: i["KCH"],
          number: i["KXH"],
          teacher: i["SKJS"],
        ),
      );
    }

    return toReturn;
  }

  Future<ClassTableData> getYjspt() async {
    Map<String, dynamic> qResult = {};

    const semesterCodeURL =
        "https://yjspt.xidian.edu.cn/gsapp/sys/wdkbapp/modules/xskcb/kfdxnxqcx.do";
    const classInfoURL =
        "https://yjspt.xidian.edu.cn/gsapp/sys/wdkbapp/modules/xskcb/xspkjgcx.do";
    const notArrangedInfoURL =
        "https://yjspt.xidian.edu.cn/gsapp/sys/wdkbapp/modules/xskcb/xswsckbkc.do";

    debugLog(() => "[getClasstable][getYjspt] Login the system.");
    String? location = await checkAndLogin(
      target:
          "https://yjspt.xidian.edu.cn/gsapp/"
          "sys/wdkbapp/*default/index.do#/xskcb",
      sliderCaptcha: (String cookieStr) =>
          SliderCaptchaClientProvider(cookie: cookieStr).solve(null),
    );

    while (location != null) {
      var response = await dio.get(location);
      debugLog(() => "[getClasstable][getYjspt] Received location: $location.");
      location = response.headers[HttpHeaders.locationHeader]?[0];
    }

    /// AKA xnxqdm as [startyear][period] eg 20242 as
    var semesterCode = await dio
        .post(semesterCodeURL)
        .then((value) {
          var data = value.data;
          if (data == null || data["datas"] == null || data["datas"]["kfdxnxqcx"] == null ||
              data["datas"]["kfdxnxqcx"]["rows"] == null || data["datas"]["kfdxnxqcx"]["rows"].isEmpty) {
            throw Exception("无法获取研究生学期信息");
          }
          return data["datas"]["kfdxnxqcx"]["rows"][0]["WID"];
        });

    DateTime now = DateTime.now();
    var currentWeek = await dio
        .post(
          'https://yjspt.xidian.edu.cn/gsapp/sys/yjsemaphome/portal/queryRcap.do',
          data: {'day': DateFormat("yyyyMMdd").format(now)},
        )
        .then((value) => value.data);
    if (!currentWeek.toString().contains("xnxq")) {
      return ClassTableData(
        semesterCode: semesterCode,
        termStartDay: "2025-01-01",
      );
    }
    currentWeek =
        RegExp(r'[0-9]+').firstMatch(currentWeek["xnxq"])?[0] ?? "null";

    debugLog(() => "[getClasstable][getYjspt] Current week is $currentWeek, fetching...");
    int weekDay = now.weekday - 1;
    String termStartDay = DateFormat("yyyy-MM-dd HH:mm:ss").format(
      now.add(Duration(days: (1 - int.parse(currentWeek)) * 7 - weekDay)).date,
    );

    if (preference.getString(preference.Preference.currentSemester) !=
        semesterCode) {
      preference.setString(preference.Preference.currentSemester, semesterCode);

      /// New semenster, user defined class is useless.
      var userClassFile = File("${supportPath.path}/$userDefinedClassName");
      if (userClassFile.existsSync()) userClassFile.deleteSync();
    }

    Map<String, dynamic> data = await dio
        .post(classInfoURL, data: {"XNXQDM": semesterCode})
        .then((response) => response.data);

    if (data['code'] != "0") {
      debugLog(() => "[getClasstable][getYjspt] extParams: ${data['extParams']['msg']} isNotPublish: ${data['extParams']['msg'].toString().contains("查询学年学期的课程未发布")}");
      if (data['extParams']['msg'].toString().contains("查询学年学期的课程未发布")) {
        debugLog(() => "[getClasstable][getYjspt] extParams: ${data['extParams']['msg']} isNotPublish: Classtable not released.");
        return ClassTableData(
          semesterCode: semesterCode,
          termStartDay: termStartDay,
        );
      } else {
        throw Exception("${data['extParams']['msg']}");
      }
    }

    if (data["datas"] == null || data["datas"]["xspkjgcx"] == null ||
        data["datas"]["xspkjgcx"]["rows"] == null) {
      throw Exception("无法获取研究生课程表数据");
    }
    qResult["rows"] = data["datas"]["xspkjgcx"]["rows"];

    var notOnTable = await dio
        .post(
          notArrangedInfoURL,
          data: {
            'XNXQDM': semesterCode,
            'XH': preference.getString(preference.Preference.idsAccount),
          },
        )
        .then((value) {
          var data = value.data;
          if (data == null || data['datas'] == null || data['datas']['xswsckbkc'] == null) {
            throw Exception("无法获取研究生未安排课程数据");
          }
          return data['datas']['xswsckbkc'];
        });
    qResult["notArranged"] = notOnTable["rows"];

    ClassTableData toReturn = ClassTableData();
    toReturn.semesterCode = semesterCode;
    toReturn.termStartDay = termStartDay;

    debugLog(() => "[getClasstable][getYjspt] ${toReturn.semesterCode} ${toReturn.termStartDay}");

    for (var i in qResult["rows"]) {
      var toDeal = ClassDetail(name: i["KCMC"], code: i["KCDM"]);
      if (!toReturn.classDetail.contains(toDeal)) {
        toReturn.classDetail.add(toDeal);
      }

      toReturn.timeArrangement.add(
        TimeArrangement(
          source: Source.school,
          index: toReturn.classDetail.indexOf(toDeal),
          start: i["KSJCDM"],
          teacher: i["JSXM"],
          stop: i["JSJCDM"],
          day: int.parse(i["XQ"].toString()),
          weekList: List<bool>.generate(
            i["ZCBH"].toString().length,
            (index) => i["ZCBH"].toString()[index] == "1",
          ),
          classroom: i["JASMC"],
        ),
      );

      if (i["ZCBH"].toString().length > toReturn.semesterLength) {
        toReturn.semesterLength = i["ZCBH"].toString().length;
      }
    }

    // Post deal here
    List<TimeArrangement> newStuff = [];
    int getCourseId(TimeArrangement i) =>
        "${i.weekList}-${i.day}-${i.classroom}".hashCode;

    for (var i = 0; i < toReturn.classDetail.length; ++i) {
      List<TimeArrangement> data = List<TimeArrangement>.from(
        toReturn.timeArrangement,
      )..removeWhere((item) => item.index != i);
      List<int> entries = [];
      //Map<int, List<TimeArrangement>> toAdd = {};

      for (var j in data) {
        int id = getCourseId(j);
        if (!entries.any((k) => k == id)) entries.add(id);
      }
      for (var j in entries) {
        List<TimeArrangement> result = List<TimeArrangement>.from(data)
          ..removeWhere((item) => getCourseId(item) != j)
          ..sort((a, b) => a.start - b.start);

        List<int> arrangementsProto = {
          for (var i in result) ...[i.start, i.stop],
        }.toList()..sort();

        debugLog(() => "arrangementsProto: $arrangementsProto");

        List<List<int>> arrangements = [[]];
        for (var j in arrangementsProto) {
          if (arrangements.last.isEmpty || arrangements.last.last == j - 1) {
            arrangements.last.add(j);
          } else {
            arrangements.add([j]);
          }
        }

        debugLog(() => "arrangements: $arrangements");

        for (var j in arrangements) {
          newStuff.add(
            TimeArrangement(
              source: Source.school,
              index: i,
              classroom: result.first.classroom,
              teacher: result.first.teacher,
              weekList: result.first.weekList,
              day: result.first.day,
              start: j.first,
              stop: j.last,
            ),
          );
        }
      }
    }

    toReturn.timeArrangement = newStuff;

    for (var i in qResult["notArranged"]) {
      toReturn.notArranged.add(
        NotArrangementClassDetail(name: i["KCMC"], code: i["KCDM"]),
      );
    }

    return toReturn;
  }

  Future<ClassTableData> getEhall() async {
    Map<String, dynamic> qResult = {};
    debugLog(() => "[getClasstable][getEhall] Login the system.");
    String get = await useApp("4770397878132218");
    debugLog(() => "[getClasstable][getEhall] Location: $get");
    await dioEhall.post(get);

    debugLog(() => "[getClasstable][getEhall] Fetch the semester information.");
    String semesterCode = await dioEhall
        .post(
          "https://ehall.xidian.edu.cn/jwapp/sys/wdkb/modules/jshkcb/dqxnxq.do",
        )
        .then((value) {
          var data = value.data;
          if (data == null || data['datas'] == null || data['datas']['dqxnxq'] == null ||
              data['datas']['dqxnxq']['rows'] == null || data['datas']['dqxnxq']['rows'].isEmpty) {
            throw Exception("无法获取学期信息");
          }
          return data['datas']['dqxnxq']['rows'][0]['DM'];
        });
    if (preference.getString(preference.Preference.currentSemester) !=
        semesterCode) {
      preference.setString(preference.Preference.currentSemester, semesterCode);

      /// New semenster, user defined class is useless.
      var userClassFile = File("${supportPath.path}/$userDefinedClassName");
      if (userClassFile.existsSync()) userClassFile.deleteSync();
    }

    debugLog(() => "[getClasstable][getEhall] Fetch the day the semester begin.");
    String termStartDay = await dioEhall
        .post(
          'https://ehall.xidian.edu.cn/jwapp/sys/wdkb/modules/jshkcb/cxjcs.do',
          data: {
            'XN': '${semesterCode.split('-')[0]}-${semesterCode.split('-')[1]}',
            'XQ': semesterCode.split('-')[2],
          },
        )
        .then((value) {
          var data = value.data;
          if (data == null || data['datas'] == null || data['datas']['cxjcs'] == null ||
              data['datas']['cxjcs']['rows'] == null || data['datas']['cxjcs']['rows'].isEmpty) {
            throw Exception("无法获取学期开始日期");
          }
          return data['datas']['cxjcs']['rows'][0]["XQKSRQ"];
        });
    debugLog(() => "[getClasstable][getEhall] Will get $semesterCode which start at $termStartDay.");

    qResult = await dioEhall
        .post(
          'https://ehall.xidian.edu.cn/jwapp/sys/wdkb/modules/xskcb/xskcb.do',
          data: {
            'XNXQDM': semesterCode,
            'XH': preference.getString(preference.Preference.idsAccount),
          },
        )
        .then((value) {
          var data = value.data;
          if (data == null || data['datas'] == null || data['datas']['xskcb'] == null) {
            throw Exception("无法获取课程表数据");
          }
          return data['datas']['xskcb'];
        });
    if (qResult['extParams']['code'] != 1) {
      debugLog(() => "[getClasstable][getEhall] extParams: ${qResult['extParams']['msg']} isNotPublish: ${qResult['extParams']['msg'].toString().contains("查询学年学期的课程未发布")}");
      if (qResult['extParams']['msg'].toString().contains("查询学年学期的课程未发布")) {
        debugLog(() => "[getClasstable][getEhall] extParams: ${qResult['extParams']['msg']} isNotPublish: Classtable not released.");
        return ClassTableData(
          semesterCode: semesterCode,
          termStartDay: termStartDay,
        );
      } else {
        throw Exception("${qResult['extParams']['msg']}");
      }
    }

    debugLog(() => "[getClasstable][getEhall] Preliminary storage...");
    qResult["semesterCode"] = semesterCode;
    qResult["termStartDay"] = termStartDay;

    var notOnTable = await dioEhall
        .post(
          "https://ehall.xidian.edu.cn/jwapp/sys/wdkb/modules/xskcb/cxxsllsywpk.do",
          data: {
            'XNXQDM': semesterCode,
            'XH': preference.getString(preference.Preference.idsAccount),
          },
        )
        .then((value) {
          var data = value.data;
          if (data == null || data['datas'] == null || data['datas']['cxxsllsywpk'] == null) {
            throw Exception("无法获取未安排课程数据");
          }
          return data['datas']['cxxsllsywpk'];
        });

    debugLog(() => "[getClasstable][getEhall] $notOnTable");
    qResult["notArranged"] = notOnTable["rows"];

    ClassTableData preliminaryData = simplifyData(qResult);

    /// Deal with the class change.
    debugLog(() => "[getClasstable][getEhall] Deal with the class change...");

    qResult = await dioEhall
        .post(
          'https://ehall.xidian.edu.cn/jwapp/sys/wdkb/modules/xskcb/xsdkkc.do',
          data: {
            'XNXQDM': semesterCode,
            //'SKZC': "6",
            '*order': "-SQSJ",
          },
        )
        .then((value) {
          var data = value.data;
          if (data == null || data['datas'] == null || data['datas']['xsdkkc'] == null) {
            throw Exception("无法获取课程变更数据");
          }
          return data['datas']['xsdkkc'];
        });
    if (qResult['extParams']['code'] != 1) {
      debugLog(() => "[getClasstable][getEhall] ${qResult['extParams']['msg']}");
    }

    // ignore: non_constant_identifier_names
    ChangeType type(String TKLXDM) {
      if (TKLXDM == '01') {
        return ChangeType.change; //调课
      } else if (TKLXDM == '02') {
        return ChangeType.stop; //停课
      } else {
        return ChangeType.patch; //补课
      }
    }

    // Merge change info
    if (int.parse(qResult["totalSize"].toString()) > 0) {
      for (var i in qResult["rows"]) {
        preliminaryData.classChanges.add(
          ClassChange(
            type: type(i["TKLXDM"]),
            classCode: i["KCH"],
            classNumber: i["KXH"],
            className: i["KCM"],
            originalAffectedWeeks: i["SKZC"] == null
                ? null
                : List<bool>.generate(
                    i["SKZC"].toString().length,
                    (index) => i["SKZC"].toString()[index] == "1",
                  ),
            newAffectedWeeks: i["XSKZC"] == null
                ? null
                : List<bool>.generate(
                    i["XSKZC"].toString().length,
                    (index) => i["XSKZC"].toString()[index] == "1",
                  ),
            originalTeacherData: i["YSKJS"],
            newTeacherData: i["XSKJS"],
            originalClassRange: [
              int.parse(i["KSJC"]?.toString() ?? "-1"),
              int.parse(i["JSJC"]?.toString() ?? "-1"),
            ],
            newClassRange: [
              int.parse(i["XKSJC"]?.toString() ?? "-1"),
              int.parse(i["XJSJC"]?.toString() ?? "-1"),
            ],
            originalWeek: i["SKXQ"],
            newWeek: i["XSKXQ"],
            originalClassroom: i["JASMC"],
            newClassroom: i["XJASMC"],
          ),
        );
      }
    }

    debugLog(() => "[getClasstable][getEhall] Dealing class change with ${preliminaryData.classChanges.length} info(s).");

    List<ClassChange> cache = [];
    List<ClassChange> toDeal = List<ClassChange>.from(
      preliminaryData.classChanges,
    );

    while (toDeal.isNotEmpty) {
      List<int> toBeRemovedIndex = [];
      for (var e in toDeal) {
        /// First, search for the classes.
        /// Due to the unstability of the api, a list is introduced.
        /// This must have an answer, otherwise there's a potato in the school's server.
        List<int> indexClassDetailList = [];
        for (int i = 0; i < preliminaryData.classDetail.length; ++i) {
          if (preliminaryData.classDetail[i].code == e.classCode) {
            indexClassDetailList.add(i);
          }
        }
        debugLog(() => "[getClasstable][getEhall] Class change related to class index $indexClassDetailList.");

        /// Then, if patch, find the class and add one
        if (e.type == ChangeType.patch) {
          debugLog(() => "[getClasstable][getEhall] Class patch.");

          /// Add classes.
          preliminaryData.timeArrangement.add(
            TimeArrangement(
              source: Source.school,
              index: indexClassDetailList.first,
              weekList: e.newAffectedWeeks!,
              day: e.newWeek!,
              start: e.newClassRange[0],
              stop: e.newClassRange[1],
              classroom: e.newClassroom ?? e.originalClassroom,
              teacher: e.isTeacherChanged ? e.newTeacher : e.originalTeacher,
            ),
          );
          toBeRemovedIndex.add(toDeal.indexOf(e));
          continue;
        }

        /// Otherwise, find the all time arrangement related to the class.
        debugLog(() => "[getClasstable][getEhall] Class change related to class detail index $indexClassDetailList.");
        List<int> indexOriginalTimeArrangementList = [];
        for (var currentClassIndex in indexClassDetailList) {
          for (int i = 0; i < preliminaryData.timeArrangement.length; ++i) {
            if (preliminaryData.timeArrangement[i].index == currentClassIndex &&
                preliminaryData.timeArrangement[i].day == e.originalWeek &&
                preliminaryData.timeArrangement[i].start ==
                    e.originalClassRange[0] &&
                preliminaryData.timeArrangement[i].stop ==
                    e.originalClassRange[1]) {
              indexOriginalTimeArrangementList.add(i);
            }
          }
        }

        /// Third, search for the time arrangements, seek for the truth.
        debugLog(() => "[getClasstable][getEhall] Class change related to time arrangement index $indexOriginalTimeArrangementList.");

        /// If empty, wait for the next turn...
        if (indexOriginalTimeArrangementList.isEmpty) continue;

        if (e.type == ChangeType.change) {
          int timeArrangementIndex = indexOriginalTimeArrangementList.first;

          debugLog(() => "[getClasstable][getEhall] Class change. Teacher changed? ${e.isTeacherChanged}. timeArrangementIndex is $timeArrangementIndex");
          for (int indexOriginalTimeArrangement
              in indexOriginalTimeArrangementList) {
            /// Seek for the change entry. Delete the classes moved waay.
            debugLog(() => "[getClasstable][getEhall] Original weeklist ${preliminaryData.timeArrangement[indexOriginalTimeArrangement].weekList} with originalAffectedWeeksList ${e.originalAffectedWeeksList}.");
            for (int i in e.originalAffectedWeeksList) {
              debugLog(() => "[getClasstable][getEhall] Week $i, status ${preliminaryData.timeArrangement[indexOriginalTimeArrangement].weekList[i]}.");
              if (preliminaryData
                  .timeArrangement[indexOriginalTimeArrangement]
                  .weekList[i]) {
                preliminaryData
                        .timeArrangement[indexOriginalTimeArrangement]
                        .weekList[i] =
                    false;
                timeArrangementIndex = preliminaryData
                    .timeArrangement[indexOriginalTimeArrangement]
                    .index;
              }
            }

            debugLog(() => "[getClasstable][getEhall] New weeklist ${preliminaryData.timeArrangement[indexOriginalTimeArrangement].weekList}.");
          }

          if (timeArrangementIndex == indexOriginalTimeArrangementList.first) {
            cache.add(e);
            timeArrangementIndex = preliminaryData
                .timeArrangement[indexOriginalTimeArrangementList.first]
                .index;
          }

          debugLog(() => "[getClasstable][getEhall] New week: ${e.newAffectedWeeks}, day: ${e.newWeek}, startToStop: ${e.newClassRange}, timeArrangementIndex: $timeArrangementIndex.");

          bool flag = false;
          ClassChange? toRemove;
          debugLog(() => "[getClasstable][getEhall] cache length = ${cache.length}");
          for (var f in cache) {
            //log.info("[getClasstable][getFromWeb]"
            //    "${f.className} ${f.classCode} ${f.originalClassRange} ${f.originalAffectedWeeksList} ${f.originalWeek}");
            //log.info("[getClasstable][getFromWeb]"
            //    "${e.className} ${e.classCode} ${e.newClassRange} ${e.newAffectedWeeksList} ${e.newWeek}");
            //log.info("[getClasstable][getFromWeb]"
            //    "${f.className == e.className} ${f.classCode == e.classCode} ${listEquals(f.originalClassRange, e.newClassRange)} ${listEquals(f.originalAffectedWeeksList, e.newAffectedWeeksList)} ${f.originalWeek == e.newWeek}");
            if (f.className == e.className &&
                f.classCode == e.classCode &&
                listEquals(f.originalClassRange, e.newClassRange) &&
                listEquals(
                  f.originalAffectedWeeksList,
                  e.newAffectedWeeksList,
                ) &&
                f.originalWeek == e.newWeek &&
                f.originalClassroom == e.newClassroom &&
                f.originalTeacherData == e.newTeacherData) {
              flag = true;
              toRemove = f;
              break;
            }
          }

          if (flag) {
            cache.remove(toRemove);
            debugLog(() => "[getClasstable][getEhall] Cannot be added");
            continue;
          }

          debugLog(() => "[getClasstable][getEhall] Can be added");

          /// Add classes.
          preliminaryData.timeArrangement.add(
            TimeArrangement(
              source: Source.school,
              index: timeArrangementIndex,
              weekList: e.newAffectedWeeks!,
              day: e.newWeek!,
              start: e.newClassRange[0],
              stop: e.newClassRange[1],
              classroom: e.newClassroom ?? e.originalClassroom,
              teacher: e.isTeacherChanged ? e.newTeacher : e.originalTeacher,
            ),
          );
        } else {
          debugLog(() => "[getClasstable][getEhall] Class stop.");

          for (int indexOriginalTimeArrangement
              in indexOriginalTimeArrangementList) {
            debugLog(() => "[getClasstable][getEhall] Original weeklist ${preliminaryData.timeArrangement[indexOriginalTimeArrangement].weekList} with originalAffectedWeeksList ${e.originalAffectedWeeksList}.");
            for (int i in e.originalAffectedWeeksList) {
              debugLog(() => "[getClasstable][getEhall] $i ${preliminaryData.timeArrangement[indexOriginalTimeArrangement].weekList[i]}");
              if (preliminaryData
                  .timeArrangement[indexOriginalTimeArrangement]
                  .weekList[i]) {
                preliminaryData
                        .timeArrangement[indexOriginalTimeArrangement]
                        .weekList[i] =
                    false;
              }
            }
            debugLog(() => "[getClasstable][getEhall] New weeklist ${preliminaryData.timeArrangement[indexOriginalTimeArrangement].weekList}.");
          }
        }
        toBeRemovedIndex.add(toDeal.indexOf(e));
      }
      toDeal = [
        for (var i = 0; i < toDeal.length; ++i)
          if (!toBeRemovedIndex.contains(i)) toDeal[i],
      ];
      debugLog(() => "[getClasstable][getEhall] After this turn, ${toDeal.length} left, removed $toBeRemovedIndex.");
    }

    return preliminaryData;
  }
}

class NotSameSemesterException implements Exception {
  final String msg;
  NotSameSemesterException({required this.msg});
}
