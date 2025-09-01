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
  
  /// Remember login info
  bool _rememberLogin = true;

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
      const SizedBox(height: 16.0),
      CheckboxListTile(
        title: const Text("记住登录信息"),
        subtitle: const Text("下次启动时自动登录"),
        value: _rememberLogin,
        onChanged: (value) {
          setState(() {
            _rememberLogin = value ?? false;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
      ),
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
    // 使用traintime_pda的登录逻辑
    if (loginState == IDSLoginState.requesting) {
      return;
    }
    
    await setLoginState(IDSLoginState.requesting);
    
    if (!mounted) return;
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(
      msg: "正在登录...",
      max: 100,
      hideValue: true,
      completed: Completed(
        completedMsg: "登录完成",
      ),
    );

    try {
      // 根据用户选择保存登录信息
      await preference.setString(
        preference.Preference.idsAccount,
        _idsAccountController.text,
      );
      
      if (_rememberLogin) {
        await preference.setString(
          preference.Preference.idsPassword,
          _idsPasswordController.text,
        );
        await preference.setBool(preference.Preference.rememberLogin, true);
        await preference.setBool(preference.Preference.autoLogin, true);
      } else {
        await preference.setString(preference.Preference.idsPassword, "");
        await preference.setBool(preference.Preference.rememberLogin, false);
        await preference.setBool(preference.Preference.autoLogin, false);
      }
      
      // 使用IDSSession的checkAndLogin方法
      await IDSSession().checkAndLogin(
        target: "https://ehall.xidian.edu.cn/login?service="
               "https://ehall.xidian.edu.cn/new/index.html",
        sliderCaptcha: (String cookieStr) async {
          await SliderCaptchaClientProvider(cookie: cookieStr).solve(context);
        },
      );
      
      // 登录成功，设置状态
      await setLoginState(IDSLoginState.success);
      log.info("[LoginView] Login successful, loginState set to success");
      
      if (mounted) {
        pd.close();
        _showMessage("登录成功");
        
        // 获取用户信息（不阻断登录流程）
        try {
          EhallSession ses = EhallSession();
          bool isPostGraduate = await ses.checkWhetherPostgraduate();
          await preference.setBool(preference.Preference.role, isPostGraduate);
          
          if (isPostGraduate) {
            log.info("Postgraduate login successful");
            try {
              await PersonalInfoSession().getSemesterInfoYjspt();
              log.info("Postgraduate semester info retrieved successfully");
            } catch (e) {
              log.warning("Failed to get postgraduate semester info: $e");
            }
          } else {
            log.info("Undergraduate login successful");
            try {
              await PersonalInfoSession().getSemesterInfoEhall();
              log.info("Undergraduate semester info retrieved successfully");
            } catch (e) {
              log.warning("Failed to get undergraduate semester info: $e");
            }
          }
        } catch (e) {
          log.warning("Failed to get user info: $e");
        }
        
        // 返回成功
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      }
      
    } on PasswordWrongException {
      await setLoginState(IDSLoginState.passwordWrong);
      if (mounted) {
        pd.close();
        _showMessage("密码错误");
      }
    } catch (e, s) {
      await setLoginState(IDSLoginState.fail);
      log.warning(
        "[LoginView] Login failed with error: $e\nStacktrace: $s",
      );
      
      if (mounted) {
        pd.close();
        if (e is LoginFailedException) {
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
    
    // 初始化记住登录信息状态
    _rememberLogin = preference.getBool(preference.Preference.rememberLogin);
    
    // 如果记住了登录信息，自动填充密码
    if (_rememberLogin) {
      var cachedPassword = preference.getString(preference.Preference.idsPassword);
      if (cachedPassword.isNotEmpty) {
        _idsPasswordController.text = cachedPassword;
      }
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
