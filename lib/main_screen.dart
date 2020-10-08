import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_uid_input_test/user_detail_edit_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    // 通知の許可をリクエスト
    _firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(
        sound: true,
        badge: true,
        alert: true,
      ),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialUrl: 'https://www.baits.jp/',
          initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
              useShouldInterceptAjaxRequest: true,
              useShouldInterceptFetchRequest: true,
              debuggingEnabled: kDebugMode,
            ),
          ),
          onWebViewCreated: (controller) {},
          onAjaxReadyStateChange: _onAjaxReadyStateChange,
        ),
      ),
    );
  }

  // Ajaxリクエストが行われたとき
  Future<AjaxRequestAction> _onAjaxReadyStateChange(
    InAppWebViewController controller,
    AjaxRequest ajaxRequest,
  ) async {
    try {
      // NOTE: Turbolinksが使われていたため
      //       onLoadStopではなくonAjaxReadyStateChangeで処理しています

      // 新規登録ページ
      if (ajaxRequest.isLoadedURL(RegExp(r'\/users\/new\/?$'))) {
        await _onLoadUsersNewPage(controller);
        return AjaxRequestAction.PROCEED;
      }

      // ログインページ
      if (ajaxRequest.isLoadedURL(RegExp(r'\/login\/?$'))) {
        await _onLoadLoginPage(controller);
        return AjaxRequestAction.PROCEED;
      }

      // ユーザー情報編集ページ
      if (ajaxRequest.isLoadedURL(RegExp(r'\/user_details\/\d+\/edit\/?$'))) {
        await _onLoadUserDetailsEditPage(controller);
        return AjaxRequestAction.PROCEED;
      }

      return AjaxRequestAction.PROCEED;
    } catch (e) {
      print(e);
      return AjaxRequestAction.ABORT;
    }
  }

  // ユーザー登録ページが読み込まれたとき
  Future<void> _onLoadUsersNewPage(InAppWebViewController controller) async {
    final String name = 'user[device_token]';
    final String token = await FirebaseMessaging().getToken();

    await controller.evaluateJavascript(
      source: 'document.getElementsByName("$name")[0].value = "$token";',
    );
  }

  // ログインページが読み込まれたとき
  Future<void> _onLoadLoginPage(InAppWebViewController controller) async {
    final String name = 'device_token';
    final String token = await FirebaseMessaging().getToken();

    await controller.evaluateJavascript(
      source: 'document.getElementsByName("$name")[0].value = "$token";',
    );
  }

  // ユーザー情報編集ページが読み込まれたとき
  Future<void> _onLoadUserDetailsEditPage(
    InAppWebViewController controller,
  ) async {
    // NOTE: フォームの値が取得できるまでラグがあるので少し待つ
    await Future.delayed(Duration(milliseconds: 100));

    final String firstNameKey = 'user_detail[first_name]';
    final String lastNameKey = 'user_detail[last_name]';
    final String firstName = await controller.evaluateJavascript(
      source: 'document.getElementsByName("$firstNameKey")[0].value;',
    );
    final String lastName = await controller.evaluateJavascript(
      source: 'document.getElementsByName("$lastNameKey")[0].value;',
    );

    final UserDetailEditParams params = await Navigator.of(context).push(
      MaterialPageRoute<UserDetailEditParams>(
        builder: (_) => UserDetailEditScreen(
          params: UserDetailEditParams(firstName, lastName),
        ),
      ),
    );
    if (params != null) {
      await controller.evaluateJavascript(
        source: 'document.getElementsByName("$firstNameKey")[0].value'
            ' = "${params.firstName}";',
      );
      await controller.evaluateJavascript(
        source: 'document.getElementsByName("$lastNameKey")[0].value'
            ' = "${params.lastName}";',
      );
      await controller.evaluateJavascript(
        source: 'document.getElementsByName("commit")[0].click();',
      );
    }
  }
}

extension PathChecker on AjaxRequest {
  bool isLoadedURL(RegExp match) {
    return readyState == AjaxRequestReadyState.DONE &&
        status == 200 &&
        match.hasMatch(url);
  }
}
