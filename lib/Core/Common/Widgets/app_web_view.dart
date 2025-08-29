import 'package:towtrackwhiz/Core/Utils/log_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'base_scaffold.dart';

class AppWebView extends StatefulWidget {
  final String fileUrl;
  final String barTitle;

  const AppWebView({super.key, required this.fileUrl, required this.barTitle});

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  late WebViewController? webViewController;
  RxBool isPageLoading = true.obs;

  @override
  void initState() {
    super.initState();
    webViewController =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // if(progress < 100) {
                //   isPageLoading.value = true;
                // }
              },
              onPageStarted: (String url) {
                isPageLoading.value = true;
              },
              onPageFinished: (String url) {
                isPageLoading.value = false;
              },
              onHttpError: (HttpResponseError error) {
                Log.e(
                  "AppWebView -- [onHttpError]",
                  error.response?.statusCode.toString(),
                );
              },
              onWebResourceError: (WebResourceError error) {
                Log.e("AppWebView -- [onWebResourceError]", error.description);
              },
              onNavigationRequest: (NavigationRequest request) {
                // if (request.url.startsWith(widget.fileUrl)) {
                //   return NavigationDecision.prevent;
                // }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..enableZoom(false)
          ..loadRequest(Uri.parse(widget.fileUrl));
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, res) async {
        if (didPop) return;
        bool canGoBack = await webViewController!.canGoBack();
        if (canGoBack) {
          webViewController!.goBack();
        } else {
          Get.back();
        }
      },
      child: BaseScaffold(
        appBarTitle: widget.barTitle,
        bodyPadding: EdgeInsets.zero,
        body: Obx(() {
          if (isPageLoading.value) {
            return Center(child: CircularProgressIndicator());
          }
          return WebViewWidget(controller: webViewController!);
        }),
      ),
    );
  }
}
