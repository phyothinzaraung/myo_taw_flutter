import 'dart:async';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:myotaw/myWidget/CustomScaffoldWidget.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'myWidget/CustomProgressIndicator.dart';

class NewsFeedWebViewScreen extends StatefulWidget {

  final String _pdfOrAudioUrl;

  NewsFeedWebViewScreen(this._pdfOrAudioUrl);

  @override
  NewsFeedWebViewScreenState createState() => NewsFeedWebViewScreenState();
}

class NewsFeedWebViewScreenState extends State<NewsFeedWebViewScreen> {

  Completer<WebViewController> _controller = Completer<WebViewController>();
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      body: ModalProgressHUD(
        inAsyncCall: _isLoading,
        progressIndicator: CustomProgressIndicatorWidget(),
        child: WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl: widget._pdfOrAudioUrl,
          onWebViewCreated: (wv){
            _controller.complete(wv);
          },
          onPageFinished: (finish){
            if(_controller.isCompleted){
              setState(() {
                _isLoading = false;
              });
            }
          },
        ),
      ),
    );
  }
}
