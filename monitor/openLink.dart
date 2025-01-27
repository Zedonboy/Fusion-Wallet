import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'dart:async';
import 'dart:io';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../constants/colors.dart';
import '../../controllers/appController.dart';

class OpenLink extends StatefulWidget {
  final String fromPage;

  OpenLink({@required this.url, this.fromPage = ''});

  final String? url;

  @override
  _OpenLinkState createState() => _OpenLinkState();
}

class _OpenLinkState extends State<OpenLink> {
  final appController = Get.find<AppController>();
  bool loading = true;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(useShouldOverrideUrlLoading: true, mediaPlaybackRequiresUserGesture: false),
    android: AndroidInAppWebViewOptions(useHybridComposition: true),
    ios: IOSInAppWebViewOptions(allowsInlineMediaPlayback: true),
  );

  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  String url = "";
  double progress = 0;
  final urlController = TextEditingController();
  Timer? timer;
  String lastOrderID = '';

  @override
  void initState() {
    super.initState();
    initialize();
    if (widget.fromPage == '') {
      //getLastTrade();
    }
  }

  // getLastTrade() async {
  //   await WalletServices().getLatestTrade(appController.walletAddress.value).then((value) {
  //     if (value.orderID != null && value.orderID != '') {
  //       lastOrderID = value.orderID!;
  //     }
  //   });
  //   timer = Timer.periodic(Duration(seconds: 2), (timer) async {
  //     await appController.getTradeStatus(appController.walletAddress.value).then((value) {
  //       if (lastOrderID != appController.orderId.value) {
  //         if (appController.orderStatus.value == 'PENDING_DELIVERY_FROM_TRANSAK' || appController.orderStatus.value == 'FAILED') {
  //           showSnackBar(value.status == 'FAILED' ? 'Order Failed' : 'Pending Delivery from Transak');
  //         }
  //       }
  //     });
  //   });
  // }

  initialize() async {
    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              androidId: 1,
              iosId: "1",
              title: "Special",
              action: () async {
                print("Menu item Special clicked!");
                print(await webViewController?.getSelectedText());
                await webViewController?.clearFocus();
              })
        ],
        options: ContextMenuOptions(hideDefaultSystemContextMenuItems: false),
        onCreateContextMenu: (hitTestResult) async {
          print("onCreateContextMenu");
          print(hitTestResult.extra);
          print(await webViewController?.getSelectedText());
        },
        onHideContextMenu: () {
          print("onHideContextMenu");
        },
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {
          var id = (Platform.isAndroid) ? contextMenuItemClicked.androidId : contextMenuItemClicked.iosId;
          print("onContextMenuActionItemClicked: " + id.toString() + " " + contextMenuItemClicked.title);
        });

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(color: primaryColor.value),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );

    if (Platform.isAndroid) {
      await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

      var swAvailable = await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      var swInterceptAvailable = await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

      if (swAvailable && swInterceptAvailable) {
        AndroidServiceWorkerController serviceWorkerController = AndroidServiceWorkerController.instance();

        await serviceWorkerController.setServiceWorkerClient(
          AndroidServiceWorkerClient(
            shouldInterceptRequest: (request) async {
              print(request);
              return null;
            },
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (widget.fromPage == '') {
      timer!.cancel();
    }

    //pusher.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: primaryBackgroundColor.value,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: primaryColor.value,
          title: Text(widget.fromPage != '' ? widget.fromPage : 'Payment',style: TextStyle(fontFamily: 'sfpro',),),
        ),
        body: Stack(
          children: [
            InAppWebView(
              key: webViewKey,
              initialUrlRequest: URLRequest(url: WebUri(widget.url!)),
              initialOptions: options,
              pullToRefreshController: pullToRefreshController,
              onWebViewCreated: (controller) {
                webViewController = controller;
              },
              onLoadStart: (controller, url) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              androidOnPermissionRequest: (controller, origin, resources) async {
                return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);
              },
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                var uri = navigationAction.request.url!;

                return NavigationActionPolicy.ALLOW;
              },
              onLoadStop: (controller, url) async {
                pullToRefreshController.endRefreshing();
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onLoadError: (controller, url, code, message) {
                pullToRefreshController.endRefreshing();
              },
              onProgressChanged: (controller, progress) {
                if (progress == 100) {
                  pullToRefreshController.endRefreshing();
                }
                setState(() {
                  this.progress = progress / 100;
                  urlController.text = this.url;
                });
              },
              onUpdateVisitedHistory: (controller, url, androidIsReload) {
                setState(() {
                  this.url = url.toString();
                  urlController.text = this.url;
                });
              },
              onConsoleMessage: (controller, consoleMessage) {},
            ),
            progress < 1.0 ? LinearProgressIndicator(value: progress) : Container(),
          ],
        ),
      ),
    );
  }

  void showSnackBar(String msg) {
    Get.snackbar(
      msg,
      "Go back to trade history to check status",
      duration: 20.seconds,
      snackPosition: SnackPosition.BOTTOM,
      showProgressIndicator: false,
      isDismissible: true,
      backgroundColor: primaryColor.value,
      colorText: Colors.white,
      mainButton: TextButton(
        onPressed: () {
          Get.closeCurrentSnackbar();
          Navigator.pop(context);
        },
        child: const Text(
          "Go Back",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white,fontFamily: 'sfpro',),
        ),
      ),
    );
  }
}