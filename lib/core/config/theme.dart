// lib/core/config/theme.dart
import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFF9A5DBA);
  static const Color secondaryColor = Color(0xFF892BB9);
  static const Color scaffoldBackgroundColor = Color(0xFFFBFBFB);
  static const Color shadowColor = Color(0x28000000);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color hintColor = Color(0x73C3C3C3);
  static const Color grey300 = Color(0xFFE0E0E0);
}

class AppTextStyles {
  // Base text style with common properties
  static const TextStyle _base = TextStyle(fontFamily: 'Poppins');

  // Font sizes
  static const double _size11 = 11;
  static const double _size12 = 12;
  static const double _size13 = 13;
  static const double _size14 = 14;
  static const double _size15 = 15;
  static const double _size18 = 18;

  // Font weights
  static const FontWeight _w400 = FontWeight.w400;
  static const FontWeight _w500 = FontWeight.w500;
  static const FontWeight _w600 = FontWeight.w600;
  static const FontWeight _w700 = FontWeight.w700;

  // Reusable text styles
  static TextStyle get headlineMedium => _base.copyWith(
    color: AppColors.black,
    fontSize: _size13,
    fontWeight: _w500,
  );

  static TextStyle get bodyLarge => _base.copyWith(
    color: AppColors.black,
    fontSize: _size12,
    fontWeight: _w600,
  );

  static TextStyle get bodyMedium => _base.copyWith(
    color: AppColors.black,
    fontSize: _size12,
    fontWeight: _w500,
  );

  static TextStyle get buttonText =>
      _base.copyWith(fontSize: _size13, fontWeight: _w600);

  static TextStyle get hintText => _base.copyWith(
    color: AppColors.hintColor,
    fontSize: _size13,
    fontWeight: _w500,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'Poppins',
      scaffoldBackgroundColor: AppColors.scaffoldBackgroundColor,
      primaryColor: AppColors.primaryColor,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        surface: AppColors.scaffoldBackgroundColor,
        error: Colors.red,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        selectionHandleColor: AppColors.secondaryColor,
        cursorColor: AppColors.secondaryColor,
        selectionColor: AppColors.secondaryColor,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles._base.copyWith(
          color: AppColors.secondaryColor,
          fontSize: AppTextStyles._size18,
          fontWeight: AppTextStyles._w700,
        ),
        displayMedium: AppTextStyles._base.copyWith(
          color: AppColors.white,
          fontSize: AppTextStyles._size15,
          fontWeight: AppTextStyles._w600,
        ),
        displaySmall: AppTextStyles._base.copyWith(
          color: AppColors.black,
          fontSize: AppTextStyles._size13,
          fontWeight: AppTextStyles._w600,
        ),
        headlineMedium: AppTextStyles.headlineMedium,
        titleLarge: AppTextStyles._base.copyWith(
          fontSize: AppTextStyles._size13,
          fontWeight: AppTextStyles._w700,
          color: AppColors.secondaryColor,
        ),
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        titleSmall: AppTextStyles._base.copyWith(
          fontSize: AppTextStyles._size11,
          fontWeight: AppTextStyles._w500,
          color: AppColors.black,
        ),
      ),
      // Button themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.white,
          elevation: 2,
          minimumSize: const Size(double.infinity, 48),

          shadowColor: AppColors.shadowColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          textStyle: AppTextStyles.buttonText,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(double.infinity, 48),

          foregroundColor: AppColors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          textStyle: AppTextStyles.buttonText,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primaryColor,
          textStyle: AppTextStyles.buttonText,
        ),
      ),
      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: AppTextStyles.hintText,
      ),
    );
  }
}
