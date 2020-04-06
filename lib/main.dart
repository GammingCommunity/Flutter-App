import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamming_community/models/chat_provider.dart';
import 'package:gamming_community/models/group_chat_provider.dart';
import 'package:gamming_community/provider/changeProfile.dart';
import 'package:gamming_community/provider/fetchMore.dart';
import 'package:gamming_community/provider/search_bar.dart';
import 'package:gamming_community/provider/search_game.dart';
import 'package:gamming_community/resources/values/app_colors.dart';
import 'package:gamming_community/view/forgot_password/forgotPassword.dart';
import 'package:gamming_community/view/home/home.dart';
import 'package:gamming_community/view/login/bloc/bloc/login_bloc.dart';
import 'package:gamming_community/view/login/login.dart';
import 'package:gamming_community/view/profile/profile.dart';
import 'package:gamming_community/view/room/create_room.dart';
import 'package:gamming_community/view/room/provider/navigateNextPage.dart';
import 'package:gamming_community/view/room_manager/bloc/room_manager_bloc.dart';
import 'package:gamming_community/view/room_manager/room_manager.dart';
import 'package:gamming_community/view/sign_up/bloc/bloc/signup_bloc.dart';
import 'package:gamming_community/view/sign_up/sign_up.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:gamming_community/provider/notficationModel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  
  // check login from logout
  Widget defaultHome = Login();
  SharedPreferences ref = await SharedPreferences.getInstance();
  bool isLoggin = ref.getBool('isLogin') != null ?? false;
  if (isLoggin) {
    defaultHome = HomePage();
  }
  runApp(MyApp(home: defaultHome));
  SystemChrome.setEnabledSystemUIOverlays([]);
}

class MyApp extends StatelessWidget {
  final Widget home;
  MyApp({this.home});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FetchMoreValue>(create: (context) => FetchMoreValue()),
        ChangeNotifierProvider<ChangeProfile>(create: (context) => ChangeProfile()),
        ChangeNotifierProvider<Search>(create: (context) => Search()),
        ChangeNotifierProvider<NotificationModel>(create: (context) => NotificationModel()),
        ChangeNotifierProvider<SearchGame>(create: (context) => SearchGame(),),
        ChangeNotifierProvider<NavigateNextPage>(create: (context) => NavigateNextPage(),)

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
              Inject(()=>GroupChatProvider())
            ],
            builder: (context) {
              return StateBuilder(
                  models: [],
                  builder: (context, _) => MaterialApp(
                        debugShowCheckedModeBanner: false,
                        themeMode: ThemeMode.dark,
                        title: 'Gamming Community',
                        darkTheme: ThemeData(
                            scaffoldBackgroundColor: Color(0xff322E2E),
                            brightness: Brightness.dark,
                            fontFamily: "GoogleSans-Regular",
                            primarySwatch: Colors.indigo,
                            accentColor: Colors.indigo,
                            cursorColor: Colors.amber,
                            toggleableActiveColor: Colors.amber, //color cho switch, cac kieu
                            appBarTheme: AppBarTheme(color: Color(0xff322E2E)),
                            indicatorColor: AppColors.PRIMARY_COLOR,
                            inputDecorationTheme: InputDecorationTheme(
                                labelStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                focusedBorder: InputBorder.none),
                            bottomAppBarTheme: BottomAppBarTheme(
                              color: Color(0xff6A45E7),
                            ),
                            textTheme: TextTheme(bodyText2: TextStyle(color: Colors.white)).apply(
                              bodyColor: Colors.white,
                              displayColor: Colors.blue,
                            ),
                            accentIconTheme: IconThemeData(color: Colors.white)),
                        theme: ThemeData(
                            brightness: Brightness.light,
                            fontFamily: "GoogleSans-Regular",
                            primarySwatch: Colors.indigo,
                            appBarTheme: AppBarTheme(color: Color(0xff322E2E)),
                            iconTheme: IconThemeData(color: Colors.white),
                            textTheme: TextTheme(
                              bodyText2: TextStyle(color: Colors.white),
                            )),
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
          )),
    );
  }
}
