import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class RecaptchaTool extends StatefulWidget {
  final Function(String) onTokenReceived;

  const RecaptchaTool({super.key, required this.onTokenReceived});

  @override
  State<RecaptchaTool> createState() => _RecaptchaToolState();
}

class _RecaptchaToolState extends State<RecaptchaTool> {
  late final WebViewController _controller;

  static const String _siteKey =
      '6LeIndcqAAAAABOidvXvB9q1uI0j0-50Qy6Uv3-W';

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(Colors.transparent)
          ..addJavaScriptChannel(
            'RecaptchaChannel',
            onMessageReceived: (JavaScriptMessage message) {
              widget.onTokenReceived(message.message);
            },
          )
          ..loadHtmlString(_getHtmlContent());
  }

  String _getHtmlContent() {
    return '''
      <html>
        <head>
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <script src="https://www.google.com/recaptcha/api.js" async defer></script>
          <style>
            body { display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
          </style>
        </head>
        <body>
          <div class="g-recaptcha" 
               data-sitekey="$_siteKey" 
               data-callback="onCaptchaVerified">
          </div>
          <script type="text/javascript">
            function onCaptchaVerified(token) {
              RecaptchaChannel.postMessage(token);
            }
          </script>
        </body>
      </html>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600, 
      child: WebViewWidget(controller: _controller),
    );
  }
}
