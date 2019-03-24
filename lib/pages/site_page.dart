import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SitePage extends StatefulWidget {
  @override
  _SitePageState createState() => _SitePageState();
}

class _SitePageState extends State<SitePage> {
  var _stackIdx = 1;

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
    return IndexedStack(
      index: _stackIdx,
      children: [
        Column(
          children: < Widget > [
            Expanded(
                child: WebView(
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: "https://flutter.dev",
                  onPageFinished: _onPageFinished,
                )
            ),
          ],
        ),
        Container(
          color: Colors.white,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }

  void _onPageFinished(String value) {
    setState(() {
      _stackIdx = 0;
    });
  }
}
