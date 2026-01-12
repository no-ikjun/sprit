import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprit/core/initialization/app_initializer.dart';
import 'package:sprit/common/ui/color_set.dart';
import 'package:sprit/common/value/router.dart';
import 'package:sprit/core/routing/app_router.dart';
import 'package:sprit/providers/analytics_index.dart';
import 'package:sprit/providers/fcm_token.dart';
import 'package:sprit/providers/library_book_state.dart';
import 'package:sprit/providers/library_section_order.dart';
import 'package:sprit/providers/navigation.dart';
import 'package:sprit/providers/new_notice.dart';
import 'package:sprit/providers/selected_book.dart';
import 'package:sprit/providers/selected_record.dart';
import 'package:sprit/providers/user_info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppInitializer.initialize();
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
        ChangeNotifierProvider(create: (_) => AnalyticsIndex()),
        ChangeNotifierProvider(create: (_) => NewNoticeState()),
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
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: ColorSet.primary),
        ),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
        debugShowCheckedModeBanner: false,
        title: 'SPRIT',
        //home: const SplashScreen(),
        initialRoute: RouteName.splash,
        routes: namedRoutes,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
