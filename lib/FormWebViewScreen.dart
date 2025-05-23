import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'helper/MyoTawConstant.dart';
import 'myWidget/CustomProgressIndicator.dart';

class FormWebViewScreen extends StatefulWidget {

  String _FormUrl, _uniqueKey, _title;

  FormWebViewScreen(this._FormUrl, this._uniqueKey, this._title);

  @override
  _FormWebViewScreenState createState() => _FormWebViewScreenState();
}

class _FormWebViewScreenState extends State<FormWebViewScreen> {

  Completer<WebViewController> _controller = Completer<WebViewController>();
  WebViewController _webViewController;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: Text(widget._title, maxLines: 1, overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.white, fontSize: FontSize.textSizeNormal),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        progressIndicator: CustomProgressIndicatorWidget(),
        child: WebviewScaffold(
            url: widget._FormUrl.replaceAll("null", widget._uniqueKey),
            withJavascript: true,
            hidden: false,
            clearCache: true,
            initialChild: Center(child: CustomProgressIndicatorWidget()),
        )/*WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget._FormUrl.replaceAll("null", widget._uniqueKey),
          onWebViewCreated: (wv){
            _controller.complete(wv);
            _webViewController = wv;
          },
          onPageFinished: (finish){
            setState(() {
              _isLoading = false;
            });
          },
        ),*/
      ),
    );
  }
}
