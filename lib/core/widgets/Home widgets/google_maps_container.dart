import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GoogleMapContainer extends StatefulWidget {
  final String googleMapUrl;

  const GoogleMapContainer({Key? key, required this.googleMapUrl})
      : super(key: key);

  @override
  State<GoogleMapContainer> createState() => _GoogleMapContainerState();
}

class _GoogleMapContainerState extends State<GoogleMapContainer> {
  late final WebViewController _controller;
  bool _webViewFailed = false;

  bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null && uri.hasAbsolutePath && uri.hasScheme;
  }

  // Future<void> _openInBrowser(String url) async {
  //   final uri = Uri.parse(url);
  //   if (await canLaunchUrl(uri)) {
  //     await launchUrl(uri, mode: LaunchMode.externalApplication);
  //   }
  // }

  @override
  void initState() {
    super.initState();

    final htmlData = '''
      <html>
        <body style="margin:0;padding:0;">
          <iframe 
            src="${widget.googleMapUrl}"
            width="100%" 
            height="100%" 
            frameborder="0">
          </iframe>
        </body>
      </html>
    ''';

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onWebResourceError: (error) {
            setState(() {
              _webViewFailed = true;
            });
          },
        ),
      )
      ..loadHtmlString(htmlData);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isValidUrl(widget.googleMapUrl) || _webViewFailed) {
      // fallback: show a clickable image that opens map in browser
      return Container(
        height: 250.h,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage('assets/images/map_placeholder.jpg'), // add your own image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Icon(Icons.map, size: 48, color: Colors.white),
        ),
      );
    }

    // working embedded webview
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        height: 250.h,
        width: double.infinity,
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
