import 'package:flutter/material.dart';
import 'package:gamming_community/resources/values/app_colors.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
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
      accentIconTheme: IconThemeData(color: Colors.white),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.white
      )

  );
  static ThemeData lightTheme = ThemeData(
      
      fontFamily: "GoogleSans-Regular",
      brightness: Brightness.light,
      primarySwatch: Colors.indigo,
      appBarTheme: AppBarTheme(color: Color(0xff322E2E)),
      iconTheme: IconThemeData(color: Colors.black),
      textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.black),
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.black,
        
      )
      
      );
}
