import 'package:flutter/material.dart';
import 'package:myself_diary/classes/utilities/custom/app_drawer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class InAppWebViewScreen extends StatefulWidget {
  final String url;
  final String? title; // optional static title

  const InAppWebViewScreen({super.key, required this.url, this.title});

  @override
  State<InAppWebViewScreen> createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen> {
  late final WebViewController _controller;
  double _progress = 0.0;
  String? _pageTitle;

  @override
  void initState() {
    super.initState();

    // Enable hybrid composition on Android (smoother rendering for some cases)
    // if (Platform.isAndroid) {
    //   WebView.platform = AndroidWebView();
    // }

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => setState(() {
            _progress = 0.05;
          }),
          onProgress: (progress) => setState(() {
            _progress = progress / 100.0;
          }),
          onPageFinished: (url) async {
            // Try to read the page title dynamically
            final t = await _controller.getTitle();
            setState(() {
              _pageTitle = t;
              _progress = 0.0;
            });
          },
          onNavigationRequest: (request) {
            // Allow all http/https; block others (e.g., intent://) if you want
            final uri = Uri.tryParse(request.url);
            if (uri == null) return NavigationDecision.prevent;
            if (uri.scheme == 'http' || uri.scheme == 'https') {
              return NavigationDecision.navigate;
            }
            // Disallow unknown schemes by default
            return NavigationDecision.prevent;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _reload() async {
    await _controller.reload();
  }

  Future<void> _goBack() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
    }
  }

  Future<void> _goForward() async {
    if (await _controller.canGoForward()) {
      await _controller.goForward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final showTitle = widget.title ?? _pageTitle ?? 'Loading…';

    return Scaffold(
      appBar: AppBar(
        title: Text(showTitle, overflow: TextOverflow.ellipsis),
        // leading: IconButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   icon: Icon(Icons.chevron_left),
        // ),
        actions: [
          IconButton(
            tooltip: 'Back',
            icon: const Icon(Icons.arrow_back),
            onPressed: _goBack,
          ),
          IconButton(
            tooltip: 'Forward',
            icon: const Icon(Icons.arrow_forward),
            onPressed: _goForward,
          ),
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: _reload,
          ),
        ],

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            height: _progress > 0 && _progress < 1 ? 2 : 0,
            color: Theme.of(context).colorScheme.primary,
            child: LinearProgressIndicator(
              value: (_progress > 0 && _progress < 1) ? _progress : null,
              backgroundColor: Colors.transparent,
              minHeight: 2,
            ),
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: SafeArea(child: WebViewWidget(controller: _controller)),
    );
  }
}
