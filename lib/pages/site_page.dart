import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SitePage extends StatefulWidget {
  @override
  _SitePageState createState() => _SitePageState();
}

class _SitePageState extends State<SitePage> {
  var _showProgress = true;

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
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Expanded(
              child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: "https://flutter.dev",
                onPageFinished: _onPageFinished,
              ),
            ),
          ],
        ),
        Opacity(
          opacity: _showProgress ? 1 : 0,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  void _onPageFinished(String value) {
    print("onPageFinished");
    setState(() {
      _showProgress = false;
    });
  }
}
