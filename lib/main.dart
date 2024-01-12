import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';
import 'package:provider/provider.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/firebase_options.dart';
import 'package:sprit/providers/navigation.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/search/detail_screen.dart';
import 'package:sprit/screens/search/review_screen.dart';
import 'package:sprit/screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarColor: Colors.transparent,
  ));
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final fcmToken = await FirebaseMessaging.instance.getToken();
  debugPrint('token: $fcmToken');
  KakaoSdk.init(nativeAppKey: '${dotenv.env['KAKAO_NATIVE_APP_KEY']}');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserInfoState()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'SPRIT',
        //home: const SplashScreen(),
        initialRoute: RouteName.splash,
        routes: namedRoutes,
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case RouteName.bookDetail:
              final String bookUuid = settings.arguments as String;
              return MaterialPageRoute(
                builder: (context) => BookDetailScreen(bookUuid: bookUuid),
              );
            case RouteName.review:
              final String bookUuid = settings.arguments as String;
              return MaterialPageRoute(
                builder: (context) => ReviewScreen(bookUuid: bookUuid),
              );
            default:
              return MaterialPageRoute(
                  builder: (context) => const SplashScreen());
          }
        },
      ),
    );
  }
}
