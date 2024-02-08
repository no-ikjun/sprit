import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_talk/kakao_flutter_sdk_talk.dart';
import 'package:provider/provider.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/firebase_options.dart';
import 'package:sprit/providers/fcm_token.dart';
import 'package:sprit/providers/library_book_state.dart';
import 'package:sprit/providers/library_section_order.dart';
import 'package:sprit/providers/navigation.dart';
import 'package:sprit/providers/selected_book.dart';
import 'package:sprit/providers/selected_record.dart';
import 'package:sprit/providers/user_info.dart';
import 'package:sprit/screens/library/book_report_scree.dart';
import 'package:sprit/screens/read/read_complete_screen.dart';
import 'package:sprit/screens/read/record_setting_screen.dart';
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
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  KakaoSdk.init(nativeAppKey: '${dotenv.env['KAKAO_NATIVE_APP_KEY']}');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserInfoState()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => FcmTokenState()),
        ChangeNotifierProvider(create: (_) => SelectedBookInfoState()),
        ChangeNotifierProvider(create: (_) => SelectedRecordInfoState()),
        ChangeNotifierProvider(create: (_) => LibrarySectionOrderState()),
        ChangeNotifierProvider(create: (_) => LibraryBookListState()),
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
            case RouteName.recordSetting:
              final String bookUuid = settings.arguments as String;
              return MaterialPageRoute(
                builder: (context) => RecordSettingScreen(bookUuid: bookUuid),
              );
            case RouteName.readComplete:
              final int goalAmount = settings.arguments as int;
              return MaterialPageRoute(
                builder: (context) =>
                    ReadCompleteScreen(goalAmount: goalAmount),
              );
            case RouteName.bookReport:
              final String reportUuid = settings.arguments as String;
              return MaterialPageRoute(
                builder: (context) => BookReportScreen(reportUuid: reportUuid),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => const SplashScreen(),
              );
          }
        },
      ),
    );
  }
}
