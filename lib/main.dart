import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:aicp/provider/car_offer_provider.dart';
import 'package:aicp/const/app_text.dart';
import 'package:aicp/const/font_family.dart';
import 'package:aicp/routes/routes.dart';
import 'package:aicp/screens/splash_screen.dart';
import 'package:aicp/provider/login_provider.dart';
import 'package:aicp/provider/news_provider.dart';
import 'package:aicp/provider/car_provider.dart';
import 'package:aicp/provider/profile_provider.dart';
import 'package:aicp/provider/car_detail_provider.dart';
import 'package:aicp/provider/car_image_provider.dart';
import 'package:aicp/screens/notification_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  try {
    await GlobalConfiguration().loadFromUrl(
        "https://tizvbc2z9i.execute-api.ap-southeast-1.amazonaws.com/latest/GetGlobalConfig");
  } catch (e) {
    // debugPrint(e.toString());
  }

  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    // debugPrint('Error from DotEnv : ' + e.toString());
  }

  runApp(Phoenix(
    child: EasyLocalization(
      supportedLocales: const [Locale('en', 'US'), Locale('km', 'KM')],
      path: 'assets/translate', // <-- change patch to your
      startLocale: const Locale('en', 'US'),
      fallbackLocale: const Locale('en', 'US'),
      useOnlyLangCode: true,
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: () => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => LoginProvider()),
          ChangeNotifierProvider(create: (_) => NewsProvider()),
          ChangeNotifierProvider(create: (_) => CarsProvider()),
          ChangeNotifierProvider(create: (_) => CarsOfferProvider()),
          ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ChangeNotifierProvider(create: (_) => CarDetailProvider()),
          ChangeNotifierProvider(create: (_) => CarImageProvider()),
        ],
        child: MaterialApp(
          /// Add language translate
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          title: AppText.appTitle,
          theme: ThemeData(fontFamily: FontFamily.PromptRegular
              // primarySwatch: Colors.blue,
              // textTheme: TextTheme(button: TextStyle(fontSize: 45.sp)),
              ),
          builder: (context, widget) {
            ScreenUtil.setContext(context);
            return MediaQuery(
              //Setting font does not change with system font size
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
          home: const CallClass(),
          routes: Routes.routes,
        ),
      ),
    );
  }
}

class CallClass extends StatelessWidget {
  const CallClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AICP',
      home: Stack(
        children: const <Widget>[
          CallFirstScreen(),
          Notify(),
        ],
      ),
    );
  }
}

class CallFirstScreen extends StatefulWidget {
  const CallFirstScreen({Key? key}) : super(key: key);

  @override
  _CallFirstScreenState createState() => _CallFirstScreenState();
}

class _CallFirstScreenState extends State<CallFirstScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: Routes.routes,
    );
  }
}

class Notify extends StatefulWidget {
  const Notify({Key? key}) : super(key: key);

  @override
  _NotifyState createState() => _NotifyState();
}

class _NotifyState extends State<Notify> {
  String _homeScreenText = "Waiting for token...";
  double heightanima = 0.0;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {}
    });

    FirebaseMessaging.instance.getToken().then((token) {
      /// Save Token Device function
      if (token == null) return;
      assert(token != null);

      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      ///ดึงข้อมูลการแจ้งเตือนตอนที่เปิด App ไว้อยู่
      // RemoteNotification notification = message.notification;
      // AndroidNotification android = message.notification?.android;
      // RemoteMessage message = args.message;
      RemoteNotification? notification = message.notification;

      // print('onMessage : ${notification?.title} ');
      // print('onMessage : ${notification?.body} ');
      // print('onMessage : ${message.data.toString()} ');
      // print('onMessage2 : ${message.data['amount_payment'].toString()} ');
      var title = notification!.title;
      var body = notification.body;

      setMessage(title, body);
      // if (notification != null && android != null && !kIsWeb) {

      // flutterLocalNotificationsPlugin.show(
      //   notification.hashCode,
      //   notification.title,
      //   notification.body,
      //   NotificationDetails(
      //     android: AndroidNotificationDetails(
      //       channel.id,
      //       channel.name,
      //       channel.description,
      //       // TODO add a proper drawable resource to android, for now using
      //       //      one that already exists in example app.
      //       icon: 'launch_background',
      //     ),
      //   ),
      // );
      // }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      /// กดจากการแจ้งเตือนข้างนอก App เข้ามาใน App
      // print('A new onMessageOpenedApp event was published!');

      var link_img = message.data['link_img'].toString();
      var activity = message.data['activity'].toString();
      // print(link_img);
      // print(activity);

      if (activity == "Ebill") {
        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(
        //       builder: (context) => ShowBillPdfPage(link_img.toString())),
        // );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NotificationScreen()),
        );
      }
    });
  }

  var messageTitle = "";
  var messageBody = "";
  var activity = "";
  var link_img = "";

  setMessage(title, body) {
    // print("setMessage");
    // print(title);
    // print(body);
    startTimer();

    setState(() {
      heightanima = 0.1;

      messageTitle = title.toString();
      messageBody = body.toString();

      // activity = message["notification"]["activity"].toString();
      // link_img = message["notification"]["link_img"].toString();
      // if (Platform.isIOS) {
      //   messageTitle = message["title"].toString();
      //   messageBody = message["body"].toString();
      //   activity = message["activity"].toString();
      //   link_img = message["link_img"].toString();
      // } else {
      //   messageTitle = message["data"]["title"].toString();
      //   messageBody = message["data"]["body"].toString();
      //   activity = message["data"]["activity"].toString();
      //   link_img = message["data"]["link_img"].toString();
      // }

      print(messageTitle);
      print(messageBody);
    });
  }

  Timer? _timer;
  int _start = 0;

  void startTimer() {
    _start = 10;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            timer.cancel();
            setState(() {
              heightanima = 0.0;
            });
          } else {
            _start = _start - 1;
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Stack(
            children: <Widget>[
              AnimatedContainer(
                height: height * heightanima,
                width: width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                child: Stack(
                  children: <Widget>[
                    Container(
                        padding: const EdgeInsets.all(3),
                        child: Scaffold(
                          body: Stack(
                            children: <Widget>[
                              Container(
                                  color: Colors.white,
                                  alignment: Alignment.bottomRight,
                                  child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          heightanima = 0.0;
                                        });
                                      },
                                      child: Container(
                                        color: Colors.white,
                                        height: 30,
                                        width: 50,
                                        child: const Center(
                                            child: Text(
                                          "Hide",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontFamily: 'Prompt-Regular'),
                                        )),
                                      ))),
                              Container(
                                padding: const EdgeInsets.all(10),
                                child: RichText(
                                  text: TextSpan(
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: messageTitle.toString() + "\n",
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontFamily: 'Prompt-Regular')),
                                      TextSpan(
                                          text: messageBody.toString(),
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontFamily: 'Prompt-Regular')),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
