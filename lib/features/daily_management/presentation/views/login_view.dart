// Copyright 2023-2025 BenderBlog Rodriguez and contributors
// Copyright 2025 Traintime PDA authors.
// SPDX-License-Identifier: MPL-2.0

// Login window of the program.

import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ai_assistant/repository/logger.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:styled_widget/styled_widget.dart';
import 'package:ai_assistant/repository/xidian_ids/jc_captcha.dart';
import 'package:ai_assistant/repository/xidian_ids/ehall_session.dart';
import 'package:ai_assistant/repository/preference.dart' as preference;
import 'package:ai_assistant/repository/xidian_ids/ids_session.dart';
import 'package:ai_assistant/repository/xidian_ids/personal_info_session.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  /// The rest of Text Editing Controller
  final TextEditingController _idsAccountController = TextEditingController();
  final TextEditingController _idsPasswordController = TextEditingController();

  /// Something related to the box.
  final double widthOfSquare = 32.0;
  final double roundRadius = 36;

  /// Variables of the input textfield
  InputDecoration _inputDecoration({
    required IconData iconData,
    required String hintText,
    Widget? suffixIcon,
  }) => InputDecoration(
    prefixIcon: Icon(iconData),
    hintText: hintText,
    suffixIcon: suffixIcon,
  );

  /// Can I see the password?
  bool _couldNotView = true;

  Widget contentColumn() => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      TextField(
        controller: _idsAccountController,
        decoration: _inputDecoration(
          iconData: MingCuteIcons.mgc_user_3_fill,
          hintText: "学号/工号",
        ),
      ).center(),
      const SizedBox(height: 16.0),
      TextField(
        controller: _idsPasswordController,
        obscureText: _couldNotView,
        decoration: _inputDecoration(
          iconData: MingCuteIcons.mgc_safe_lock_fill,
          hintText: "密码",
          suffixIcon: IconButton(
            icon: Icon(_couldNotView ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _couldNotView = !_couldNotView;
              });
            },
          ),
        ),
      ).center(),
      SizedBox(height: width / height > 1.0 ? 16.0 : 64.0),
      FilledButton(
        style: FilledButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          maximumSize: const Size(double.infinity, 64),
        ),
        child: const Text(
          "登录",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
        ),
        onPressed: () async {
          if (_idsPasswordController.text.isNotEmpty) {
            await login();
          } else {
            _showMessage("请输入密码");
          }
        },
      ),
      const SizedBox(height: 8.0),
    ],
  ).constrained(maxWidth: 400);

  Future<void> login() async {
    bool isGood = true;
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      msg: "正在登录...",
      max: 100,
      hideValue: true,
      completed: Completed(
        completedMsg: "登录完成",
      ),
    );
    EhallSession ses = EhallSession();

    try {
      await ses.clearCookieJar();
      log.warning(
        "[login_view][login] "
        "Have cleared login state.",
      );
    } on Exception {
      log.warning(
        "[login_view][login] "
        "No clear state.",
      );
    }

    try {
      await ses.loginEhall(
        username: _idsAccountController.text,
        password: _idsPasswordController.text,
        onResponse: (int number, String status) => pd.update(
          msg: status,
          value: number,
        ),
        sliderCaptcha: (String cookieStr) {
          return SliderCaptchaClientProvider(cookie: cookieStr).solve(context);
        },
      );
      if (!mounted) return;
        if (isGood == true) {
          // 设置登录状态为成功
          loginState = IDSLoginState.success;
          preference.setString(
            preference.Preference.idsAccount,
            _idsAccountController.text,
          );
          preference.setString(
            preference.Preference.idsPassword,
            _idsPasswordController.text,
          );        bool isPostGraduate = await ses.checkWhetherPostgraduate();
        if (isPostGraduate) {
          // 实现研究生信息获取
          log.info("Postgraduate login successful, getting semester info");
          try {
            await PersonalInfoSession().getSemesterInfoYjspt();
            log.info("Postgraduate semester info retrieved successfully");
          } catch (e) {
            log.warning("Failed to get postgraduate semester info: $e");
            // 不阻断登录流程，继续执行
          }
        } else {
          // 实现本科生信息获取
          log.info("Undergraduate login successful, getting semester info");
          try {
            await PersonalInfoSession().getSemesterInfoEhall();
            log.info("Undergraduate semester info retrieved successfully");
          } catch (e) {
            log.warning("Failed to get undergraduate semester info: $e");
            // 不阻断登录流程，继续执行
          }
        }

        if (mounted) {
          if (pd.isOpen()) pd.close();
          _showMessage("登录成功");

          // 实现导航到主界面
          log.info("Login successful, navigating to main interface");
          // 保存登录状态和用户角色
          await preference.setBool(preference.Preference.role, isPostGraduate);

          // 导航到主界面
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/main');
          }
        }
      }
    } catch (e, s) {
      isGood = false;
      pd.close();
      if (mounted) {
        if (e is PasswordWrongException) {
          _showMessage(e.msg);
        } else if (e is LoginFailedException) {
          _showMessage(e.msg);
        } else if (e is DioException) {
          if (e.message == null) {
            if (e.response == null) {
              _showMessage("无法连接到服务器");
            } else {
              _showMessage("登录失败，状态码：${e.response!.statusCode}");
            }
          } else {
            _showMessage("登录失败：${e.message}");
          }
        } else {
          log.warning(
            "[login_view][login] "
            "Login failed with error: \n$e\nStacktrace is:\n$s",
          );
          _showMessage("登录失败：${e.toString().substring(0, min(e.toString().length, 120))}");
        }
      }
    }
  }

  double get width => MediaQuery.sizeOf(context).width;
  double get height => MediaQuery.sizeOf(context).height;

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void initState() {
    super.initState();

    var cachedAccount = preference.getString(preference.Preference.idsAccount);
    if (cachedAccount.isNotEmpty) {
      _idsAccountController.text = cachedAccount;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("登录"),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          left: width / height > 1.0 ? width * 0.25 : widthOfSquare,
          right: width / height > 1.0 ? width * 0.25 : widthOfSquare,
          top: kToolbarHeight,
        ),
        child: width / height > 1.0
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: contentColumn()),
                ],
              )
            : Column(
                children: [
                  contentColumn(),
                ],
              ).center(),
      ),
    );
  }
}
