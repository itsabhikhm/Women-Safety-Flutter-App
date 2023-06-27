import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/quotes.dart';

class SafeWebView extends StatelessWidget {
  final String? url;
  final String title;
  final int index;
  const SafeWebView(
      {Key? key, this.url, required this.title, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(url!));

    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: Text(title),
        trailing: CircleAvatar(
          backgroundColor: Colors.grey[200],
          backgroundImage: AssetImage(imageSliders[index]),
        ),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
