import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

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
          initialUrl: 'https://uid-input-test.herokuapp.com/',
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
      if (ajaxRequest.readyState == AjaxRequestReadyState.DONE &&
          ajaxRequest.status == 200 &&
          ajaxRequest.url.endsWith('/users/new')) {
        await _onLoadUsersNewPage(controller);
        return AjaxRequestAction.PROCEED;
      }

      if (ajaxRequest.readyState == AjaxRequestReadyState.DONE &&
          ajaxRequest.status == 200 &&
          ajaxRequest.url.endsWith('/login')) {
        await _onLoadLoginPage(controller);
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
}
