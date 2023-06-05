import 'package:demo_webview/SplashScreenPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // navigation bar color
      statusBarColor: Colors.white, // status bar color
      statusBarIconBrightness: Brightness.dark, // status bar icon color
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final WebViewController _controller;
  bool _isLoading = false;
  int _selectedIndex = 0;

  static const List<String> _page = [
    "https://flutter.dev",
    "https://www.google.com",
    "https://www.youtube.com",
    "https://www.facebook.com"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _controller.canGoBack()) {
          _controller.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SafeArea(
          child: Stack(children: [
            WebViews(),
            if (_isLoading) const Center(child: CircularProgressIndicator()),
          ]),
        ),
        bottomNavigationBar: NavBottom(),
      ),
    );
  }

  WebView WebViews() {
    return WebView(
      initialUrl: _page[_selectedIndex],
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        _controller = controller;
      },
      onPageStarted: (String url) {
        setState(() {
          _isLoading = true;
        });
      },
      onPageFinished: (String url) {
        setState(() {
          _isLoading = false;
        });
      },
      onWebResourceError: (error) => _showErrorDialog()
    );
  }

  // _page.elementAt(_selectedIndex), tab gnav
  Container NavBottom() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          blurRadius: 20,
          color: Colors.black.withOpacity(.1),
        )
      ]),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
            child: GNav(
          rippleColor: Colors.green[300]!,
          // color khi click vao
          hoverColor: Colors.green[100]!,
          // mau hover
          gap: 8,
          // khoang cach giua text va icon
          activeColor: Colors.orange,
          // mau tab duoc chon
          iconSize: 24,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          // navigation bar padding
          duration: const Duration(milliseconds: 400),
          tabBackgroundColor: Colors.orange[100]!,
          // mau back tab khi duoc chon
          color: Colors.grey[800],
          // mau icon khi chua dc chon
          tabBorderRadius: 15,
          // border tab
          // tabBorder: Border.all(color: Colors.grey, width: 1), // tab button border
          // tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)],
          // curve: Curves.easeOutExpo,
          haptic: true,
          tabs: [
            GButton(
              text: "Home",
              icon: Icons.home,
            ),
            GButton(
              text: "Likes",
              icon: Icons.heart_broken,
            ),
            GButton(
              text: "Search",
              icon: Icons.search,
            ),
            GButton(
              text: "Profile",
              icon: Icons.supervised_user_circle,
            ),
          ],
          selectedIndex: _selectedIndex,
          onTabChange: (index) {
            _controller.loadUrl(_page[index]);
            setState(() {
              _selectedIndex = index;
            });
          },
        )),
      ),
    );
  }

  _showErrorDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("No Internet",style: TextStyle(fontFamily: "MyFont"),),
        content: const Text("Please check your internet connection and try again",style: TextStyle(fontFamily: "MyFont"),),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

///// cach moi
// webView(url) {
//   _controller = WebViewController()
//     ..setJavaScriptMode(JavaScriptMode.unrestricted)
//     ..setBackgroundColor(const Color(0x00000000))
//     ..setNavigationDelegate(
//       NavigationDelegate(
//         onProgress: (int progress) {
//           // Update loading bar.
//         },
//         onPageStarted: (String url) {
//           setState(() {
//             _isLoading = true;
//           });
//         },
//         onPageFinished: (String url) {
//           setState(() {
//             _isLoading = false;
//           });
//         },
//         onWebResourceError: (WebResourceError error) {},
//         onNavigationRequest: (NavigationRequest request) {
//           if (request.url.startsWith('https://www.youtube.com/')) {
//             return NavigationDecision.prevent;
//           }
//           return NavigationDecision.navigate;
//         },
//       ),
//     )
//     ..loadRequest(Uri.parse(url));
// }
}
