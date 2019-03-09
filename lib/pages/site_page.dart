import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SitePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Site"),
      ),
      body: _webView(),
    );
  }

  _webView() {
    return WebView(
      initialUrl: "https://flutter.dev",
    );
  }
}
