import 'package:flutter/material.dart';
import '../utils/colors.dart';

ThemeData themeData = ThemeData(
  primaryColor: primaryColor,
  fontFamily: "Fira Sans",
  scaffoldBackgroundColor: Colors.white,
  brightness: Brightness.light,
  textTheme: TextTheme(
    displayLarge: const TextStyle(
      fontSize: 40.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
      color: primaryColor,
    ),
    displayMedium: const TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
      color: primaryColor,
    ),
    displaySmall: const TextStyle(
      fontSize: 28.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
      color: primaryColor,
    ),
    headlineMedium: const TextStyle(
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
      color: primaryColor,
    ),
    headlineSmall: const TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
      color: primaryColor,
    ),
    titleLarge: const TextStyle(
      fontSize: 13.5,
      fontWeight: FontWeight.normal,
      fontFamily: 'Montserrat',
      color: primaryColor,
      height: 1.4,
    ),
    titleMedium: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
      color: primaryColor.withOpacity(0.8),
    ),
    titleSmall: TextStyle(
      fontSize: 14.5,
      fontWeight: FontWeight.bold,
      fontFamily: 'Montserrat',
      color: primaryColor.withOpacity(0.8),
    ),
    bodyLarge: TextStyle(
      height: 1.4,
      fontSize: 16.5,
      fontWeight: FontWeight.normal,
      fontFamily: 'Fira Sans',
      color: Colors.grey[900],
    ),
    bodyMedium: TextStyle(
      height: 1.4,
      fontSize: 15,
      fontWeight: FontWeight.normal,
      fontFamily: 'Fira Sans',
      color: Colors.grey[900],
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      visualDensity: const VisualDensity(
        horizontal: 0.5,
        vertical: 1.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      elevation: 2,
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ElevatedButton.styleFrom(
      visualDensity: const VisualDensity(
        horizontal: 0.5,
        vertical: 1.0,
      ),
      backgroundColor: Colors.white,
      textStyle: const TextStyle(
        color: primaryColor,
        fontWeight: FontWeight.w600,
      ),
      side: const BorderSide(width: 0.8, color: primaryColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6.0),
      ),
      elevation: 2,
    ),
  ),
  cardTheme: CardTheme(
    elevation: 0,
    color: Colors.grey[50],
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.grey[200]!, width: 1),
      borderRadius: BorderRadius.circular(6.0),
    ),
  ),
  listTileTheme: ListTileThemeData(
    textColor: Colors.grey[900],
    iconColor: primaryColor,
    selectedTileColor: yellowLightColor.withAlpha(50),
    selectedColor: Colors.black,
    shape: BeveledRectangleBorder(
      side: BorderSide(width: 0.3, color: Colors.grey[200]!),
      borderRadius: BorderRadius.circular(4.0),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    hintStyle: TextStyle(
      color: Colors.grey[600],
      fontSize: 13.5,
    ),
    labelStyle: const TextStyle(
      color: primaryColor,
      fontSize: 13.5,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.0),
      borderSide: BorderSide(color: Colors.grey[300]!),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.0),
      borderSide: BorderSide(color: Colors.grey[350]!),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.0),
      borderSide: const BorderSide(color: Colors.red),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6.0),
      borderSide: const BorderSide(color: Colors.red),
    ),
    isDense: true,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    elevation: 5,
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    extendedTextStyle: TextStyle(
      fontFamily: 'Fira Sans',
    ),
  ),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: ColorPrimarySwatch.get)
      .copyWith(surface: Colors.white),
);
