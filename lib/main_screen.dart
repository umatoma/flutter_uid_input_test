import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MainScreen extends StatefulWidget {
  final ChromeSafariBrowser browser = new MyChromeSafariBrowser(
    new MyInAppBrowser(),
  );

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    widget.browser.addMenuItem(
      new ChromeSafariBrowserMenuItem(
        id: 1,
        label: 'Custom item menu 1',
        action: (url, title) {
          print('Custom item menu 1 clicked!');
          print(url);
          print(title);
        },
      ),
    );
    widget.browser.addMenuItem(
      new ChromeSafariBrowserMenuItem(
        id: 2,
        label: 'Custom item menu 2',
        action: (url, title) {
          print('Custom item menu 2 clicked!');
          print(url);
          print(title);
        },
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ChromeSafariBrowser Example'),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () async {
            await widget.browser.open(
              url: 'https://uid-input-test.herokuapp.com/',
              options: ChromeSafariBrowserClassOptions(
                android: AndroidChromeCustomTabsOptions(
                  addDefaultShareMenuItem: false,
                ),
                ios: IOSSafariOptions(
                  barCollapsingEnabled: true,
                ),
              ),
            );
          },
          child: Text('Open Chrome Safari Browser'),
        ),
      ),
    );
  }
}

class MyInAppBrowser extends InAppBrowser {
  @override
  Future onLoadStart(String url) async {
    print("\n\nStarted $url\n\n");
  }

  @override
  Future onLoadStop(String url) async {
    print("\n\nStopped $url\n\n");
  }

  @override
  void onLoadError(String url, int code, String message) {
    print("\n\nCan't load $url.. Error: $message\n\n");
  }

  @override
  void onExit() {
    print("\n\nBrowser closed!\n\n");
  }
}

class MyChromeSafariBrowser extends ChromeSafariBrowser {
  MyChromeSafariBrowser(browserFallback) : super(bFallback: browserFallback);

  @override
  void onOpened() {
    print("ChromeSafari browser opened");
  }

  @override
  void onCompletedInitialLoad() {
    print("ChromeSafari browser initial load completed");
  }

  @override
  void onClosed() {
    print("ChromeSafari browser closed");
  }
}
