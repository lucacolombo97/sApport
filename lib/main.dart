import 'dart:io';
import 'dart:developer';
import 'package:sizer/sizer.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:sApport/Views/Utils/constants.dart';
import 'package:sApport/ViewModel/map_view_model.dart';
import 'package:sApport/ViewModel/user_view_model.dart';
import 'package:sApport/ViewModel/auth_view_model.dart';
import 'package:sApport/ViewModel/chat_view_model.dart';
import 'package:sApport/Model/Services/map_service.dart';
import 'package:sApport/Router/app_router_delegate.dart';
import 'package:sApport/Model/Services/user_service.dart';
import 'package:sApport/Views/Welcome/welcome_screen.dart';
import 'package:sApport/Model/Services/firestore_service.dart';
import 'package:sApport/Model/Services/notification_service.dart';
import 'package:sApport/ViewModel/BaseUser/report_view_model.dart';
import 'package:sApport/Model/Services/firebase_auth_service.dart';
import 'package:sApport/ViewModel/BaseUser/Diary/diary_view_model.dart';

/// sApport project authors: @lucacolombo97 and @simoneghiazzi
/// 
/// Copyright 2021. All rights reserved. 
/// The sApport authors.

/// Used to set set the emulator for Firebase during Testing
/// 
/// ** SET FALSE DURING DEPLOYMENT **
const bool USE_FIRESTORE_EMULATOR = false;

Future<void> main() async {
  // Flutter initialization
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization and functional checks
  await Firebase.initializeApp().then((_) => log("Firebase initialization completed")).catchError((e) {
    log('Initialization error $e');
    exit(-1);
  });
  await FirebaseAppCheck.instance
      .activate(webRecaptchaSiteKey: "recaptcha-v3-site-key")
      .then((_) => log("FirebaseAppCheck initialization completed"))
      .catchError((e) {
    log("FirebaseAppCheck error $e");
    exit(-1);
  });
  if (USE_FIRESTORE_EMULATOR) {
    FirebaseFirestore.instance.settings = const Settings(host: "localhost:8080", sslEnabled: false, persistenceEnabled: false);
    FirebaseAuth.instance.useAuthEmulator("localhost", 9099);
  }

  // Services initialization
  setupServices();
  FirebaseAuthService _firebaseAuthService = GetIt.I<FirebaseAuthService>();
  UserService _userService = GetIt.I<UserService>();

  // Already logged user check: if the user is already logged
  // fetch the correct user data from the DB and load the relative homePage.
  //
  // If the user is not already logged or the email has not been verified, load the welcome page.
  if (_firebaseAuthService.currentUserId != null && _firebaseAuthService.isUserEmailVerified()) {
    await _userService.loadLoggedUser().then((_) => log("User of category ${_userService.loggedUser!.collection} logged"));
    runApp(MyApp(homePage: _userService.loggedUser!.homePageRoute));
  } else {
    runApp(MyApp());
  }
}

/// Initialization of the services into the GetIt service locator
void setupServices() {
  var getIt = GetIt.I;
  getIt.registerSingleton<FirestoreService>(FirestoreService(FirebaseFirestore.instance));
  getIt.registerSingleton<FirebaseAuthService>(FirebaseAuthService(FirebaseAuth.instance));
  getIt.registerSingleton<NotificationService>(NotificationService(FirebaseMessaging.instance));
  getIt.registerSingleton<UserService>(UserService());
  getIt.registerSingleton<MapService>(MapService());
}

class MyApp extends StatefulWidget {
  final String? homePage;

  MyApp({Key? key, this.homePage}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppRouterDelegate routerDelegate = AppRouterDelegate();

  @override
  void initState() {
    // Add the WelcomePage to the routerDelegate and the homePage only if the user is already logged
    routerDelegate.replaceAll([
      RouteSettings(name: WelcomeScreen.route),
      if (widget.homePage != null) ...[RouteSettings(name: widget.homePage)],
    ]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppRouterDelegate>(create: (_) => routerDelegate),
        ChangeNotifierProvider<ChatViewModel>(create: (_) => ChatViewModel()),
        ChangeNotifierProvider<DiaryViewModel>(create: (_) => DiaryViewModel()),
        ChangeNotifierProvider<MapViewModel>(create: (_) => MapViewModel()),
        Provider(create: (context) => ReportViewModel()),
        Provider(create: (context) => AuthViewModel()),
        Provider(create: (context) => UserViewModel()),
      ],
      child: Sizer(
        builder: (context, orientation, deviceType) {
          // Check the device type and disable the landscape orientation if it is not a tablet
          if (!(deviceType == DeviceType.tablet)) {
            SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: "sApport",
            theme: ThemeData(
              primaryColor: kPrimaryColor,
              scaffoldBackgroundColor: Colors.white,
              fontFamily: "Lato",
            ),
            home: Router(
              routerDelegate: routerDelegate,
              backButtonDispatcher: RootBackButtonDispatcher(),
            ),
          );
        },
      ),
    );
  }
}
