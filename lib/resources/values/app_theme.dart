import 'package:flutter/material.dart';
import 'package:gamming_community/resources/values/app_colors.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor:AppColors.BACKGROUND_COLOR,
      
      //backgroundColor: AppColors.BACKGROUND_COLOR,
      brightness: Brightness.dark,
      fontFamily: "GoogleSans-Regular",
      primarySwatch: Colors.indigo,
      accentColor: Colors.indigo,
      cursorColor: Colors.amber,
      toggleableActiveColor: Colors.amber, //color cho switch, cac kieu
      //appBarTheme: AppBarTheme(color: Color(0xff322E2E)),
      appBarTheme: AppBarTheme(color: AppColors.BACKGROUND_COLOR),
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
      bottomSheetTheme: BottomSheetThemeData(
        modalBackgroundColor: AppColors.BACKGROUND_COLOR,
        backgroundColor: AppColors.BACKGROUND_COLOR,
        clipBehavior: Clip.antiAlias,
        
      ),
      accentIconTheme: IconThemeData(color: Colors.white),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        hoverElevation: 0,
       elevation: 0,
       highlightElevation: 0,
       focusElevation: 0,
       disabledElevation: 0,

      ),
      tabBarTheme: TabBarTheme(labelColor: Colors.white),
      chipTheme: ChipThemeData(
          backgroundColor: AppColors.BACKGROUND_COLOR.withOpacity(0.12),
          disabledColor: Colors.grey,
          selectedColor: AppColors.BACKGROUND_COLOR.withOpacity(0.5),
          secondarySelectedColor: AppColors.BACKGROUND_COLOR.withOpacity(0.5),
          labelPadding: EdgeInsets.all(0),
          padding: EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          labelStyle: TextStyle(color: Colors.white),
          secondaryLabelStyle: TextStyle(color: Colors.white),
          brightness: Brightness.dark),
          dialogBackgroundColor: AppColors.BACKGROUND_COLOR,
      snackBarTheme: SnackBarThemeData(backgroundColor: ColorScheme.light().background),);
      
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
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        hoverElevation: 0,
       elevation: 0,
       highlightElevation: 0,
       focusElevation: 0,
       disabledElevation: 0,

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
