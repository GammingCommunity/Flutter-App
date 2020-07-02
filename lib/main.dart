import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bloc;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gamming_community/API/config/refreshToken.dart';
import 'package:gamming_community/generated/i18n.dart';
import 'package:gamming_community/hive_models/connection/hive_connection.dart';
import 'package:gamming_community/provider/changeProfile.dart';
import 'package:gamming_community/provider/notficationModel.dart';
import 'package:gamming_community/provider/search_bar.dart';
import 'package:gamming_community/provider/search_game.dart';
import 'package:gamming_community/resources/values/app_theme.dart';
import 'package:gamming_community/view/feeds/provider/feedsProvider.dart';
import 'package:gamming_community/view/finding_room/finding_room_provider.dart';
import 'package:gamming_community/view/forgot_password/forgotPassword.dart';
import 'package:gamming_community/view/group_dashboard/provider/group_post_provider.dart';
import 'package:gamming_community/view/home/home.dart';
import 'package:gamming_community/view/home/provider/search_friend_provider.dart';
import 'package:gamming_community/view/login/bloc/bloc/login_bloc.dart';
import 'package:gamming_community/view/login/login.dart';
import 'package:gamming_community/view/messages/models/group_chat_provider.dart';
import 'package:gamming_community/view/messages/models/private_chat_provider.dart';
import 'package:gamming_community/view/news/provider/newsProvider.dart';
import 'package:gamming_community/view/notfications/notificationProvider.dart';
import 'package:gamming_community/view/profile/profile.dart';
import 'package:gamming_community/view/profile/profileController.dart';
import 'package:gamming_community/view/room/create_room_v2.dart';
import 'package:gamming_community/view/room/provider/explorerProvider.dart';
import 'package:gamming_community/view/room/provider/navigateNextPage.dart';
import 'package:gamming_community/view/room/provider/room_list_provider.dart';
import 'package:gamming_community/view/room_manager/bloc/room_manager_bloc.dart';
import 'package:gamming_community/view/room_manager/provider/edit_room_provider.dart';
import 'package:gamming_community/view/room_manager/room_create_provider.dart';
import 'package:gamming_community/view/room_manager/room_manager.dart';
import 'package:gamming_community/view/sign_up/bloc/bloc/signup_bloc.dart';
import 'package:gamming_community/view/sign_up/provider/sign_up_provider.dart';
import 'package:gamming_community/view/sign_up/sign_up.dart';
import 'package:gamming_community/view/user_post/post_provider.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init hiveDB

  await hiveInit();

  SharedPreferences ref = await SharedPreferences.getInstance();
  bool isEng = ref.getBool("isEng") ?? true;
  bool isLogin = ref.getBool('isLogin') == null ?? false;
  // check login from logout
  Widget defaultHome = Login();

  // check token is not invaild
  print(isLogin);
  if (isLogin) {
    if (await RefreshToken.isVaildSession()) {
      print("vaild session");
      defaultHome = HomePage();
    } else {
      await RefreshToken.renewToken();
      defaultHome = HomePage();
    }
  } else {
    defaultHome = Login();
  }

  runApp(MyApp(home: defaultHome, enLanguage: isEng));
  SystemChrome.setEnabledSystemUIOverlays([]);
}

class MyApp extends StatelessWidget {
  final Widget home;
  final bool enLanguage;
  MyApp({this.home, this.enLanguage = true});

  @override
  Widget build(BuildContext context) {
    final i18n = I18n.delegate;

    return GetBuilder<ProfileController>(
        init: ProfileController(),
        builder: (p) => MultiProvider(
                providers: [
                  //ChangeNotifierProvider<FetchMoreValue>(create: (context) => FetchMoreValue()),
                  ChangeNotifierProvider<ChangeProfile>(create: (context) => ChangeProfile()),
                  ChangeNotifierProvider<SearchProvider>(create: (context) => SearchProvider()),
                  ChangeNotifierProvider<NotificationModel>(
                      create: (context) => NotificationModel()),
                  ChangeNotifierProvider<SearchGame>(
                    create: (context) => SearchGame(),
                  ),
                  ChangeNotifierProvider<NavigateNextPage>(
                    create: (context) => NavigateNextPage(),
                  ),
                  ChangeNotifierProvider(
                    create: (context) => SignUpProvider(),
                    child: SignUp(),
                  )
                ],
                child: bloc.MultiBlocProvider(
                  providers: [
                    bloc.BlocProvider<LoginBloc>(
                      create: (BuildContext context) => LoginBloc(),
                      child: Login(),
                    ),
                    bloc.BlocProvider<SignUpBloc>(
                      create: (BuildContext context) => SignUpBloc(),
                      child: SignUp(),
                    ),
                    bloc.BlocProvider<RoomManagerBloc>(
                      create: (BuildContext context) => RoomManagerBloc(),
                      child: RoomManager(),
                    )
                  ],
                  child: Injector(
                    inject: [
                      Inject(() => PrivateChatProvider()),
                      Inject(() => GroupChatProvider()),
                      Inject(() => NotificationProvider()),
                      Inject(() => RoomCreateProvider()),
                      Inject(() => EditRoomProvider()),
                      Inject(() => RoomsProvider()),
                      Inject(() => NewsProvider()),
                      Inject(() => FeedsProvider()),
                      Inject(() => ExploreProvider()),
                      Inject(() => SearchFriendsProvider()),
                      Inject(() => GroupPostProvider()),
                      Inject(() => PostProvider()),
                      Inject(() => FindingRoomProvider())
                    ],
                    builder: (context) {
                      return GetX<ProfileController>(
                          builder: (p) => GetMaterialApp(
                                opaqueRoute: false,
                                localeResolutionCallback:
                                    i18n.resolution(fallback: Locale('en', 'US')),
                                supportedLocales: i18n.supportedLocales,
                                locale:
                                    enLanguage == true ? Locale('en', 'US') : Locale('vi', 'VI'),
                                localizationsDelegates: {
                                  i18n,
                                  GlobalMaterialLocalizations.delegate,
                                  GlobalWidgetsLocalizations.delegate
                                },
                                debugShowCheckedModeBanner: false,
                                themeMode: p.darkTheme.value ? ThemeMode.dark : ThemeMode.light,
                                title: 'Gamming Community',
                                darkTheme: AppTheme.darkTheme,
                                theme: AppTheme.lightTheme,
                                builder: BotToastInit(), //1. call BotToastInit
                                navigatorObservers: [BotToastNavigatorObserver()],
                                initialRoute: '/',
                                getPages: [
                                  GetPage(
                                      name: '/', page: () => Login(), transition: Transition.fade),
                                  GetPage(name: '/signup', page: () => SignUp(),transition: Transition.rightToLeftWithFade),
                                  GetPage(name: '/forgot', page: () => ForgotPassword()),
                                  GetPage(
                                      name: '/homepage',
                                      page: () => HomePage(),
                                      transition: Transition.native),
                                  GetPage(name: '/createroom', page: () => CreateRoomV2()),
                                  GetPage(name: '/profile', page: () => Profile()),
                                ],
                                home: home,
                              ));
                    },
                  ),
                )));
  }
}
/*onGenerateRoute: (RouteSettings settings) {
                          List<String> pathElements = settings.name.split("/");
                          if (pathElements[0] != "") return null;
                          switch (pathElements[1]) {
                            case "login":
                              return MaterialPageRoute(builder: (context) => Login());
                              break;
                            case "signup":
                              return MaterialPageRoute(builder: (context) => SignUp());
                              break;
                            case "forgot":
                              return MaterialPageRoute(builder: (context) => ForgotPassword());
                              break;
                            case "homepage":
                              return MaterialPageRoute(builder: (context) => HomePage());
                              break;
                            case "profile":
                              return MaterialPageRoute(builder: (context) => Profile());
                              break;
                            case "createRoom":
                              return MaterialPageRoute(builder: (context) => CreateRoom());
                            default:
                              return MaterialPageRoute(builder: (_) {
                                return Scaffold(
                                  body: Center(
                                    child: Text('No route defined for ${settings.name}'),
                                  ),
                                );
                              });
                          }
                        },*/
/*routes: <String, WidgetBuilder>{
                '/login': (context) => Login(),
                '/signup': (context) => SignUp(),
                '/forgot': (context) => ForgotPassword(),
                '/homepage': (context) => HomePage(),
                '/profile': (context) => Profile()
              },*/
