import 'dart:async';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:myotaw/helper/MyoTawConstant.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'myWidget/CustomProgressIndicator.dart';

class MyoTawPolicyWebViewScreen extends StatefulWidget {
  @override
  _MyoTawPolicyWebViewScreenState createState() => _MyoTawPolicyWebViewScreenState();
}

class _MyoTawPolicyWebViewScreenState extends State<MyoTawPolicyWebViewScreen> {

  Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController _webViewController;
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        progressIndicator: CustomProgressIndicatorWidget(),
        child: WebView(
          initialUrl: BaseUrl.MYO_TAW_POLICY_URL,
          onWebViewCreated: (wv){
            _controller.complete(wv);
            _webViewController = wv;
          },
          onPageFinished: (finish){
            setState(() {
              _isLoading = false;
            });
          },
        ),
      ),
    );
  }
}
