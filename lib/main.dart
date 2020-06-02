import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gamming_community/API/config/refreshToken.dart';
import 'package:gamming_community/generated/i18n.dart';
import 'package:gamming_community/hive_models/connection/hive_connection.dart';
import 'package:gamming_community/models/chat_provider.dart';
import 'package:gamming_community/models/group_chat_provider.dart';
import 'package:gamming_community/provider/changeProfile.dart';
import 'package:gamming_community/provider/fetchMore.dart';
import 'package:gamming_community/provider/search_bar.dart';
import 'package:gamming_community/provider/search_game.dart';
import 'package:gamming_community/resources/values/app_theme.dart';
import 'package:gamming_community/view/feeds/provider/feedsProvider.dart';
import 'package:gamming_community/view/forgot_password/forgotPassword.dart';
import 'package:gamming_community/view/home/home.dart';
import 'package:gamming_community/view/home/provider/search_friend_provider.dart';
import 'package:gamming_community/view/login/bloc/bloc/login_bloc.dart';
import 'package:gamming_community/view/login/login.dart';
import 'package:gamming_community/view/news/provider/newsProvider.dart';
import 'package:gamming_community/view/notfications/notificationProvider.dart';
import 'package:gamming_community/view/profile/profile.dart';
import 'package:gamming_community/view/profile/settingProvider.dart';
import 'package:gamming_community/view/room/create_room.dart';
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
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:gamming_community/provider/notficationModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init hiveDB

  await hiveInit();

  // check login from logout
  Widget defaultHome = Login();
  SharedPreferences ref = await SharedPreferences.getInstance();
  bool isEng = ref.getBool("isEng") ?? true;
  // check token is not invaild

  if (ref.getBool('isLogin') != null) {
    if (await RefreshToken.isVaildSession()) {
      print("vaild session");
      defaultHome = HomePage();
    } else {
      await RefreshToken.renewToken();
      defaultHome = HomePage();
    }
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
    SettingProvider settingProvider;
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<FetchMoreValue>(create: (context) => FetchMoreValue()),
          ChangeNotifierProvider<ChangeProfile>(create: (context) => ChangeProfile()),
          ChangeNotifierProvider<SearchProvider>(create: (context) => SearchProvider()),
          ChangeNotifierProvider<NotificationModel>(create: (context) => NotificationModel()),
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
        child: MultiBlocProvider(
          providers: [
            BlocProvider<LoginBloc>(
              create: (BuildContext context) => LoginBloc(),
              child: Login(),
            ),
            BlocProvider<SignUpBloc>(
              create: (BuildContext context) => SignUpBloc(),
              child: SignUp(),
            ),
            BlocProvider<RoomManagerBloc>(
              create: (BuildContext context) => RoomManagerBloc(),
              child: RoomManager(),
            )
          ],
          child: Injector(
            inject: [
              Inject(() => ChatProvider()),
              Inject(() => GroupChatProvider()),
              Inject(() => SettingProvider()),
              Inject(() => NotificationProvider()),
              Inject(() => RoomCreateProvider()),
              Inject(() => EditRoomProvider()),
              Inject(() => RoomsProvider()),
              Inject(() => NewsProvider()),
              Inject(() => FeedsProvider()),
              Inject(() => ExploreProvider()),
              Inject(() => SearchFriendsProvider())
            ],
            builder: (context) {
              settingProvider = Injector.get(context: context);
              return StateBuilder(
                  models: [],
                  builder: (context, _) => GetMaterialApp(
                        localeResolutionCallback: i18n.resolution(fallback: Locale('en', 'US')),
                        supportedLocales: i18n.supportedLocales,
                        locale: enLanguage == true ? Locale('en', 'US') : Locale('vi', 'VI'),
                        localizationsDelegates: {
                          i18n,
                          GlobalMaterialLocalizations.delegate,
                          GlobalWidgetsLocalizations.delegate
                        },
                        debugShowCheckedModeBanner: false,
                        themeMode: settingProvider.darkTheme ? ThemeMode.dark : ThemeMode.light,
                        title: 'Gamming Community',
                        darkTheme: AppTheme.darkTheme,
                        theme: AppTheme.lightTheme,
                        builder: (context, child) => BotToastInit(
                          child: child,
                        ), //1. call BotToastInit
                        navigatorObservers: [BotToastNavigatorObserver()],
                        //initialRoute: '/',
                        onGenerateRoute: (RouteSettings settings) {
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
                        },
                        /*routes: <String, WidgetBuilder>{
                '/login': (context) => Login(),
                '/signup': (context) => SignUp(),
                '/forgot': (context) => ForgotPassword(),
                '/homepage': (context) => HomePage(),
                '/profile': (context) => Profile()
              },*/
                        home: home,
                      ));
            },
          ),
        ));
  }
}
