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
      tabBarTheme: TabBarTheme(labelColor: Colors.white),
      chipTheme: ChipThemeData(
          backgroundColor: AppColors.BACKGROUND_COLOR,
          disabledColor: Colors.grey,
          selectedColor: Colors.black,
          secondarySelectedColor: Colors.black,
          labelPadding: EdgeInsets.all(0),
          padding: EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          labelStyle: TextStyle(color: Colors.white),
          secondaryLabelStyle: TextStyle(color: Colors.white),
          brightness: Brightness.dark),
      snackBarTheme: SnackBarThemeData(backgroundColor: ColorScheme.light().background));
  static ThemeData lightTheme = ThemeData(
      backgroundColor: Colors.white,
      fontFamily: "GoogleSans-Regular",
      brightness: Brightness.light,
      primarySwatch: Colors.indigo,
      appBarTheme: AppBarTheme(color: Color(0xff322E2E)),
      iconTheme: IconThemeData(color: Colors.black),
      primaryColor: Colors.white,
      textTheme: TextTheme(
        bodyText2: TextStyle(color: Colors.black),
      ),
      buttonTheme: ButtonThemeData(

        textTheme: ButtonTextTheme.primary
      ),
      tabBarTheme: TabBarTheme(
        labelColor: Colors.black,
      ),
      chipTheme: ChipThemeData(
          backgroundColor: Colors.grey[400],
          disabledColor: Colors.black38,
          selectedColor: Colors.white,
          secondarySelectedColor: Colors.white,
          labelPadding: EdgeInsets.all(0),
          padding: EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          labelStyle: TextStyle(color: Colors.black),
          secondaryLabelStyle: TextStyle(color: Colors.black),
          brightness: Brightness.light),
      snackBarTheme: SnackBarThemeData(backgroundColor: ColorScheme.dark().background));
}
