// Copyright 2023-2025 BenderBlog Rodriguez and contributors
// Copyright 2025 Traintime PDA authors.
// SPDX-License-Identifier: MPL-2.0

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:campus_copilot/repository/xidian_ids/jc_captcha.dart';
import 'package:campus_copilot/shared/utils/debug_log.dart';
import 'package:campus_copilot/repository/preference.dart' as preference;
import 'package:campus_copilot/repository/xidian_ids/ehall_session.dart';

class PersonalInfoSession extends EhallSession {
  Future<void> getSemesterInfoYjspt() async {
    String location = await checkAndLogin(
      target: "https://yjspt.xidian.edu.cn/",
      sliderCaptcha: (String cookieStr) =>
          SliderCaptchaClientProvider(cookie: cookieStr).solve(null),
    );

    debugLog(() => "[PersonalInfoSession][getSemesterInfoYjspt] Location is $location");
    var response = await dio.get(location);
    while (response.headers[HttpHeaders.locationHeader] != null) {
      location = response.headers[HttpHeaders.locationHeader]![0];
      debugLog(() => "[PersonalInfoSession][getSemesterInfoYjspt] Received location: $location.");
      response = await dio.get(location);
    }

    debugLog(() => "[PersonalInfoSession][getSemesterInfoYjspt] Getting the current semester info.");
    var detailed = await dio
        .post(
          "https://yjspt.xidian.edu.cn/gsapp/sys/yjsemaphome/modules/pubWork/getUserInfo.do",
        )
        .then((value) {
          var data = value.data;
          if (data == null) {
            throw GetInformationFailedException("无法获取研究生用户信息");
          }
          return data;
        });
    if (detailed["code"] != "0") {
      throw GetInformationFailedException(detailed["msg"].toString());
    }
    if (detailed["data"] == null || detailed["data"]["xnxqdm"] == null) {
      throw GetInformationFailedException("研究生用户信息数据结构异常");
    }
    await preference.setString(
      preference.Preference.currentSemester,
      detailed["data"]["xnxqdm"],
    );
  }

  Future<String> getDormInfoEhall() async {
    debugLog(() => "[ehall_session][getDormInfoEhall] Ready to get the user information.");

    String location = await super.checkAndLogin(
      target:
          "https://xgxt.xidian.edu.cn/xsfw/sys/jbxxapp/*default/index.do#/wdxx",
      sliderCaptcha: (String cookieStr) =>
          SliderCaptchaClientProvider(cookie: cookieStr).solve(null),
    );
    debugLog(() => "[ehall_session][getDormInfoEhall] Location is $location");
    var response = await dio.get(
      location,
      options: Options(
        headers: {
          HttpHeaders.refererHeader:
              "https://xgxt.xidian.edu.cn/xsfw/sys/jbxxapp/*default/index.do",
          HttpHeaders.hostHeader: "xgxt.xidian.edu.cn",
        },
      ),
    );
    while (response.headers[HttpHeaders.locationHeader] != null) {
      location = response.headers[HttpHeaders.locationHeader]![0];
      debugLog(() => "[ehall_session][useApp] Received location: $location.");
      response = await dioEhall.get(
        location,
        options: Options(
          headers: {
            HttpHeaders.refererHeader:
                "https://xgxt.xidian.edu.cn/xsfw/sys/jbxxapp/*default/index.do",
            HttpHeaders.hostHeader: "xgxt.xidian.edu.cn",
          },
        ),
      );
    }
    await dioEhall.post(
      "https://xgxt.xidian.edu.cn/xsfw/sys/swpubapp/indexmenu/getAppConfig.do?appId=4585275700341858&appName=jbxxapp",
      options: Options(
        headers: {
          HttpHeaders.refererHeader:
              "https://xgxt.xidian.edu.cn/xsfw/sys/jbxxapp/*default/index.do",
          HttpHeaders.hostHeader: "xgxt.xidian.edu.cn",
        },
      ),
    );

    /// Get information here. resultCode==00000 is successful.
    debugLog(() => "[ehall_session][getDormInfoEhall] Getting the dorm information.");
    var detailed = await dioEhall
        .post(
          "https://xgxt.xidian.edu.cn/xsfw/sys/jbxxapp/modules/infoStudent/getStuBaseInfo.do",
          data:
              "requestParamStr="
              "{\"XSBH\":\"${preference.getString(preference.Preference.idsAccount)}\"}",
          options: Options(
            headers: {
              HttpHeaders.refererHeader:
                  "https://xgxt.xidian.edu.cn/xsfw/sys/jbxxapp/*default/index.do",
              HttpHeaders.hostHeader: "xgxt.xidian.edu.cn",
            },
          ),
        )
        .then((value) {
          var data = value.data;
          if (data == null) {
            throw GetInformationFailedException("无法获取宿舍信息");
          }
          return data;
        });
    debugLog(() => "[ehall_session][getDormInfoEhall] Storing the user information.");
    if (detailed["returnCode"] != "#E000000000000") {
      throw GetInformationFailedException(detailed["description"]);
    }

    if (detailed["data"] == null || detailed["data"]["ZSDZ"] == null) {
      throw GetInformationFailedException("宿舍信息数据结构异常");
    }

    return detailed["data"]["ZSDZ"].toString();
  }

  Future<void> getSemesterInfoEhall() async {
    debugLog(() => "[ehall_session][getSemesterInfoEhall] Get the semester information.");
    String get = await useApp("4770397878132218");
    await dioEhall.post(get);
    String semesterCode = await dioEhall
        .post(
          "https://ehall.xidian.edu.cn/jwapp/sys/wdkb/modules/jshkcb/dqxnxq.do",
        )
        .then((value) {
          var data = value.data;
          if (data == null || data['datas'] == null || data['datas']['dqxnxq'] == null ||
              data['datas']['dqxnxq']['rows'] == null || data['datas']['dqxnxq']['rows'].isEmpty) {
            throw GetInformationFailedException("无法获取本科生学期信息");
          }
          return data['datas']['dqxnxq']['rows'][0]['DM'];
        });
    await preference.setString(
      preference.Preference.currentSemester,
      semesterCode,
    );
  }
}
